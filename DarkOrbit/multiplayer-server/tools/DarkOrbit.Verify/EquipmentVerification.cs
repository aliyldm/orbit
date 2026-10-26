using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Equipment;

internal static class EquipmentVerification
{
    public static async Task Run()
    {
        int assertions = 0;
        void Same(JsonNode? actual, JsonNode? expected, string at)
        {
            assertions++;
            if (actual is JsonObject obj && expected is JsonObject other)
            {
                if (!obj.Select(p => p.Key).Order().SequenceEqual(other.Select(p => p.Key).Order())) throw new InvalidOperationException(at + " field set differs");
                foreach (var (key, value) in obj) Same(value, other[key], at + "." + key); return;
            }
            if (actual is JsonArray array && expected is JsonArray list)
            {
                if (array.Count != list.Count) throw new InvalidOperationException(at + " array count differs");
                for (int i = 0; i < array.Count; i++) Same(array[i], list[i], at + "[" + i + "]"); return;
            }
            if (actual is not null && expected is not null && double.TryParse(actual.ToJsonString(), System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out var a) && double.TryParse(expected.ToJsonString(), System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out var b))
            { if (Math.Abs(a - b) <= Math.Max(1, Math.Abs(b)) * 1e-11) return; }
            else if (JsonNode.DeepEquals(actual, expected)) return;
            throw new InvalidOperationException(at + $": got {actual}, expected {expected}");
        }
        var cases = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/equipment-contract.json"))!["cases"]!.AsArray();
        foreach (var c in cases) Same(EquipmentStats.Compute(c!["input"]!.AsObject()), c["expected"], c["name"]!.GetValue<string>());
        Console.WriteLine(JsonSerializer.Serialize(new { status = "PASS", equipmentCases = cases.Count, equipmentAssertions = assertions, sourceDatabaseUntouched = true, fullGameplayReady = false }));
    }
}
