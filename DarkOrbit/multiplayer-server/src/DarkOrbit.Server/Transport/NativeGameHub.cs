using System.Collections.Concurrent;
using System.Security.Authentication;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;

namespace DarkOrbit.Server.Transport;

public sealed class NativeGameHub : IAsyncDisposable
{
    public LegacyCodec Codec { get; } = new();
    private readonly NativePlayerRepository players;
    private readonly RedisSessions tickets;
    private readonly IReadOnlyDictionary<int, MapDefinition> maps;
    private readonly int serverId;
    private readonly WorldDirectory directory;
    private readonly ConcurrentDictionary<long, NativeConnection> online = [];
    private readonly ConcurrentDictionary<long, SemaphoreSlim> pilotLocks = [];
    private readonly SemaphoreSlim presence = new(1);
    private static readonly TimeSpan LeaseLifetime = TimeSpan.FromSeconds(40);
    public int OnlineCount => online.Count;
    public NativeGameHub(NativePlayerRepository players, RedisSessions tickets, IReadOnlyDictionary<int, MapDefinition> maps, int serverId)
    {
        this.players = players; this.tickets = tickets; this.maps = maps; this.serverId = serverId;
        directory = new(key => { var map = maps[key.MapId]; return new MapActor(key, map.Width, map.Height); });
    }
    public Task<MapSnapshot?> Snapshot(MapKey key) => directory.Snapshot(key);
    private static MapKey MapFor(NativePilot pilot, MapDefinition map)
    {
        byte[] bytes = new byte[16]; BitConverter.TryWriteBytes(bytes.AsSpan(), pilot.PlayerId);
        return new MapKey(pilot.ServerId, pilot.MapId, map.Private ? new Guid(bytes) : Guid.Empty);
    }
    internal async Task<bool> Dispatch(NativeConnection connection, JsonObject command)
    {
        string name = command["_"]!.GetValue<string>();
        if (name == "VersionRequest") { connection.Send(new JsonObject { ["_"] = "VersionCommand", ["version"] = command["version"]!.DeepClone(), ["equal"] = true }); return true; }
        if (name == "LoginRequest") return await Login(connection, command);
        if (!connection.Ready || !await Authorized(connection)) throw new AuthenticationException("Unauthenticated command");
        if (name == "MoveRequest") await Move(connection, command["targetX"]!.GetValue<int>(), command["targetY"]!.GetValue<int>());
        // Other native feature requests remain unsupported during the port. No
        // success/reward is fabricated; /ready remains false until full parity.
        return true;
    }
    private async Task<bool> Authorized(NativeConnection connection) =>
        !connection.IsClosed && connection.Pilot is { } pilot && connection.RedisLease is { } lease && connection.Ticket is { } token &&
        await tickets.Verify(token, pilot.PlayerId, serverId) is { AccountId: var account } && account == pilot.AccountId &&
        await tickets.Renew(pilot.PlayerId, serverId, lease, LeaseLifetime);
    private async Task<bool> Login(NativeConnection connection, JsonObject command)
    {
        if (connection.Pilot is not null || command["instanceId"]!.GetValue<int>() != serverId) throw new AuthenticationException("Invalid login");
        long id = command["userID"]!.GetValue<int>(); string token = command["sessionID"]!.GetValue<string>();
        var ticket = await tickets.Verify(token, id, serverId) ?? throw new AuthenticationException("Invalid ticket");
        var pilot = await players.Load(id) ?? throw new AuthenticationException("Unknown pilot");
        if (pilot.ServerId != serverId || pilot.AccountId != ticket.AccountId || !maps.ContainsKey(pilot.MapId)) throw new AuthenticationException("Owner mismatch");
        var gate = pilotLocks.GetOrAdd(id, _ => new SemaphoreSlim(1)); await gate.WaitAsync();
        try
        {
            if (online.TryGetValue(id, out var previous))
            {
                var old = (await directory.Snapshot(previous.Map))!.Pilots.Single(p => p.Lease == previous.MapLease);
                pilot = pilot with { MapId = previous.Map.MapId, X = old.X, Y = old.Y };
            }
            connection.Pilot = pilot; connection.Ticket = token; connection.Map = MapFor(pilot, maps[pilot.MapId]);
            connection.RedisLease = await tickets.Acquire(id, serverId, LeaseLifetime);
            if (!await players.Claim(id, connection.RedisLease)) throw new AuthenticationException("Stale database fence");
            if (!await players.SavePosition(id, connection.RedisLease, pilot.MapId, pilot.X, pilot.Y)) throw new AuthenticationException("Lost database owner");
            var initial = pilot.Initialization(Codec).ToArray();
            await presence.WaitAsync();
            try
            {
                if (online.TryGetValue(id, out previous))
                {
                    foreach (var peer in Peers(previous.Map, previous)) peer.Send(Remove(id));
                    previous.Close();
                }
                connection.MapLease = await directory.Connect(id, connection.Map, pilot.X, pilot.Y, pilot.Dead ? 0 : pilot.Speed);
                online[id] = connection;
                foreach (var packet in initial) if (!connection.Send(packet)) throw new IOException("Initial queue exceeded");
                var snapshot = (await directory.Snapshot(connection.Map))!;
                foreach (var peer in Peers(connection.Map, connection).ToArray())
                {
                    var location = snapshot.Pilots.Single(p => p.Lease == peer.MapLease);
                    Show(connection, peer.Pilot!, location.X, location.Y);
                    var motion = snapshot.Motions.FirstOrDefault(m => m.PlayerId == peer.Pilot!.PlayerId); if (motion is not null) connection.Send(Movement(motion));
                    Show(peer, pilot, pilot.X, pilot.Y);
                }
                connection.Ready = true;
            }
            finally { presence.Release(); }
            return true;
        }
        finally { gate.Release(); }
    }
    private IEnumerable<NativeConnection> Peers(MapKey key, NativeConnection except) => online.Values.Where(c => c != except && c.Map == key && c.Ready && !c.IsClosed);
    private static JsonObject Remove(long id) => new() { ["_"] = "ShipRemoveCommand", ["userId"] = id };
    private static JsonObject Movement(MapMotion motion) => new() { ["_"] = "MoveCommand", ["userId"] = motion.PlayerId, ["x"] = (int)Math.Round(motion.X), ["y"] = (int)Math.Round(motion.Y), ["timeToTarget"] = motion.RemainingMs };
    private static void Show(NativeConnection target, NativePilot pilot, double x, double y)
    {
        if (pilot.Dead) return; target.Send(pilot.Create(x, y)); foreach (var decoration in pilot.PublicDecorations()) target.Send(decoration);
    }
    private async Task Move(NativeConnection connection, int x, int y)
    {
        var pilot = connection.Pilot!; if (pilot.Dead) return;
        var gate = pilotLocks[pilot.PlayerId]; await gate.WaitAsync();
        try
        {
            if (!online.TryGetValue(pilot.PlayerId, out var current) || current != connection) return;
            if (!await directory.Move(connection.MapLease, x, y)) return;
            var snapshot = (await directory.Snapshot(connection.Map))!;
            var motion = snapshot.Motions.FirstOrDefault(m => m.PlayerId == pilot.PlayerId);
            var position = snapshot.Pilots.Single(p => p.Lease == connection.MapLease);
            motion ??= new MapMotion(pilot.PlayerId,position.X,position.Y,0);
            foreach (var peer in Peers(connection.Map, connection)) peer.Send(Movement(motion));
        }
        finally { gate.Release(); }
    }
    internal async Task<bool> Heartbeat(NativeConnection connection)
    {
        if (!await Authorized(connection)) return false;
        var pilot = connection.Pilot!; var gate = pilotLocks[pilot.PlayerId]; await gate.WaitAsync();
        try
        {
            if (!online.TryGetValue(pilot.PlayerId, out var current) || current != connection) return false;
            var position = (await directory.Snapshot(connection.Map))!.Pilots.Single(p => p.Lease == connection.MapLease);
            return await players.SavePosition(pilot.PlayerId, connection.RedisLease!, connection.Map.MapId, position.X, position.Y);
        }
        finally { gate.Release(); }
    }
    public void RevokeConnections(string token) { foreach (var connection in online.Values) if (connection.Ticket == token) connection.Close(); }
    internal async Task Disconnect(NativeConnection connection)
    {
        if (connection.Pilot is not { } pilot) return;
        var gate = pilotLocks[pilot.PlayerId]; await gate.WaitAsync();
        try
        {
            if (online.TryGetValue(pilot.PlayerId, out var current) && current == connection)
            {
                try
                {
                    var position = (await directory.Snapshot(connection.Map))!.Pilots.Single(p => p.Lease == connection.MapLease);
                    await players.SavePosition(pilot.PlayerId, connection.RedisLease!, connection.Map.MapId, position.X, position.Y);
                }
                catch { /* Cleanup must continue even during database failure. */ }
                await presence.WaitAsync();
                try
                {
                    online.TryRemove(pilot.PlayerId, out _); await directory.Disconnect(connection.MapLease);
                    foreach (var peer in Peers(connection.Map, connection)) peer.Send(Remove(pilot.PlayerId));
                }
                finally { presence.Release(); }
            }
            if (connection.RedisLease is { } lease) { try { await tickets.Release(pilot.PlayerId, serverId, lease); } catch { /* Fenced lease expires; never delete another owner. */ } }
        }
        finally { gate.Release(); }
    }
    public ValueTask DisposeAsync() => directory.DisposeAsync();
}
