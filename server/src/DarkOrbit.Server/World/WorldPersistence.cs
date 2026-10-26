using System.Text.Json.Nodes;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;

namespace DarkOrbit.Server.World;

public sealed record Wallet(decimal Credits, decimal Uridium, decimal Ep, decimal Honour, int Level);
public sealed record NpcReward(decimal Credits = 0, decimal Uridium = 0, decimal Ep = 0, decimal Honour = 0);
public sealed record ShotDebit(Guid Id, long PlayerId, ConnectionLease Connection, string Ammo, int Amount, string? Claim, NpcReward Reward);
public sealed record StoredWorld(long Revision, JsonObject State);
public sealed record WorldCommit(bool Accepted, long Revision, Wallet? Wallet = null, long AmmoRemaining = 0, string? Reason = null);
public sealed record CommittedAttack(NpcDamage Damage, WorldCommit Commit);

public interface IWorldPersistence
{
    Task<StoredWorld> Load(MapKey key, JsonObject initial);
    Task<WorldCommit> Commit(MapKey key, long revision, JsonObject state, ShotDebit? debit = null);
}
