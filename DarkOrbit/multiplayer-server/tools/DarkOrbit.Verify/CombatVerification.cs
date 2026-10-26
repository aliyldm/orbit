using System.Security.Authentication;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;
using DarkOrbit.Server.World;
using Npgsql;
using NpgsqlTypes;

internal static class CombatVerification
{
    public static async Task Run()
    {
        int assertions = 0; void Check(bool ok, string message) { assertions++; if (!ok) throw new InvalidOperationException(message); }
        var pg = Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES")!; var options = new NpgsqlConnectionStringBuilder(pg);
        if (options.Host != "127.0.0.1" || options.Port != 55432 || options.Database != "darkorbit_development") throw new InvalidOperationException("Only isolated development storage is permitted");
        await using var source = NpgsqlDataSource.Create(pg);
        var archive = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/postgresql-rehearsal.json"))!;
        string schema = "mp_" + Convert.ToHexStringLower(RandomNumberGenerator.GetBytes(8)), q = '"' + schema + '"';
        await NativeBootstrap.Create(source, archive["schema"]!.GetValue<string>(), schema, "artifacts/private/native-profiles.json", archive["snapshotSha256"]!.GetValue<string>());
        async Task Execute(string sql) { await using var command = source.CreateCommand(sql); await command.ExecuteNonQueryAsync(); }
        async Task<T> Scalar<T>(string sql) { await using var command = source.CreateCommand(sql); return (T)(await command.ExecuteScalarAsync())!; }
        async Task Reject<T>(Func<Task> action, string message) where T : Exception
        { bool rejected = false; try { await action(); } catch (T) { rejected = true; } Check(rejected, message); }
        try
        {
            var doc = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/private/native-profiles.json"))!;
            var hero = doc["profiles"]![0]!["commands"]!.AsArray().First(c => c!["_"]!.GetValue<string>() == "ShipInitializationCommand")!;
            for (int i = 1; i <= 3; i++)
            {
                long id = 900100 + i; var profile = hero.DeepClone().AsObject(); profile.Remove("shipId"); profile["userId"] = id; profile["level"] = 1;
                await using var account = source.CreateCommand($"INSERT INTO {q}.accounts VALUES($1,$2,'synthetic-no-login',0)"); account.Parameters.AddWithValue(id); account.Parameters.AddWithValue("combatqa" + i); await account.ExecuteNonQueryAsync();
                await using var player = source.CreateCommand($"INSERT INTO {q}.players(id,account_id,server_id,map_id,x,y,profile,initial_commands,connection_owner,connection_fence) VALUES($1,$1,1,$2,5000,5000,$3,$4,'qa',1)");
                player.Parameters.AddWithValue(id); player.Parameters.AddWithValue(i == 3 ? 2 : 19); player.Parameters.AddWithValue(NpgsqlDbType.Jsonb, profile.ToJsonString()); player.Parameters.AddWithValue(NpgsqlDbType.Jsonb, new JsonArray(hero.DeepClone()).ToJsonString()); await player.ExecuteNonQueryAsync();
                await Execute($"INSERT INTO {q}.player_economy VALUES({id},9007199254740993.25,10.5,0,-5,1); INSERT INTO {q}.player_combat(player_id) VALUES({id}); INSERT INTO {q}.inventory_items VALUES({id * 10},{id},'ammunition_laser_lcb-10',3,NULL,NULL,NULL,0),({id * 10 + 1},{id},'ammunition_laser_lcb-10',20,NULL,NULL,NULL,0),({id * 10 + 2},{id},'ammunition_laser_lcb-10',999,1,'laser',0,0)");
            }
            string legacy = '"' + archive["schema"]!.GetValue<string>() + '"';
            Check(await Scalar<long>($"SELECT count(*) FROM {q}.inventory_items WHERE player_id<900000") == await Scalar<long>($"SELECT count(*) FROM {legacy}.items"), "All archived inventory rows copied once without touching source");
            await using var store = new CombatRepository(source, schema, 1); await store.Acquire();
            await using var rival = new CombatRepository(source, schema, 1);
            await Reject<AuthenticationException>(() => rival.Acquire(), "Second live host cannot take the same server world");
            var clock = new CombatTime(); var map = WorldContent.Default.Maps[19]; var key = new MapKey(1, 19, Guid.Empty);
            var actor = new MapActor(key, map.Width, map.Height, clock, content: map, randomSeed: 41, persistence: store);
            var a = new SessionLease(900101, Guid.NewGuid()); var b = new SessionLease(900102, Guid.NewGuid());
            var npc = (await actor.Snapshot()).Npcs.First(n => n.Key == "kristallon" && !map.Peace(n.X + 300, n.Y, 1));
            await actor.Join(new(a, npc.X + 300, npc.Y, 400)); await actor.Join(new(b, npc.X + 400, npc.Y, 400));
            ShotDebit Debit(long player, int amount = 5) => new(Guid.NewGuid(), player, new("qa", 1), "ammunition_laser_lcb-10", amount, null, new());
            static NpcReward Reward(JsonObject def) { var r = def["reward"]!; return new(r["credits"]!.GetValue<decimal>(), r["uridium"]!.GetValue<decimal>(), r["ep"]!.GetValue<decimal>(), r["honour"]!.GetValue<decimal>()); }
            async Task Ready(long id) => await Execute($"UPDATE {q}.player_combat SET laser_ready_at='-infinity',rsb_ready_at='-infinity' WHERE player_id={id}");
            async Task<long> Ammo(long id) => await Scalar<long>($"SELECT sum(amount)::bigint FROM {q}.inventory_items WHERE player_id={id} AND ship_id IS NULL");
            var hit = await actor.AttackNpc(a, npc.Id, 1000, .8, 600, Debit(a.PlayerId), Reward);
            Check(hit.Commit.Accepted && hit.Damage.State!.Hp == npc.Hp - 200 && await Ammo(a.PlayerId) == 18, "One transaction persists native damage and multi-stack ammunition debit");
            Check(await Scalar<long>($"SELECT amount FROM {q}.inventory_items WHERE id=9001010") == 0 && await Scalar<long>($"SELECT amount FROM {q}.inventory_items WHERE id=9001011") == 18 && await Scalar<long>($"SELECT amount FROM {q}.inventory_items WHERE id=9001012") == 999, "Debit spans free stacks and excludes equipped inventory");
            var cooldown = await actor.AttackNpc(a, npc.Id, 1000, .8, 600, Debit(a.PlayerId), Reward);
            Check(!cooldown.Commit.Accepted && cooldown.Commit.Reason == "cooldown" && await Ammo(a.PlayerId) == 18 && (await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id).Hp == npc.Hp - 200, "Repeated packet cannot bypass the persistent one-second laser clock");
            await Ready(a.PlayerId); long version = await Scalar<long>($"SELECT revision FROM {q}.world_checkpoints WHERE map_id=19");
            var empty = await actor.AttackNpc(a, npc.Id, 1000, .8, 600, Debit(a.PlayerId, 100), Reward);
            Check(!empty.Commit.Accepted && empty.Commit.Reason == "ammo" && await Scalar<long>($"SELECT revision FROM {q}.world_checkpoints WHERE map_id=19") == version, "Insufficient ammo rolls back the map checkpoint too");
            Check((await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id).Hp == npc.Hp - 200, "Failed debit restores actor HP and shield before another command can observe it");
            var lethal = await Task.WhenAll(actor.AttackNpc(a, npc.Id, 2000000, .8, 600, Debit(a.PlayerId), Reward), actor.AttackNpc(b, npc.Id, 2000000, .8, 600, Debit(b.PlayerId), Reward));
            var winner = lethal.Single(x => x.Damage.Killed);
            Check(lethal.Count(x => x.Commit.Accepted) == 1 && await Scalar<long>($"SELECT count(*) FROM {q}.npc_reward_claims") == 1, "Two simultaneous attackers produce one persistent kill claim/payout");
            Check(winner.Commit.Wallet!.Credits == 9007199254740993.25m + 409600 && winner.Commit.Wallet.Uridium == 138.5m && winner.Commit.Wallet.Ep == 51200 && winner.Commit.Wallet.Level == 4, "Reward preserves fractional and greater-than-JS-safe balances; level thresholds match legacy");
            var reloaded = await new NativePlayerRepository(source, schema).Load(lethal[0].Damage.Killed ? a.PlayerId : b.PlayerId);
            Check(reloaded!.Profile["credits"]!.GetValue<decimal>() == winner.Commit.Wallet.Credits && reloaded.Level == 4, "Reconnect loads live PG wallet instead of frozen opening balances");
            await Ready(a.PlayerId); long ammoBeforeDuplicate = await Ammo(a.PlayerId); var checkpoint = await store.Load(key, new());
            await Reject<InvalidDataException>(async () => { await store.Commit(key, checkpoint.Revision, checkpoint.State, Debit(a.PlayerId) with { Claim = winner.Damage.ClaimId }); }, "Another receipt cannot pay the same NPC generation twice");
            Check(await Ammo(a.PlayerId) == ammoBeforeDuplicate && await Scalar<long>($"SELECT revision FROM {q}.world_checkpoints WHERE map_id=19") == checkpoint.Revision, "Duplicate kill claim rolls back its attempted ammo and checkpoint update");
            await actor.DisposeAsync();
            actor = new MapActor(key, map.Width, map.Height, clock, content: map, randomSeed: 777, persistence: store);
            Check(!(await actor.Snapshot()).Npcs.Any(n => n.Id == npc.Id), "Restart restores the dead generation rather than minting a fresh rewarded NPC");
            clock.Advance(31); await actor.Tick(); var respawn = (await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id);
            Check(respawn.Generation == npc.Generation + 1 && respawn.Hp == npc.HpMax, "Persisted respawn deadline produces one new generation");
            await actor.Join(new(b, respawn.X + 100, respawn.Y, 400)); await Ready(b.PlayerId);
            await Execute($"ALTER TABLE {q}.npc_reward_claims ADD CONSTRAINT reject_qa_tail CHECK(player_id<>900102)");
            long beforeAmmo = await Ammo(b.PlayerId);
            await Reject<PostgresException>(async () => { await actor.AttackNpc(b, npc.Id, 2000000, .8, 600, Debit(b.PlayerId), Reward); }, "Late reward constraint failure rejects the complete shot");
            Check(await Ammo(b.PlayerId) == beforeAmmo && await Scalar<long>($"SELECT count(*) FROM {q}.npc_reward_claims") == 1, "Late failure returns ammunition and cannot add a partial reward");
            await Reject<InvalidOperationException>(async () => { await actor.Snapshot(); }, "Ambiguous storage failure fences the in-memory map until recovery");
            await actor.DisposeAsync();
            actor = new MapActor(key, map.Width, map.Height, clock, content: map, persistence: store);
            Check((await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id).Hp == npc.HpMax, "Recovered map reads the last committed HP after failure"); await actor.DisposeAsync();
            // Exact operation replay uses a separate normal map so it does not
            // interfere with the actor's checkpoint revision.
            var replayKey = new MapKey(1, 2, Guid.Empty); var state = new JsonObject { ["test"] = 1 };
            var loaded = await store.Load(replayKey, state); var charge = Debit(900103); var result = await store.Commit(replayKey, loaded.Revision, state, charge);
            var replay = await store.Commit(replayKey, loaded.Revision, state, charge);
            Check(result == replay && await Ammo(900103) == 18, "Exact internal operation retry returns the receipt without another debit");
            await Reject<InvalidDataException>(async () => { await store.Commit(replayKey, loaded.Revision, state, charge with { Amount = 6 }); }, "Operation identity cannot be reused for different contents");
            var epBooster = WorldContent.Default.RewardBoosters.First(p => (p.Value?["EXPERIENCE_POINTS"]?.GetValue<decimal>() ?? 0) > 0);
            var honourBooster = WorldContent.Default.RewardBoosters.First(p => (p.Value?["HONOUR_POINTS"]?.GetValue<decimal>() ?? 0) > 0);
            await Execute($"INSERT INTO {q}.owned_ships(id,player_id,loot_id) VALUES(900103,900103,'ship_g-surgeon'); UPDATE {q}.players SET active_ship_id=900103,profile=jsonb_set(profile,ARRAY['shipId'],'900103'::jsonb,true) WHERE id=900103");
            foreach (var boost in new[] { epBooster, honourBooster })
            {
                await using var command = source.CreateCommand($"INSERT INTO {q}.active_boosters VALUES(900103,$1,$2)"); command.Parameters.AddWithValue(boost.Key); command.Parameters.AddWithValue(DateTimeOffset.UtcNow.AddMinutes(5).ToUnixTimeMilliseconds()); await command.ExecuteNonQueryAsync();
            }
            await Ready(900103);
            var bonus = await store.Commit(replayKey, result.Revision, new JsonObject { ["test"] = 2 }, Debit(900103) with { Claim = "qa-hull-booster", Reward = new(100, 4, 100, 20) });
            decimal epBonus = new[] { epBooster, honourBooster }.Sum(b => b.Value?["EXPERIENCE_POINTS"]?.GetValue<decimal>() ?? 0), honourBonus = new[] { epBooster, honourBooster }.Sum(b => b.Value?["HONOUR_POINTS"]?.GetValue<decimal>() ?? 0);
            Check(bonus.Wallet!.Ep == Math.Round(106 * (1 + epBonus / 100), MidpointRounding.AwayFromZero) && bonus.Wallet.Honour == -5 + Math.Round(21 * (1 + honourBonus / 100), MidpointRounding.AwayFromZero), "Original hull bonus rounding precedes live EP/honour booster rounding");
            await Execute($"UPDATE {q}.active_boosters SET expires_at=0 WHERE player_id=900103"); await Ready(900103);
            var expired = await store.Commit(replayKey, bonus.Revision, new JsonObject { ["test"] = 3 }, Debit(900103) with { Claim = "qa-expired-booster", Reward = new(100, 4, 100, 20) });
            Check(expired.Wallet!.Ep == bonus.Wallet.Ep + 106 && expired.Wallet.Honour == bonus.Wallet.Honour + 21, "Expired boosters cannot keep rewarding from a frozen profile");
            await Execute($"UPDATE {q}.owned_ships SET loot_id='ship_g-veteran' WHERE id=900103; UPDATE {q}.player_economy SET level=15 WHERE player_id=900103; INSERT INTO {q}.inventory_items(id,player_id,loot_id,amount,upgrade_level) VALUES(90010399,900103,'equipment_shipupgrade_spc-xp02',1,0); INSERT INTO {q}.equipment_mounts VALUES(900103,900103,1,'ship',0,NULL,'ship_upgrade',0,90010399)");
            await Ready(900103);
            var moduleBonus = await store.Commit(replayKey, expired.Revision, new JsonObject { ["test"] = 4 }, Debit(900103, 1) with { Claim = "qa-module-under-cap", Reward = new(100, 4, 100, 20) });
            Check(moduleBonus.Wallet!.Ep == expired.Wallet.Ep + 125, "Live hull and compatible EP module add before original rounding at an eligible player level");
            await Execute($"UPDATE {q}.player_economy SET level=17 WHERE player_id=900103"); await Ready(900103);
            var cappedModule = await store.Commit(replayKey, moduleBonus.Revision, new JsonObject { ["test"] = 5 }, Debit(900103, 1) with { Claim = "qa-module-over-cap", Reward = new(100, 4, 100, 20) });
            Check(cappedModule.Wallet!.Ep == moduleBonus.Wallet.Ep + 110, "EP module player-level restriction is checked in the payout transaction, not from frozen stats");
            await Execute($"UPDATE {q}.players SET connection_owner='replacement',connection_fence=2 WHERE id=900103");
            await Reject<AuthenticationException>(async () => { await store.Commit(replayKey, loaded.Revision, state, charge); }, "Old connection cannot replay or spend after replacement");
            await Execute($"UPDATE {q}.world_authority SET expires_at=clock_timestamp()-interval '1 second' WHERE server_id=1");
            await rival.Acquire(); await Reject<AuthenticationException>(async () => { await store.Load(key, new()); }, "Expired/replaced world owner cannot mutate checkpoints");
            await store.DisposeAsync(); Check(await rival.Renew(), "Stale owner cleanup cannot expire the replacement host");
            Console.WriteLine(JsonSerializer.Serialize(new { status = "PASS", combatStorageAssertions = assertions, atomicAmmoHpReward = true, sharedKillClaim = true, restartRecovery = true, receiptReplay = true, hostAndPlayerFencing = true, sourceAccountsUntouched = true, fullGameplayReady = false }));
        }
        finally { await Execute($"DROP SCHEMA {q} CASCADE"); }
    }
    private sealed class CombatTime : TimeProvider
    {
        private long millis; private readonly DateTimeOffset start = DateTimeOffset.UtcNow;
        public override long TimestampFrequency => 1000;
        public override long GetTimestamp() => millis;
        public override DateTimeOffset GetUtcNow() => start.AddMilliseconds(millis);
        public void Advance(int seconds) => millis += seconds * 1000L;
    }
}
