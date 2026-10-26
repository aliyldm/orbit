using System.Net;
using System.Text;
using System.Text.Json.Nodes;
using DarkOrbit.Host;
using DarkOrbit.Server.Equipment;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;
using DarkOrbit.Server.Transport;
using Npgsql;
using NpgsqlTypes;

internal static class EquipmentLiveVerification
{
    internal static async Task<int> Run(NpgsqlDataSource source, string schema, long player, long ship, JsonObject originalHero)
    {
        int assertions = 0;
        void Check(bool ok, string message) { assertions++; if (!ok) throw new InvalidOperationException(message); }
        string q = '"' + schema + '"';
        async Task Execute(string sql) { await using var c = source.CreateCommand(sql); await c.ExecuteNonQueryAsync(); }
        var equipment = new EquipmentRepository(source, schema); var players = new NativePlayerRepository(source, schema);
        // Deliberately stale opening values must never win over canonical rows.
        var hero = originalHero.DeepClone().AsObject(); hero["userId"] = player; hero["mapId"] = 1; hero["speed"] = 1; hero["hitMax"] = 1; hero["shieldMax"] = 999999;
        var commands = new JsonArray(hero, new JsonObject { ["_"] = "AttributeShipSpeedUpdateCommand", ["newSpeed"] = 1, ["displaySpeed"] = 1 },
            new JsonObject { ["_"] = "AttributeShieldUpdateCommand", ["shieldNow"] = 999999, ["shieldMax"] = 999999 },
            new JsonObject { ["_"] = "LegacyModule", ["message"] = "0|S|CFG|2" });
        await using (var update = source.CreateCommand($"UPDATE {q}.players SET initial_commands=$1 WHERE id=$2"))
        { update.Parameters.AddWithValue(NpgsqlDbType.Jsonb, commands.ToJsonString()); update.Parameters.AddWithValue(player); await update.ExecuteNonQueryAsync(); }
        await Execute($"INSERT INTO {q}.inventory_items(id,player_id,loot_id,amount,upgrade_level) VALUES(9002020,{player},'equipment_generator_speed_g3n-7900',1,0)");
        JsonObject Move(string from, string to, long id, int config, string slot) => new()
        {
            ["hangarId"] = ship, ["from"] = new JsonObject { ["target"] = from, ["items"] = new JsonArray(id), ["configId"] = config, ["slotset"] = slot },
            ["to"] = new JsonObject { ["target"] = to, ["configId"] = config, ["slotset"] = slot }
        };
        await equipment.Move(player, Move("inventory", "ship", 9002011, 1, "lasers"));
        await equipment.Move(player, Move("inventory", "ship", 9002020, 2, "generators")); await equipment.Switch(player, ship, 1);
        var unboosted = (await players.Load(player))!; double baseHitMax = EquipmentStats.N(unboosted.Profile["hitMax"]);
        var hpBooster = EquipmentContent.Default.Document["boosterTypes"]!.AsObject().First(p => p.Value!["boostList"]!.AsArray().Any(b => EquipmentStats.S(b!["type"]) == "HITPOINTS" && EquipmentStats.N(b["factor"]) > 0));
        await using (var add = source.CreateCommand($"INSERT INTO {q}.active_boosters VALUES($1,$2,$3)"))
        { add.Parameters.AddWithValue(player); add.Parameters.AddWithValue(hpBooster.Key); add.Parameters.AddWithValue(DateTimeOffset.UtcNow.AddSeconds(3).ToUnixTimeMilliseconds()); await add.ExecuteNonQueryAsync(); }
        await using (var hp = source.CreateCommand($"UPDATE {q}.owned_ships SET record=record||jsonb_build_object('hitpoints',$1::double precision) WHERE id=$2 AND player_id=$3"))
        { hp.Parameters.AddWithValue(baseHitMax + 1); hp.Parameters.AddWithValue(ship); hp.Parameters.AddWithValue(player); await hp.ExecuteNonQueryAsync(); }
        var expected1 = (await players.Load(player))!; var expected2 = EquipmentStats.Compute(await equipment.Context(player, ship, 2));
        Check(expected1.Speed != EquipmentStats.N(expected2["speed"]), "Two canonical configurations have different actual movement speeds");
        await using var runtime = await NativeDevelopmentRuntime.Create(Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES")!, Environment.GetEnvironmentVariable("DARKORBIT_REDIS")!, schema,
            new NativeGameOptions { Port = 0, HeartbeatInterval = TimeSpan.FromMilliseconds(250) });
        runtime.Game.Start(); await using var app = NativeApplication.Build(runtime, 0); await app.StartAsync();
        try
        {
            string token = await runtime.Tickets.Issue(new(player, player, 1));
            using var client = new HttpClient(new HttpClientHandler { UseCookies = true, CookieContainer = new CookieContainer() }) { BaseAddress = new Uri(app.Urls.Single()) };
            client.DefaultRequestHeaders.Add("Cookie", "dosid=" + token);
            var session = new JsonObject { ["userID"] = player, ["sessionID"] = token, ["instanceId"] = 1 };
            await using var probe = new NativeVerification.Probe(); await probe.Connect(runtime.Game.Port, session);
            var initial = await probe.Wait(c => c["_"]!.GetValue<string>() == "ShipInitializationCommand");
            Check(EquipmentStats.N(initial["speed"]) == expected1.Speed && EquipmentStats.N(initial["hitMax"]) == EquipmentStats.N(expected1.Profile["hitMax"]) && EquipmentStats.S(initial["typeId"]) == "ship_defcom", "Native hero uses live hull, speed and health instead of captured values");
            var speed = await probe.Wait(c => c["_"]!.GetValue<string>() == "AttributeShipSpeedUpdateCommand");
            Check(EquipmentStats.N(speed["newSpeed"]) == expected1.Speed, "Following speed update cannot restore a stale opening value");
            await probe.Wait(c => c["_"]!.GetValue<string>() == "DroneFormationChangeCommand");
            await probe.Wait(c => c["_"]!.GetValue<string>() == "HitpointInfoCommand" && EquipmentStats.N(c["hitpointsMax"]) == baseHitMax);
            Check(EquipmentStats.N((await players.Load(player))!.Profile["hitPoints"]) == baseHitMax && EquipmentStats.N((await equipment.Context(player, ship))["ship"]!["hitpoints"]) == baseHitMax, "Timed bonus expiry refreshes the actor and persists capped health without healing");
            int hangarMark = probe.Commands.Length;
            await probe.Send(new JsonObject { ["_"] = "HangarShipSaveConfigRequest", ["shipId"] = ship });
            await probe.Wait(c => c["_"]!.GetValue<string>() == "HangarShipSaveConfigCommand" && EquipmentStats.N(c["resultId"]) == 1, hangarMark);
            await probe.Send(new JsonObject { ["_"] = "HangarShipFavouriteRequest", ["shipId"] = ship, ["favourite"] = 1 });
            await probe.Wait(c => c["_"]!.GetValue<string>() == "HangarShipFavouriteCommand" && EquipmentStats.N(c["resultId"]) == 1, hangarMark);
            await probe.Send(new JsonObject { ["_"] = "HangarShipClearConfigRequest", ["shipId"] = ship, ["configId"] = 1 });
            await probe.Wait(c => c["_"]!.GetValue<string>() == "HangarShipClearConfigCommand" && EquipmentStats.N(c["resultId"]) == 1, hangarMark);
            await probe.Send(new JsonObject { ["_"] = "HangarShipLoadConfigRequest", ["shipId"] = ship });
            await probe.Wait(c => c["_"]!.GetValue<string>() == "HangarShipLoadConfigCommand" && EquipmentStats.N(c["resultId"]) == 1, hangarMark);
            Check(EquipmentStats.N((await players.Load(player))!.Profile["stats"]!["laserCount"]) == 1 && EquipmentStats.N((await equipment.Context(player, ship))["ship"]!["favorite"]) == 1, "Native save/clear/load/favourite requests operate on canonical equipment");
            int mark = probe.Commands.Length;
            await probe.Send(new JsonObject { ["_"] = "ConfigChangeRequest", ["presetId"] = 2 });
            await probe.Wait(c => c["_"]!.GetValue<string>() == "LegacyModule" && EquipmentStats.S(c["message"]) == "0|S|CFG|2", mark);
            var state2 = await players.Load(player); var actor2 = (await runtime.Hub.Snapshot(new MapKey(1, 1, Guid.Empty)))!.Pilots.Single(p => p.Lease.PlayerId == player);
            Check(EquipmentStats.N(state2!.Profile["activeConfig"]) == 2 && EquipmentStats.N(state2.Profile["stats"]!["laserCount"]) == 0 && actor2.Speed == state2.Speed && state2.Speed == EquipmentStats.N(expected2["speed"]), "Native configuration switch updates PG, stats and authoritative movement together");
            mark = probe.Commands.Length; await probe.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = "S|CFG|1" });
            await probe.Wait(c => c["_"]!.GetValue<string>() == "LegacyModule" && EquipmentStats.S(c["message"]) == "0|S|CFG|1", mark);
            Check(EquipmentStats.N((await players.Load(player))!.Profile["stats"]!["laserCount"]) == 1, "C-key legacy protocol uses the same configuration repository");
            async Task<JsonObject> Api(string action, JsonObject request)
            {
                var response = await client.PostAsync("/flashAPI/inventory.php", new FormUrlEncodedContent(new Dictionary<string, string> { ["action"] = action, ["params"] = Convert.ToBase64String(Encoding.UTF8.GetBytes(request.ToJsonString())) }));
                response.EnsureSuccessStatusCode(); return JsonNode.Parse(Convert.FromBase64String(await response.Content.ReadAsStringAsync()))!.AsObject();
            }
            var onlineHullChange = await Api("activateShip", new JsonObject { ["hangarId"] = ship });
            Check(EquipmentStats.N(onlineHullChange["isError"]) == 1, "Original offline hangar activation policy is enforced while the game is connected");
            await probe.Send(new JsonObject { ["_"] = "MoveRequest", ["positionX"] = 99999, ["positionY"] = 99999, ["targetX"] = 10000, ["targetY"] = 10000 });
            await probe.Send(new JsonObject { ["_"] = "VersionRequest", ["version"] = "route-started" }); await probe.Wait(c => c["_"]!.GetValue<string>() == "VersionCommand" && EquipmentStats.S(c["version"]) == "route-started");
            var moved = await Api("move", Move("ship", "inventory", 9002011, 1, "lasers"));
            var snapshot = (await runtime.Hub.Snapshot(new MapKey(1, 1, Guid.Empty)))!;
            Check(EquipmentStats.N(moved["isError"]) == 0 && moved["data"]?["ret"]?.GetValue<bool>() == true && EquipmentStats.N((await players.Load(player))!.Profile["stats"]!["laserCount"]) == 0, "Authenticated original Flash envelope removes equipment and recomputes live stats");
            Check(!snapshot.Motions.Any(m => m.PlayerId == player) && snapshot.Pilots.Single(p => p.Lease.PlayerId == player).X < 10000, "Live inventory refresh retires the route at its authoritative position");
            decimal creditsBefore = (await players.Load(player))!.Profile["credits"]!.GetValue<decimal>();
            var bad = await Api("sellMultiple", new JsonObject { ["items"] = new JsonArray(9002012, 1) });
            Check(EquipmentStats.N(bad["isError"]) == 1 && (await players.Load(player))!.Profile["credits"]!.GetValue<decimal>() == creditsBefore, "Invalid bulk sale returns native error without prefix debit or credit");
            var sold = await Api("sell", new JsonObject { ["itemId"] = 9002012, ["quantity"] = 1 });
            Check(EquipmentStats.N(sold["isError"]) == 0 && sold["data"]?["update"]?["deleted"]?.AsArray().Count == 1 && sold["data"]?["money"]?["credits"]?.GetValue<string>() == ((await players.Load(player))!.Profile["credits"]!.GetValue<decimal>()).ToString(System.Globalization.CultureInfo.InvariantCulture), "Sale response contains committed wallet and per-item update");
            using var stranger = new HttpClient { BaseAddress = client.BaseAddress };
            Check((await stranger.PostAsync("/flashAPI/inventory.php", new FormUrlEncodedContent(new Dictionary<string, string> { ["action"] = "sell", ["params"] = "e30=" }))).StatusCode == HttpStatusCode.Unauthorized, "Inventory mutations require a valid account ticket");
            Check((await client.GetAsync("/ready")).StatusCode == HttpStatusCode.ServiceUnavailable, "Partial migration remains unavailable for production cutover");
            await using var replacement = new NativeVerification.Probe(); await replacement.Connect(runtime.Game.Port, session);
            await probe.Closed.WaitAsync(TimeSpan.FromSeconds(5));
            var relogged = await replacement.Wait(c => c["_"]!.GetValue<string>() == "ShipInitializationCommand");
            Check(EquipmentStats.N(relogged["speed"]) == expected1.Speed && EquipmentStats.N((await players.Load(player))!.Profile["stats"]!["laserCount"]) == 0, "Reconnect retains canonical configuration and sold/unequipped state");
            Check(!await players.SaveVitals((await players.Load(player))!, new("retired-owner", 1)), "A retired connection cannot overwrite the new owner's canonical vitals");
        }
        finally { await app.StopAsync(); }
        return assertions;
    }
}
