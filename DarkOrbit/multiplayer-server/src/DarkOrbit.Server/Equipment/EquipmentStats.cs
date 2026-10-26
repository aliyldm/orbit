using System.Globalization;
using System.Text.Json.Nodes;

namespace DarkOrbit.Server.Equipment;

// Exact composition order from the old loadPlayer pipeline. Catalogue facts
// come from the old source exporter; client-supplied stats are never accepted.
public static class EquipmentStats
{
    public static double N(JsonNode? node, double fallback = 0) => node is null ? fallback : double.Parse(node.ToJsonString(), CultureInfo.InvariantCulture);
    public static string S(JsonNode? node, string fallback = "") => node?.GetValue<string>() ?? fallback;
    public static double Round(double value) => Math.Floor(value + .5); // JavaScript Math.round, including negative half values.
    private static bool Truth(JsonNode? node) => node is not null && (node is JsonValue v && v.TryGetValue<bool>(out var b) ? b : N(node) != 0);
    private static readonly EquipmentContent C = EquipmentContent.Default;
    public static JsonObject Modules(string hull, IEnumerable<JsonObject> items, int level = 1)
    {
        var result = new JsonObject(); var used = new HashSet<string>(); int capacity = Capacity(hull, "ship_upgrades");
        foreach (var item in items.Where(i => S(i["slot"]) == "ship_upgrade").Take(capacity))
        {
            var def = C.Document["modules"]?[S(item["loot_id"])]; if (def is null || !Compatible(S(item["loot_id"]), hull) || !used.Add(S(def["kind"]))) continue;
            if (def["maxLevel"] is { } max && level > N(max)) continue;
            foreach (var (key, value) in def["effects"]!.AsObject()) result[key] = N(result[key]) + N(value) / 100;
        }
        return result;
    }
    public static int Capacity(string hull, string slot) => (int)N(C.Meta(hull)["slotable"]?["slots"]?.AsArray().FirstOrDefault(s => S(s?["name"]) == slot)?["size"]);
    public static bool Compatible(string item, string hull) => C.Document["modules"]?[item]?["ships"]?.AsArray().Any(s => S(s) == hull) == true;
    private static double Upgraded(JsonObject item, string property, bool general = false)
    {
        var rule = C.Meta(S(item["loot_id"]))["upgradable"];
        bool relevant = general || property == "damage" && S(rule?["upgradeType"]) == "LASER_DAMAGE_UPGRADE" || property == "shield" && S(rule?["upgradeType"]) == "GENERATOR_SHIELD_UPGRADE";
        double value = N(item[property], N(C.Meta(S(item["loot_id"]))[property]));
        return relevant ? value * (1 + N(item["upgrade_level"]) * N(rule?["bonusPerLevel"]) / 100) : value;
    }
    public static JsonObject Compute(JsonObject context)
    {
        var ship = context["ship"]!; string hull = S(ship["loot_id"]); var type = context["type"] as JsonObject ?? C.Ships[hull];
        var own = context["equipped"]!.AsArray().Select(n => n!.DeepClone().AsObject()).ToList();
        var drones = context["drones"]!.AsArray().Select(n => n!.AsObject()).ToArray();
        var droneEq = context["droneEquipment"]!.AsArray().Select(n => n!.AsObject()).ToArray();
        var assigned = new Dictionary<long, string>(); var ids = drones.Select(d => (long)N(d["id"])).ToHashSet();
        foreach (var i in droneEq.Where(i => S(i["drone_slot"]) == "design" && ids.Contains((long)N(i["drone_id"])))) assigned[(long)N(i["drone_id"])] = S(C.Document["droneDesignTypes"]?[S(i["loot_id"])], "cosmetic");
        int Count(string name) => assigned.Values.Count(v => v == name);
        bool Full(string name) => ids.Count > 0 && Count(name) == ids.Count && (name != "spartan" || ids.Count == 10);
        int spartan = Count("spartan"), hermes = Count("hermes"), demon = Count("demon"), cerberus = Count("cerberus");
        double hpBonus = Full("hercules") ? .2 : Full("spartan") ? .15 : spartan * .01;
        var design = new JsonObject { ["counts"] = new JsonObject { ["spartan"] = spartan, ["hermes"] = hermes, ["demon"] = demon, ["cerberus"] = cerberus },
            ["full"] = new JsonObject { ["havoc"] = Full("havoc"), ["hercules"] = Full("hercules"), ["spartan"] = Full("spartan"), ["hermes"] = Full("hermes"), ["demon"] = Full("demon"), ["cerberus"] = Full("cerberus") },
            ["hpBonus"] = hpBonus, ["baseHpBonus"] = hermes * .02, ["rocketMultiplier"] = 1 + Math.Min(.1, demon * .01), ["rocketCooldown"] = Full("hermes") ? .9 : Full("demon") ? .95 : 1,
            ["launcherCooldown"] = Full("hermes") ? .9 : 1, ["mineCooldown"] = Full("hermes") ? .9 : 1, ["abilityCooldownReduction"] = Full("hermes") ? .1 : 0,
            ["evasion"] = Full("cerberus") ? .1 : 0, ["laserEfficiency"] = Full("cerberus") ? .05 : 0, ["npcLaserMultiplier"] = 1 + cerberus * .01 };
        foreach (var source in droneEq.Where(i => S(i["drone_slot"]) == "default"))
        {
            var item = source.DeepClone().AsObject(); var drone = drones.Single(d => N(d["id"]) == N(item["drone_id"]));
            string designType = assigned.GetValueOrDefault((long)N(drone["id"]), "");
            double damageBonus = designType == "havoc" && Full("havoc") ? 1.1 : designType == "spartan" ? 1 + (Full("spartan") ? .1 : .01) : designType == "hermes" ? 1.005 : 1;
            double shieldBonus = designType == "hercules" ? 1.15 : designType == "spartan" && Full("spartan") ? 1.1 : 1;
            var upgrade = C.Document["droneUpgrades"]?[S(drone["loot_id"])]?[((int)N(drone["level"])).ToString(CultureInfo.InvariantCulture)];
            item["damage"] = N(item["damage"]) * (1 + N(drone["level"]) * .02) * damageBonus * (1 + N(drone["upgrade_level"]) * N(upgrade?["DRONE_DAMAGE_UPGRADE"]) / 100);
            item["shield"] = N(item["shield"]) * (1 + N(drone["level"]) * .04) * shieldBonus * (1 + N(drone["upgrade_level"]) * N(upgrade?["DRONE_SHIELD_UPGRADE"]) / 100); own.Add(item);
        }
        var shields = own.Where(i => S(i["category"]) == "shield_generator").ToArray(); var lasers = own.Where(i => S(i["category"]) == "laser").ToArray();
        var passives = new Dictionary<string, double> { ["hp"] = 0, ["shield"] = 0, ["damage"] = 0, ["abilityCooldown"] = 0 };
        foreach (var item in own.Where(i => S(i["slot"]) == "heavy_gun"))
        {
            var def = C.Document["launcherTypes"]?[S(item["loot_id"]).Replace("equipment_weapon_rocketlauncher_", "", StringComparison.Ordinal)];
            foreach (var key in passives.Keys.ToArray()) passives[key] += N(def?[key]);
        }
        double modernHp = lasers.Sum(i => C.Meta(S(i["loot_id"]))["equipable"]?["boostList"]?.AsArray().Where(b => S(b?["type"]) == "HITPOINTS").Sum(b => N(b!["factor"]) / 100) ?? 0);
        var speedGens = own.Where(i => S(i["category"]) == "speed_generator").Sum(i => N(i["speed"]));
        var profiles = new JsonArray(lasers.Select(i => (JsonNode)new JsonObject { ["id"] = i["id"]!.DeepClone(), ["lootId"] = S(i["loot_id"]), ["ship"] = i["drone_id"] is null, ["damage"] = Upgraded(i, "damage", true) }).ToArray());
        var stats = new JsonObject { ["shipModules"] = Modules(hull, own), ["shipModuleCount"] = own.Count(i => S(i["slot"]) == "ship_upgrade" && Compatible(S(i["loot_id"]), hull)),
            ["hitMax"] = Round(N(type["hitpoints"]) * (1 + modernHp) * (1 + passives["hp"])), ["shieldMax"] = Round(Round(shields.Sum(i => Upgraded(i, "shield"))) * (1 + passives["shield"])),
            ["shieldRegenMultiplier"] = 1 + shields.Count(i => new[] { "equipment_generator_shield_fs-01", "equipment_generator_shield_fs-02", "equipment_generator_shield_fs-03" }.Contains(S(i["loot_id"])) && N(i["amount"], 1) != 0) * .0625,
            ["shieldAbsorb"] = shields.Length == 0 ? 0 : shields.Sum(i => N(i["shield_absorb"])) / shields.Length,
            ["speed"] = N(type["speed"]) + speedGens, ["speedGeneratorBonus"] = speedGens, ["laserCount"] = lasers.Length, ["shipLaserCount"] = lasers.Count(i => i["drone_id"] is null),
            ["laserDamage"] = Round(lasers.Sum(i => Upgraded(i, "damage")) * (1 + passives["damage"])), ["rocketMultiplier"] = 1 + passives["damage"], ["abilityCooldownReduction"] = passives["abilityCooldown"], ["laserProfiles"] = profiles,
            ["driveDefense"] = Round(own.Where(i => S(i["slot"]) == "lens").Sum(i => Defense(i, "driveDef"))),
            ["cannonDefense"] = new JsonObject(), ["cargoMax"] = N(type["cargo"]) * (own.Any(i => S(i["slot"]) == "extra" && S(i["loot_id"]) == "equipment_extra_cpu_g3x-crgo-x") ? 2 : 1) };
        foreach (var kind in new[] { "t", "c", "e" }) stats["cannonDefense"]![kind] = Round(own.Where(i => S(i["slot"]) == "cannon_shield" && S(i["loot_id"]).StartsWith("equipment_cannon_shield_mr-" + kind, StringComparison.Ordinal)).Sum(i => Defense(i, "cannonDef")));
        var hullBonus = C.Document["hulls"]?[hull]?.DeepClone().AsObject() ?? new JsonObject(); var modules = stats["shipModules"]!.AsObject();
        if (hull == "ship_orcus") foreach (var key in modules.Select(p => p.Key).ToArray()) modules[key] = N(modules[key]) * 1.75;
        if (hull == "ship_solaris-plus") hullBonus["damage"] = N(hullBonus["damage"]) + .03 * Math.Min(4, N(stats["shipModuleCount"]));
        stats["hitMax"] = Round(N(stats["hitMax"]) * (1 + N(hullBonus["hit"]) + N(modules["hit"])));
        stats["shieldMax"] = Round(N(stats["shieldMax"]) * (1 + N(hullBonus["shield"]) + N(modules["shield"])));
        stats["laserHitBonus"] = N(modules["laserAccuracy"]); stats["rocketHitBonus"] = N(modules["rocketAccuracy"]);
        stats["moduleEvasion"] = N(hullBonus["evasion"]) + N(modules["evasion"]); stats["shieldPenetration"] = N(hullBonus["shieldPenetration"]) + N(modules["shieldPenetration"]);
        stats["laserDamage"] = N(stats["laserDamage"]) * (1 + N(hullBonus["damage"]) + N(modules["damage"]));
        stats["rocketMultiplier"] = N(stats["rocketMultiplier"]) * (1 + N(hullBonus["damage"]) + N(modules["damage"]) + N(modules["rocketDamage"]));
        var formation = C.Document["formations"]?[((int)N(context["formationId"])).ToString(CultureInfo.InvariantCulture)]?.DeepClone().AsObject() ?? new();
        stats["hitMax"] = Round(N(stats["hitMax"]) * (1 + hpBonus)); stats["speedGeneratorBonus"] = N(stats["speedGeneratorBonus"]) * N(formation["speed"], 1);
        foreach (var (key, effect) in new[] { ("hitMax", "hit"), ("shieldMax", "shield"), ("speed", "speed"), ("laserDamage", "laser") }) stats[key] = Round(N(stats[key]) * N(formation[effect], 1));
        stats["shieldAbsorb"] = Math.Clamp(N(stats["shieldAbsorb"]) + N(formation["absorb"]), 0, 1);
        stats["hitMax"] = N(stats["hitMax"]) + Round(N(type["hitpoints"]) * N(design["baseHpBonus"]));
        stats["npcLaserMultiplier"] = N(formation["npcLaser"], 1) * N(design["npcLaserMultiplier"]); stats["rocketMultiplier"] = N(stats["rocketMultiplier"]) * N(formation["rocket"], 1) * N(design["rocketMultiplier"]);
        stats["shieldPenetration"] = Math.Clamp(N(stats["shieldPenetration"]) + N(formation["penetration"]), 0, 1);
        stats["abilityCooldownReduction"] = N(stats["abilityCooldownReduction"]) + N(design["abilityCooldownReduction"]); stats["droneDesigns"] = design; stats["formation"] = formation;
        ApplySkills(stats, context["skillLevels"]!.AsObject());
        double speed = 1, shield = 1;
        foreach (var buff in context["oreBuffs"]!.AsArray().Where(b => N(b!["expires_at"]) > N(context["now"])))
        { double factor = (int)N(buff!["ore_type"]) switch { 5 => 1.1, 6 => 1.2, 7 => 1.4, 28 => 1.5, _ => 1 }; if (N(buff["item_type"]) == 2) speed = factor; if (N(buff["item_type"]) == 3) shield = factor; }
        stats["speed"] = Round(N(stats["speed"]) + N(stats["speedGeneratorBonus"]) * (speed - 1)); stats["shieldMax"] = Round(N(stats["shieldMax"]) * shield);
        var boosts = new Dictionary<string, double>();
        foreach (var booster in context["boosters"]!.AsArray().Where(b => N(b!["expires_at"]) > N(context["now"])))
            foreach (var effect in C.Document["boosterTypes"]?[S(booster!["loot_id"])]?["boostList"]?.AsArray() ?? []) { string key = S(effect!["type"]); boosts[key] = boosts.GetValueOrDefault(key) + N(effect["factor"]); }
        double Factor(string key) => 1 + boosts.GetValueOrDefault(key) / 100;
        stats["hitMax"] = Round(N(stats["hitMax"]) * Factor("HITPOINTS")); stats["shieldMax"] = Round(N(stats["shieldMax"]) * Factor("SHIELD")); stats["laserDamage"] = N(stats["laserDamage"]) * Factor("DAMAGE");
        stats["npcLaserMultiplier"] = N(stats["npcLaserMultiplier"], 1) * Factor("DAMAGE_NPC"); stats["rocketMultiplier"] = N(stats["rocketMultiplier"], 1) * Factor("DAMAGE") * Factor("DAMAGE_NPC");
        stats["repairMultiplier"] = Factor("REPAIR"); stats["shieldRegenMultiplier"] = N(stats["shieldRegenMultiplier"], 1) * Factor("SHIELD_REGENERATION");
        stats["laserHitBonus"] = N(stats["laserHitBonus"]) + boosts.GetValueOrDefault("LASER_HIT_CHANCE") / 100; stats["rocketHitBonus"] = N(stats["rocketHitBonus"]) + boosts.GetValueOrDefault("ROCKET_HIT_CHANCE") / 100;
        return stats;
    }
    private static double Defense(JsonObject item, string key)
    { var copy = item.DeepClone().AsObject(); copy[key] = N(C.Meta(S(item["loot_id"]))[key]); return Upgraded(copy, key, true); }
    private static void ApplySkills(JsonObject stats, JsonObject levels)
    {
        double At(string id) { int level = (int)N(levels[id]); return level <= 0 ? 0 : N(C.Document["skillBenefits"]![id]!["values"]![level - 1]) / 100; }
        double Either(string first, string second) => N(levels[second]) != 0 ? At(second) : At(first);
        string hullId = N(levels["18b"]) != 0 ? "18b" : "18a"; int hullLevel = (int)N(levels[hullId]);
        var skills = new JsonObject { ["hull"] = hullLevel > 0 ? N(C.Document["skillBenefits"]![hullId]!["values"]![hullLevel - 1]) : 0, ["shield"] = At("17"), ["absorb"] = At("8"), ["cargo"] = At("4"),
            ["repairMultiplier"] = 1 + At("13"), ["npcLaserMultiplier"] = 1 + At("11"), ["rocketMultiplier"] = 1 + At("6"), ["npcEpMultiplier"] = 1 + At("2"), ["npcCreditsMultiplier"] = 1 + At("9"),
            ["honourMultiplier"] = 1 + Either("21a", "21b"), ["bonusUridiumMultiplier"] = 1 + Either("23a", "23b"), ["bonusLootMultiplier"] = 1 + At("15"), ["cargoLootMultiplier"] = 1 + At("14"),
            ["pvpLaserMultiplier"] = 1 + Either("22a", "22b"), ["evasion"] = Either("16a", "16b"), ["rocketAccuracy"] = At("20"), ["laserAccuracy"] = At("19"), ["mineDamageMultiplier"] = 1 + Either("5a", "5b"), ["mineRadiusMultiplier"] = 1 + At("1") };
        stats["hitMax"] = N(stats["hitMax"]) + N(skills["hull"]); stats["shieldMax"] = Round(N(stats["shieldMax"]) * (1 + N(skills["shield"])));
        stats["shieldAbsorb"] = Math.Min(1, N(stats["shieldAbsorb"]) + N(skills["absorb"])); stats["cargoMax"] = Round(N(stats["cargoMax"]) * (1 + N(skills["cargo"])));
        stats["npcLaserMultiplier"] = N(stats["npcLaserMultiplier"], 1) * N(skills["npcLaserMultiplier"]); stats["rocketMultiplier"] = N(stats["rocketMultiplier"], 1) * N(skills["rocketMultiplier"]); stats["skills"] = skills;
    }
}
