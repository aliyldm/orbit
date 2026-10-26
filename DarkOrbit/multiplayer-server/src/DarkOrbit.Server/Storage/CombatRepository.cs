using System.Security.Authentication;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.World;
using Npgsql;
using NpgsqlTypes;

namespace DarkOrbit.Server.Storage;

// PostgreSQL owns checkpoints, ammunition and kill payouts. All three commit
// together. A process lease fences a second host for this server during the
// transition; later sharding can narrow this authority to individual maps.
public sealed partial class CombatRepository : IWorldPersistence, IAsyncDisposable
{
    private readonly NpgsqlDataSource source;
    private readonly string schema;
    private readonly int serverId;
    private readonly Guid owner = Guid.NewGuid();
    private long fence;
    [GeneratedRegex("^mp_[a-f0-9]{16}$")] private static partial Regex SchemaPattern();
    public CombatRepository(NpgsqlDataSource source, string schema, int serverId)
    {
        if (!SchemaPattern().IsMatch(schema) || serverId <= 0) throw new ArgumentException("Invalid combat repository scope");
        this.source = source; this.schema = '"' + schema + '"'; this.serverId = serverId;
    }
    public async Task Acquire()
    {
        await using (var exists = source.CreateCommand("SELECT to_regclass($1) IS NOT NULL"))
        {
            exists.Parameters.AddWithValue(schema + ".world_authority");
            if (!(bool)(await exists.ExecuteScalarAsync())!) throw new InvalidOperationException("Development schema predates combat storage. Run tools/bootstrap-native-development.ps1 to create a fresh schema; never replace the live SQLite database.");
        }
        await using var command = source.CreateCommand($"""
        INSERT INTO {schema}.world_authority AS old VALUES($1,$2,1,clock_timestamp()+interval '40 seconds')
        ON CONFLICT(server_id) DO UPDATE SET owner=$2,fence=old.fence+1,expires_at=clock_timestamp()+interval '40 seconds'
        WHERE old.expires_at<=clock_timestamp() RETURNING fence
        """);
        command.Parameters.AddWithValue(serverId); command.Parameters.AddWithValue(owner);
        var result = await command.ExecuteScalarAsync();
        if (result is null) throw new AuthenticationException("This game server already has a live world owner");
        fence = (long)result;
    }
    public async Task<bool> Renew()
    {
        await using var command = source.CreateCommand($"UPDATE {schema}.world_authority SET expires_at=clock_timestamp()+interval '40 seconds' WHERE server_id=$1 AND owner=$2 AND fence=$3 AND expires_at>clock_timestamp()");
        command.Parameters.AddWithValue(serverId); command.Parameters.AddWithValue(owner); command.Parameters.AddWithValue(fence);
        return await command.ExecuteNonQueryAsync() == 1;
    }
    private void Scope(MapKey key)
    { if (key.ServerId != serverId || key.MapId <= 0 || fence <= 0) throw new AuthenticationException("Invalid world authority"); }
    private async Task Authority(NpgsqlConnection connection, NpgsqlTransaction transaction)
    {
        await using var command = new NpgsqlCommand($"SELECT 1 FROM {schema}.world_authority WHERE server_id=$1 AND owner=$2 AND fence=$3 AND expires_at>clock_timestamp() FOR SHARE", connection, transaction);
        command.Parameters.AddWithValue(serverId); command.Parameters.AddWithValue(owner); command.Parameters.AddWithValue(fence);
        if (await command.ExecuteScalarAsync() is null) throw new AuthenticationException("Lost world authority");
    }
    private static void Key(NpgsqlCommand command, MapKey key)
    { command.Parameters.AddWithValue(key.ServerId); command.Parameters.AddWithValue(key.MapId); command.Parameters.AddWithValue(key.Instance); }
    public async Task<StoredWorld> Load(MapKey key, JsonObject initial)
    {
        Scope(key); await using var connection = await source.OpenConnectionAsync(); await using var transaction = await connection.BeginTransactionAsync();
        await Authority(connection, transaction);
        await using (var create = new NpgsqlCommand($"INSERT INTO {schema}.world_checkpoints VALUES($1,$2,$3,0,$4) ON CONFLICT DO NOTHING", connection, transaction))
        { Key(create, key); create.Parameters.AddWithValue(NpgsqlDbType.Jsonb, initial.ToJsonString()); await create.ExecuteNonQueryAsync(); }
        StoredWorld result;
        await using (var command = new NpgsqlCommand($"SELECT revision,state::text FROM {schema}.world_checkpoints WHERE server_id=$1 AND map_id=$2 AND instance=$3", connection, transaction))
        {
            Key(command, key); await using var reader = await command.ExecuteReaderAsync(); if (!await reader.ReadAsync()) throw new InvalidOperationException("World checkpoint absent");
            result = new(reader.GetInt64(0), JsonNode.Parse(reader.GetString(1))!.AsObject());
        }
        await transaction.CommitAsync(); return result;
    }
    public async Task<WorldCommit> Commit(MapKey key, long revision, JsonObject state, ShotDebit? debit = null)
    {
        Scope(key);
        if (revision < 0 || debit is { } d && (d.Id == Guid.Empty || d.PlayerId <= 0 || d.Amount <= 0 || d.Reward.Credits < 0 || d.Reward.Uridium < 0 || d.Reward.Ep < 0 || d.Reward.Honour < 0 || d.Claim is null && d.Reward != new NpcReward())) throw new ArgumentException("Invalid authoritative shot");
        string fingerprint = Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(new { key, revision, state, debit }))));
        await using var connection = await source.OpenConnectionAsync(); await using var transaction = await connection.BeginTransactionAsync();
        await Authority(connection, transaction);
        if (debit is not null)
        {
            // Serialize each player's debits and verify the connection fence
            // before replay lookup: a retired connection cannot read receipts.
            await using (var own = new NpgsqlCommand($"SELECT 1 FROM {schema}.players WHERE id=$1 AND server_id=$2 AND map_id=$3 AND connection_owner=$4 AND connection_fence=$5 FOR UPDATE", connection, transaction))
            {
                own.Parameters.AddWithValue(debit.PlayerId); own.Parameters.AddWithValue(serverId); own.Parameters.AddWithValue(key.MapId); own.Parameters.AddWithValue(debit.Connection.Owner); own.Parameters.AddWithValue(debit.Connection.Fence);
                if (await own.ExecuteScalarAsync() is null) throw new AuthenticationException("Lost player owner/map");
            }
            await using (var replay = new NpgsqlCommand($"SELECT player_id,fingerprint,result::text FROM {schema}.combat_receipts WHERE id=$1", connection, transaction))
            {
                replay.Parameters.AddWithValue(debit.Id); await using var reader = await replay.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    if (reader.GetInt64(0) != debit.PlayerId || reader.GetString(1) != fingerprint) throw new InvalidDataException("Receipt identity reused for a different shot");
                    var result = JsonSerializer.Deserialize<WorldCommit>(reader.GetString(2))!;
                    await reader.DisposeAsync(); await transaction.CommitAsync(); return result;
                }
            }
            await using (var cooldown = new NpgsqlCommand($"SELECT laser_ready_at<=clock_timestamp() AND ($2<> 'ammunition_laser_rsb-75' OR rsb_ready_at<=clock_timestamp()) FROM {schema}.player_combat WHERE player_id=$1", connection, transaction))
            {
                cooldown.Parameters.AddWithValue(debit.PlayerId); cooldown.Parameters.AddWithValue(debit.Ammo);
                var ready = await cooldown.ExecuteScalarAsync();
                if (ready is null) throw new InvalidDataException("Player combat state absent");
                if (!(bool)ready) return new(false, revision, Reason: "cooldown");
            }
        }
        await using (var update = new NpgsqlCommand($"UPDATE {schema}.world_checkpoints SET revision=revision+1,state=$4 WHERE server_id=$1 AND map_id=$2 AND instance=$3 AND revision=$5 RETURNING revision", connection, transaction))
        {
            Key(update, key); update.Parameters.AddWithValue(NpgsqlDbType.Jsonb, state.ToJsonString()); update.Parameters.AddWithValue(revision);
            if (await update.ExecuteScalarAsync() is null) throw new InvalidDataException("Stale map checkpoint");
        }
        long remaining = 0; Wallet? wallet = null;
        if (debit is not null)
        {
            List<(long Id, long Amount)> stacks = [];
            await using (var read = new NpgsqlCommand($"SELECT id,amount FROM {schema}.inventory_items WHERE player_id=$1 AND loot_id=$2 AND ship_id IS NULL AND amount>0 ORDER BY id FOR UPDATE", connection, transaction))
            {
                read.Parameters.AddWithValue(debit.PlayerId); read.Parameters.AddWithValue(debit.Ammo); await using var reader = await read.ExecuteReaderAsync();
                while (await reader.ReadAsync()) stacks.Add((reader.GetInt64(0), reader.GetInt64(1)));
            }
            long available = stacks.Sum(s => s.Amount);
            if (available < debit.Amount) return new(false, revision, Reason: "ammo"); // Dispose rolls back checkpoint too.
            long left = debit.Amount;
            foreach (var stack in stacks)
            {
                long take = Math.Min(left, stack.Amount); if (take == 0) break;
                await using var update = new NpgsqlCommand($"UPDATE {schema}.inventory_items SET amount=amount-$1 WHERE id=$2 AND player_id=$3", connection, transaction);
                update.Parameters.AddWithValue(take); update.Parameters.AddWithValue(stack.Id); update.Parameters.AddWithValue(debit.PlayerId); await update.ExecuteNonQueryAsync(); left -= take;
            }
            remaining = available - debit.Amount;
            await using (var cloak = new NpgsqlCommand($"UPDATE {schema}.players SET profile=jsonb_set(profile,ARRAY['cloaked'],'false'::jsonb,true) WHERE id=$1", connection, transaction))
            { cloak.Parameters.AddWithValue(debit.PlayerId); await cloak.ExecuteNonQueryAsync(); }
            await using (var cooldown = new NpgsqlCommand($"UPDATE {schema}.player_combat SET laser_ready_at=clock_timestamp()+interval '1 second',rsb_ready_at=CASE WHEN $2='ammunition_laser_rsb-75' THEN clock_timestamp()+interval '3 seconds' ELSE rsb_ready_at END WHERE player_id=$1", connection, transaction))
            { cooldown.Parameters.AddWithValue(debit.PlayerId); cooldown.Parameters.AddWithValue(debit.Ammo); await cooldown.ExecuteNonQueryAsync(); }
            if (debit.Claim is not null)
            {
                await using (var claim = new NpgsqlCommand($"INSERT INTO {schema}.npc_reward_claims VALUES($1,$2,$3,$4,$5,$6) ON CONFLICT DO NOTHING", connection, transaction))
                {
                    Key(claim, key); claim.Parameters.AddWithValue(debit.Claim); claim.Parameters.AddWithValue(debit.PlayerId); claim.Parameters.AddWithValue(debit.Id);
                    if (await claim.ExecuteNonQueryAsync() != 1) throw new InvalidDataException("NPC kill generation already paid");
                }
                var r = await Reward(connection, transaction, debit.PlayerId, debit.Reward);
                await using var credit = new NpgsqlCommand($"""
                UPDATE {schema}.player_economy SET credits=credits+$1,uridium=uridium+$2,ep=ep+$3,honour=honour+$4,
                level=greatest(level,1+(SELECT count(*)::integer FROM generate_series(0,30) n WHERE ep+$3>=10000*power(2::numeric,n)))
                WHERE player_id=$5 RETURNING credits,uridium,ep,honour,level
                """, connection, transaction);
                credit.Parameters.AddWithValue(r.Credits); credit.Parameters.AddWithValue(r.Uridium); credit.Parameters.AddWithValue(r.Ep); credit.Parameters.AddWithValue(r.Honour); credit.Parameters.AddWithValue(debit.PlayerId);
                await using var reader = await credit.ExecuteReaderAsync();
                if (!await reader.ReadAsync()) throw new InvalidDataException("Player economy absent");
                wallet = new(reader.GetDecimal(0), reader.GetDecimal(1), reader.GetDecimal(2), reader.GetDecimal(3), reader.GetInt32(4));
            }
            var result = new WorldCommit(true, revision + 1, wallet, remaining);
            await using var receipt = new NpgsqlCommand($"INSERT INTO {schema}.combat_receipts(id,player_id,fingerprint,result) VALUES($1,$2,$3,$4)", connection, transaction);
            receipt.Parameters.AddWithValue(debit.Id); receipt.Parameters.AddWithValue(debit.PlayerId); receipt.Parameters.AddWithValue(fingerprint); receipt.Parameters.AddWithValue(NpgsqlDbType.Jsonb, JsonSerializer.Serialize(result)); await receipt.ExecuteNonQueryAsync();
        }
        await transaction.CommitAsync(); return new(true, revision + 1, wallet, remaining);
    }
    private async Task<NpcReward> Reward(NpgsqlConnection connection, NpgsqlTransaction transaction, long player, NpcReward reward)
    {
        decimal ep = 0, honour = 0;
        var modules = await new EquipmentRepository(source, schema.Trim('"')).RewardModules(connection, transaction, player);
        if (WorldContent.Default.RewardHulls[modules.Hull] is { } hullDefinition)
        { ep = hullDefinition["ep"]?.GetValue<decimal>() ?? 0; honour = hullDefinition["honour"]?.GetValue<decimal>() ?? 0; }
        ep += (decimal)DarkOrbit.Server.Equipment.EquipmentStats.N(modules.Effects["ep"]); honour += (decimal)DarkOrbit.Server.Equipment.EquipmentStats.N(modules.Effects["honour"]);
        decimal rawEp = Math.Round(reward.Ep * (1 + ep), MidpointRounding.AwayFromZero), rawHonour = Math.Round(reward.Honour * (1 + honour), MidpointRounding.AwayFromZero);
        ep = 0; honour = 0;
        await using (var boosts = new NpgsqlCommand($"SELECT loot_id FROM {schema}.active_boosters WHERE player_id=$1 AND expires_at>extract(epoch FROM clock_timestamp())*1000 ORDER BY loot_id", connection, transaction))
        {
            boosts.Parameters.AddWithValue(player); await using var reader = await boosts.ExecuteReaderAsync();
            while (await reader.ReadAsync()) if (WorldContent.Default.RewardBoosters[reader.GetString(0)] is { } definition)
            { ep += definition["EXPERIENCE_POINTS"]?.GetValue<decimal>() ?? 0; honour += definition["HONOUR_POINTS"]?.GetValue<decimal>() ?? 0; }
        }
        return reward with { Ep = Math.Round(rawEp * (1 + ep / 100), MidpointRounding.AwayFromZero), Honour = Math.Round(rawHonour * (1 + honour / 100), MidpointRounding.AwayFromZero) };
    }
    public async ValueTask DisposeAsync()
    {
        if (fence == 0) return;
        await using var command = source.CreateCommand($"UPDATE {schema}.world_authority SET expires_at=clock_timestamp() WHERE server_id=$1 AND owner=$2 AND fence=$3");
        command.Parameters.AddWithValue(serverId); command.Parameters.AddWithValue(owner); command.Parameters.AddWithValue(fence); await command.ExecuteNonQueryAsync();
    }
}
