using System.Threading.Channels;
using System.Text.Json.Nodes;
using DarkOrbit.Server.World;

namespace DarkOrbit.Server.Runtime;

// Instance distinguishes ordinary shared maps from private Galaxy Gate runs.
public readonly record struct MapKey(int ServerId, int MapId, Guid Instance);
public readonly record struct SessionLease(long PlayerId, Guid ConnectionId);
public sealed record Pilot(SessionLease Lease, double X, double Y, double Speed, int Faction = 1, bool Dead = false, bool Cloaked = false, bool Jumping = false);
public sealed record MapMotion(long PlayerId, double X, double Y, int RemainingMs);
public sealed record MapSnapshot(MapKey Key, long Revision, Pilot[] Pilots, MapMotion[] Motions, NpcSnapshot[] Npcs);

// All mutation for one map is serialized. Different maps execute independently.
// These are infrastructure primitives; combat/rewards are still in the legacy runtime.
public sealed class MapActor : IAsyncDisposable
{
    private readonly Channel<Action> inbox;
    private readonly Task loop;
    private readonly Dictionary<long, Pilot> pilots = [];
    private readonly Dictionary<long, Route> routes = [];
    private readonly TimeProvider time;
    private readonly double width, height;
    private long revision;
    private readonly SharedNpcs? npcs;
    private readonly List<JsonObject> pendingEvents = [];
    private readonly long origin;
    public MapKey Key { get; }
    public MapActor(MapKey key, double width, double height, TimeProvider? time = null, int capacity = 4096, MapContent? content = null, int? randomSeed = null)
    {
        if (!double.IsFinite(width) || !double.IsFinite(height) || width <= 0 || height <= 0) throw new ArgumentOutOfRangeException(nameof(width));
        Key = key; this.width = width; this.height = height; this.time = time ?? TimeProvider.System;
        origin = this.time.GetTimestamp();
        if (content is not null && key.Instance == Guid.Empty) npcs = new SharedNpcs(content, 0, randomSeed);
        inbox = Channel.CreateBounded<Action>(new BoundedChannelOptions(capacity) { SingleReader = true, FullMode = BoundedChannelFullMode.Wait });
        loop = Task.Run(async () => { await foreach (var action in inbox.Reader.ReadAllAsync()) action(); });
    }
    private async Task<T> Ask<T>(Func<T> action, CancellationToken cancellation = default)
    {
        // Cancellation may stop admission, but once accepted a command is awaited
        // through completion: callers never receive cancellation after mutation.
        var completion = new TaskCompletionSource<T>(TaskCreationOptions.RunContinuationsAsynchronously);
        await inbox.Writer.WriteAsync(() => { try { completion.SetResult(action()); } catch (Exception e) { completion.SetException(e); } }, cancellation);
        return await completion.Task;
    }
    public Task Join(Pilot pilot, CancellationToken cancellation = default) => Ask(() =>
    {
        Validate(pilot); if (pilots.ContainsKey(pilot.Lease.PlayerId)) throw new InvalidOperationException("Player already belongs to this map");
        pilots.Add(pilot.Lease.PlayerId, pilot with { X = Math.Clamp(pilot.X, 0, width), Y = Math.Clamp(pilot.Y, 0, height) }); revision++; return true;
    }, cancellation);
    public Task<bool> Leave(SessionLease lease) => Ask(() =>
    {
        if (!Owns(lease)) return false; pilots.Remove(lease.PlayerId); routes.Remove(lease.PlayerId);
        if (npcs is not null) pendingEvents.AddRange(npcs.Depart(lease, Now)); revision++; return true;
    });
    public Task Replace(SessionLease previous, Pilot pilot) => Ask(() =>
    {
        Validate(pilot);
        if (pilot.Lease.PlayerId != previous.PlayerId || !Owns(previous)) throw new InvalidOperationException("Stale map replacement");
        if (npcs is not null) pendingEvents.AddRange(npcs.Depart(previous, Now));
        pilots[previous.PlayerId] = pilot with { X = Math.Clamp(pilot.X, 0, width), Y = Math.Clamp(pilot.Y, 0, height) };
        routes.Remove(previous.PlayerId); revision++; return true;
    });
    public Task<bool> Move(SessionLease lease, double x, double y, CancellationToken cancellation = default) => Ask(() =>
    {
        if (!double.IsFinite(x) || !double.IsFinite(y)) throw new ArgumentOutOfRangeException(nameof(x));
        if (!Owns(lease)) return false; Update(lease.PlayerId);
        var pilot = pilots[lease.PlayerId]; if (pilot.Speed <= 0) return false;
        x = Math.Clamp(x, 0, width); y = Math.Clamp(y, 0, height);
        double duration = Math.Sqrt(Math.Pow(x - pilot.X, 2) + Math.Pow(y - pilot.Y, 2)) / pilot.Speed;
        routes[lease.PlayerId] = new(pilot.X, pilot.Y, x, y, time.GetTimestamp(), duration); revision++; return true;
    }, cancellation);
    public Task<MapSnapshot> Snapshot() => Ask(() =>
    {
        foreach (long id in pilots.Keys) Update(id);
        return new MapSnapshot(Key, revision, pilots.Values.OrderBy(p => p.Lease.PlayerId).ToArray(), routes.Select(r => new MapMotion(r.Key,r.Value.ToX,r.Value.ToY,(int)Math.Clamp(Math.Ceiling((r.Value.Duration-time.GetElapsedTime(r.Value.Start,time.GetTimestamp()).TotalSeconds)*1000),0,int.MaxValue))).ToArray(), npcs?.Snapshots(Now) ?? []);
    });
    private long Now => (long)time.GetElapsedTime(origin, time.GetTimestamp()).TotalMilliseconds;
    public Task<bool> Status(SessionLease lease, int faction, bool dead, bool cloaked, bool jumping) => Ask(() =>
    {
        if (!Owns(lease)) return false;
        pilots[lease.PlayerId] = pilots[lease.PlayerId] with { Faction = faction, Dead = dead, Cloaked = cloaked, Jumping = jumping };
        if ((dead || jumping) && npcs is not null) pendingEvents.AddRange(npcs.Depart(lease, Now)); return true;
    });
    public Task<JsonObject[]> Tick() => Ask(() =>
    {
        foreach (long id in pilots.Keys) Update(id);
        if (npcs is not null) pendingEvents.AddRange(npcs.Tick(Now, pilots.Values));
        var result = pendingEvents.ToArray(); pendingEvents.Clear(); return result;
    });
    // Server-side damage API; native fire is connected only after atomic ammo,
    // reward/equipment repositories are ready. Never trust client damage values.
    public Task<NpcDamage> DamageNpc(SessionLease lease, int target, int damage, double absorb, double range) => Ask(() =>
    {
        if (!Owns(lease) || npcs is null) return new NpcDamage(false, false, null, null);
        Update(lease.PlayerId); var result = npcs.Damage(pilots[lease.PlayerId], target, damage, absorb, range, Now);
        if (result.Applied) revision++; return result;
    });
    private bool Owns(SessionLease lease) => pilots.TryGetValue(lease.PlayerId, out var pilot) && pilot.Lease == lease;
    private void Update(long id)
    {
        if (!routes.TryGetValue(id, out var route)) return;
        double elapsed = time.GetElapsedTime(route.Start, time.GetTimestamp()).TotalSeconds;
        double ratio = route.Duration <= 0 ? 1 : Math.Clamp(elapsed / route.Duration, 0, 1);
        pilots[id] = pilots[id] with { X = route.X + (route.ToX - route.X) * ratio, Y = route.Y + (route.ToY - route.Y) * ratio };
        if (ratio == 1) routes.Remove(id);
    }
    private static void Validate(Pilot pilot)
    {
        if (pilot.Lease.PlayerId <= 0 || pilot.Lease.ConnectionId == Guid.Empty || !double.IsFinite(pilot.X) || !double.IsFinite(pilot.Y) || !double.IsFinite(pilot.Speed) || pilot.Speed < 0)
            throw new ArgumentException("Invalid authoritative pilot");
    }
    public async ValueTask DisposeAsync() { inbox.Writer.TryComplete(); await loop; }
    private sealed record Route(double X, double Y, double ToX, double ToY, long Start, double Duration);
}
