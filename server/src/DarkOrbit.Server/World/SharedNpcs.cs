using System.Text.Json.Nodes;
using System.Security.Cryptography;
using System.Text;
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
    private Guid run = Guid.NewGuid();
    private readonly string definitionHash;
    private long previousTick;
    internal SharedNpcs(MapContent map, long now, int? seed = null)
    {
        this.map = map; random = seed is { } s ? new Random(s) : Random.Shared; previousTick = now;
        definitionHash = Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes($"{map.Id}:{map.Width}:{map.Height}:" + map.Spawns.ToJsonString())));
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
        npc.Generation++; npc.DeadUntil = 0; npc.NextWander = now + (long)Between(1000, 4000); npc.LastHit = 0; npc.HasHit = false;
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
            if (n.Number("fleeAt", 0) > 0 && n.Flag("fleeToCorner", false) && n.Speed > 0 && n.Hp <= n.MaxHp * n.Number("fleeAt", 0) && (n.HasHit || n.Target is not null || n.Fleeing))
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
        if (!Eligible(pilot) || damage < 0 || !double.IsFinite(absorb) || !double.IsFinite(range) || range < 0 || !npcs.TryGetValue(target, out var n) || n.Hp <= 0) return new(false, false, null, null);
        Update(n, now); if (Distance(n.X, n.Y, pilot.X, pilot.Y) > range) return new(false, false, null, null);
        int shield = Math.Min(n.Shield, (int)Math.Round(damage * Math.Clamp(absorb, 0, 1))); n.Shield -= shield; n.Hp = Math.Max(0, n.Hp - (damage - shield)); if (damage > 0) { n.LastHit = now; n.HasHit = true; } n.Target = pilot.Lease; n.Returning = false;
        bool killed = n.Hp == 0; if (killed) { n.DeadUntil = now + Math.Max(1, n.Def["respawnMs"]!.GetValue<int>()); n.Route = null; n.Target = null; }
        return new(true, killed, Snapshot(n, now), killed ? $"{run:N}:{n.Id}:{n.Generation}" : null);
    }
    internal JsonObject Definition(int id) => npcs[id].Def.DeepClone().AsObject();
    internal JsonObject Capture(long now, long utc)
    {
        var rows = new JsonArray();
        foreach (var n in npcs.Values)
        {
            Update(n, now);
            rows.Add(new JsonObject { ["id"] = n.Id, ["key"] = n.Def["key"]?.DeepClone(), ["generation"] = n.Generation,
                ["hp"] = n.Hp, ["shield"] = n.Shield, ["x"] = n.X, ["y"] = n.Y, ["homeX"] = n.HomeX, ["homeY"] = n.HomeY,
                ["deadFor"] = Math.Max(0, n.DeadUntil - now), ["wanderIn"] = Math.Max(0, n.NextWander - now), ["hitAgo"] = n.HasHit ? Math.Max(0, now - n.LastHit) : -1,
                ["returning"] = n.Returning, ["fleeing"] = n.Fleeing,
                ["targetId"] = n.Target?.PlayerId, ["targetLease"] = n.Target?.ConnectionId.ToString("N"),
                ["route"] = n.Route is { } r ? new JsonObject { ["x"] = r.TargetX, ["y"] = r.TargetY, ["duration"] = Math.Max(0, r.Start + r.Duration - now) } : null });
        }
        return new JsonObject { ["format"] = 1, ["definition"] = definitionHash, ["run"] = run.ToString("N"), ["savedAt"] = utc, ["npcs"] = rows };
    }
    internal void Restore(JsonObject state, long now, long utc, bool restart)
    {
        if (state["format"]!.GetValue<int>() != 1 || state["definition"]!.GetValue<string>() != definitionHash || state["npcs"]!.AsArray().Count != npcs.Count) throw new InvalidDataException("World checkpoint/catalog mismatch");
        run = Guid.ParseExact(state["run"]!.GetValue<string>(), "N");
        long elapsed = Math.Max(0, utc - state["savedAt"]!.GetValue<long>());
        var seen = new HashSet<int>();
        foreach (var row in state["npcs"]!.AsArray())
        {
            int id = row!["id"]!.GetValue<int>();
            if (!seen.Add(id) || !npcs.TryGetValue(id, out var n) || row["key"]?.GetValue<string>() != n.Def["key"]?.GetValue<string>()) throw new InvalidDataException("World NPC identity changed");
            n.Generation = row["generation"]!.GetValue<int>(); n.Hp = row["hp"]!.GetValue<int>(); n.Shield = row["shield"]!.GetValue<int>();
            n.X = row["x"]!.GetValue<double>(); n.Y = row["y"]!.GetValue<double>(); n.HomeX = row["homeX"]!.GetValue<double>(); n.HomeY = row["homeY"]!.GetValue<double>();
            if (n.Generation <= 0 || n.Hp < 0 || n.Hp > n.MaxHp || n.Shield < 0 || n.Shield > n.MaxShield || !double.IsFinite(n.X) || !double.IsFinite(n.Y) || !double.IsFinite(n.HomeX) || !double.IsFinite(n.HomeY) || n.X < 0 || n.X > map.Width || n.Y < 0 || n.Y > map.Height || n.HomeX < 0 || n.HomeX > map.Width || n.HomeY < 0 || n.HomeY > map.Height) throw new InvalidDataException("Invalid NPC checkpoint values");
            n.DeadUntil = now + Math.Max(0, row["deadFor"]!.GetValue<long>() - elapsed); n.NextWander = now + Math.Max(0, row["wanderIn"]!.GetValue<long>() - elapsed);
            long ago = row["hitAgo"]!.GetValue<long>(); n.HasHit = ago >= 0; n.LastHit = ago < 0 ? 0 : now - ago - elapsed;
            n.Returning = row["returning"]!.GetValue<bool>(); n.Fleeing = row["fleeing"]!.GetValue<bool>(); n.Target = null; n.Route = null;
            if (row["route"] is { } route)
            {
                double x = route["x"]!.GetValue<double>(), y = route["y"]!.GetValue<double>(); long duration = route["duration"]!.GetValue<long>();
                if (!double.IsFinite(x) || !double.IsFinite(y) || x < 0 || x > map.Width || y < 0 || y > map.Height || duration < 0) throw new InvalidDataException("Invalid NPC route checkpoint");
                double ratio = duration <= 0 ? 1 : Math.Clamp((double)elapsed / duration, 0, 1); n.X += (x - n.X) * ratio; n.Y += (y - n.Y) * ratio;
                if (duration > elapsed) n.Route = new(n.X, n.Y, x, y, now, (int)Math.Min(int.MaxValue, duration - elapsed));
            }
            if (row["targetId"] is { } target)
            {
                if (!restart) n.Target = new SessionLease(target.GetValue<long>(), Guid.ParseExact(row["targetLease"]!.GetValue<string>(), "N"));
                else if (n.Hp > 0 && n.Flag("chase", true) && n.Speed > 0 && Distance(n.X, n.Y, n.HomeX, n.HomeY) > 2) { n.Returning = true; n.Route = null; }
            }
        }
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
        internal bool Returning, Fleeing, HasHit;
        internal Route? Route;
        internal double Number(string key, double fallback) => Behavior[key]?.GetValue<double>() ?? fallback;
        internal bool Flag(string key, bool fallback) => Behavior[key]?.GetValue<bool>() ?? fallback;
    }
}
