using System.Text.Json.Nodes;
using DarkOrbit.Server.World;

namespace DarkOrbit.Server.Transport;

public sealed partial class NativeGameHub
{
    private async Task AmmoStatus(NativeConnection connection)
    {
        var counts = await players.Ammo(connection.Pilot!.PlayerId);
        foreach (var id in content.AmmoTemplates.Select(p => p.Key).Where(ClassicLaser.Supports)) connection.Send(ClassicLaser.Status(id, counts.GetValueOrDefault(id), connection.Ammo));
    }
    private void AbortLaser(NativeConnection connection)
    {
        if (connection.Attacking is null) return; connection.Attacking = null;
        var command = new JsonObject { ["_"] = "AttackAbortLaserCommand", ["uid"] = connection.Pilot!.PlayerId };
        connection.Send(command); foreach (var peer in Peers(connection.Map, connection)) peer.Send(command);
    }
    private async Task StopLaser(NativeConnection connection)
    {
        var gate = pilotLocks[connection.Pilot!.PlayerId]; await gate.WaitAsync();
        try { if (online.GetValueOrDefault(connection.Pilot.PlayerId) == connection) AbortLaser(connection); }
        finally { gate.Release(); }
    }
    private async Task LaserAction(NativeConnection connection, JsonObject command)
    {
        string id = command["menuItemId"]!.GetValue<string>();
        if (id.StartsWith("drone_formation_", StringComparison.Ordinal)) { await ChangeFormation(connection, id); return; }
        if (!ClassicLaser.Supports(id)) return;
        var gate = pilotLocks[connection.Pilot!.PlayerId]; await gate.WaitAsync();
        try
        {
            if (online.GetValueOrDefault(connection.Pilot.PlayerId) != connection || connection.Jumping || connection.Pilot.Dead) return;
            if (id == ClassicLaser.Rsb && connection.Ammo != ClassicLaser.Rsb) connection.PreviousAmmo = connection.Ammo;
            if (id != ClassicLaser.Rsb) connection.PreviousAmmo = id;
            connection.Ammo = id; await AmmoStatus(connection);
            if (command["actionType"]!.GetValue<short>() == 1 && connection.Selected is { } target)
            { connection.Attacking = target; await FireLaser(connection); }
        }
        finally { gate.Release(); }
    }
    private async Task StartLaser(NativeConnection connection, int target)
    {
        var gate = pilotLocks[connection.Pilot!.PlayerId]; await gate.WaitAsync();
        try
        {
            if (online.GetValueOrDefault(connection.Pilot.PlayerId) != connection || connection.Jumping || connection.Pilot.Dead) return;
            connection.Attacking = target; await FireLaser(connection);
        }
        finally { gate.Release(); }
    }
    // Called under the pilot lock. The MapActor serializes target validation,
    // damage, PostgreSQL debit/claim/checkpoint and rollback across attackers.
    private async Task FireLaser(NativeConnection connection)
    {
        var pilot = connection.Pilot!;
        if (connection.Attacking is not { } target || connection.IsClosed || connection.Jumping || pilot.Dead || Environment.TickCount64 < connection.NextLaser || online.GetValueOrDefault(pilot.PlayerId) != connection) return;
        await RefreshEquipment(connection); pilot = connection.Pilot!;
        if (pilot.Dead) { AbortLaser(connection); return; }
        if (combat is null || !ClassicLaser.Supports(pilot.Profile))
        {
            AbortLaser(connection); connection.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = "0|A|STD|Bu donanımın savaş özellikleri yeni sunucuya henüz taşınmadı." }); return;
        }
        if (!await Authorized(connection)) { connection.Close(); return; }
        var snapshot = (await directory.Snapshot(connection.Map))!; var npc = snapshot.Npcs.FirstOrDefault(n => n.Id == target);
        if (npc is null) { AbortLaser(connection); return; }
        if (npc.Key.Contains("cubikon", StringComparison.Ordinal) || npc.Key.Contains("battleray", StringComparison.Ordinal))
        { AbortLaser(connection); return; } // Special shields/escorts must be ported together.
        var position = snapshot.Pilots.Single(p => p.Lease == connection.MapLease);
        if (!content.Maps.TryGetValue(connection.Map.MapId, out var map) || map.Peace(position.X, position.Y, pilot.Faction) || double.Hypot(npc.X - position.X, npc.Y - position.Y) > 600)
        {
            connection.Send(new JsonObject { ["_"] = "AttackRangeExceededCommand", ["uid"] = target, ["maxRange"] = 600, ["type"] = 0 }); AbortLaser(connection); return;
        }
        if (connection.Ammo == ClassicLaser.Rsb && Environment.TickCount64 < connection.NextRsb) connection.Ammo = connection.PreviousAmmo;
        var counts = await players.Ammo(pilot.PlayerId); int cost = ClassicLaser.Cost(pilot.Profile);
        if (connection.Ammo == ClassicLaser.Rsb && counts.GetValueOrDefault(connection.Ammo) < cost) connection.Ammo = connection.PreviousAmmo;
        string ammo = connection.Ammo;
        int damage = ClassicLaser.Damage(pilot.Profile, ammo, Random.Shared.NextDouble());
        bool hit = Random.Shared.NextDouble() < ClassicLaser.Chance(pilot.Profile);
        var debit = new ShotDebit(Guid.NewGuid(), pilot.PlayerId, connection.RedisLease!, ammo, cost, null, new());
        var attack = await directory.AttackNpc(connection.MapLease, target, hit ? damage : 0, ClassicLaser.Absorb(pilot.Profile), 600, debit, def => ClassicLaser.Reward(pilot.Profile, def));
        if (attack is null || !attack.Commit.Accepted)
        {
            if (attack?.Commit.Reason == "cooldown")
            {
                if (connection.Ammo == ClassicLaser.Rsb) connection.Ammo = connection.PreviousAmmo;
                connection.NextLaser = Environment.TickCount64 + 250;
            }
            else AbortLaser(connection);
            return;
        }
        connection.NextLaser = Environment.TickCount64 + 1000;
        if (ammo == ClassicLaser.Rsb)
        {
            connection.NextRsb = Environment.TickCount64 + 3000; connection.Ammo = connection.PreviousAmmo;
            connection.Send(new JsonObject { ["_"] = "MenuItemCooldownGroupTimerCommand", ["timerState"] = new JsonObject { ["_"] = "TimerStateModule", ["timerStateValue"] = 2 }, ["cooldownType"] = new JsonObject { ["_"] = "CooldownTypeModule", ["typeValue"] = 10 }, ["maxTime"] = 3000, ["time"] = 3000 });
        }
        await presence.WaitAsync();
        try
        {
            var recipients = Peers(connection.Map, connection).Append(connection).ToArray();
            if (pilot.Cloaked)
            {
                pilot.Profile["cloaked"] = false; await directory.Status(connection.MapLease, pilot.Faction, false, false, false);
                var cloak = new JsonObject { ["_"] = "LegacyModule", ["message"] = $"0|n|INV|{pilot.PlayerId}|0" }; foreach (var peer in recipients) peer.Send(cloak);
            }
            var laser = new JsonObject { ["_"] = "AttackLaserRunCommand", ["attackerId"] = pilot.PlayerId, ["targetId"] = target, ["laserColor"] = ClassicLaser.Color(ammo), ["isDiminishedBySkillShield"] = false, ["skilledLaser"] = false, ["visualType"] = 0 };
            var state = attack.Damage.State!;
            var impact = hit ? new JsonObject { ["_"] = "AttackHitCommand", ["attackType"] = new JsonObject { ["_"] = "AttackTypeModule", ["attackTypeValue"] = 1 }, ["attackerId"] = pilot.PlayerId, ["victimId"] = target, ["victimHitpoints"] = state.Hp, ["victimShield"] = state.Shield, ["victimNanoHull"] = 0, ["damage"] = damage, ["skilled"] = false, ["strike"] = false, ["cannonType"] = 0 }
                : new JsonObject { ["_"] = "AttackMissedCommand", ["attackType"] = new JsonObject { ["_"] = "AttackTypeModule", ["attackTypeValue"] = 1 }, ["targetUserId"] = target, ["skillColorId"] = 0 };
            foreach (var peer in recipients) { peer.Send(laser); peer.Send(impact); }
            if (attack.Damage.Killed)
            {
                foreach (var peer in recipients)
                {
                    peer.Send(new JsonObject { ["_"] = "ShipDestroyedCommand", ["destroyedUserId"] = target, ["explosionTypeId"] = 0 });
                    peer.Send(Remove(target));
                    if (peer.Selected == target) { peer.Selected = null; peer.Send(new JsonObject { ["_"] = "ShipDeselectionCommand" }); }
                    if (peer.Attacking == target) AbortLaser(peer);
                }
            }
        }
        finally { presence.Release(); }
        await AmmoStatus(connection);
        if (attack.Commit.Wallet is { } wallet)
        {
            int beforeLevel = pilot.Level;
            // Report actual committed totals/deltas, never projected wallet data.
            // Equipment/actor refresh has its own path. Copy only committed
            // wallet fields here so reward notification cannot restore an old
            // cloak, route, hull or stale opening projection.
            foreach (var (field, code, total) in new[] { ("credits", "CRE", wallet.Credits), ("uridium", "URI", wallet.Uridium), ("ep", "EP", wallet.Ep), ("honourPoints", "HON", wallet.Honour) })
            {
                decimal old = pilot.Profile[field]?.GetValue<decimal>() ?? 0; decimal delta = total - old;
                if (delta != 0) connection.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = FormattableString.Invariant($"0|LM|ST|{code}|{delta}|{total}") + (code == "EP" ? $"|{wallet.Level}" : "") });
            }
            if (wallet.Level > beforeLevel) connection.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = FormattableString.Invariant($"0|A|LUP|{wallet.Level}|{wallet.Ep}") });
            pilot.Profile["credits"] = wallet.Credits; pilot.Profile["uridium"] = wallet.Uridium;
            pilot.Profile["ep"] = wallet.Ep; pilot.Profile["honourPoints"] = wallet.Honour; pilot.Profile["level"] = wallet.Level;
        }
    }
}
