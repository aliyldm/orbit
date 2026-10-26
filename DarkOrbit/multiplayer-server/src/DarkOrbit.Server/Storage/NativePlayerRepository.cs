using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using Npgsql;
using DarkOrbit.Server.World;
using DarkOrbit.Server.Equipment;

namespace DarkOrbit.Server.Storage;

public sealed record MapDefinition(int Id, int Width, int Height, bool Private = false);
public sealed record AccountLogin(long AccountId, long PlayerId, string PasswordHash);
public sealed record NativePilot(long PlayerId, long AccountId, int ServerId, int MapId, double X, double Y, JsonObject Profile, JsonArray Commands)
{
    public double Speed => Profile["speed"]!.GetValue<double>();
    public bool Dead => Profile["hitPoints"]!.GetValue<double>() <= 0;
    public int Faction => Profile["factionId"]!.GetValue<int>();
    public int Level => Profile["level"]?.GetValue<int>() ?? Commands.First(c => c!["_"]!.GetValue<string>() == "ShipInitializationCommand")!["level"]!.GetValue<int>();
    public bool Cloaked => Profile["cloaked"]?.GetValue<bool>() ?? Commands.First(c => c!["_"]!.GetValue<string>() == "ShipInitializationCommand")!["cloaked"]!.GetValue<bool>();
    private static readonly HashSet<string> MapCommands = ["AssetCreateCommand", "SpaceStationCommand", "MapAddPOICommand", "QuestGiversAvailableCommand", "MapAssetActionAvailableCommand", "JumpgateCreateCommand", "POIReadyCommand", "BeaconCommand", "AddBoxCommand", "AddOreCommand"];
    public JsonObject Create(double x, double y)
    {
        var hero = Commands.First(c => c!["_"]!.GetValue<string>() == "ShipInitializationCommand")!;
        var result = new JsonObject { ["_"] = "ShipCreateCommand", ["userId"] = PlayerId, ["x"] = (int)Math.Round(x), ["y"] = (int)Math.Round(y), ["npc"] = false,
            ["clanDiplomacy"] = new JsonObject { ["_"] = "ClanRelationModule", ["type"] = 0 },
            ["minimapStrategyModule"] = new JsonObject { ["_"] = "MinimapStrategyModule", ["minimapStrategy"] = 0 }, ["modifier"] = new JsonArray() };
        foreach (string field in new[] { "typeId", "expansionStage", "userName", "clanTag", "factionId", "clanId", "dailyRank", "galaxyGatesDone", "useSystemFont", "cloaked" }) result[field] = hero[field]?.DeepClone();
        foreach (string field in new[] { "typeId", "expansionStage", "cloaked" }) if (Profile[field] is { } value) result[field] = value.DeepClone();
        return result;
    }
    public IEnumerable<JsonObject> PublicDecorations() => Profile["equipmentState"] is JsonObject ? EquipmentCommands.Public(Profile) : Commands.Where(c =>
        c!["_"]!.GetValue<string>() == "DroneFormationChangeCommand" ||
        c["_"]!.GetValue<string>() == "LegacyModule" && c["message"]!.GetValue<string>().StartsWith($"0|n|d|{PlayerId}|", StringComparison.Ordinal)).Select(c => c!.DeepClone().AsObject());
    public IEnumerable<byte[]> Initialization(LegacyCodec codec, WorldContent? world = null)
    {
        foreach (var node in Commands)
        {
            var command = node!.DeepClone().AsObject(); string name = command["_"]!.GetValue<string>();
            if (world is not null && MapCommands.Contains(name)) continue;
            if (Profile["equipmentState"] is JsonObject && (name is "DroneFormationChangeCommand" or "DroneFormationAvailableFormationsCommand" or "ShipUpgradeModuleUpdateCommand" || name == "LegacyModule" && command["message"]!.GetValue<string>().StartsWith($"0|n|d|{PlayerId}|", StringComparison.Ordinal))) continue;
            if (name == "ShipInitializationCommand")
            {
                command["x"] = (int)Math.Round(X); command["y"] = (int)Math.Round(Y); command["mapId"] = MapId;
                command["cloaked"] = Cloaked;
                foreach (var field in new[] { "credits", "uridium", "ep", "honourPoints", "level", "typeId", "expansionStage", "speed", "hitPoints", "hitMax", "shield", "shieldMax", "nanoHull", "maxNanoHull", "cargoSpace", "cargoSpaceMax" }) if (Profile[field] is { } value) command[field] = value.DeepClone();
            }
            if (name == "AttributeShieldUpdateCommand") { command["shieldNow"] = Profile["shield"]?.DeepClone(); command["shieldMax"] = Profile["shieldMax"]?.DeepClone(); }
            if (name == "AttributeShipSpeedUpdateCommand") { command["newSpeed"] = Speed; command["displaySpeed"] = Speed; }
            if (name == "HitpointInfoCommand" && Profile["equipmentState"] is JsonObject) command = EquipmentCommands.Hitpoints(Profile);
            if (name == "LegacyModule" && command["message"]!.GetValue<string>().StartsWith("0|S|CFG|", StringComparison.Ordinal) && Profile["activeConfig"] is { } config) command["message"] = $"0|S|CFG|{EquipmentStats.N(config)}";
            if (name == "BeaconCommand") { command["positionX"] = (int)Math.Round(X); command["positionY"] = (int)Math.Round(Y); command["positionAheadX"] = (int)Math.Round(X); command["positionAheadY"] = (int)Math.Round(Y); }
            yield return NativeFrames.Frame(codec.Encode(command));
        }
        if (Profile["equipmentState"] is JsonObject)
            foreach (var command in EquipmentCommands.Public(Profile).Append(EquipmentCommands.Modules(Profile)).Append(EquipmentCommands.AvailableFormations(Profile))) yield return NativeFrames.Frame(codec.Encode(command));
        if (world is not null && world.Maps.TryGetValue(MapId, out var map))
            foreach (var command in map.Initialization(Faction, X, Y, Dead)) yield return NativeFrames.Frame(codec.Encode(command));
    }
}

