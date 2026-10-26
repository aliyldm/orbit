using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Threading.Channels;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;
using Npgsql;

if (args.Length == 1 && args[0] == "storage") { await StorageVerification.Run(); return; }
if (args.Length == 1 && args[0] == "native") { await NativeVerification.Run(); return; }
if (args.Length == 1 && args[0] == "world") { await WorldVerification.Run(); return; }
if (args.Length == 1 && args[0] == "combat") { await CombatVerification.Run(); return; }
if (args.Length == 1 && args[0] == "laser") { await ClassicLaserVerification.Run(); return; }
if (args.Length == 1 && args[0] == "equipment") { await EquipmentVerification.Run(); return; }
if (args.Length == 1 && args[0] == "equipment-storage") { await EquipmentStorageVerification.Run(); return; }

if (args.Length > 0 && args[0] == "bootstrap")
{
    if (args.Length != 5) throw new ArgumentException("bootstrap <archive> <target> <private profiles> <snapshot hash>");
    await using var source = NpgsqlDataSource.Create(Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES") ?? throw new InvalidOperationException("DARKORBIT_POSTGRES required"));
    Console.WriteLine(JsonSerializer.Serialize(await NativeBootstrap.Create(source, args[1], args[2], args[3], args[4]), new JsonSerializerOptions { WriteIndented = true })); return;
}

if (args.Length > 0 && args[0] == "import")
{
    if (args.Length != 3) throw new ArgumentException("import <private snapshot> <fresh legacy_16hex schema>");
    var connectionString = Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES") ?? throw new InvalidOperationException("Set DARKORBIT_POSTGRES without exposing it in command arguments");
    await using var source = NpgsqlDataSource.Create(connectionString);
    var result = await SnapshotImporter.Import(source, args[1], args[2]);
    Console.WriteLine(JsonSerializer.Serialize(result, new JsonSerializerOptions { WriteIndented = true })); return;
}

if (args.Length > 0) throw new ArgumentException("Unknown verification mode");
var clock = Stopwatch.StartNew(); int assertions = 0;
void Check(bool condition, string label) { Interlocked.Increment(ref assertions); if (!condition) throw new InvalidOperationException(label); }
void Throws(Action fn, string label)
{
    bool failed = false; try { fn(); } catch (Exception e) when (e is InvalidDataException or EndOfStreamException) { failed = true; }
    Check(failed, label);
}
var codec = new LegacyCodec();
var oracle = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/protocol-contract.json"))!;
Check(codec.ClassCount == oracle["classCount"]!.GetValue<int>(), "All schema classes present");
Check(codec.SchemaSha256 == oracle["schemaSha256"]!.GetValue<string>(), "Embedded schema exactly matches legacy oracle");
int cases = 0;
foreach (var sample in oracle["cases"]!.AsArray())
{
    var bytes = Convert.FromHexString(sample!["hex"]!.GetValue<string>()); var expected = sample["expected"]!.AsObject();
    var decoded = codec.Decode(bytes);
    Check(JsonNode.DeepEquals(decoded, expected), "Decode " + sample["name"]);
    Check(codec.Encode(expected).SequenceEqual(bytes), "Encode " + sample["name"]); cases++;
}
Console.WriteLine($"PASS native protocol: {cases} JS/.NET byte and object contracts, {codec.ClassCount} schema classes");
Throws(() => codec.Decode([127, 127]), "Unknown module rejected");
Throws(() => codec.Decode([0]), "Truncated module rejected");
var version = codec.Encode(new JsonObject { ["_"] = "VersionRequest", ["version"] = "unchanged-native-client" });
Throws(() => codec.Decode([.. version, 0]), "Trailing fields rejected");
var frames = new NativeFrames(); var input = NativeFrames.Frame(version, true).Concat(NativeFrames.Frame(version)).ToArray();
var complete = new List<byte[]>(); foreach (byte b in input) complete.AddRange(frames.Push([b])); frames.Complete();
Check(complete.Count == 2 && complete.All(b => b.SequenceEqual(version)), "Fragmented first4/subsequent3 frame parsing");
Check(new NativeFrames().Push(input).Count == 2, "Coalesced input");
Throws(() => new NativeFrames().Push([0, 0, 0, 1]), "Undersized frame");
Throws(() => new NativeFrames().Push([0, 16, 0, 1]), "Oversized frame");
Throws(() => new NativeFrames().Push(new byte[NativeFrames.MaxPending + 1]), "Pending bytes bound");
Throws(() => { var f = new NativeFrames(); f.Push([0]); f.Complete(); }, "Incomplete close rejected");

// Actual TCP streams exercise independent incremental parsers, not GUI rendering.
var listener = new TcpListener(IPAddress.Loopback, 0); listener.Start(); var endpoint = (IPEndPoint)listener.LocalEndpoint;
using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(15));
async Task Handle(TcpClient client)
{
    using (client)
    {
        var stream = client.GetStream(); var decoder = new NativeFrames(); var buffer = new byte[4096]; int received = 0;
        while (received < 2)
        {
            int count = await stream.ReadAsync(buffer, timeout.Token); if (count == 0) throw new EndOfStreamException();
            foreach (var body in decoder.Push(buffer.AsSpan(0, count)))
            {
                var command = codec.Decode(body)!;
                if (command["_"]!.GetValue<string>() != "VersionRequest") throw new InvalidDataException();
                await stream.WriteAsync(NativeFrames.Frame(codec.Encode(new JsonObject { ["_"] = "VersionCommand", ["version"] = command["version"]!.DeepClone(), ["equal"] = true })), timeout.Token); received++;
            }
        }
    }
}
async Task Probe(string name)
{
    using var client = new TcpClient(); await client.ConnectAsync(endpoint.Address, endpoint.Port, timeout.Token);
    var stream = client.GetStream(); var body = codec.Encode(new JsonObject { ["_"] = "VersionRequest", ["version"] = name });
    var requests = NativeFrames.Frame(body, true).Concat(NativeFrames.Frame(body)).ToArray();
    foreach (byte b in requests) await stream.WriteAsync(new byte[] { b }, timeout.Token);
    var parser = new NativeFrames(false); var buffer = new byte[512]; int replies = 0;
    while (replies < 2)
    {
        int count = await stream.ReadAsync(buffer, timeout.Token); if (count == 0) throw new EndOfStreamException();
        foreach (var reply in parser.Push(buffer.AsSpan(0, count)))
        {
            var result = codec.Decode(reply)!;
            Check(result["version"]!.GetValue<string>() == name && result["equal"]!.GetValue<bool>(), "TCP connection replies isolated"); replies++;
        }
    }
}
var accept = Task.Run(async () => { var a = await listener.AcceptTcpClientAsync(timeout.Token); var b = await listener.AcceptTcpClientAsync(timeout.Token); await Task.WhenAll(Handle(a), Handle(b)); });
try { await Task.WhenAll(Probe("pilot-A"), Probe("pilot-B"), accept); } finally { listener.Stop(); }
Console.WriteLine("PASS real TCP: two independent clients, fragmented native frames and codec replies");

