using System.Collections.Concurrent;
using System.Net;
using System.Net.Sockets;

namespace DarkOrbit.Server.Transport;

public sealed record NativeGameOptions
{
    public int Port { get; init; } = 18096;
    public string BindAddress { get; init; } = "127.0.0.1";
    public string AdvertisedHost { get; init; } = "127.0.0.1";
    public int? AdvertisedPort { get; init; }
    public int ServerId { get; init; } = 1;
    public int MaxConnections { get; init; } = 1024;
    public TimeSpan AuthenticationTimeout { get; init; } = TimeSpan.FromSeconds(15);
    public TimeSpan IdleTimeout { get; init; } = TimeSpan.FromSeconds(120);
    public TimeSpan WriteTimeout { get; init; } = TimeSpan.FromSeconds(5);
    public TimeSpan HeartbeatInterval { get; init; } = TimeSpan.FromSeconds(10);
}

public sealed class NativeGameServer(NativeGameHub hub, NativeGameOptions options) : IAsyncDisposable
{
    private readonly TcpListener listener = new(IPAddress.Parse(options.BindAddress), options.Port);
    private readonly CancellationTokenSource stopping = new();
    private readonly ConcurrentDictionary<long, (NativeConnection Connection, Task Work)> connections = [];
    private Task? accepting;
    private long serial;
    public int Port => ((IPEndPoint)listener.LocalEndpoint).Port;
    public IPAddress BindAddress => ((IPEndPoint)listener.LocalEndpoint).Address;
    public int ConnectionCount => connections.Count;
    public void Start()
    {
        if (accepting is not null) throw new InvalidOperationException("Already started");
        listener.Start(); accepting = Accept();
    }
    private async Task Accept()
    {
        try
        {
            while (!stopping.IsCancellationRequested)
            {
                var socket = await listener.AcceptTcpClientAsync(stopping.Token);
                if (connections.Count >= options.MaxConnections) { socket.Dispose(); continue; }
                long id = Interlocked.Increment(ref serial); var connection = new NativeConnection(socket, hub, Port, options);
                // Register before starting: an immediate rejection cannot leave a
                // completed connection trapped in the connection limit forever.
                var start = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
                var work = Task.Run(async () => { await start.Task; try { await connection.Run(); } catch { connection.Close(); } finally { connections.TryRemove(id, out _); } });
                connections[id] = (connection, work); start.SetResult();
            }
        }
        catch (OperationCanceledException) when (stopping.IsCancellationRequested) { }
        catch (SocketException) when (stopping.IsCancellationRequested) { }
    }
    public async ValueTask DisposeAsync()
    {
        stopping.Cancel(); listener.Stop(); if (accepting is not null) await accepting;
        var active = connections.Values.ToArray(); foreach (var connection in active) connection.Connection.Close();
        await Task.WhenAll(active.Select(c => c.Work)); stopping.Dispose();
    }
}
