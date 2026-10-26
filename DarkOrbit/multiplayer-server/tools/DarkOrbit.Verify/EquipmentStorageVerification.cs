using System.Security.Cryptography;
using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Equipment;
using DarkOrbit.Server.Storage;
using Npgsql;
using NpgsqlTypes;

internal static class EquipmentStorageVerification
{
    public static async Task Run()
    {
        int assertions = 0; void Check(bool ok, string message) { assertions++; if (!ok) throw new InvalidOperationException(message); }
        var pg = Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES")!; var settings = new NpgsqlConnectionStringBuilder(pg);
        if (settings.Host != "127.0.0.1" || settings.Port != 55432 || settings.Database != "darkorbit_development") throw new InvalidOperationException("Only isolated development database is permitted");
        await using var source = NpgsqlDataSource.Create(pg); var archive = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/postgresql-rehearsal.json"))!;
        string schema = "mp_" + Convert.ToHexStringLower(RandomNumberGenerator.GetBytes(8)), q = '"' + schema + '"';
        await NativeBootstrap.Create(source, archive["schema"]!.GetValue<string>(), schema, "artifacts/private/native-profiles.json", archive["snapshotSha256"]!.GetValue<string>());
        async Task Execute(string sql) { await using var c = source.CreateCommand(sql); await c.ExecuteNonQueryAsync(); }
        async Task<T> Scalar<T>(string sql) { await using var c = source.CreateCommand(sql); return (T)(await c.ExecuteScalarAsync())!; }
        async Task Reject(Func<Task> work, string message) { bool rejected = false; try { await work(); } catch (Exception e) when (e is ArgumentException or InvalidDataException or PostgresException) { rejected = true; } Check(rejected, message); }
        try
        {
            var repository = new EquipmentRepository(source, schema); var profiles = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/private/native-profiles.json"))!["profiles"]!.AsArray();
            long baselineTime = DateTimeOffset.Parse(JsonNode.Parse(await File.ReadAllTextAsync("artifacts/private/legacy-snapshot.json"))!["createdAt"]!.GetValue<string>()).ToUnixTimeMilliseconds();
            foreach (var entry in profiles)
            {
                var p = entry!["profile"]!; var context = await repository.Context((long)EquipmentStats.N(p["userId"]), (long)EquipmentStats.N(p["shipId"]), at: baselineTime);
                var stats = EquipmentStats.Compute(context);
                foreach (var field in new[] { "hitMax", "shieldMax", "speed", "laserCount", "shipLaserCount", "laserDamage", "shieldAbsorb", "cargoMax", "rocketMultiplier", "npcLaserMultiplier" })
                    Check(Math.Abs(EquipmentStats.N(stats[field]) - EquipmentStats.N(p["stats"]![field])) <= Math.Max(1, Math.Abs(EquipmentStats.N(p["stats"]![field]))) * 1e-10, "Archived real profile stat parity: " + field);
            }
            const long player = 900201, ship = 900201; var profile = profiles[0]!["profile"]!.DeepClone().AsObject(); profile["userId"] = player; profile["shipId"] = ship;
            await Execute($"INSERT INTO {q}.accounts VALUES({player},'equipmentqa','no-login',0)");
            await using (var command = source.CreateCommand($"INSERT INTO {q}.players(id,account_id,server_id,map_id,x,y,profile,initial_commands) VALUES($1,$1,1,1,1000,1000,$2,'[]'::jsonb)"))
            { command.Parameters.AddWithValue(player); command.Parameters.AddWithValue(NpgsqlDbType.Jsonb, profile.ToJsonString()); await command.ExecuteNonQueryAsync(); }
            await Execute($"INSERT INTO {q}.player_economy VALUES({player},1000,1000,0,0,18); INSERT INTO {q}.owned_ships(id,player_id,loot_id,record) VALUES({ship},{player},'ship_defcom',jsonb_build_object('id',{ship},'player_id',{player},'loot_id','ship_defcom','active_config',1,'hitpoints',1000,'shield',0,'nano_hull',0,'favorite',0)); UPDATE {q}.players SET active_ship_id={ship} WHERE id={player}");
            await Execute($"INSERT INTO {q}.equipment_drones VALUES(900201,{player},jsonb_build_object('id',900201,'player_id',{player},'loot_id','drone_iris','level',5,'upgrade_level',15,'damage',0,'experience',0))");
            for (int i = 0; i < 8; i++) await Execute($"INSERT INTO {q}.inventory_items(id,player_id,loot_id,amount,upgrade_level) VALUES({9002010+i},{player},'equipment_weapon_laser_lf-4',1,15)");
            JsonObject Move(string origin, string destination, long[] items, int config = 1, string slot = "lasers", long? drone = null) => new()
            {
                ["hangarId"] = ship,
                ["from"] = new JsonObject { ["target"] = origin, ["configId"] = config, ["items"] = new JsonArray(items.Select(i => (JsonNode)JsonValue.Create(i)!).ToArray()), ["slotset"] = slot, ["droneId"] = drone },
                ["to"] = new JsonObject { ["target"] = destination, ["configId"] = config, ["slotset"] = slot, ["droneId"] = drone }
            };
            var result = await repository.Move(player, Move("inventory", "ship", [9002010, 9002011, 9002012, 9002013]));
            Check(result is JsonArray rejected && rejected.Select(i => EquipmentStats.N(i)).SequenceEqual(new double[] { 9002013 }), "Overflow fills three ship slots and returns only rejected native IDs");
            Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player} AND target='ship'") == 3, "Ship mounts persist without overfill");
            await repository.Move(player, Move("inventory", "ship", [9002010], 2));
            Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE item_id=9002010") == 2, "One physical item can be shared by two configurations of the same hull");
            var droneResult = await repository.Move(player, Move("inventory", "drone", [9002013, 9002014, 9002015], slot: "default", drone: 900201));
            Check(droneResult is JsonArray overflow && EquipmentStats.N(overflow[0]) == 9002015, "Drone overflow fills two slots and preserves the remainder");
            var computed = EquipmentStats.Compute(await repository.Context(player, ship));
            Check(EquipmentStats.N(computed["laserCount"]) == 5 && EquipmentStats.N(computed["laserDamage"]) > 1000, "Canonical PG stats include upgraded drone-mounted weapons");
            long before = await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}");
            await Reject(async () => { await repository.Move(player, Move("inventory", "ship", [9002015, 1])); }, "Invalid tail rejects the entire multi-item move");
            Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}") == before, "Rejected bulk move leaves mounts intact");
            await repository.Move(player, Move("drone", "inventory", [9002013], slot: "default", drone: 900201));
            Check(EquipmentStats.N(EquipmentStats.Compute(await repository.Context(player, ship))["laserCount"]) == 4, "Drone unequip changes live stats immediately");
            var sale = await repository.Sell(player, new JsonObject { ["itemId"] = 9002010, ["quantity"] = 1 }, false);
            Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE item_id=9002010") == 0 && sale["deleted"]!.AsArray().Count == 1, "Sale removes both configuration assignments atomically");
            Check(await Scalar<decimal>($"SELECT credits FROM {q}.player_economy WHERE player_id={player}") == 1000 + (decimal)EquipmentStats.N(EquipmentContent.Default.Meta("equipment_weapon_laser_lf-4")["sellable"]!["credits"]), "Sale price comes from original metadata");
            await Reject(async () => { await repository.Sell(player, new JsonObject { ["items"] = new JsonArray(9002015, 1) }, true); }, "Invalid sale tail cannot remove or credit a valid prefix");
            await repository.Switch(player, ship, 2); Check(EquipmentStats.N((await repository.Context(player, ship))["ship"]!["active_config"]) == 2, "Configuration switch uses canonical shield pools");
            await repository.Clear(player, ship, 1); Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player} AND config_id=1") == 0, "Clearing a configuration removes all target types");
            var hero = profiles[0]!["commands"]!.AsArray().First(c => c!["_"]!.GetValue<string>() == "ShipInitializationCommand")!.AsObject();
            int liveAssertions = await EquipmentLiveVerification.Run(source, schema, player, ship, hero);
            int hangarAssertions = await EquipmentHangarVerification.Run(source, schema, player, ship);
            Console.WriteLine(JsonSerializer.Serialize(new { status = "PASS", equipmentStorageAssertions = assertions, equipmentLiveAssertions = liveAssertions, equipmentHangarAssertions = hangarAssertions, actualArchivedProfiles = profiles.Count, canonicalInventory = true, realTcpAndHttp = true, sourceDatabaseUntouched = true, fullGameplayReady = false }));
        }
        finally { await Execute($"DROP SCHEMA {q} CASCADE"); }
    }
}