var time = new ManualTime();
await using (var directory = new WorldDirectory(key => new MapActor(key, 21000, 13000, time, 32)))
{
    var shared = new MapKey(1, 1, Guid.Empty); var other = new MapKey(1, 2, Guid.Empty);
    var a = await directory.Connect(1, shared, 100, 100, 100); var b = await directory.Connect(2, shared, 300, 300, 200);
    Check((await directory.Snapshot(shared))!.Pilots.Length == 2, "Second player does not expel first");
    await Task.WhenAll(directory.Move(a, 1100, 100), directory.Move(b, 300, 2300)); time.Advance(TimeSpan.FromSeconds(1));
    var snapshot = (await directory.Snapshot(shared))!;
    Check(snapshot.Pilots[0].X == 200 && snapshot.Pilots[1].Y == 500, "Independent authoritative movement");
    var replacement = await directory.Connect(1, shared, 10, 10, 100);
    Check(!await directory.Disconnect(a), "Delayed old close cannot remove replacement");
    Check(!await directory.Move(a, 0, 0), "Old connection cannot move replacement");
    Check((await directory.Snapshot(shared))!.Pilots.Length == 2, "Reconnect preserves other player");
    var transferred = await directory.Connect(1, other, 400, 500, 100);
    Check(!await directory.Move(replacement, 0, 0), "Old map lease retired");
    Check((await directory.Snapshot(shared))!.Pilots.Single().Lease == b, "Other player remains in old map");
    Check((await directory.Snapshot(other))!.Pilots.Single().Lease == transferred, "New map membership");
    var gateA = new MapKey(1, 51, Guid.NewGuid()); var gateB = new MapKey(1, 51, Guid.NewGuid());
    await directory.Connect(3, gateA, 0, 0, 100); await directory.Connect(4, gateB, 0, 0, 100);
    Check((await directory.Snapshot(gateA))!.Pilots.Single().Lease.PlayerId == 3, "Private gate isolation");
    Check((await directory.Snapshot(gateB))!.Pilots.Single().Lease.PlayerId == 4, "Second private gate isolation");
    var differentServer = new MapKey(2, 1, Guid.Empty); await directory.Connect(5, differentServer, 0, 0, 100);
    Check((await directory.Snapshot(differentServer))!.Pilots.Length == 1, "Server identity isolation");
    bool rejected = false; try { await directory.Move(b, double.NaN, 0); } catch (ArgumentOutOfRangeException) { rejected = true; }
    Check(rejected, "Nonfinite coordinates rejected without actor failure");
    Check(await directory.Move(b, double.MaxValue, -double.MaxValue), "Destination clamps to map bounds");
}
await using (var directory = new WorldDirectory(key => new MapActor(key, 21000, 13000, time, 16)))
{
    var leases = await Task.WhenAll(Enumerable.Range(1, 1000).Select(i => directory.Connect(i, new MapKey(1, i % 10 + 1, Guid.Empty), 0, 0, 100)));
    await Task.WhenAll(leases.Select(lease => directory.Move(lease, 1000, 0))); time.Advance(TimeSpan.FromSeconds(1));
    for (int i = 1; i <= 10; i++)
    {
        var snapshot = (await directory.Snapshot(new MapKey(1, i, Guid.Empty)))!;
        Check(snapshot.Pilots.Length == 100 && snapshot.Pilots.All(p => p.X == 100), "1000 actor memberships/movements preserved");
    }
    await Task.WhenAll(leases.Select(lease => directory.Disconnect(lease)));
    Check((await directory.Snapshot(new MapKey(1, 1, Guid.Empty)))!.Pilots.Length == 0, "Concurrent disconnect cleanup");
}
var failedDestination = new MapActor(new MapKey(1, 2, Guid.Empty), 21000, 13000);
await failedDestination.DisposeAsync();
await using (var directory = new WorldDirectory(key => key.MapId == 2 ? failedDestination : new MapActor(key, 21000, 13000)))
{
    var origin = new MapKey(1, 1, Guid.Empty); var lease = await directory.Connect(1, origin, 100, 100, 100);
    bool failed = false;
    try { await directory.Connect(1, new MapKey(1, 2, Guid.Empty), 100, 100, 100); } catch (ChannelClosedException) { failed = true; }
    Check(failed, "Failed destination rejects transfer");
    Check((await directory.Snapshot(origin))!.Pilots.Single().Lease == lease, "Failed transfer preserves old membership");
    Check(await directory.Move(lease, 200, 200), "Old connection remains usable after target failure");
}
Console.WriteLine("PASS map actors: 1000 synthetic memberships, 10 maps, movement, reconnect, gate/server isolation and cleanup");
Console.WriteLine(JsonSerializer.Serialize(new { status = "PASS", assertions, nativeContracts = cases, protocolClasses = codec.ClassCount, syntheticSessions = 1000, elapsedMs = clock.ElapsedMilliseconds, gameplayReady = false }));

sealed class ManualTime : TimeProvider
{
    private long timestamp;
    public override long TimestampFrequency => TimeSpan.TicksPerSecond;
    public override long GetTimestamp() => Interlocked.Read(ref timestamp);
    public void Advance(TimeSpan elapsed) => Interlocked.Add(ref timestamp, elapsed.Ticks);
}
