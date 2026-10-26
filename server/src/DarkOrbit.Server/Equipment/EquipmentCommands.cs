using System.Globalization;
using System.Text.Json.Nodes;

namespace DarkOrbit.Server.Equipment;

// Fresh native projections; no captured account's equipment is replayed.
public static class EquipmentCommands
{
    public static JsonObject AvailableFormations(JsonObject p) => new() { ["_"] = "DroneFormationAvailableFormationsCommand", ["availableFormations"] = p["equipmentState"]!["availableFormations"]!.DeepClone() };
    public static JsonObject Hitpoints(JsonObject p) => new() { ["_"] = "HitpointInfoCommand", ["hitpoints"] = p["hitPoints"]?.DeepClone(), ["hitpointsMax"] = p["hitMax"]?.DeepClone(), ["nanoHull"] = p["nanoHull"]?.DeepClone(), ["nanoHullMax"] = p["maxNanoHull"]?.DeepClone() };
    public static JsonObject Modules(JsonObject p)
    {
        var c = p["equipmentState"]!; string hull = EquipmentStats.S(c["ship"]!["loot_id"]);
        var icons = new Dictionary<string, int> { ["HP"] = 1, ["DAMAGE"] = 2, ["SHIELD"] = 3, ["SPECIAL"] = 4 };
        return new JsonObject { ["_"] = "ShipUpgradeModuleUpdateCommand", ["uid"] = p["userId"]!.DeepClone(), ["max"] = EquipmentStats.Capacity(hull, "ship_upgrades"),
            ["moduleTypeIds"] = new JsonArray(c["equipped"]!.AsArray().Where(i => EquipmentStats.S(i!["slot"]) == "ship_upgrade" && EquipmentStats.Compatible(EquipmentStats.S(i["loot_id"]), hull)).Select(i => (JsonNode)JsonValue.Create(icons[EquipmentStats.S(EquipmentContent.Default.Document["modules"]![EquipmentStats.S(i!["loot_id"]) ]!["kind"])])!).ToArray()) };
    }
    public static IEnumerable<JsonObject> Public(JsonObject p)
    {
        var c = p["equipmentState"]!; var fields = new List<string> { "0", "n", "d", EquipmentStats.N(p["userId"]).ToString(CultureInfo.InvariantCulture) };
        foreach (var drone in c["drones"]!.AsArray())
        {
            double id = EquipmentStats.N(drone!["id"]); var eq = c["droneEquipment"]!.AsArray().Where(i => EquipmentStats.N(i!["drone_id"]) == id).ToArray();
            int Design(string slot)
            {
                string loot = EquipmentStats.S(eq.FirstOrDefault(i => EquipmentStats.S(i!["drone_slot"]) == slot)?["loot_id"]);
                return (int)EquipmentStats.N(EquipmentContent.Default.Meta(loot)["designId"], EquipmentStats.N(EquipmentContent.Default.Document["dronePatterns"]?[loot.Replace("drone_designs_", "", StringComparison.Ordinal)]));
            }
            fields.Add(EquipmentStats.N(EquipmentContent.Default.Meta(EquipmentStats.S(drone["loot_id"]))["droneId"]).ToString(CultureInfo.InvariantCulture));
            fields.Add((EquipmentStats.N(drone["level"]) + 1).ToString(CultureInfo.InvariantCulture)); fields.Add(Design("design").ToString(CultureInfo.InvariantCulture)); fields.Add(Design("visual").ToString(CultureInfo.InvariantCulture));
        }
        yield return new JsonObject { ["_"] = "LegacyModule", ["message"] = string.Join('|', fields) };
        yield return new JsonObject { ["_"] = "DroneFormationChangeCommand", ["uid"] = p["userId"]!.DeepClone(), ["selectedFormationId"] = c["formationId"]!.DeepClone() };
    }
}
