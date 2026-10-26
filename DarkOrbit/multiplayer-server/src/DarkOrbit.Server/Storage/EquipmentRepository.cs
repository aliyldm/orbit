using System.Data;
using System.Globalization;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using DarkOrbit.Server.Equipment;
using Npgsql;

namespace DarkOrbit.Server.Storage;

public sealed partial class EquipmentRepository
{
    private readonly NpgsqlDataSource source;
    private readonly string schema;
    [GeneratedRegex("^mp_[a-f0-9]{16}$")] private static partial Regex SchemaPattern();
    public EquipmentRepository(NpgsqlDataSource source, string schema)
    {
        if (!SchemaPattern().IsMatch(schema)) throw new ArgumentException("Invalid equipment schema");
        this.source = source; this.schema = '"' + schema + '"';
    }
    private NpgsqlCommand Command(NpgsqlConnection connection, NpgsqlTransaction transaction, string sql, params object[] values)
    {
        var command = new NpgsqlCommand(sql, connection, transaction);
        foreach (var value in values) command.Parameters.AddWithValue(value); return command;
    }
    private async Task<JsonArray> Rows(NpgsqlConnection connection, NpgsqlTransaction transaction, string sql, params object[] values)
    {
        await using var command = Command(connection, transaction, sql, values); await using var reader = await command.ExecuteReaderAsync(); var array = new JsonArray();
        while (await reader.ReadAsync()) array.Add(JsonNode.Parse(reader.GetString(0))); return array;
    }
    public async Task<JsonObject> Context(long playerId, long shipId, int? config = null, long? at = null)
    {
        await using var connection = await source.OpenConnectionAsync(); await using var transaction = await connection.BeginTransactionAsync(IsolationLevel.RepeatableRead);
        var result = await Context(connection, transaction, playerId, shipId, config, at ?? DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        await transaction.CommitAsync(); return result;
    }
    private async Task<JsonObject> Context(NpgsqlConnection connection, NpgsqlTransaction transaction, long playerId, long shipId, int? config, long now)
    {
        var rows = await Rows(connection, transaction, $"SELECT s.record::text FROM {schema}.owned_ships s WHERE s.id=$1 AND s.player_id=$2", shipId, playerId);
        if (rows.Count != 1 || rows[0]?["id"] is null) throw new InvalidDataException("Canonical ship record absent"); var ship = rows[0]!.AsObject();
        int active = config ?? (int)EquipmentStats.N(ship["active_config"], 1); if (active is not (1 or 2)) throw new ArgumentException("Invalid configuration");
        var type = (await Rows(connection, transaction, $"SELECT record::text FROM {schema}.equipment_ship_types WHERE loot_id=$1", EquipmentStats.S(ship["loot_id"]))).Single()!;
        var mounts = await Rows(connection, transaction, $"""
        SELECT (to_jsonb(i)||t.record||jsonb_build_object('id',i.id,'loot_id',i.loot_id,'amount',i.amount,'upgrade_level',i.upgrade_level,
          'slot',CASE WHEN e.target='drone' THEN i.slot ELSE e.slot END,'slot_index',e.slot_index,'ship_id',e.ship_id,'config_id',e.config_id,
          'drone_slot',CASE WHEN e.target='drone' THEN e.slot ELSE NULL END,'drone_id',e.drone_id,'target',e.target))::text
        FROM {schema}.equipment_mounts e JOIN {schema}.inventory_items i ON i.id=e.item_id AND i.player_id=e.player_id
        JOIN {schema}.equipment_item_types t ON t.loot_id=i.loot_id WHERE e.player_id=$1 AND e.ship_id=$2 AND e.config_id=$3
        ORDER BY CASE WHEN e.target='ship' THEN 0 ELSE 1 END,e.target_id,e.slot_index,i.id
        """, playerId, shipId, active);
        var levels = await Rows(connection, transaction, $"SELECT jsonb_build_object('id',skill_id,'level',level)::text FROM {schema}.equipment_skill_levels WHERE player_id=$1 ORDER BY skill_id", playerId);
        var skills = new JsonObject(); foreach (var level in levels) skills[EquipmentStats.S(level!["id"])] = level["level"]!.DeepClone();
        int formation;
        await using (var command = Command(connection, transaction, $"SELECT formation_id FROM {schema}.equipment_formations WHERE player_id=$1", playerId)) formation = (int?)await command.ExecuteScalarAsync() ?? 0;
        long version;
        await using (var command = Command(connection, transaction, $"SELECT equipment_revision FROM {schema}.players WHERE id=$1", playerId)) version = (long)(await command.ExecuteScalarAsync())!;
        var result = new JsonObject { ["ship"] = ship.DeepClone(), ["type"] = type.DeepClone(), ["equipped"] = new JsonArray(mounts.Where(n => EquipmentStats.S(n!["target"]) == "ship").Select(n => n!.DeepClone()).ToArray()),
            ["drones"] = await Rows(connection, transaction, $"SELECT record::text FROM {schema}.equipment_drones WHERE player_id=$1 ORDER BY id", playerId),
            ["droneEquipment"] = new JsonArray(mounts.Where(n => EquipmentStats.S(n!["target"]) == "drone").Select(n => n!.DeepClone()).ToArray()), ["formationId"] = formation,
            ["petEquipment"] = new JsonArray(mounts.Where(n => EquipmentStats.S(n!["target"]) == "pet").Select(n => n!.DeepClone()).ToArray()),
            ["skillLevels"] = skills, ["oreBuffs"] = await Rows(connection, transaction, $"SELECT to_jsonb(b)::text FROM {schema}.equipment_ore_buffs b WHERE player_id=$1 ORDER BY item_type", playerId),
            ["boosters"] = await Rows(connection, transaction, $"SELECT to_jsonb(b)::text FROM {schema}.active_boosters b WHERE player_id=$1 ORDER BY loot_id", playerId), ["now"] = now, ["revision"] = version };
        await using (var command = Command(connection, transaction, $"SELECT coalesce(sum(amount),0)::bigint FROM {schema}.equipment_resources WHERE player_id=$1 AND ore_type<>3", playerId)) result["cargoUsed"] = (long)(await command.ExecuteScalarAsync())!;
        result["designs"] = await Rows(connection, transaction, $"SELECT jsonb_build_object('loot_id',loot_id)::text FROM {schema}.equipment_designs WHERE player_id=$1 ORDER BY loot_id", playerId);
        result["pet"] = (await Rows(connection, transaction, $"SELECT record::text FROM {schema}.equipment_pets WHERE player_id=$1", playerId)).FirstOrDefault()?.DeepClone();
        result["petSlots"] = (await Rows(connection, transaction, $"SELECT record::text FROM {schema}.equipment_pet_slots WHERE player_id=$1", playerId)).FirstOrDefault()?.DeepClone() ?? new JsonObject();
        var formations = new HashSet<int> { 0 };
        foreach (var item in await Rows(connection, transaction, $"SELECT jsonb_build_object('loot_id',loot_id)::text FROM {schema}.inventory_items WHERE player_id=$1 AND amount>0 ORDER BY id", playerId))
            if (EquipmentContent.Default.Document["formationIds"]?[EquipmentStats.S(item!["loot_id"])] is { } value) formations.Add((int)EquipmentStats.N(value));
        result["availableFormations"] = new JsonArray(formations.Select(id => (JsonNode)JsonValue.Create(id)!).ToArray());
        return result;
    }
    internal async Task<NativePilot> Hydrate(NativePilot pilot, NpgsqlConnection connection, NpgsqlTransaction transaction)
    {
        if (pilot.Profile["shipId"] is not { } id) return pilot;
        return Project(pilot, await Context(connection, transaction, pilot.PlayerId, (long)EquipmentStats.N(id), null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()));
    }
    public async Task<NativePilot> Hydrate(NativePilot pilot)
    {
        if (pilot.Profile["shipId"] is not { } id) return pilot; // Synthetic protocol-only fixtures have no owned hull.
        return Project(pilot, await Context(pilot.PlayerId, (long)EquipmentStats.N(id)));
    }
    private static NativePilot Project(NativePilot pilot, JsonObject context)
    {
        var stats = EquipmentStats.Compute(context); var ship = context["ship"]!;
        var profile = pilot.Profile.DeepClone().AsObject(); profile["stats"] = stats; profile["equipmentState"] = context;
        profile["activeConfig"] = ship["active_config"]!.DeepClone(); profile["speed"] = stats["speed"]!.DeepClone();
        foreach (var key in new[] { "hitMax", "shieldMax" }) profile[key] = stats[key]!.DeepClone();
        profile["hitPoints"] = Math.Min(EquipmentStats.N(ship["hitpoints"]), EquipmentStats.N(stats["hitMax"])); profile["shield"] = Math.Min(EquipmentStats.N(ship["shield"]), EquipmentStats.N(stats["shieldMax"]));
        string hull = EquipmentStats.S(ship["loot_id"]); profile["maxNanoHull"] = EquipmentStats.N(EquipmentContent.Default.Meta(hull)["maxNanoHull"]);
        profile["nanoHull"] = Math.Min(EquipmentStats.N(ship["nano_hull"]), EquipmentStats.N(profile["maxNanoHull"])); profile["cargoSpaceMax"] = stats["cargoMax"]!.DeepClone();
        profile["cargoSpace"] = Math.Max(0, EquipmentStats.N(stats["cargoMax"]) - EquipmentStats.N(context["cargoUsed"]));
        string appearance = hull;
        if (ship["design_loot_id"] is { } desired && EquipmentStats.S(desired) != hull)
        {
            string design = EquipmentStats.S(desired);
            if (context["designs"]!.AsArray().Any(d => EquipmentStats.S(d!["loot_id"]) == design) && EquipmentStats.N(EquipmentContent.Default.Meta(design)["baseShipId"], -1) == EquipmentStats.N(EquipmentContent.Default.Meta(hull)["shipId"], -2)) appearance = design;
        }
        profile["typeId"] = appearance; profile["expansionStage"] = EquipmentStats.N(stats["shipLaserCount"]) > 1 ? EquipmentStats.N(EquipmentContent.Default.Document["expansion"]?[appearance], 1) : 1;
        profile["equipmentRevision"] = context["revision"]!.DeepClone();
        var expiries = context["oreBuffs"]!.AsArray().Where(b => EquipmentStats.N(b!["item_type"]) >= 2).Concat(context["boosters"]!.AsArray()).Select(b => EquipmentStats.N(b!["expires_at"])).Where(e => e > EquipmentStats.N(context["now"])).ToArray();
        profile["equipmentExpiresAt"] = expiries.Length == 0 ? long.MaxValue : (long)expiries.Min();
        return pilot with { Profile = profile };
    }
    internal async Task<(string Hull, JsonObject Effects)> RewardModules(NpgsqlConnection connection, NpgsqlTransaction transaction, long player)
    {
        string hull; int config, level;
        await using (var command = Command(connection, transaction, $"SELECT s.loot_id,coalesce((s.record->>'active_config')::integer,1),e.level FROM {schema}.players p JOIN {schema}.owned_ships s ON s.id=p.active_ship_id AND s.player_id=p.id JOIN {schema}.player_economy e ON e.player_id=p.id WHERE p.id=$1", player))
        {
            await using var reader = await command.ExecuteReaderAsync(); if (!await reader.ReadAsync()) return ("", new());
            hull = reader.GetString(0); config = reader.GetInt32(1); level = reader.GetInt32(2);
        }
        var items = await Rows(connection, transaction, $"SELECT jsonb_build_object('loot_id',i.loot_id,'slot',m.slot)::text FROM {schema}.equipment_mounts m JOIN {schema}.inventory_items i ON i.id=m.item_id AND i.player_id=m.player_id JOIN {schema}.players p ON p.id=m.player_id AND p.active_ship_id=m.ship_id WHERE m.player_id=$1 AND m.config_id=$2 AND m.target='ship' AND m.slot='ship_upgrade' ORDER BY m.slot_index,i.id", player, config);
        var effects = EquipmentStats.Modules(hull, items.Select(i => i!.AsObject()), level);
        if (hull == "ship_orcus") foreach (var key in effects.Select(p => p.Key).ToArray()) effects[key] = EquipmentStats.N(effects[key]) * 1.75;
        return (hull, effects);
    }
}
