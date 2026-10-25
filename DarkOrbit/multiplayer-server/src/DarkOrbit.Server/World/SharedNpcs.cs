using System.Text.Json.Nodes;
using DarkOrbit.Server.Runtime;

namespace DarkOrbit.Server.World;

public sealed record NpcMotion(int X, int Y, int RemainingMs);
public sealed record NpcSnapshot(int Id, string Key, int TypeId, string Name, double X, double Y, int Hp, int HpMax, int Shield, int ShieldMax, int Generation, long? Target, bool Returning, NpcMotion? Motion)
{
    public JsonObject Create()
    {
        var command = WorldContent.Default.NpcTemplate.DeepClone().AsObject();
        command["userId"] = Id; command["typeId"] = TypeId.ToString(System.Globalization.CultureInfo.InvariantCulture); command["userName"] = Name;
        command["x"] = (int)Math.Round(X); command["y"] = (int)Math.Round(Y); return command;
    }
    public JsonObject Selection() => new() { ["_"] = "ShipSelectionCommand", ["userId"] = Id, ["shipType"] = TypeId, ["shield"] = Shield, ["shieldMax"] = ShieldMax, ["hitpoints"] = Hp, ["hitpointsMax"] = HpMax, ["nanoHull"] = 0, ["maxNanoHull"] = 0, ["shieldSkill"] = false };
}

public sealed record NpcDamage(bool Applied, bool Killed, NpcSnapshot? State, string? ClaimId);

