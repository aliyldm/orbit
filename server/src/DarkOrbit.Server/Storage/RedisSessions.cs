using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using StackExchange.Redis;

namespace DarkOrbit.Server.Storage;

public sealed record SessionTicket(long AccountId, long PlayerId, int ServerId);
public sealed record ConnectionLease(string Owner, long Fence);

// One shared multiplexer per service. Redis carries transient auth/presence;
// PostgreSQL remains the future source of truth for inventory and rewards.
public sealed class RedisSessions(IConnectionMultiplexer redis, string keyPrefix = "darkorbit")
{
    private readonly IDatabase db = redis.GetDatabase();
    private static void ValidateIds(long playerId, int serverId)
    {
        if (playerId <= 0 || serverId <= 0) throw new ArgumentOutOfRangeException(nameof(playerId));
    }
    private RedisKey TicketKey(string token) => keyPrefix + ":session:" + Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(token)));
    private RedisKey LeaseKey(long playerId, int serverId) => $"{keyPrefix}:{{{serverId}:{playerId}}}:connection";
    private RedisKey FenceKey(long playerId, int serverId) => $"{keyPrefix}:{{{serverId}:{playerId}}}:fence";
    public async Task<string> Issue(SessionTicket ticket, TimeSpan? lifetime = null)
    {
        ValidateIds(ticket.PlayerId, ticket.ServerId); if (ticket.AccountId <= 0) throw new ArgumentOutOfRangeException(nameof(ticket));
        var ttl = lifetime ?? TimeSpan.FromHours(24);
        if (ttl < TimeSpan.FromMilliseconds(1) || ttl > TimeSpan.FromHours(24)) throw new ArgumentOutOfRangeException(nameof(lifetime));
        for (int attempt = 0; attempt < 3; attempt++)
        {
            string token = Convert.ToHexStringLower(RandomNumberGenerator.GetBytes(16));
            if (await db.StringSetAsync(TicketKey(token), JsonSerializer.Serialize(ticket), ttl, When.NotExists)) return token;
        }
        throw new InvalidOperationException("Session issuance collision");
    }
    public async Task<SessionTicket?> Verify(string token, long playerId, int serverId)
    {
        if (!ValidToken(token) || playerId <= 0 || serverId <= 0) return null;
        var ticket = await Read(token);
        return ticket?.PlayerId == playerId && ticket.ServerId == serverId ? ticket : null;
    }
    public async Task<SessionTicket?> Read(string token)
    {
        if (!ValidToken(token)) return null;
        var value = await db.StringGetAsync(TicketKey(token)); if (value.IsNull) return null;
        return JsonSerializer.Deserialize<SessionTicket>(value.ToString());
    }
    public Task<bool> Revoke(string token) => ValidToken(token) ? db.KeyDeleteAsync(TicketKey(token)) : Task.FromResult(false);
    private static bool ValidToken(string? token) => token is { Length: 32 } && token.All(c => c is >= '0' and <= '9' or >= 'a' and <= 'f');

    // Replacement and fencing increment are one Redis operation. All keys use
    // the same hash slot so this also works with Redis Cluster later.
    public async Task<ConnectionLease> Acquire(long playerId, int serverId, TimeSpan ttl)
    {
        ValidateIds(playerId, serverId); long millis = LeaseMilliseconds(ttl);
        string owner = Guid.NewGuid().ToString("N");
        var result = await db.ScriptEvaluateAsync("local f=redis.call('INCR',KEYS[2]);redis.call('SET',KEYS[1],ARGV[1]..':'..f,'PX',ARGV[2]);return f", [LeaseKey(playerId, serverId), FenceKey(playerId, serverId)], [owner, millis]);
        return new ConnectionLease(owner, (long)result);
    }
    public async Task<bool> Renew(long playerId, int serverId, ConnectionLease lease, TimeSpan ttl)
    {
        ValidateIds(playerId, serverId); long millis = LeaseMilliseconds(ttl);
        var result = await db.ScriptEvaluateAsync("if redis.call('GET',KEYS[1])==ARGV[1] then return redis.call('PEXPIRE',KEYS[1],ARGV[2]) else return 0 end", [LeaseKey(playerId, serverId)], [$"{lease.Owner}:{lease.Fence}", millis]);
        return (long)result == 1;
    }
    public async Task<bool> Release(long playerId, int serverId, ConnectionLease lease)
    {
        ValidateIds(playerId, serverId);
        var result = await db.ScriptEvaluateAsync("if redis.call('GET',KEYS[1])==ARGV[1] then return redis.call('DEL',KEYS[1]) else return 0 end", [LeaseKey(playerId, serverId)], [$"{lease.Owner}:{lease.Fence}"]);
        return (long)result == 1;
    }
    private static long LeaseMilliseconds(TimeSpan ttl)
    {
        if (ttl < TimeSpan.FromMilliseconds(1) || ttl > TimeSpan.FromMinutes(5)) throw new ArgumentOutOfRangeException(nameof(ttl));
        return (long)ttl.TotalMilliseconds;
    }
}