// Equipment and economy are read from live tables in a consistent snapshot.
// Other, not-yet-ported opening messages remain compatibility projections.
public sealed partial class NativePlayerRepository
{
    private readonly NpgsqlDataSource source;
    private readonly string schema;
    public EquipmentRepository Equipment { get; }
    [GeneratedRegex("^mp_[a-f0-9]{16}$")]
    private static partial Regex SchemaPattern();
    public NativePlayerRepository(NpgsqlDataSource source, string schema)
    {
        if (!SchemaPattern().IsMatch(schema)) throw new ArgumentException("Invalid native development schema");
        this.source = source; this.schema = '"' + schema + '"'; Equipment = new(source, schema);
    }
    public async Task<AccountLogin?> FindAccount(string username, CancellationToken cancellation = default)
    {
        await using var command = source.CreateCommand($"SELECT a.id,p.id,a.password_hash FROM {schema}.accounts a JOIN {schema}.players p ON p.account_id=a.id WHERE a.username=$1");
        command.Parameters.AddWithValue(username); await using var reader = await command.ExecuteReaderAsync(cancellation);
        return await reader.ReadAsync(cancellation) ? new(reader.GetInt64(0), reader.GetInt64(1), reader.GetString(2)) : null;
    }
    public async Task<NativePilot?> Load(long playerId, CancellationToken cancellation = default)
    {
        await using var connection = await source.OpenConnectionAsync(cancellation);
        await using var transaction = await connection.BeginTransactionAsync(System.Data.IsolationLevel.RepeatableRead, cancellation);
        await using var command = new NpgsqlCommand($"""
        SELECT p.id,p.account_id,p.server_id,p.map_id,p.x,p.y,
          (p.profile || CASE WHEN p.active_ship_id IS NULL THEN jsonb_build_object() ELSE jsonb_build_object('shipId',p.active_ship_id) END || CASE WHEN e.player_id IS NULL THEN jsonb_build_object() ELSE jsonb_build_object('credits',e.credits,'uridium',e.uridium,'ep',e.ep,'honourPoints',e.honour,'level',e.level) END)::text,p.initial_commands::text
        FROM {schema}.players p LEFT JOIN {schema}.player_economy e ON e.player_id=p.id WHERE p.id=$1
        """, connection, transaction);
        command.Parameters.AddWithValue(playerId); NativePilot? pilot;
        await using (var reader = await command.ExecuteReaderAsync(cancellation))
            pilot = await reader.ReadAsync(cancellation) ? new(reader.GetInt64(0), reader.GetInt64(1), reader.GetInt32(2), reader.GetInt32(3), reader.GetDouble(4), reader.GetDouble(5), JsonNode.Parse(reader.GetString(6))!.AsObject(), JsonNode.Parse(reader.GetString(7))!.AsArray()) : null;
        if (pilot is not null) pilot = await Equipment.Hydrate(pilot, connection, transaction);
        await transaction.CommitAsync(cancellation); return pilot;
    }
    public async Task<long> EquipmentRevision(long playerId)
    {
        await using var command = source.CreateCommand($"SELECT equipment_revision FROM {schema}.players WHERE id=$1"); command.Parameters.AddWithValue(playerId);
        return (long?)await command.ExecuteScalarAsync() ?? throw new InvalidDataException("Pilot is absent");
    }
    public async Task<IReadOnlyDictionary<int, MapDefinition>> Maps()
    {
        await using var command = source.CreateCommand($"SELECT id,width,height,private FROM {schema}.maps");
        await using var reader = await command.ExecuteReaderAsync(); Dictionary<int, MapDefinition> maps = [];
        while (await reader.ReadAsync()) { var map = new MapDefinition(reader.GetInt32(0), reader.GetInt32(1), reader.GetInt32(2), reader.GetBoolean(3)); maps.Add(map.Id, map); }
        return maps;
    }
    public async Task<bool> Claim(long playerId, ConnectionLease lease)
    {
        await using var command = source.CreateCommand($"UPDATE {schema}.players SET connection_owner=$1,connection_fence=$2 WHERE id=$3 AND connection_fence<$2");
        command.Parameters.AddWithValue(lease.Owner); command.Parameters.AddWithValue(lease.Fence); command.Parameters.AddWithValue(playerId);
        return await command.ExecuteNonQueryAsync() == 1;
    }
    public async Task<IReadOnlyDictionary<string, long>> Ammo(long playerId)
    {
        await using var command = source.CreateCommand($"SELECT loot_id,sum(amount)::bigint FROM {schema}.inventory_items WHERE player_id=$1 AND ship_id IS NULL AND loot_id LIKE 'ammunition_laser_%' GROUP BY loot_id");
        command.Parameters.AddWithValue(playerId); await using var reader = await command.ExecuteReaderAsync(); Dictionary<string, long> result = [];
        while (await reader.ReadAsync()) result[reader.GetString(0)] = reader.GetInt64(1); return result;
    }
    public async Task<bool> SavePosition(long playerId, ConnectionLease lease, int mapId, double x, double y)
    {
        if (!double.IsFinite(x) || !double.IsFinite(y)) throw new ArgumentException("Invalid authoritative position");
        await using var command = source.CreateCommand($"UPDATE {schema}.players SET map_id=$1,x=$2,y=$3 WHERE id=$4 AND connection_owner=$5 AND connection_fence=$6");
        command.Parameters.AddWithValue(mapId); command.Parameters.AddWithValue(x); command.Parameters.AddWithValue(y); command.Parameters.AddWithValue(playerId); command.Parameters.AddWithValue(lease.Owner); command.Parameters.AddWithValue(lease.Fence);
        return await command.ExecuteNonQueryAsync() == 1;
    }
    public async Task<bool> SaveVitals(NativePilot pilot, ConnectionLease lease)
    {
        if (pilot.Profile["shipId"] is null) return true;
        double hp = EquipmentStats.N(pilot.Profile["hitPoints"]), shield = EquipmentStats.N(pilot.Profile["shield"]), nano = EquipmentStats.N(pilot.Profile["nanoHull"]);
        if (new[] { hp, shield, nano }.Any(v => !double.IsFinite(v) || v < 0)) throw new ArgumentException("Invalid authoritative vitals");
        await using var connection = await source.OpenConnectionAsync(); await using var transaction = await connection.BeginTransactionAsync();
        await using (var own = new NpgsqlCommand($"SELECT 1 FROM {schema}.players WHERE id=$1 AND active_ship_id=$2 AND connection_owner=$3 AND connection_fence=$4 FOR UPDATE", connection, transaction))
        {
            own.Parameters.AddWithValue(pilot.PlayerId); own.Parameters.AddWithValue(EquipmentRepository.Id(pilot.Profile["shipId"])); own.Parameters.AddWithValue(lease.Owner); own.Parameters.AddWithValue(lease.Fence);
            if (await own.ExecuteScalarAsync() is null) return false;
        }
        await using var update = new NpgsqlCommand($"UPDATE {schema}.owned_ships SET record=record||jsonb_build_object('hitpoints',$1::double precision,'shield',$2::double precision,'nano_hull',$3::double precision) WHERE id=$4 AND player_id=$5", connection, transaction);
        update.Parameters.AddWithValue(hp); update.Parameters.AddWithValue(shield); update.Parameters.AddWithValue(nano); update.Parameters.AddWithValue(EquipmentRepository.Id(pilot.Profile["shipId"])); update.Parameters.AddWithValue(pilot.PlayerId);
        if (await update.ExecuteNonQueryAsync() != 1) return false;
        await transaction.CommitAsync(); return true;
    }
}