// Owned exclusively by its MapActor. No per-player clone, wall-clock timer,
// database callback or socket can mutate these entities outside that actor.
internal sealed class SharedNpcs
{
    private readonly MapContent map;
    private readonly Random random;
    private readonly Dictionary<int, Npc> npcs = [];
    private readonly Guid run = Guid.NewGuid();
    private long previousTick;
    internal SharedNpcs(MapContent map, long now, int? seed = null)
    {
        this.map = map; random = seed is { } s ? new Random(s) : Random.Shared; previousTick = now;
        int id = 100000;
        foreach (var row in map.Spawns)
            for (int i = 0; i < row!["count"]!.GetValue<int>(); i++)
            {
                var npc = new Npc(id++, row["def"]!.AsObject()); Reset(npc, now); npcs.Add(npc.Id, npc);
            }
    }
    private double Between(double a, double b) => a + random.NextDouble() * (b - a);
    private void Reset(Npc npc, long now)
    {
        npc.Hp = npc.MaxHp; npc.Shield = npc.MaxShield; npc.X = Math.Round(Between(500, map.Width - 500)); npc.Y = Math.Round(Between(500, map.Height - 500));
        npc.HomeX = npc.X; npc.HomeY = npc.Y; npc.Target = null; npc.Route = null; npc.Returning = false; npc.Fleeing = false;
        npc.Generation++; npc.DeadUntil = 0; npc.NextWander = now + (long)Between(1000, 4000); npc.LastHit = 0;
    }
    private void Update(Npc npc, long now)
    {
        if (npc.Route is not { } r) return;
        double ratio = r.Duration <= 0 ? 1 : Math.Clamp((double)(now - r.Start) / r.Duration, 0, 1);
        npc.X = r.X + (r.TargetX - r.X) * ratio; npc.Y = r.Y + (r.TargetY - r.Y) * ratio;
        if (ratio >= 1) npc.Route = null;
    }
    private static double Distance(double x, double y, double a, double b) => double.Hypot(x - a, y - b);
    private static JsonObject Movement(Npc n, int x, int y, int duration) => new() { ["_"] = "MoveCommand", ["userId"] = n.Id, ["x"] = x, ["y"] = y, ["timeToTarget"] = duration };
    private void Move(Npc n, double x, double y, long now, List<JsonObject> events)
    {
        if (n.Speed <= 0) return;
        x = Math.Round(Math.Clamp(x, 200, map.Width - 200)); y = Math.Round(Math.Clamp(y, 200, map.Height - 200));
        int duration = Math.Max(1, (int)Math.Round(Distance(n.X, n.Y, x, y) / n.Speed * 1000));
        n.Route = new(n.X, n.Y, x, y, now, duration); events.Add(Movement(n, (int)x, (int)y, duration));
    }
    private void Drop(Npc n, long now, List<JsonObject> events, bool retreat)
    {
        if (n.Target is not null) events.Add(new JsonObject { ["_"] = "AttackAbortLaserCommand", ["uid"] = n.Id });
        n.Target = null;
        if (n.Route is not null) { Update(n, now); n.Route = null; events.Add(Movement(n, (int)Math.Round(n.X), (int)Math.Round(n.Y), 0)); }
        if (retreat && n.Flag("chase", true) && n.Flag("roam", true) && n.Speed > 0 && Distance(n.X, n.Y, n.HomeX, n.HomeY) > 2)
        { n.Returning = true; Move(n, n.HomeX, n.HomeY, now, events); }
    }
    internal JsonObject[] Tick(long now, IReadOnlyCollection<Pilot> pilots)
    {
        List<JsonObject> events = [];
        // A delayed event loop advances positions once; no catch-up attack or
        // regeneration bursts. Regeneration retains the old one-second cadence.
        bool regenerate = now - previousTick >= 1000; if (regenerate) previousTick = now;
        foreach (var n in npcs.Values)
        {
            if (n.Hp <= 0)
            {
                if (now >= n.DeadUntil) { Reset(n, now); events.Add(Snapshot(n, now).Create()); }
                continue;
            }
            Update(n, now);
            if (n.Target is { } target)
            {
                var pilot = pilots.FirstOrDefault(p => p.Lease == target);
                if (pilot is null || !Eligible(pilot) || Distance(n.X, n.Y, pilot.X, pilot.Y) > n.Number("retainRadius", 2500)) Drop(n, now, events, true);
            }
            if (n.Returning)
            {
                if (Distance(n.X, n.Y, n.HomeX, n.HomeY) <= 2) { n.Returning = false; n.Route = null; n.NextWander = now + 1000; }
                else if (n.Route is null) Move(n, n.HomeX, n.HomeY, now, events);
                continue;
            }
            if (n.Number("fleeAt", 0) > 0 && n.Flag("fleeToCorner", false) && n.Speed > 0 && n.Hp <= n.MaxHp * n.Number("fleeAt", 0) && (n.LastHit > 0 || n.Target is not null || n.Fleeing))
            {
                if (!n.Fleeing)
                {
                    Drop(n, now, events, false); n.Fleeing = true; double inset = n.Number("cornerInset", 500);
                    var corner = new[] { (inset, inset), (map.Width - inset, inset), (inset, map.Height - inset), (map.Width - inset, map.Height - inset) }.MinBy(c => Distance(n.X, n.Y, c.Item1, c.Item2));
                    Move(n, corner.Item1, corner.Item2, now, events);
                }
                continue;
            }
            if (n.Target is null && n.Behavior["aggression"]?.GetValue<string>() == "aggressive")
            {
                var candidate = pilots.Where(p => Eligible(p) && !p.Cloaked && Distance(n.X, n.Y, p.X, p.Y) <= n.Number("acquisitionRadius", 900))
                    .OrderBy(p => Distance(n.X, n.Y, p.X, p.Y)).ThenBy(p => p.Lease.PlayerId).FirstOrDefault();
                if (candidate is not null) n.Target = candidate.Lease;
            }
            if (n.Target is { } lease)
            {
                var p = pilots.First(p => p.Lease == lease);
                if (n.Flag("chase", true) && Distance(n.X, n.Y, p.X, p.Y) > n.Number("chaseDistance", 450) && (n.Route is null || now >= n.NextSteer))
                { Move(n, p.X + Between(-150, 150), p.Y + Between(-150, 150), now, events); n.NextSteer = now + 1000; }
            }
            else
            {
                n.HomeX = n.X; n.HomeY = n.Y;
                if (n.Flag("roam", true) && now >= n.NextWander) { Move(n, n.X + Between(-600, 600), n.Y + Between(-600, 600), now, events); n.NextWander = now + (long)Between(3000, 8000); }
                if (regenerate && now - n.LastHit > 10000) n.Shield = Math.Min(n.MaxShield, n.Shield + Math.Max(1, (int)Math.Round(n.MaxShield * .05)));
            }
        }
        return events.ToArray();
    }
    private bool Eligible(Pilot p) => !p.Dead && !p.Jumping && !map.Peace(p.X, p.Y, p.Faction);
    internal JsonObject[] Depart(SessionLease lease, long now)
    {
        List<JsonObject> events = []; foreach (var n in npcs.Values.Where(n => n.Hp > 0 && n.Target == lease)) Drop(n, now, events, true); return events.ToArray();
    }
    internal NpcSnapshot[] Snapshots(long now) => npcs.Values.Where(n => n.Hp > 0).Select(n => { Update(n, now); return Snapshot(n, now); }).ToArray();
    internal NpcDamage Damage(Pilot pilot, int target, int damage, double absorb, double range, long now)
    {
        if (!Eligible(pilot) || damage <= 0 || !double.IsFinite(absorb) || !double.IsFinite(range) || range < 0 || !npcs.TryGetValue(target, out var n) || n.Hp <= 0) return new(false, false, null, null);
        Update(n, now); if (Distance(n.X, n.Y, pilot.X, pilot.Y) > range) return new(false, false, null, null);
        int shield = Math.Min(n.Shield, (int)Math.Round(damage * Math.Clamp(absorb, 0, 1))); n.Shield -= shield; n.Hp = Math.Max(0, n.Hp - (damage - shield)); n.LastHit = now; n.Target = pilot.Lease; n.Returning = false;
        bool killed = n.Hp == 0; if (killed) { n.DeadUntil = now + Math.Max(1, n.Def["respawnMs"]!.GetValue<int>()); n.Route = null; n.Target = null; }
        return new(true, killed, Snapshot(n, now), killed ? $"{run:N}:{n.Id}:{n.Generation}" : null);
    }
    private static NpcSnapshot Snapshot(Npc n, long now) => new(n.Id, n.Def["key"]?.GetValue<string>() ?? "", n.Def["typeId"]!.GetValue<int>(), n.Def["name"]!.GetValue<string>(), n.X, n.Y, n.Hp, n.MaxHp, n.Shield, n.MaxShield, n.Generation, n.Target?.PlayerId, n.Returning,
        n.Route is { } r ? new((int)r.TargetX, (int)r.TargetY, (int)Math.Clamp(r.Start + r.Duration - now, 0, int.MaxValue)) : null);
    private sealed record Route(double X, double Y, double TargetX, double TargetY, long Start, int Duration);
    private sealed class Npc(int id, JsonObject def)
    {
        internal readonly int Id = id;
        internal readonly JsonObject Def = def;
        internal readonly JsonObject Behavior = def["behavior"]?.AsObject() ?? new();
        internal readonly int MaxHp = def["hitpoints"]!.GetValue<int>(), MaxShield = def["shield"]!.GetValue<int>();
        internal readonly double Speed = def["speed"]!.GetValue<double>();
        internal int Hp, Shield, Generation;
        internal double X, Y, HomeX, HomeY;
        internal long LastHit, NextWander, NextSteer, DeadUntil;
        internal SessionLease? Target;
        internal bool Returning, Fleeing;
        internal Route? Route;
        internal double Number(string key, double fallback) => Behavior[key]?.GetValue<double>() ?? fallback;
        internal bool Flag(string key, bool fallback) => Behavior[key]?.GetValue<bool>() ?? fallback;
    }
}
