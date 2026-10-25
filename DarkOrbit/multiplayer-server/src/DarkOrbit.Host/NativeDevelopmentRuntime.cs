using DarkOrbit.Server.Storage;
using DarkOrbit.Server.Transport;
using Npgsql;
using StackExchange.Redis;

namespace DarkOrbit.Host;

public sealed class NativeDevelopmentRuntime : IAsyncDisposable
{
    private readonly NpgsqlDataSource source;
    private readonly ConnectionMultiplexer redis;
    public NativePlayerRepository Players { get; }
    public RedisSessions Tickets { get; }
    public NativeGameHub Hub { get; }
    public NativeGameServer Game { get; }
    public NativeGameOptions Options { get; }
    public SemaphoreSlim PasswordSlots { get; } = new(2);
    private NativeDevelopmentRuntime(NpgsqlDataSource source, ConnectionMultiplexer redis, NativePlayerRepository players, RedisSessions tickets, NativeGameHub hub, NativeGameOptions options)
    { this.source = source; this.redis = redis; Players = players; Tickets = tickets; Hub = hub; Options = options; Game = new(hub, options); }
    public static async Task<NativeDevelopmentRuntime> Create(string postgres, string redisConnection, string schema, NativeGameOptions options)
    {
        var source = NpgsqlDataSource.Create(postgres); ConnectionMultiplexer? redis = null;
        try
        {
            redis = await ConnectionMultiplexer.ConnectAsync(redisConnection);
            var players = new NativePlayerRepository(source, schema); var maps = await players.Maps(); var tickets = new RedisSessions(redis,"darkorbit-stage2-"+schema);
            var hub = new NativeGameHub(players, tickets, maps, options.ServerId);
            return new(source, redis, players, tickets, hub, options);
        }
        catch { redis?.Dispose(); await source.DisposeAsync(); throw; }
    }
    public async ValueTask DisposeAsync() { await Game.DisposeAsync(); await Hub.DisposeAsync(); redis.Dispose(); await source.DisposeAsync(); PasswordSlots.Dispose(); }
}
