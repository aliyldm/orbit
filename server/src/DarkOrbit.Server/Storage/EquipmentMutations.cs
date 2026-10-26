using System.Globalization;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Equipment;
using Npgsql;
using NpgsqlTypes;

namespace DarkOrbit.Server.Storage;

public sealed partial class EquipmentRepository
{
    private static readonly Dictionary<string, string> Slots = new() { ["lasers"] = "laser", ["generators"] = "generator", ["extras"] = "extra", ["heavy_guns"] = "heavy_gun", ["cannons"] = "cannon", ["drives"] = "drive", ["cannon_shields"] = "cannon_shield", ["lenses"] = "lens", ["ship_upgrades"] = "ship_upgrade", ["QuantumFluidCore"] = "quantum_core" };
    private static readonly Dictionary<string, int> Extensions = new() { ["equipment_extra_cpu_sle-01"] = 2, ["equipment_extra_cpu_sle-02"] = 4, ["equipment_extra_cpu_sle-03"] = 6, ["equipment_extra_cpu_sle-04"] = 10 };
    private static readonly Dictionary<string, string> PetSlots = new() { ["lasers"] = "laser", ["laser"] = "laser", ["generators"] = "generator", ["generator"] = "generator", ["gears"] = "gear", ["gear"] = "gear", ["protocols"] = "protocol", ["protocol"] = "protocol", ["visual"] = "visual" };
    public static long Id(JsonNode? value)
    {
        string text = value is JsonValue v && v.TryGetValue<string>(out var s) ? s : value?.ToJsonString() ?? "";
        if (!long.TryParse(text, NumberStyles.None, CultureInfo.InvariantCulture, out long id) || id <= 0 || id > 9007199254740991L) throw new ArgumentException("Geçersiz kimlik veya miktar."); return id;
    }
    public static int Configuration(JsonNode? value) { long config = value is null ? 1 : Id(value); if (config is not (1 or 2)) throw new ArgumentException("Geçersiz konfigürasyon."); return (int)config; }
    private static int Config(JsonNode? value) => Configuration(value);
    private static long[] Ids(JsonNode? value, int limit)
    {
        if (value is not JsonArray array || array.Count == 0 || array.Count > limit) throw new ArgumentException("Geçersiz eşya listesi.");
        var ids = array.Select(Id).ToArray(); if (ids.Distinct().Count() != ids.Length) throw new ArgumentException("Tekrarlanan eşya kimliği."); return ids;
    }
    private async Task<int> Execute(NpgsqlConnection c, NpgsqlTransaction tx, string sql, params object[] values)
    { await using var command = Command(c, tx, sql, values); return await command.ExecuteNonQueryAsync(); }
    private async Task<JsonNode> Mutate(long player, Func<NpgsqlConnection, NpgsqlTransaction, Task<JsonNode>> action, Func<bool>? affectsEquipment = null)
    {
        await using var c = await source.OpenConnectionAsync(); await using var tx = await c.BeginTransactionAsync();
        await using (var own = Command(c, tx, $"SELECT 1 FROM {schema}.players WHERE id=$1 FOR UPDATE", player)) if (await own.ExecuteScalarAsync() is null) throw new ArgumentException("Oyuncu bulunamadı.");
        var result = await action(c, tx);
        if (affectsEquipment?.Invoke() == false) { await tx.CommitAsync(); return result; }
        await Execute(c, tx, $"UPDATE {schema}.players SET equipment_revision=equipment_revision+1 WHERE id=$1", player);
        await using (var active = Command(c, tx, $"SELECT active_ship_id FROM {schema}.players WHERE id=$1", player))
        {
            var id = await active.ExecuteScalarAsync(); if (id is long ship)
            {
                var context = await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()); var stats = EquipmentStats.Compute(context); var record = context["ship"]!.DeepClone().AsObject();
                record["hitpoints"] = Math.Min(EquipmentStats.N(record["hitpoints"]), EquipmentStats.N(stats["hitMax"])); record["shield"] = Math.Min(EquipmentStats.N(record["shield"]), EquipmentStats.N(stats["shieldMax"]));
                await SaveShip(c, tx, player, ship, record);
            }
        }
        await tx.CommitAsync(); return result;
    }
    private async Task SaveShip(NpgsqlConnection c, NpgsqlTransaction tx, long player, long ship, JsonObject record)
    {
        await using var command = new NpgsqlCommand($"UPDATE {schema}.owned_ships SET record=$1 WHERE id=$2 AND player_id=$3", c, tx);
        command.Parameters.AddWithValue(NpgsqlDbType.Jsonb, record.ToJsonString()); command.Parameters.AddWithValue(ship); command.Parameters.AddWithValue(player); await command.ExecuteNonQueryAsync();
    }
    private static string SlotFor(JsonObject item)
    {
        var meta = EquipmentContent.Default.Meta(EquipmentStats.S(item["loot_id"])); string cls = EquipmentStats.S(meta["typeClass"]); if (cls.Contains(".ammo.", StringComparison.Ordinal)) return "";
        return cls.Split('.').Last() switch { "LaserType" => "laser", "EngineType" or "ShieldType" => "generator", "CPUType" or "ExtraType" or "RobotType" or "ModuleType" or "UpgradeType" => "extra", "HellstormLauncherType" => "heavy_gun", "CannonType" => "cannon", "DriveType" => "drive", "CannonShieldType" => "cannon_shield", "LensType" => "lens", "ShipUpgradeType" => "ship_upgrade", "QuantumFluidCoreType" => "quantum_core", _ => EquipmentStats.S(item["category"]) switch { "laser" => "laser", "shield_generator" or "speed_generator" => "generator", "extra" or "cpu" => "extra", "rocket_launcher" => "heavy_gun", _ => "" } };
    }
    private static int ExtraCapacity(JsonObject type, IEnumerable<JsonObject> equipped) => (int)EquipmentStats.N(type["extra_slots"]) + equipped.Select(i => Extensions.GetValueOrDefault(EquipmentStats.S(i["loot_id"]))).DefaultIfEmpty(0).Max();
    private static void ModulesValid(string hull, IEnumerable<JsonObject> layout)
    {
        var kinds = new HashSet<string>(); foreach (var item in layout.Where(i => EquipmentStats.S(i["slot"]) == "ship_upgrade"))
        {
            string id = EquipmentStats.S(item["loot_id"]); if (!EquipmentStats.Compatible(id, hull)) throw new ArgumentException("Bu modül seçili gemiye takılamaz.");
            if (!kinds.Add(EquipmentStats.S(EquipmentContent.Default.Document["modules"]![id]!["kind"]))) throw new ArgumentException("Aynı sınıftan yalnızca bir gemi modülü takılabilir.");
        }
    }
    private static JsonNode? PetItem(JsonObject item) => EquipmentContent.Default.Document["petItems"]?[EquipmentStats.S(item["loot_id"])]?.AsArray().ElementAtOrDefault((int)EquipmentStats.N(item["pet_level"], 1) - 1);
    private static bool PetAccepts(JsonObject item, string slot, JsonObject context)
    {
        string id = EquipmentStats.S(item["loot_id"]), cls = EquipmentStats.S(EquipmentContent.Default.Meta(id)["typeClass"]);
        if (slot == "visual") return EquipmentContent.Default.Document["petAppearances"]?[id] is not null && cls.EndsWith(".PetCustomizationType", StringComparison.Ordinal);
        if (slot == "laser") return EquipmentStats.S(item["category"]) == "laser" || cls.EndsWith(".LaserType", StringComparison.Ordinal);
        if (slot == "generator") return EquipmentStats.S(item["category"]) == "shield_generator" || cls.EndsWith(".ShieldType", StringComparison.Ordinal);
        var entry = PetItem(item);
        return entry is not null && EquipmentStats.S(entry["kind"]) == (slot == "gear" ? "gear" : slot == "protocol" ? "protocol" : "") && entry["supported"]?.GetValue<bool>() == true && EquipmentStats.N(context["pet"]?["level"]) >= EquipmentStats.N(entry["minimumPetLevel"]);
    }
    private static void CannonsValid(IEnumerable<JsonObject> layout)
    {
        var types = layout.Where(i => EquipmentStats.S(i["slot"]) == "cannon").Select(i => (int)EquipmentStats.N(EquipmentContent.Default.Document["cannonTypes"]?[EquipmentStats.S(i["loot_id"])], -1)).ToArray();
        if (types.Any(t => t < 0) || types.Distinct().Count() != types.Length) throw new ArgumentException("Her parçacık topu türünden yalnızca bir tane takılabilir.");
    }
    public Task<JsonNode> Move(long player, JsonObject request, bool partial = true) => Mutate(player, (c, tx) => Move(c, tx, player, request, partial));
    private async Task<JsonNode> Move(NpgsqlConnection c, NpgsqlTransaction tx, long player, JsonObject request, bool partial)
    {
        var from = request["from"]?.AsObject() ?? new(); var to = request["to"]?.AsObject() ?? new(); long ship = Id(request["params"]?["hi"] ?? request["hangarId"] ?? request["params"]?["hangarId"]);
        int config = Config(to["configId"] ?? from["configId"]); if (from["configId"] is not null && Config(from["configId"]) != config) throw new ArgumentException("Konfigürasyonlar arası taşıma desteklenmiyor.");
        string origin = EquipmentStats.S(from["target"]), destination = EquipmentStats.S(to["target"]); if (origin == destination || !(origin == "inventory" || destination == "inventory")) throw new ArgumentException("Geçersiz ekipman hedefi.");
        string target = origin == "inventory" ? destination : origin; if (target is not ("ship" or "drone" or "pet")) throw new ArgumentException("Geçersiz ekipman hedefi.");
        long[] ids = Ids(from["items"], 100); var context = await Context(c, tx, player, ship, config, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        var side = destination == "inventory" ? from : to; string slot = target == "ship" ? Slots.GetValueOrDefault(EquipmentStats.S(side["slotset"]), "") : target == "pet" ? PetSlots.GetValueOrDefault(EquipmentStats.S(side["slotset"]), "") : EquipmentStats.S(side["slotset"], "default");
        long targetId = target == "drone" ? Id(side["droneId"]) : 0;
        var all = await Rows(c, tx, $"SELECT (to_jsonb(i)||t.record||jsonb_build_object('id',i.id,'ship_id',i.ship_id,'slot',i.slot,'slot_index',i.slot_index,'amount',i.amount))::text FROM {schema}.inventory_items i JOIN {schema}.equipment_item_types t ON t.loot_id=i.loot_id WHERE i.player_id=$1 AND i.id=ANY($2) ORDER BY i.id", player, ids);
        if (all.Count != ids.Length) throw new ArgumentException("Eşya bulunamadı."); var byId = all.ToDictionary(i => Id(i!["id"]), i => i!.AsObject()); var items = ids.Select(i => byId[i]).ToArray();
        var mounts = await Rows(c, tx, $"SELECT to_jsonb(e)::text FROM {schema}.equipment_mounts e WHERE player_id=$1 ORDER BY item_id,config_id", player);
        var current = mounts.Where(m => EquipmentStats.N(m!["ship_id"]) == ship && EquipmentStats.N(m["config_id"]) == config).ToArray();
        int capacity;
        if (target == "ship")
        {
            if (slot == "" || items.Any(i => EquipmentStats.N(i["amount"]) != 1 || SlotFor(i) != slot)) throw new ArgumentException("Eşya bu yuvaya uymuyor.");
            foreach (var i in items) if (EquipmentContent.Default.Meta(EquipmentStats.S(i["loot_id"]))["equipable"]?["entities"] is JsonArray entities && !entities.Any(e => EquipmentStats.S(e) == "SHIP")) throw new ArgumentException("Bu eşya gemiye takılamaz.");
            var eq = context["equipped"]!.AsArray().Select(i => i!.AsObject()).ToArray();
            capacity = slot switch { "laser" => (int)EquipmentStats.N(context["type"]!["laser_slots"]), "generator" => (int)EquipmentStats.N(context["type"]!["generator_slots"]), "extra" => ExtraCapacity(context["type"]!.AsObject(), eq), _ => EquipmentStats.Capacity(EquipmentStats.S(context["ship"]!["loot_id"]), Slots.Single(p => p.Value == slot).Key) };
            if (destination == "ship" && slot == "ship_upgrade") ModulesValid(EquipmentStats.S(context["ship"]!["loot_id"]), eq.Concat(items.Select(i => { var copy = i.DeepClone().AsObject(); copy["slot"] = slot; return copy; })));
            if (destination == "ship" && slot == "cannon") CannonsValid(eq.Concat(items.Select(i => { var copy = i.DeepClone().AsObject(); copy["slot"] = slot; return copy; })));
        }
        else if (target == "drone")
        {
            var drone = context["drones"]!.AsArray().FirstOrDefault(d => EquipmentStats.N(d!["id"]) == targetId) ?? throw new ArgumentException("Diroit bulunamadı.");
            var accepted = EquipmentContent.Default.Meta(EquipmentStats.S(drone["loot_id"]))["slotable"]?["slots"]?.AsArray().FirstOrDefault(s => EquipmentStats.S(s!["name"]) == slot);
            if (accepted is null || items.Any(i => EquipmentStats.N(i["amount"]) != 1 || EquipmentContent.Default.Meta(EquipmentStats.S(i["loot_id"]))["equipable"]?["entities"]?.AsArray().Any(e => EquipmentStats.S(e) == "DRONE") != true || accepted["accepts"]!.AsArray().All(t => EquipmentStats.S(t) != EquipmentStats.S(EquipmentContent.Default.Meta(EquipmentStats.S(i["loot_id"]))["typeClass"]).Split('.').Last()))) throw new ArgumentException("Eşya bu diroit yuvasına uymuyor.");
            capacity = (int)EquipmentStats.N(accepted["size"]);
        }
        else
        {
            if (context["pet"] is null) throw new ArgumentException("P.E.T. sahibi değilsin.");
            if (slot == "" || items.Any(i => EquipmentStats.N(i["amount"]) != 1) || destination == "pet" && items.Any(i => !PetAccepts(i, slot, context))) throw new ArgumentException("Eşya bu P.E.T. yuvasına uymuyor veya P.E.T. seviyesi yetersiz.");
            capacity = (int)Math.Max(EquipmentStats.N(EquipmentContent.Default.Document["petSlotBase"]![slot]), EquipmentStats.N(context["petSlots"]?[slot]));
        }
        if (destination == "inventory")
        {
            if (items.Any(i => !current.Any(m => EquipmentStats.N(m!["item_id"]) == Id(i["id"]) && EquipmentStats.S(m["target"]) == target && EquipmentStats.N(m["target_id"]) == targetId && EquipmentStats.S(m["slot"]) == slot))) throw new ArgumentException("Eşya belirtilen yuvada takılı değil.");
            if (target == "ship") CheckExtensionRemoval(context, ids);
            await Execute(c, tx, $"DELETE FROM {schema}.equipment_mounts WHERE player_id=$1 AND item_id=ANY($2) AND config_id=$3", player, ids, config);
            if (target == "ship" && config == 1) await Execute(c, tx, $"UPDATE {schema}.inventory_items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE player_id=$1 AND id=ANY($2)", player, ids);
            return JsonValue.Create(true)!;
        }
        foreach (var i in items)
        {
            long id = Id(i["id"]);
            if (i["ship_id"] is { } owner && EquipmentStats.N(owner) != ship || mounts.Any(m => EquipmentStats.N(m!["item_id"]) == id && (EquipmentStats.N(m["config_id"]) == config || EquipmentStats.N(m["ship_id"]) != ship))) throw new ArgumentException("Eşya başka bir yuvada takılı.");
        }
        var used = current.Where(m => EquipmentStats.S(m!["target"]) == target && EquipmentStats.N(m["target_id"]) == targetId && EquipmentStats.S(m["slot"]) == slot).Select(m => (int)EquipmentStats.N(m!["slot_index"])).ToHashSet();
        int[] free = Enumerable.Range(0, capacity).Where(i => !used.Contains(i)).ToArray(); if (!partial && free.Length < items.Length) return JsonValue.Create(false)!;
        foreach (var (item, index) in items.Take(free.Length).Select((item, n) => (item, n)))
        {
            await Execute(c, tx, $"INSERT INTO {schema}.equipment_mounts VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)", player, ship, config, target, targetId, target == "drone" ? targetId : DBNull.Value, slot, free[index], Id(item["id"]));
            if (target == "ship" && config == 1) await Execute(c, tx, $"UPDATE {schema}.inventory_items SET ship_id=$1,slot=$2,slot_index=$3 WHERE id=$4 AND player_id=$5", ship, slot, free[index], Id(item["id"]), player);
        }
        return free.Length < items.Length ? new JsonArray(items.Skip(free.Length).Select(i => i["id"]!.DeepClone()).ToArray()) : JsonValue.Create(true)!;
    }
    private static void CheckExtensionRemoval(JsonObject context, long[] removed, bool sale = false)
    {
        var eq = context["equipped"]!.AsArray().Select(i => i!.AsObject()).ToArray(); var rest = eq.Where(i => !removed.Contains(Id(i["id"])));
        if (sale && !eq.Any(i => removed.Contains(Id(i["id"])) && Extensions.ContainsKey(EquipmentStats.S(i["loot_id"])))) return;
        int capacity = ExtraCapacity(context["type"]!.AsObject(), rest);
        if (rest.Any(i => EquipmentStats.S(i["slot"]) == "extra" && EquipmentStats.N(i["slot_index"]) >= capacity)) throw new ArgumentException("Önce genişletilmiş yuvalardaki eşyaları çıkar.");
    }
    public Task<JsonNode> Clear(long player, long ship, int config) => Mutate(player, async (c, tx) =>
    {
        await Context(c, tx, player, ship, Config(JsonValue.Create(config)), DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        await Execute(c, tx, $"DELETE FROM {schema}.equipment_mounts WHERE player_id=$1 AND ship_id=$2 AND config_id=$3", player, ship, config);
        if (config == 1) await Execute(c, tx, $"UPDATE {schema}.inventory_items SET ship_id=NULL,slot=NULL,slot_index=NULL WHERE player_id=$1 AND ship_id=$2", player, ship); return JsonValue.Create(true)!;
    });
    public Task<JsonNode> EquipDrones(long player, JsonObject request) => Mutate(player, async (c, tx) =>
    {
        var from = request["from"]?.AsObject() ?? new(); var to = request["to"]?.AsObject() ?? new();
        if (EquipmentStats.S(from["target"]) != "inventory" || EquipmentStats.S(to["target"]) != "drone" || from["droneItems"] is not JsonObject plan || plan.Count is < 1 or > 10) throw new ArgumentException("Geçersiz toplu diroit hedefi.");
        var allIds = plan.SelectMany(p => p.Value is JsonArray a ? a.Select(Id) : throw new ArgumentException("Geçersiz eşya listesi.")).ToArray();
        if (allIds.Length is < 1 or > 100 || allIds.Distinct().Count() != allIds.Length) throw new ArgumentException("Geçersiz toplu eşya listesi.");
        var rejected = new JsonArray();
        foreach (var pair in plan)
        {
            long drone = Id(JsonValue.Create(pair.Key));
            if (drone.ToString(CultureInfo.InvariantCulture) != pair.Key) throw new ArgumentException("Geçersiz diroit kimliği.");
            await using (var own = Command(c, tx, $"SELECT 1 FROM {schema}.equipment_drones WHERE id=$1 AND player_id=$2", drone, player))
                if (await own.ExecuteScalarAsync() is null) throw new ArgumentException("Diroit bulunamadı.");
            if (pair.Value!.AsArray().Count == 0) continue;
            var part = request.DeepClone().AsObject(); part["from"]!["items"] = pair.Value.DeepClone(); part["to"]!["droneId"] = drone;
            var result = await Move(c, tx, player, part, true);
            if (result is JsonArray overflow) foreach (var id in overflow) rejected.Add(id!.DeepClone());
        }
        return rejected.Count == 0 ? JsonValue.Create(true)! : rejected;
    });
    public Task<JsonNode> Switch(long player, long ship, int config) => Mutate(player, async (c, tx) =>
    {
        Config(JsonValue.Create(config)); var context = await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()); var record = context["ship"]!.DeepClone().AsObject(); int previous = (int)EquipmentStats.N(record["active_config"], 1);
        if (previous != config)
        {
            var outgoing = EquipmentStats.Compute(context);
            record["shield"] = Math.Min(EquipmentStats.N(record["shield"]), EquipmentStats.N(outgoing["shieldMax"]));
            record["hitpoints"] = Math.Min(EquipmentStats.N(record["hitpoints"]), EquipmentStats.N(outgoing["hitMax"]));
            await Execute(c, tx, $"INSERT INTO {schema}.equipment_config_shields VALUES($1,$2,$3) ON CONFLICT(ship_id,config_id) DO UPDATE SET shield=excluded.shield", ship, previous, EquipmentStats.N(record["shield"]));
            await using var read = Command(c, tx, $"SELECT shield FROM {schema}.equipment_config_shields WHERE ship_id=$1 AND config_id=$2", ship, config); record["shield"] = (double?)await read.ExecuteScalarAsync() ?? 0;
            record["active_config"] = config; await SaveShip(c, tx, player, ship, record);
        }
        return JsonValue.Create(true)!;
    });
    public Task<JsonNode> Formation(long player, long ship, string lootId) => Mutate(player, async (c, tx) =>
    {
        var context = await Context(c, tx, player, ship, null, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds());
        var value = EquipmentContent.Default.Document["formationIds"]?[lootId];
        if (value is null || !context["availableFormations"]!.AsArray().Any(v => EquipmentStats.N(v) == EquipmentStats.N(value))) throw new ArgumentException("Bu uçuş düzenine sahip değilsin.");
        int id = (int)EquipmentStats.N(value);
        if (id != 0 && context["drones"]!.AsArray().Count < 4) throw new ArgumentException("Uçuş düzeni için en az dört diroit gerekli.");
        await Execute(c, tx, $"INSERT INTO {schema}.equipment_formations VALUES($1,$2) ON CONFLICT(player_id) DO UPDATE SET formation_id=excluded.formation_id", player, id);
        return JsonValue.Create(id)!;
    });
    public Task<JsonNode> Sell(long player, JsonObject request, bool multiple)
    {
        bool affects = false;
        return Mutate(player, async (c, tx) =>
    {
        long[] ids = multiple ? Ids(request["items"], 10000) : [Id(request["itemId"])]; long quantity = multiple ? 0 : Id(request["quantity"]);
        var rows = await Rows(c, tx, $"SELECT to_jsonb(i)::text FROM {schema}.inventory_items i WHERE player_id=$1 AND id=ANY($2) AND amount>0 ORDER BY id", player, ids);
        if (rows.Count != ids.Length) throw new ArgumentException("Eşya bulunamadı.");
        await using (var mounted = Command(c, tx, $"SELECT 1 FROM {schema}.equipment_mounts WHERE player_id=$1 AND item_id=ANY($2) LIMIT 1", player, ids)) affects = await mounted.ExecuteScalarAsync() is not null || rows.Any(r => r!["ship_id"] is not null);
        var removed = new List<long>(); var changed = new JsonObject(); decimal total = 0;
        foreach (var row in rows)
        {
            var meta = EquipmentContent.Default.Meta(EquipmentStats.S(row!["loot_id"])); long amount = multiple ? (long)EquipmentStats.N(row["amount"]) : quantity;
            if (amount > EquipmentStats.N(row["amount"])) throw new ArgumentException("Yeterli eşya yok.");
            double price = EquipmentStats.N(PetItem(row.AsObject())?["sellCredits"], EquipmentStats.N(meta["sellable"]?["credits"])); if (price <= 0 || price != Math.Truncate(price)) throw new ArgumentException("Bu eşya satılamaz.");
            await using var busy = Command(c, tx, $"SELECT 1 FROM {schema}.equipment_jobs WHERE player_id=$1 AND target_id=$2", player, Id(row["id"])); if (await busy.ExecuteScalarAsync() is not null) throw new ArgumentException("İşlemdeki eşya satılamaz.");
            total += (decimal)price * amount;
            if (amount == EquipmentStats.N(row["amount"])) removed.Add(Id(row["id"])); else changed[Id(row["id"]).ToString(CultureInfo.InvariantCulture)] = new JsonObject { ["Q"] = (long)EquipmentStats.N(row["amount"]) - amount };
        }
        foreach (var s in await Rows(c, tx, $"SELECT record::text FROM {schema}.owned_ships WHERE player_id=$1 ORDER BY id", player))
            for (int config = 1; config <= 2; config++) CheckExtensionRemoval(await Context(c, tx, player, Id(s!["id"]), config, DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()), removed.ToArray(), true);
        foreach (var row in rows)
        {
            long id = Id(row!["id"]); if (removed.Contains(id)) await Execute(c, tx, $"DELETE FROM {schema}.inventory_items WHERE player_id=$1 AND id=$2", player, id);
            else await Execute(c, tx, $"UPDATE {schema}.inventory_items SET amount=amount-$1 WHERE player_id=$2 AND id=$3", quantity, player, id);
        }
        await using var money = Command(c, tx, $"UPDATE {schema}.player_economy SET credits=credits+$1 WHERE player_id=$2 AND credits+$1<=9007199254740991 AND trunc(credits+$1)=credits+$1 RETURNING credits", total, player);
        if (total > 9007199254740991m || await money.ExecuteScalarAsync() is null) throw new ArgumentException("Satış tutarı sınırı aşıldı.");
        return new JsonObject { ["deleted"] = new JsonArray(removed.Select(id => (JsonNode)JsonValue.Create(id.ToString(CultureInfo.InvariantCulture))!).ToArray()), ["changed"] = changed };
        }, () => affects);
    }
}
