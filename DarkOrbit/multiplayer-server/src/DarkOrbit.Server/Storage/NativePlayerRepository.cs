using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using Npgsql;

namespace DarkOrbit.Server.Storage;

public sealed record MapDefinition(int Id, int Width, int Height, bool Private = false);
public sealed record AccountLogin(long AccountId, long PlayerId, string PasswordHash);
public sealed record NativePilot(long PlayerId, long AccountId, int ServerId, int MapId, double X, double Y, JsonObject Profile, JsonArray Commands)
{
    public double Speed => Profile["speed"]!.GetValue<double>();
    public bool Dead => Profile["hitPoints"]!.GetValue<double>() <= 0;
    public JsonObject Create(double x, double y)
    {
        var hero = Commands.First(c => c!["_"]!.GetValue<string>() == "ShipInitializationCommand")!;
        var result = new JsonObject { ["_"] = "ShipCreateCommand", ["userId"] = PlayerId, ["x"] = (int)Math.Round(x), ["y"] = (int)Math.Round(y), ["npc"] = false,
            ["clanDiplomacy"] = new JsonObject { ["_"] = "ClanRelationModule", ["type"] = 0 },
            ["minimapStrategyModule"] = new JsonObject { ["_"] = "MinimapStrategyModule", ["minimapStrategy"] = 0 }, ["modifier"] = new JsonArray() };
        foreach (string field in new[] { "typeId", "expansionStage", "userName", "clanTag", "factionId", "clanId", "dailyRank", "galaxyGatesDone", "useSystemFont", "cloaked" }) result[field] = hero[field]?.DeepClone();
        return result;
    }
    public IEnumerable<JsonObject> PublicDecorations() => Commands.Where(c =>
        c!["_"]!.GetValue<string>() == "DroneFormationChangeCommand" ||
        c["_"]!.GetValue<string>() == "LegacyModule" && c["message"]!.GetValue<string>().StartsWith($"0|n|d|{PlayerId}|", StringComparison.Ordinal)).Select(c => c!.DeepClone().AsObject());
    public IEnumerable<byte[]> Initialization(LegacyCodec codec)
    {
        foreach (var node in Commands)
        {
            var command = node!.DeepClone().AsObject(); string name = command["_"]!.GetValue<string>();
            if (name == "ShipInitializationCommand") { command["x"] = (int)Math.Round(X); command["y"] = (int)Math.Round(Y); command["mapId"] = MapId; }
            if (name == "BeaconCommand") { command["positionX"] = (int)Math.Round(X); command["positionY"] = (int)Math.Round(Y); command["positionAheadX"] = (int)Math.Round(X); command["positionAheadY"] = (int)Math.Round(Y); }
            yield return NativeFrames.Frame(codec.Encode(command));
        }
    }
}

// Stage-2 development repository. Derived stats/init are compatibility
// projections until their individual live feature repositories are ported.
public sealed partial class NativePlayerRepository
{
    private readonly NpgsqlDataSource source;
    private readonly string schema;
    [GeneratedRegex("^mp_[a-f0-9]{16}$")]
    private static partial Regex SchemaPattern();
    public NativePlayerRepository(NpgsqlDataSource source, string schema)
    {
        if (!SchemaPattern().IsMatch(schema)) throw new ArgumentException("Invalid native development schema");
        this.source = source; this.schema = '"' + schema + '"';
    }
    public async Task<AccountLogin?> FindAccount(string username, CancellationToken cancellation = default)
    {
        await using var command = source.CreateCommand($"SELECT a.id,p.id,a.password_hash FROM {schema}.accounts a JOIN {schema}.players p ON p.account_id=a.id WHERE a.username=$1");
        command.Parameters.AddWithValue(username); await using var reader = await command.ExecuteReaderAsync(cancellation);
        return await reader.ReadAsync(cancellation) ? new(reader.GetInt64(0), reader.GetInt64(1), reader.GetString(2)) : null;
    }
    public async Task<NativePilot?> Load(long playerId, CancellationToken cancellation = default)
    {
        await using var command = source.CreateCommand($"SELECT id,account_id,server_id,map_id,x,y,profile::text,initial_commands::text FROM {schema}.players WHERE id=$1");
        command.Parameters.AddWithValue(playerId); await using var reader = await command.ExecuteReaderAsync(cancellation);
        return await reader.ReadAsync(cancellation) ? new(reader.GetInt64(0), reader.GetInt64(1), reader.GetInt32(2), reader.GetInt32(3), reader.GetDouble(4), reader.GetDouble(5), JsonNode.Parse(reader.GetString(6))!.AsObject(), JsonNode.Parse(reader.GetString(7))!.AsArray()) : null;
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
    public async Task<bool> SavePosition(long playerId, ConnectionLease lease, int mapId, double x, double y)
    {
        if (!double.IsFinite(x) || !double.IsFinite(y)) throw new ArgumentException("Invalid authoritative position");
        await using var command = source.CreateCommand($"UPDATE {schema}.players SET map_id=$1,x=$2,y=$3 WHERE id=$4 AND connection_owner=$5 AND connection_fence=$6");
        command.Parameters.AddWithValue(mapId); command.Parameters.AddWithValue(x); command.Parameters.AddWithValue(y); command.Parameters.AddWithValue(playerId); command.Parameters.AddWithValue(lease.Owner); command.Parameters.AddWithValue(lease.Fence);
        return await command.ExecuteNonQueryAsync() == 1;
    }
}
