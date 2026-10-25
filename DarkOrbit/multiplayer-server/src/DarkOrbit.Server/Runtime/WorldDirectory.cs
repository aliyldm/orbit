namespace DarkOrbit.Server.Runtime;

// Admission/transfer operations are serialized separately from high frequency
// movement. A delayed close from an old socket cannot remove a replacement.
public sealed class WorldDirectory(Func<MapKey, MapActor> factory) : IAsyncDisposable
{
    private readonly SemaphoreSlim admission = new(1);
    private readonly Dictionary<MapKey, MapActor> maps = [];
    private readonly Dictionary<long, (SessionLease Lease, MapActor Map)> online = [];
    private bool stopping;
    public async Task<SessionLease> Connect(long playerId, MapKey key, double x, double y, double speed)
    {
        await admission.WaitAsync();
        try
        {
            ObjectDisposedException.ThrowIf(stopping, this);
            var lease = new SessionLease(playerId, Guid.NewGuid()); var pilot = new Pilot(lease, x, y, speed);
            // Validate before retiring an existing connection.
            if (playerId <= 0 || key.ServerId <= 0 || key.MapId <= 0 || !double.IsFinite(x) || !double.IsFinite(y) || !double.IsFinite(speed) || speed < 0) throw new ArgumentException("Invalid pilot");
            if (!maps.TryGetValue(key, out var map)) { map = factory(key); maps.Add(key, map); }
            bool replacing = online.TryGetValue(playerId, out var old);
            if (replacing && old.Map == map) await map.Replace(old.Lease, pilot);
            else
            {
                // Admit the destination before retiring the old membership. A
                // failed target must not log out the existing healthy pilot.
                await map.Join(pilot);
                try { if (replacing && !await old.Map.Leave(old.Lease)) throw new InvalidOperationException("Source membership lost"); }
                catch { await map.Leave(lease); throw; }
            }
            online[playerId] = (lease, map); return lease;
        }
        finally { admission.Release(); }
    }
    public async Task<bool> Disconnect(SessionLease lease)
    {
        await admission.WaitAsync();
        try
        {
            if (!online.TryGetValue(lease.PlayerId, out var old) || old.Lease != lease) return false;
            await old.Map.Leave(lease); online.Remove(lease.PlayerId); return true;
        }
        finally { admission.Release(); }
    }
    public async Task<bool> Move(SessionLease lease, double x, double y)
    {
        MapActor map;
        await admission.WaitAsync();
        try
        {
            if (!online.TryGetValue(lease.PlayerId, out var current) || current.Lease != lease) return false;
            map = current.Map;
        }
        finally { admission.Release(); }
        return await map.Move(lease, x, y);
    }
    public async Task<MapSnapshot?> Snapshot(MapKey key)
    {
        MapActor? map;
        await admission.WaitAsync(); try { maps.TryGetValue(key, out map); } finally { admission.Release(); }
        return map is null ? null : await map.Snapshot();
    }
    public async Task<bool> Status(SessionLease lease, int faction, bool dead, bool cloaked, bool jumping)
    {
        MapActor? map;
        await admission.WaitAsync();
        try { map = online.TryGetValue(lease.PlayerId, out var current) && current.Lease == lease ? current.Map : null; }
        finally { admission.Release(); }
        return map is not null && await map.Status(lease, faction, dead, cloaked, jumping);
    }
    public async Task<IReadOnlyDictionary<MapKey, System.Text.Json.Nodes.JsonObject[]>> Tick()
    {
        MapActor[] actors;
        await admission.WaitAsync(); try { actors = maps.Values.ToArray(); } finally { admission.Release(); }
        var results = await Task.WhenAll(actors.Select(async actor => (actor.Key, Events: await actor.Tick())));
        return results.ToDictionary(r => r.Key, r => r.Events);
    }
    public async ValueTask DisposeAsync()
    {
        await admission.WaitAsync();
        try { if (stopping) return; stopping = true; foreach (var map in maps.Values) await map.DisposeAsync(); online.Clear(); maps.Clear(); }
        finally { admission.Release(); }
    }
}
