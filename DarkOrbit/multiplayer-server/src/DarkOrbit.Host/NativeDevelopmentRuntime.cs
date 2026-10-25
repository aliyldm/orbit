using DarkOrbit.Server.Storage;
using DarkOrbit.Server.Transport;
using Npgsql;
using StackExchange.Redis;

namespace DarkOrbit.Host;

public sealed class NativeDevelopmentRuntime : IAsyncDisposable
{
    private readonly NpgsqlDataSource source;
    private readonly ConnectionMultiplexer redis;
    private readonly CombatRepository combat;
    public NativePlayerRepository Players { get; }
    public RedisSessions Tickets { get; }
    public NativeGameHub Hub { get; }
    public NativeGameServer Game { get; }
    public NativeGameOptions Options { get; }
    public SemaphoreSlim PasswordSlots { get; } = new(2);
    private NativeDevelopmentRuntime(NpgsqlDataSource source, ConnectionMultiplexer redis, NativePlayerRepository players, RedisSessions tickets, NativeGameHub hub, NativeGameOptions options, CombatRepository combat)
    { this.source = source; this.redis = redis; this.combat = combat; Players = players; Tickets = tickets; Hub = hub; Options = options; Game = new(hub, options); }
    public static async Task<NativeDevelopmentRuntime> Create(string postgres, string redisConnection, string schema, NativeGameOptions options)
    {
        var source = NpgsqlDataSource.Create(postgres); ConnectionMultiplexer? redis = null; CombatRepository? combat = null;
        try
        {
            redis = await ConnectionMultiplexer.ConnectAsync(redisConnection);
            var players = new NativePlayerRepository(source, schema); var maps = await players.Maps(); var tickets = new RedisSessions(redis,"darkorbit-stage2-"+schema);
            combat = new(source, schema, options.ServerId); await combat.Acquire();
            var hub = new NativeGameHub(players, tickets, maps, options.ServerId, combat);
            return new(source, redis, players, tickets, hub, options, combat);
        }
        catch { if (combat is not null) await combat.DisposeAsync(); redis?.Dispose(); await source.DisposeAsync(); throw; }
    }
    public async ValueTask DisposeAsync()
    {
        try { await Game.DisposeAsync(); }
        finally
        {
            try { await Hub.DisposeAsync(); }
            finally
            {
                try { await combat.DisposeAsync(); }
                finally { redis.Dispose(); await source.DisposeAsync(); PasswordSlots.Dispose(); }
            }
        }
    }
}
