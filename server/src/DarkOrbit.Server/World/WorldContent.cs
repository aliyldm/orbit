using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Runtime;

namespace DarkOrbit.Server.World;

// Exported from the unchanged legacy rule engine, never from a pilot snapshot.
public sealed class WorldContent
{
    public static WorldContent Default { get; } = Load();
    public IReadOnlyDictionary<int, MapContent> Maps { get; }
    public JsonObject NpcTemplate { get; }
    public JsonObject AmmoTemplates { get; }
    public JsonObject RewardHulls { get; }
    public JsonObject RewardBoosters { get; }
    private WorldContent(Dictionary<int, MapContent> maps, JsonObject template, JsonObject ammoTemplates, JsonObject hulls, JsonObject boosters) { Maps = maps; NpcTemplate = template; AmmoTemplates = ammoTemplates; RewardHulls = hulls; RewardBoosters = boosters; }
    private static WorldContent Load()
    {
        using var stream = typeof(WorldContent).Assembly.GetManifestResourceStream("WorldContent.json")!;
        var doc = JsonNode.Parse(stream)!;
        if (doc["format"]!.GetValue<int>() != 1) throw new InvalidDataException("Unsupported world content");
        var maps = doc["maps"]!.AsArray().Select(m => new MapContent(m!.AsObject())).ToDictionary(m => m.Id);
        return new(maps, doc["npcTemplate"]!.AsObject(), doc["ammoTemplates"]!.AsObject(), doc["rewardHulls"]!.AsObject(), doc["rewardBoosters"]!.AsObject());
    }
}

public sealed class MapContent
{
    public int Id { get; }
    public int Faction { get; }
    public int Width { get; }
    public int Height { get; }
    public JsonObject? Station { get; }
    public IReadOnlyList<Portal> Portals { get; }
    public JsonArray Spawns { get; }
    private readonly JsonArray staticCommands;
    private readonly JsonArray afterCommands;
    public MapContent(JsonObject source)
    {
        Id = source["id"]!.GetValue<int>(); Faction = source["faction_id"]!.GetValue<int>();
        Width = source["width"]!.GetValue<int>(); Height = source["height"]!.GetValue<int>();
        Station = source["station"] as JsonObject; Spawns = source["spawns"]!.AsArray();
        Portals = source["portals"]!.AsArray().Select(p => new Portal(p!.AsObject())).ToArray();
        staticCommands = source["staticCommands"]!.AsArray();
        afterCommands = source["afterCommands"]!.AsArray();
    }
    public IEnumerable<Portal> VisiblePortals(int faction) => Portals.Where(p => !p.OwnOnly || p.Faction == faction);
    public bool AtStation(double x, double y, int faction) => Station is { } s && (s["factionId"]!.GetValue<int>() == 0 || s["factionId"]!.GetValue<int>() == faction) &&
        double.Hypot(x - s["x"]!.GetValue<double>(), y - s["y"]!.GetValue<double>()) <= s["radius"]!.GetValue<double>();
    public bool Peace(double x, double y, int faction) => AtStation(x, y, faction) || Faction > 0 && Faction == faction && Nearest(x, y, faction) is not null;
    public Portal? Nearest(double x, double y, int faction) => VisiblePortals(faction).Where(p => p.Distance(x, y) <= 750).OrderBy(p => p.Distance(x, y)).ThenBy(p => p.Id).FirstOrDefault();
    public IEnumerable<JsonObject> Initialization(int faction, double x, double y, bool dead)
    {
        foreach (var c in staticCommands) yield return c!.DeepClone().AsObject();
        foreach (var portal in VisiblePortals(faction))
        {
            yield return portal.Create(); yield return portal.State(!dead && portal.Distance(x, y) <= 750);
        }
        foreach (var c in afterCommands) yield return c!.DeepClone().AsObject();
        yield return new JsonObject { ["_"] = "POIReadyCommand" };
    }
    public JsonObject Beacon(Pilot pilot, int faction, bool dead, MapMotion? motion = null) => new()
    {
        ["_"] = "BeaconCommand", ["repairRobotActive"] = false, ["positionX"] = (int)Math.Round(pilot.X), ["positionY"] = (int)Math.Round(pilot.Y),
        ["positionAheadX"] = (int)Math.Round(motion?.X ?? pilot.X), ["positionAheadY"] = (int)Math.Round(motion?.Y ?? pilot.Y),
        ["inRadiationZone"] = false, ["inStation"] = AtStation(pilot.X, pilot.Y, faction), ["inPeaceArea"] = Peace(pilot.X, pilot.Y, faction),
        ["nearJumpGate"] = !dead && Nearest(pilot.X, pilot.Y, faction) is not null, ["isAlarmEffectActive"] = false, ["repairRobotLootId"] = "", ["repairBotSkilled"] = false
    };
}

public sealed class Portal(JsonObject source)
{
    public int Id { get; } = source["id"]!.GetValue<int>();
    public int Target { get; } = source["target_map"]!.GetValue<int>();
    public int X { get; } = source["x"]!.GetValue<int>();
    public int Y { get; } = source["y"]!.GetValue<int>();
    public int TargetX { get; } = source["target_x"]!.GetValue<int>();
    public int TargetY { get; } = source["target_y"]!.GetValue<int>();
    public int Faction { get; } = source["factionId"]!.GetValue<int>();
    public bool OwnOnly { get; } = source["ownOnly"]!.GetValue<bool>();
    public int Level(int faction) => faction is >= 1 and <= 3 ? Math.Max(source["min_level"]!.GetValue<int>(), source["levels"]![faction - 1]!.GetValue<int>()) : int.MaxValue;
    public double Distance(double x, double y) => double.Hypot(x - X, y - Y);
    public JsonObject Create() => new() { ["_"] = "JumpgateCreateCommand", ["gateId"] = Id, ["factionId"] = 0, ["designId"] = source["design_id"]!.DeepClone(), ["x"] = X, ["y"] = Y, ["isVisibleOnMinimap"] = true, ["showBubble"] = true, ["decoratorAssetTypes"] = new JsonArray() };
    public JsonObject State(bool available) => new()
    {
        ["_"] = "MapAssetActionAvailableCommand", ["mapAssetId"] = Id, ["state"] = available ? 0 : 1, ["activatable"] = available,
        ["toolTip"] = new JsonObject { ["_"] = "MessageKeyListWildcardCommand", ["commandList"] = new JsonArray(new JsonObject {
            ["_"] = "MessageKeyListWildcardModule", ["wildCardReplacements"] = new JsonArray(new JsonObject { ["_"] = "MessageWildcardReplacementModule", ["wildcard"] = "%MAP%", ["replacement"] = Target.ToString(System.Globalization.CultureInfo.InvariantCulture), ["replacementType"] = new JsonObject { ["_"] = "ReplacementTypeModule", ["typeValue"] = 6 } }),
            ["baseKey"] = "ttip_jumpgate", ["baseKeyType"] = new JsonObject { ["_"] = "ReplacementTypeModule", ["typeValue"] = 5 }, ["textStyle"] = 0 }) },
        ["additionalInformation"] = new JsonObject { ["_"] = "AssetInformationModule" }
    };
}
