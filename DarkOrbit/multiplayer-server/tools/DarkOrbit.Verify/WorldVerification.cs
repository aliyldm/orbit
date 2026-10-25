using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.World;

internal static class WorldVerification
{
    public static async Task Run()
    {
        int assertions = 0; void Check(bool condition, string description) { assertions++; if (!condition) throw new InvalidOperationException(description); }
        var content = WorldContent.Default; var codec = new LegacyCodec();
        var oracle = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/world-contract.json"))!["cases"]!.AsArray();
        foreach (var entry in oracle)
        {
            int id = entry!["map"]!.GetValue<int>(), faction = entry["faction"]!.GetValue<int>(); double x = entry["x"]!.GetValue<double>(), y = entry["y"]!.GetValue<double>();
            var contractMap = content.Maps[id]; var expected = entry["commands"]!.AsArray(); var commands = contractMap.Initialization(faction, x, y, false).ToArray();
            Check(expected.Count == commands.Length, $"Map {id} command count");
            for (int i = 0; i < commands.Length; i++) Check(codec.Encode(expected[i]!.AsObject()).SequenceEqual(codec.Encode(commands[i])), $"Map {id} legacy command {i}");
            var beacon = contractMap.Beacon(new Pilot(new(1, Guid.NewGuid()), x, y, 100), faction, false);
            Check(codec.Encode(entry["beacon"]!.AsObject()).SequenceEqual(codec.Encode(beacon)), $"Map {id} legacy peace/station/gate beacon");
        }
        var m14 = content.Maps[4]; var to41 = m14.Portals.Single(p => p.Target == 13);
        Check(to41.Level(1) == 8 && m14.Nearest(to41.X, to41.Y, 1) == to41, "Original 1-4 to 4-1 access and nearest gate");
        var map = content.Maps[19]; var clock = new ManualTime();
        await using var actor = new MapActor(new(1, 19, Guid.Empty), map.Width, map.Height, clock, content: map, randomSeed: 41);
        var initial = await actor.Snapshot(); Check(initial.Npcs.Count(n => n.Key == "kristallon") == 18, "1-7 has the unchanged 18 Kristallon slots");
        var npc = initial.Npcs.First(n => n.Key == "kristallon");
        var a = new SessionLease(1, Guid.NewGuid()); var b = new SessionLease(2, Guid.NewGuid());
        await actor.Join(new(a, npc.X + 300, npc.Y, 400)); await actor.Join(new(b, npc.X + 400, npc.Y, 400));
        Check((await actor.Snapshot()).Npcs.Length == initial.Npcs.Length, "Joining two players does not duplicate NPCs");
        var hit = await actor.DamageNpc(a, npc.Id, 1000, .8, 600);
        Check(hit.Applied && !hit.Killed && hit.State!.Hp == npc.Hp - 200 && hit.State.Shield == npc.Shield - 800, "Shared shield/HP absorption matches the old .8 rule");
        Check((await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id).Target == 1, "Damaged NPC retains exact session target");
        await actor.Tick();
        Check((await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id).Hp == npc.Hp - 200, "Second pilot sees the same damaged NPC state");
        var killResults = await Task.WhenAll(actor.DamageNpc(a, npc.Id, 2000000, .8, 600), actor.DamageNpc(b, npc.Id, 2000000, .8, 600));
        Check(killResults.Count(r => r.Killed) == 1 && killResults.Count(r => r.Applied) == 1, "Concurrent lethal hits claim a shared NPC exactly once");
        var claim = killResults.Single(r => r.Killed).ClaimId;
        clock.Advance(TimeSpan.FromSeconds(29)); await actor.Tick(); Check(!(await actor.Snapshot()).Npcs.Any(n => n.Id == npc.Id), "Dead NPC remains absent until original respawn deadline");
        clock.Advance(TimeSpan.FromSeconds(1)); var respawn = await actor.Tick(); var next = (await actor.Snapshot()).Npcs.Single(n => n.Id == npc.Id);
        Check(next.Generation == npc.Generation + 1 && next.Hp == npc.HpMax && next.Shield == npc.ShieldMax && respawn.Count(c => c["_"]!.GetValue<string>() == "ShipCreateCommand" && c["userId"]!.GetValue<int>() == npc.Id) == 1, "Shared respawn has one new generation and one create event");
        await actor.Move(a, next.X, next.Y); clock.Advance(TimeSpan.FromSeconds(100)); await actor.Tick();
        var secondKill = await actor.DamageNpc(a, next.Id, 2000000, .8, 600);
        Check(secondKill.Killed && secondKill.ClaimId != claim, "Respawn uses a distinct idempotency identity");
        var chase = (await actor.Snapshot()).Npcs.First(n => n.Key == "kristallon");
        await actor.Replace(a, new(a, chase.X + 1000, chase.Y, 400));
        Check((await actor.DamageNpc(a, chase.Id, 10, .8, 1200)).Applied, "Authoritative attack establishes target");
        await actor.Tick(); clock.Advance(TimeSpan.FromSeconds(1)); await actor.Tick();
        await actor.Leave(a); await actor.Tick();
        var retreat = (await actor.Snapshot()).Npcs.Single(n => n.Id == chase.Id);
        Check(retreat.Target is null && retreat.Returning, "Disconnected target is dropped and NPC returns to its patrol");
        clock.Advance(TimeSpan.FromMinutes(1)); await actor.Tick(); Check(!(await actor.Snapshot()).Npcs.Single(n => n.Id == chase.Id).Returning, "Retreat advances even when the target is gone");
        Check(!(await actor.DamageNpc(a, chase.Id, 100, .8, 100000)).Applied, "Stale disconnected lease cannot damage shared NPC");
        await actor.Status(b, 1, false, false, true); Check(!(await actor.DamageNpc(b, chase.Id, 100, .8, 100000)).Applied, "Jumping pilot cannot attack");
        await using var privateMap = new MapActor(new(1, 19, Guid.NewGuid()), map.Width, map.Height, content: map);
        Check((await privateMap.Snapshot()).Npcs.Length == 0, "Ordinary NPC population is never leaked into private Galaxy Gate instances");
        foreach (var n in initial.Npcs) { codec.Encode(n.Create()); codec.Encode(n.Selection()); }
        Check(true, "Every 1-7 NPC uses encodable original native create/selection packets");
        Console.WriteLine(JsonSerializer.Serialize(new { status = "PASS", worldAssertions = assertions, legacyMapCases = oracle.Count, sharedNpcLifecycle = true, duplicateKillProtection = true, patrolReturn = true, fullGameplayReady = false }));
    }
}
