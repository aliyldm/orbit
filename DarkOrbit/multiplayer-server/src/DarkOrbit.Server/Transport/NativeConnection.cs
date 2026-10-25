using System.Net.Sockets;
using System.Text;
using System.Text.Json.Nodes;
using System.Threading.Channels;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;

namespace DarkOrbit.Server.Transport;

internal sealed class NativeConnection(TcpClient client, NativeGameHub hub, int port, NativeGameOptions options)
{
    private readonly CancellationTokenSource closed = new();
    private readonly Channel<byte[]> outbound = Channel.CreateBounded<byte[]>(new BoundedChannelOptions(1024) { SingleReader = true, FullMode = BoundedChannelFullMode.Wait });
    private int queuedBytes;
    internal NativePilot? Pilot;
    internal SessionLease MapLease;
    internal ConnectionLease? RedisLease;
    internal MapKey Map;
    internal string? Ticket;
    internal bool Ready;
    internal bool Jumping;
    internal int? Selected;
    internal readonly Dictionary<int, bool> PortalStates = [];
    internal long LastBeacon;
    internal bool IsClosed => closed.IsCancellationRequested;
    internal void Close()
    {
        if (!closed.IsCancellationRequested) { closed.Cancel(); outbound.Writer.TryComplete(); client.Dispose(); }
    }
    internal bool Send(byte[] frame)
    {
        if (IsClosed) return false;
        if (Interlocked.Add(ref queuedBytes, frame.Length) > NativeFrames.MaxPending) { Interlocked.Add(ref queuedBytes, -frame.Length); Close(); return false; }
        if (outbound.Writer.TryWrite(frame)) return true;
        Interlocked.Add(ref queuedBytes, -frame.Length); Close(); return false;
    }
    internal bool Send(JsonObject command) => Send(NativeFrames.Frame(hub.Codec.Encode(command)));
    internal async Task Run()
    {
        client.NoDelay = true; closed.CancelAfter(options.AuthenticationTimeout);
        var stream = client.GetStream();
        var writer = Task.Run(async () =>
        {
          try {
            await foreach (var frame in outbound.Reader.ReadAllAsync(closed.Token))
            {
                try { using var timeout = CancellationTokenSource.CreateLinkedTokenSource(closed.Token); timeout.CancelAfter(options.WriteTimeout); await stream.WriteAsync(frame, timeout.Token); }
                finally { Interlocked.Add(ref queuedBytes, -frame.Length); }
            }
          } catch { Close(); throw; }
        });
        var heartbeat = Task.Run(async () =>
        {
            try { while (true) { await Task.Delay(options.HeartbeatInterval, closed.Token); if (Ready && !await hub.Heartbeat(this)) { Close(); return; } } }
            catch (OperationCanceledException) when (IsClosed) { }
            catch { Close(); }
        });
        try
        {
            var parser = new NativeFrames(); var buffer = new byte[16384]; List<byte> sniff = []; bool sniffed = false;
            byte[] policy = Encoding.ASCII.GetBytes("<policy-file-request/>");
            while (!IsClosed)
            {
                using var idle = CancellationTokenSource.CreateLinkedTokenSource(closed.Token); idle.CancelAfter(options.IdleTimeout);
                int count = await stream.ReadAsync(buffer, idle.Token); if (count == 0) { parser.Complete(); break; }
                byte[] input = buffer.AsSpan(0, count).ToArray();
                if (!sniffed)
                {
                    sniff.AddRange(input);
                    if (sniff[0] == '<')
                    {
                        int prefix = Math.Min(sniff.Count, policy.Length);
                        if (!sniff.Take(prefix).SequenceEqual(policy.Take(prefix))) throw new InvalidDataException("Invalid policy request");
                        if (sniff.Count < policy.Length) continue;
                        await stream.WriteAsync(Encoding.UTF8.GetBytes($"<?xml version=\"1.0\"?><cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"{port}\" /></cross-domain-policy>\0"), closed.Token); return;
                    }
                    input = sniff.ToArray(); sniffed = true;
                }
                foreach (byte[] body in parser.Push(input))
                {
                    var command = hub.Codec.Decode(body) ?? throw new InvalidDataException("Null command");
                    if (!await hub.Dispatch(this, command)) return;
                    if (Ready) closed.CancelAfter(Timeout.InfiniteTimeSpan);
                }
            }
        }
        catch (Exception e) when (e is IOException or SocketException or OperationCanceledException or InvalidDataException or ArgumentException or System.Security.Authentication.AuthenticationException) { }
        finally
        {
            Close();
            try { await Task.WhenAll(writer, heartbeat); } catch (Exception e) when (e is IOException or SocketException or OperationCanceledException or ChannelClosedException) { }
            await hub.Disconnect(this);
            closed.Dispose();
        }
    }
}
