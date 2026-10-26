using System.Globalization;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Equipment;
using Npgsql;
using NpgsqlTypes;

namespace DarkOrbit.Server.Storage;

public sealed partial class EquipmentRepository
{
    public Task<JsonNode> Favourite(long player, long ship, bool value) => Mutate(player, async (c, tx) =>
    {
        var context = await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        var record = context["ship"]!.DeepClone().AsObject(); record["favorite"] = value ? 1 : 0;
        await SaveShip(c, tx, player, ship, record); return JsonValue.Create(true)!;
    }, () => false);
    // Offline policy is enforced by the hub under the same pilot lock as login.
    public Task<JsonNode> Activate(long player, long ship) => Mutate(player, async (c, tx) =>
    {
        await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        await Execute(c, tx, $"UPDATE {schema}.players SET active_ship_id=$1 WHERE id=$2", ship, player); return new JsonObject();
    });
    public Task<JsonNode> ChangeDesign(long player, long ship, string design) => Mutate(player, async (c, tx) =>
    {
        var context = await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()); var record = context["ship"]!.DeepClone().AsObject();
        string hull = EquipmentStats.S(record["loot_id"]); var catalogue = EquipmentContent.Default;
        if (design != hull && (!context["designs"]!.AsArray().Any(i => EquipmentStats.S(i!["loot_id"]) == design) || EquipmentStats.N(catalogue.Meta(design)["baseShipId"], -1) != EquipmentStats.N(catalogue.Meta(hull)["shipId"], -2))) throw new ArgumentException("Bu tasarıma sahip değilsin veya bu gemiye uymuyor.");
        record["design_loot_id"] = design == hull ? null : design; await SaveShip(c, tx, player, ship, record); return JsonValue.Create(true)!;
    });
    public Task<JsonNode> SaveLayout(long player, long ship) => Mutate(player, async (c, tx) =>
    {
        await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        var mounts = await Rows(c, tx, $"SELECT to_jsonb(e)::text FROM {schema}.equipment_mounts e WHERE player_id=$1 AND ship_id=$2 ORDER BY config_id,CASE target WHEN 'ship' THEN 0 WHEN 'drone' THEN 1 ELSE 2 END,target_id,slot_index,item_id", player, ship);
        var layout = new JsonArray(new JsonArray(), new JsonArray());
        foreach (var m in mounts)
        {
            var row = new JsonObject { ["id"] = m!["item_id"]!.DeepClone(), ["slot"] = m["slot"]!.DeepClone(), ["index"] = m["slot_index"]!.DeepClone() };
            if (EquipmentStats.S(m["target"]) == "drone") row["droneId"] = m["drone_id"]!.DeepClone();
            if (EquipmentStats.S(m["target"]) == "pet") row["pet"] = true;
            layout[(int)EquipmentStats.N(m["config_id"]) - 1]!.AsArray().Add(row);
        }
        await using var command = new NpgsqlCommand($"INSERT INTO {schema}.equipment_saved VALUES($1,$2) ON CONFLICT(ship_id) DO UPDATE SET layout=excluded.layout", c, tx);
        command.Parameters.AddWithValue(ship); command.Parameters.AddWithValue(NpgsqlDbType.Jsonb, layout.ToJsonString()); await command.ExecuteNonQueryAsync(); return JsonValue.Create(true)!;
    }, () => false);
    private static int ShipCapacity(JsonObject context, string slot, IEnumerable<JsonObject> equipped) => slot switch
    {
        "laser" => (int)EquipmentStats.N(context["type"]!["laser_slots"]),
        "generator" => (int)EquipmentStats.N(context["type"]!["generator_slots"]),
        "extra" => ExtraCapacity(context["type"]!.AsObject(), equipped),
        _ => Slots.FirstOrDefault(p => p.Value == slot).Key is { } name ? EquipmentStats.Capacity(EquipmentStats.S(context["ship"]!["loot_id"]), name) : 0
    };
    private static int LayoutCapacity(JsonObject context, string target, long drone, string slot, JsonObject item, IEnumerable<JsonObject> equipped)
    {
        if (target == "ship")
        {
            if (SlotFor(item) != slot) return 0;
            var entities = EquipmentContent.Default.Meta(EquipmentStats.S(item["loot_id"]))["equipable"]?["entities"] as JsonArray;
            if (entities is not null && !entities.Any(e => EquipmentStats.S(e) == "SHIP")) return 0;
            var placed = item.DeepClone().AsObject(); placed["slot"] = slot; var all = equipped.Append(placed);
            ModulesValid(EquipmentStats.S(context["ship"]!["loot_id"]), all); CannonsValid(all);
            return ShipCapacity(context, slot, equipped);
        }
        if (target == "pet")
            return context["pet"] is null || !PetAccepts(item, slot, context) ? 0 : (int)Math.Max(EquipmentStats.N(EquipmentContent.Default.Document["petSlotBase"]?[slot]), EquipmentStats.N(context["petSlots"]?[slot]));
        var row = context["drones"]!.AsArray().FirstOrDefault(d => EquipmentStats.N(d!["id"]) == drone);
        if (row is null) return 0;
        var rule = EquipmentContent.Default.Meta(EquipmentStats.S(row["loot_id"]))["slotable"]?["slots"]?.AsArray().FirstOrDefault(s => EquipmentStats.S(s!["name"]) == slot);
        if (rule is null || rule["accepts"]!.AsArray().All(t => EquipmentStats.S(t) != EquipmentStats.S(EquipmentContent.Default.Meta(EquipmentStats.S(item["loot_id"]))["typeClass"]).Split('.').Last())) return 0;
        return (int)EquipmentStats.N(rule["size"]);
    }
    private async Task ClearAll(NpgsqlConnection c, NpgsqlTransaction tx, long player, long ship)
    {
        await Execute(c, tx, $"DELETE FROM {schema}.equipment_mounts WHERE player_id=$1 AND ship_id=$2", player, ship);
        await Execute(c, tx, $"UPDATE {schema}.inventory_items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE player_id=$1 AND ship_id=$2", player, ship);
    }
    public Task<JsonNode> LoadLayout(long player, long ship) => Mutate(player, async (c, tx) =>
    {
        var context = await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        var saved = await Rows(c, tx, $"SELECT layout::text FROM {schema}.equipment_saved WHERE ship_id=$1", ship);
        if (saved.Count == 0) throw new ArgumentException("Kayıtlı konfigürasyon yok.");
        if (saved[0] is not JsonArray layout || layout.Count != 2 || layout.Any(r => r is not JsonArray)) throw new InvalidDataException("Invalid saved layout");
        var items = (await Rows(c, tx, $"SELECT (to_jsonb(i)||t.record||jsonb_build_object('id',i.id,'loot_id',i.loot_id,'amount',i.amount,'pet_level',i.pet_level))::text FROM {schema}.inventory_items i JOIN {schema}.equipment_item_types t ON t.loot_id=i.loot_id WHERE i.player_id=$1", player)).ToDictionary(i => Id(i!["id"]), i => i!.AsObject());
        var other = await Rows(c, tx, $"SELECT to_jsonb(e)::text FROM {schema}.equipment_mounts e WHERE player_id=$1 AND ship_id<>$2", player, ship);
        var blocked = other.Select(e => Id(e!["item_id"])).ToHashSet(); var proposed = new JsonArray(); bool complete = true;
        for (int config = 1; config <= 2; config++)
        {
            var used = new HashSet<long>(); var occupied = new HashSet<(string, long, string, int)>(); var shipItems = new List<JsonObject>();
            foreach (var row in layout[config - 1]!.AsArray())
            {
                try
                {
                    if (row is not JsonObject entry) throw new ArgumentException("Invalid layout item");
                    long id = Id(entry["id"]); double indexValue = EquipmentStats.N(entry["index"], -1);
                    if (indexValue < 0 || indexValue > int.MaxValue || indexValue != Math.Truncate(indexValue) || !items.TryGetValue(id, out var item) || EquipmentStats.N(item["amount"]) != 1 || item["ship_id"] is { } owner && EquipmentStats.N(owner) != ship || blocked.Contains(id) || used.Contains(id)) throw new ArgumentException("Unavailable layout item");
                    long drone = entry["droneId"] is null ? 0 : Id(entry["droneId"]); string target = entry["pet"]?.GetValue<bool>() == true ? "pet" : drone != 0 ? "drone" : "ship", slot = EquipmentStats.S(entry["slot"]); int index = (int)indexValue;
                    if (index >= LayoutCapacity(context, target, drone, slot, item, shipItems) || occupied.Contains((target, drone, slot, index))) throw new ArgumentException("Unavailable layout slot");
                    used.Add(id); occupied.Add((target, drone, slot, index));
                    if (target == "ship") { var placed = item.DeepClone().AsObject(); placed["slot"] = slot; placed["slot_index"] = index; shipItems.Add(placed); }
                    proposed.Add(new JsonObject { ["config_id"] = config, ["target"] = target, ["target_id"] = drone, ["drone_id"] = target == "drone" ? JsonValue.Create(drone) : null, ["slot"] = slot, ["slot_index"] = index, ["item_id"] = id });
                }
                catch (ArgumentException) { complete = false; }
            }
        }
        await ClearAll(c, tx, player, ship);
        await using (var insert = new NpgsqlCommand($"INSERT INTO {schema}.equipment_mounts SELECT $1,$2,x.config_id,x.target,x.target_id,x.drone_id,x.slot,x.slot_index,x.item_id FROM jsonb_to_recordset($3) AS x(config_id integer,target text,target_id bigint,drone_id bigint,slot text,slot_index integer,item_id bigint)", c, tx))
        { insert.Parameters.AddWithValue(player); insert.Parameters.AddWithValue(ship); insert.Parameters.AddWithValue(NpgsqlDbType.Jsonb, proposed.ToJsonString()); await insert.ExecuteNonQueryAsync(); }
        await Execute(c, tx, $"UPDATE {schema}.inventory_items i SET ship_id=e.ship_id,slot=e.slot,slot_index=e.slot_index FROM {schema}.equipment_mounts e WHERE e.item_id=i.id AND e.player_id=$1 AND e.ship_id=$2 AND e.config_id=1 AND e.target='ship'", player, ship);
        return JsonValue.Create(complete)!;
    });
    public Task<JsonNode> Import(long player, long origin, long target) => Mutate(player, async (c, tx) =>
    {
        if (origin == target) throw new ArgumentException("Kaynak ve hedef gemi aynı.");
        var from = await Context(c, tx, player, origin, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        var to = await Context(c, tx, player, target, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        for (int config = 1; config <= 2; config++)
        {
            var context = await Context(c, tx, player, origin, config, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()); var equipped = context["equipped"]!.AsArray().Select(i => i!.AsObject()).ToArray();
            ModulesValid(EquipmentStats.S(to["ship"]!["loot_id"]), equipped);
            if (equipped.Count(i => EquipmentStats.S(i["slot"]) == "ship_upgrade") > EquipmentStats.Capacity(EquipmentStats.S(to["ship"]!["loot_id"]), "ship_upgrades") || equipped.Any(i => EquipmentStats.N(i["slot_index"]) >= ShipCapacity(to, EquipmentStats.S(i["slot"]), equipped))) throw new ArgumentException("Hedef geminin yuvaları bu konfigürasyon için yetersiz.");
        }
        await ClearAll(c, tx, player, target);
        await Execute(c, tx, $"UPDATE {schema}.equipment_mounts SET ship_id=$1 WHERE player_id=$2 AND ship_id=$3", target, player, origin);
        await Execute(c, tx, $"UPDATE {schema}.inventory_items SET ship_id=$1 WHERE player_id=$2 AND ship_id=$3", target, player, origin);
        var record = to["ship"]!.DeepClone().AsObject(); record["active_config"] = from["ship"]!["active_config"]!.DeepClone(); await SaveShip(c, tx, player, target, record);
        return JsonValue.Create(true)!;
    });
}
