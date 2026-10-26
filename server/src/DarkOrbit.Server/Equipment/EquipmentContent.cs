using System.Text.Json.Nodes;

namespace DarkOrbit.Server.Equipment;

public sealed class EquipmentContent
{
    public static EquipmentContent Default { get; } = new();
    public JsonObject Document { get; }
    public IReadOnlyDictionary<string, JsonObject> Ships { get; }
    public IReadOnlyDictionary<string, JsonObject> Items { get; }
    private EquipmentContent()
    {
        using var stream = typeof(EquipmentContent).Assembly.GetManifestResourceStream("EquipmentContent.json")!;
        Document = JsonNode.Parse(stream)!.AsObject();
        if (Document["format"]!.GetValue<int>() != 1) throw new InvalidDataException("Invalid equipment catalogue");
        Ships = Document["shipTypes"]!.AsArray().ToDictionary(n => n!["loot_id"]!.GetValue<string>(), n => n!.AsObject());
        Items = Document["itemTypes"]!.AsArray().ToDictionary(n => n!["loot_id"]!.GetValue<string>(), n => n!.AsObject());
    }
    public JsonObject Meta(string id) => Document["items"]?[id]?.AsObject() ?? new();
}
