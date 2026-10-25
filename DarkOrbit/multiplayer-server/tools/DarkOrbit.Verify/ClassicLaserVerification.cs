using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Server.World;

internal static class ClassicLaserVerification
{
    public static async Task Run()
    {
        int assertions = 0; void Check(bool value, string message) { assertions++; if (!value) throw new InvalidOperationException(message); }
        var cases = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/classic-combat-contract.json"))!["cases"]!.AsArray();
        foreach (var c in cases)
        {
            var profile = c!["profile"]!.AsObject(); string ammo = c["ammo"]!.GetValue<string>();
            Check(ClassicLaser.Supports(profile), "Classic weapon loadout accepted");
            Check(ClassicLaser.Damage(profile, ammo, c["roll"]!.GetValue<double>()) == c["damage"]!.GetValue<int>(), "Legacy mixed ship/drone/upgraded classic damage and ammunition multiplier");
            Check(Math.Abs(ClassicLaser.Chance(profile) - c["chance"]!.GetValue<double>()) < 1e-10, "Legacy additive accuracy");
            Check(ClassicLaser.Color(ammo) == c["color"]!.GetValue<int>(), "Original native ammunition color");
        }
        Check(!ClassicLaser.Supports("ammunition_laser_sab-50"), "Unported shield drain never falls through to ordinary damage");
        var modern = cases[0]!["profile"]!.DeepClone().AsObject(); modern["stats"]!["laserProfiles"]![0]!["lootId"] = "equipment_weapon_laser_lf-5-mf";
        Check(!ClassicLaser.Supports(modern), "Unported modern proc loadout is rejected instead of silently nerfed");
        Console.WriteLine(JsonSerializer.Serialize(new { status = "PASS", classicFormulaAssertions = assertions, legacyClassicCases = cases.Count, fullGameplayReady = false }));
    }
}
