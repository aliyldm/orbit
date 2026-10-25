using System.Collections.Concurrent;
using System.Security.Authentication;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;
using DarkOrbit.Server.World;

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
    private readonly WorldContent content = WorldContent.Default;
    private readonly CancellationTokenSource stopping = new();
    private readonly ConcurrentDictionary<long, PendingJump> jumps = [];
    private readonly Task simulation;
    private static readonly TimeSpan LeaseLifetime = TimeSpan.FromSeconds(40);
    public int OnlineCount => online.Count;
    public bool WorldHealthy => !simulation.IsFaulted && !stopping.IsCancellationRequested;
    public NativeGameHub(NativePlayerRepository players, RedisSessions tickets, IReadOnlyDictionary<int, MapDefinition> maps, int serverId)
    {
        this.players = players; this.tickets = tickets; this.maps = maps; this.serverId = serverId;
        directory = new(key => { var map = maps[key.MapId]; return new MapActor(key, map.Width, map.Height, content: content.Maps.GetValueOrDefault(key.MapId)); });
        simulation = RunWorld();
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
        if (name == "JumpRequest") await Jump(connection, null);
        if (name == "MapAssetActivationRequest") await Jump(connection, command["mapAssetId"]!.GetValue<int>());
        if (name == "ShipSelectRequest") await Select(connection, command["targetId"]!.GetValue<int>());
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
            var initial = pilot.Initialization(Codec, content).ToArray();
            await presence.WaitAsync();
            try
            {
                if (online.TryGetValue(id, out previous))
                {
                    foreach (var peer in Peers(previous.Map, previous)) peer.Send(Remove(id));
                    previous.Close();
                    jumps.TryRemove(id, out _);
                }
                connection.MapLease = await directory.Connect(id, connection.Map, pilot.X, pilot.Y, pilot.Dead ? 0 : pilot.Speed);
                await directory.Status(connection.MapLease, pilot.Faction, pilot.Dead, pilot.Cloaked, false);
                online[id] = connection;
                foreach (var packet in initial) if (!connection.Send(packet)) throw new IOException("Initial queue exceeded");
                var snapshot = (await directory.Snapshot(connection.Map))!;
                ShowNpcs(connection, snapshot);
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
        var pilot = connection.Pilot!; if (pilot.Dead || connection.Jumping) return;
        var gate = pilotLocks[pilot.PlayerId]; await gate.WaitAsync();
        try
        {
            if (!online.TryGetValue(pilot.PlayerId, out var current) || current != connection || connection.Jumping) return;
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
        if (!WorldHealthy) return false;
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
    private static void ShowNpcs(NativeConnection connection, MapSnapshot snapshot)
    {
        foreach (var npc in snapshot.Npcs)
        {
            connection.Send(npc.Create());
            if (npc.Motion is { } motion) connection.Send(new JsonObject { ["_"] = "MoveCommand", ["userId"] = npc.Id, ["x"] = motion.X, ["y"] = motion.Y, ["timeToTarget"] = motion.RemainingMs });
        }
    }
    private static void PortalUpdates(NativeConnection connection, MapContent map, Pilot position)
    {
        foreach (var portal in map.VisiblePortals(connection.Pilot!.Faction))
        {
            bool available = !connection.Jumping && !connection.Pilot.Dead && portal.Distance(position.X, position.Y) <= 750;
            if (!connection.PortalStates.TryGetValue(portal.Id, out bool old) || old != available)
            { connection.Send(portal.State(available)); connection.PortalStates[portal.Id] = available; }
        }
    }
    private async Task Select(NativeConnection connection, int id)
    {
        var pilot = connection.Pilot!; var gate = pilotLocks[pilot.PlayerId]; await gate.WaitAsync();
        try
        {
            if (pilot.Dead || connection.Jumping || !online.TryGetValue(pilot.PlayerId, out var current) || current != connection) return;
            var snapshot = (await directory.Snapshot(connection.Map))!; var npc = snapshot.Npcs.FirstOrDefault(n => n.Id == id);
            if (npc is not null) { connection.Selected = id; connection.Send(npc.Selection()); }
        }
        finally { gate.Release(); }
    }
    private async Task Jump(NativeConnection connection, int? gateId)
    {
        var pilot = connection.Pilot!; var gate = pilotLocks[pilot.PlayerId]; await gate.WaitAsync();
        try
        {
            if (pilot.Dead || connection.Jumping || !online.TryGetValue(pilot.PlayerId, out var current) || current != connection || !content.Maps.TryGetValue(connection.Map.MapId, out var map)) return;
            var position = (await directory.Snapshot(connection.Map))!.Pilots.Single(p => p.Lease == connection.MapLease);
            var portal = map.Nearest(position.X, position.Y, pilot.Faction);
            if (portal is null || gateId is { } requested && requested != portal.Id || !maps.TryGetValue(portal.Target, out var destination) || destination.Private) return;
            int level = portal.Level(pilot.Faction);
            if (pilot.Level < level)
            {
                connection.Send(new JsonObject { ["_"] = "JumpDeniedCommand", ["mandatoryLevel"] = level });
                connection.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = $"0|A|STD|Hedef harita için en az {level}. seviye gerekli." }); return;
            }
            // Retire the route immediately; the client cannot move away during
            // the original two-second transition or queue another jump.
            await directory.Move(connection.MapLease, position.X, position.Y);
            foreach (var peer in Peers(connection.Map, connection)) peer.Send(Movement(new MapMotion(pilot.PlayerId, position.X, position.Y, 0)));
            connection.Jumping = true; connection.Selected = null;
            await directory.Status(connection.MapLease, pilot.Faction, pilot.Dead, pilot.Cloaked, true);
            connection.Send(new JsonObject { ["_"] = "JumpInitiatedCommand", ["mapId"] = portal.Target, ["gateId"] = portal.Id });
            jumps[pilot.PlayerId] = new(connection, portal, Environment.TickCount64 + 2000);
        }
        finally { gate.Release(); }
    }
    private async Task CompleteJump(long id, PendingJump pending)
    {
        var gate = pilotLocks[id]; await gate.WaitAsync();
        try
        {
            var connection = pending.Connection;
            if (!jumps.TryGetValue(id, out var actual) || actual != pending) return;
            jumps.TryRemove(id, out _);
            if (!online.TryGetValue(id, out var current) || current != connection || !connection.Jumping || !await Authorized(connection)) { connection.Close(); return; }
            await presence.WaitAsync();
            try
            {
                var previousMap = connection.Map; var old = (await directory.Snapshot(previousMap))!.Pilots.Single(p => p.Lease == connection.MapLease);
                var pilot = connection.Pilot! with { MapId = pending.Portal.Target, X = pending.Portal.TargetX, Y = pending.Portal.TargetY };
                var newMap = MapFor(pilot, maps[pilot.MapId]);
                var lease = await directory.Connect(id, newMap, pilot.X, pilot.Y, pilot.Speed);
                connection.Map = newMap; connection.MapLease = lease;
                await directory.Status(lease, pilot.Faction, pilot.Dead, pilot.Cloaked, false);
                try
                {
                    if (!await players.SavePosition(id, connection.RedisLease!, pilot.MapId, pilot.X, pilot.Y)) throw new AuthenticationException("Lost transfer owner");
                }
                catch
                {
                    // No destination peers have seen this transfer yet. Retire
                    // its lease and restore the original actor before cleanup.
                    connection.MapLease = await directory.Connect(id, previousMap, old.X, old.Y, old.Speed);
                    await directory.Status(connection.MapLease, old.Faction, old.Dead, old.Cloaked, false);
                    connection.Map = previousMap; connection.Close(); throw;
                }
                foreach (var peer in Peers(previousMap, connection)) peer.Send(Remove(id));
                connection.Pilot = pilot; connection.Jumping = false;
                connection.PortalStates.Clear();
                connection.Send(new JsonObject { ["_"] = "JumpToServerCommand" });
                foreach (var frame in pilot.Initialization(Codec, content)) connection.Send(frame);
                var snapshot = (await directory.Snapshot(newMap))!; ShowNpcs(connection, snapshot);
                foreach (var peer in Peers(newMap, connection))
                {
                    var position = snapshot.Pilots.Single(p => p.Lease == peer.MapLease); Show(connection, peer.Pilot!, position.X, position.Y);
                    if (snapshot.Motions.FirstOrDefault(m => m.PlayerId == peer.Pilot!.PlayerId) is { } motion) connection.Send(Movement(motion));
                    Show(peer, pilot, pilot.X, pilot.Y);
                }
            }
            finally { presence.Release(); }
        }
        finally { gate.Release(); }
    }
    private async Task RunWorld()
    {
        using var timer = new PeriodicTimer(TimeSpan.FromMilliseconds(250));
        try
        {
            while (await timer.WaitForNextTickAsync(stopping.Token))
            {
                foreach (var pair in jumps.ToArray()) if (pair.Value.Due <= Environment.TickCount64)
                {
                    try { await CompleteJump(pair.Key, pair.Value); }
                    catch (Exception e) { pair.Value.Connection.Close(); Console.Error.WriteLine($"Native map transfer failed ({e.GetType().Name})"); }
                }
                await presence.WaitAsync(stopping.Token);
                try
                {
                    foreach (var (mapKey, events) in await directory.Tick())
                    {
                        var recipients = online.Values.Where(c => c.Ready && !c.IsClosed && c.Map == mapKey).ToArray();
                        foreach (var command in events) foreach (var recipient in recipients) recipient.Send(command);
                        if (recipients.Length == 0 || !content.Maps.TryGetValue(mapKey.MapId, out var map)) continue;
                        var snapshot = (await directory.Snapshot(mapKey))!;
                        foreach (var c in recipients)
                        {
                            var position = snapshot.Pilots.FirstOrDefault(p => p.Lease == c.MapLease); if (position is null) continue;
                            if (Environment.TickCount64 - c.LastBeacon >= 1000)
                            {
                                c.Send(map.Beacon(position, c.Pilot!.Faction, c.Pilot.Dead, snapshot.Motions.FirstOrDefault(m => m.PlayerId == c.Pilot.PlayerId)));
                                c.LastBeacon = Environment.TickCount64;
                            }
                            PortalUpdates(c, map, position);
                        }
                    }
                }
                finally { presence.Release(); }
            }
        }
        catch (OperationCanceledException) when (stopping.IsCancellationRequested) { }
    }
    private sealed record PendingJump(NativeConnection Connection, Portal Portal, long Due);
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
                    jumps.TryRemove(pilot.PlayerId, out _);
                    foreach (var peer in Peers(connection.Map, connection)) peer.Send(Remove(pilot.PlayerId));
                }
                finally { presence.Release(); }
            }
            if (connection.RedisLease is { } lease) { try { await tickets.Release(pilot.PlayerId, serverId, lease); } catch { /* Fenced lease expires; never delete another owner. */ } }
        }
        finally { gate.Release(); }
    }
    public async ValueTask DisposeAsync()
    {
        stopping.Cancel();
        try { await simulation; }
        finally
        {
            await directory.DisposeAsync(); stopping.Dispose();
            foreach (var gate in pilotLocks.Values) gate.Dispose(); presence.Dispose();
        }
    }
}
