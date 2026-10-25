using System.Text.Json.Nodes;

namespace DarkOrbit.Server.World;

// The first outgoing-combat port intentionally accepts the classic damage-only
// subset. Modern procs, SAB/drains, NPC retaliation and live stat rebuilding
// are separate pending ports; readiness remains false.
public static class ClassicLaser
{
    public const string Default = "ammunition_laser_lcb-10", Rsb = "ammunition_laser_rsb-75";
    private static readonly Dictionary<string, (int Multiplier, int Color)> ammo = new()
    { [Default] = (1, 0), ["ammunition_laser_mcb-25"] = (2, 1), ["ammunition_laser_mcb-50"] = (3, 2), ["ammunition_laser_ucb-100"] = (4, 3), [Rsb] = (6, 6) };
    private static readonly HashSet<string> weapons = ["equipment_weapon_laser_mp-1", "equipment_weapon_laser_lf-1", "equipment_weapon_laser_lf-2", "equipment_weapon_laser_lf-3", "equipment_weapon_laser_lf-4"];
    public static bool Supports(string id) => ammo.ContainsKey(id);
    public static int Color(string id) => ammo[id].Color;
    private static double Number(JsonNode? node, double fallback = 0) => node is null ? fallback : node.GetValue<double>();
    public static bool Supports(JsonObject profile) => profile["stats"] is JsonObject s && s["laserProfiles"] is JsonArray list && list.Count > 0 && list.Count == Number(s["laserCount"]) && list.All(l => weapons.Contains(l!["lootId"]!.GetValue<string>())) && double.IsFinite(Number(s["laserDamage"])) && Number(s["laserDamage"]) >= 0 && Number(s["shipModules"]?["ep"]) == 0 && Number(s["shipModules"]?["honour"]) == 0;
    public static int Cost(JsonObject profile) => profile["stats"]!["laserProfiles"]!.AsArray().Count;
    public static double Chance(JsonObject profile)
    {
        var s = profile["stats"]!;
        return Math.Clamp(.8 + Number(s["skills"]?["laserAccuracy"]) + Number(s["laserHitBonus"]) + Number(s["droneDesigns"]?["laserEfficiency"]), 0, 1);
    }
    public static double Absorb(JsonObject profile) => Math.Max(0, .8 - Number(profile["stats"]?["shieldPenetration"]));
    public static int Damage(JsonObject profile, string id, double roll)
    {
        if (!Supports(profile) || !Supports(id) || !double.IsFinite(roll) || roll is < 0 or > 1) throw new ArgumentException("Unsupported classic laser profile");
        var s = profile["stats"]!; var lasers = s["laserProfiles"]!.AsArray(); double total = lasers.Sum(l => Number(l!["damage"]));
        double scale = total > 0 ? Number(s["laserDamage"]) / Math.Round(total, MidpointRounding.AwayFromZero) : 1;
        double sum = lasers.Sum(l => Number(l!["damage"]) + (l["lootId"]!.GetValue<string>() == "equipment_weapon_laser_lf-3" ? 15 : 0));
        return checked((int)Math.Round(Math.Max(0, sum * scale * (.75 + .25 * roll) * ammo[id].Multiplier * Number(s["npcLaserMultiplier"], 1)), MidpointRounding.AwayFromZero));
    }
    public static NpcReward Reward(JsonObject profile, JsonObject definition)
    {
        var r = definition["reward"]!; var s = profile["stats"]!;
        static decimal Rounded(double value) => (decimal)Math.Round(value, MidpointRounding.AwayFromZero);
        return new(Rounded(Number(r["credits"]) * Number(s["skills"]?["npcCreditsMultiplier"], 1)), NumberDecimal(r["uridium"]),
            Rounded(Number(r["ep"]) * Number(s["skills"]?["npcEpMultiplier"], 1) * Number(s["formation"]?["ep"], 1)),
            Rounded(Number(r["honour"]) * Number(s["skills"]?["honourMultiplier"], 1) * Number(s["formation"]?["honour"], 1)));
    }
    private static decimal NumberDecimal(JsonNode? value) => value?.GetValue<decimal>() ?? 0;
    public static JsonObject Status(string id, long count, string selected)
    {
        var command = WorldContent.Default.AmmoTemplates[id]!.DeepClone().AsObject();
        command["counterValue"] = count; command["available"] = count > 0; command["activatable"] = count > 0; command["selected"] = selected == id;
        void Replace(JsonNode? node)
        {
            if (node is JsonObject obj)
            {
                if (obj["wildcard"]?.GetValue<string>() == "%COUNT%") obj["replacement"] = count.ToString(System.Globalization.CultureInfo.InvariantCulture);
                foreach (var child in obj.ToArray()) Replace(child.Value);
            }
            else if (node is JsonArray array) foreach (var child in array) Replace(child);
        }
        Replace(command); return command;
    }
}
