using System.Text.Json.Nodes;
using DarkOrbit.Server.Equipment;
using DarkOrbit.Server.Storage;
using Npgsql;

internal static class EquipmentHangarVerification
{
    internal static async Task<int> Run(NpgsqlDataSource source, string schema, long player, long ship)
    {
        int assertions = 0;
        void Check(bool ok, string message) { assertions++; if (!ok) throw new InvalidOperationException(message); }
        string q = '"' + schema + '"'; var repository = new EquipmentRepository(source, schema);
        async Task Execute(string sql) { await using var c = source.CreateCommand(sql); await c.ExecuteNonQueryAsync(); }
        async Task<T> Scalar<T>(string sql) { await using var c = source.CreateCommand(sql); return (T)(await c.ExecuteScalarAsync())!; }
        async Task Reject(Func<Task> action, string message) { bool failed = false; try { await action(); } catch (ArgumentException) { failed = true; } Check(failed, message); }
        await repository.Clear(player, ship, 1); await repository.Clear(player, ship, 2); await repository.Switch(player, ship, 1);
        await Execute($"INSERT INTO {q}.equipment_drones VALUES(900202,{player},jsonb_build_object('id',900202,'player_id',{player},'loot_id','drone_iris','level',5,'upgrade_level',0,'damage',0,'experience',0)); INSERT INTO {q}.equipment_pets VALUES({player},jsonb_build_object('player_id',{player},'level',8,'hp_upgrade_level',0,'hitpoints',50000,'shield',0,'fuel',1000)); INSERT INTO {q}.inventory_items(id,player_id,loot_id,amount,upgrade_level,pet_level) VALUES(9002030,{player},'equipment_petgear_g-kk1',1,0,3)");
        JsonObject Move(string from, string to, long[] ids, string slot, int config = 1, long? drone = null) => new()
        {
            ["hangarId"] = ship, ["from"] = new JsonObject { ["target"] = from, ["items"] = new JsonArray(ids.Select(i => (JsonNode)JsonValue.Create(i)!).ToArray()), ["configId"] = config, ["slotset"] = slot, ["droneId"] = drone },
            ["to"] = new JsonObject { ["target"] = to, ["configId"] = config, ["slotset"] = slot, ["droneId"] = drone }
        };
        await repository.Move(player, Move("inventory", "ship", [9002011,9002013], "lasers"));
        var plan = Move("inventory", "drone", [9002014], "default");
        plan["from"]!["droneItems"] = new JsonObject { ["900201"] = new JsonArray(9002014,9002015), ["900202"] = new JsonArray(9002016,9002017) };
        Check((await repository.EquipDrones(player, plan)).GetValue<bool>(), "Bulk native drone plan fills all specified drones");
        long mounts = await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}");
        var invalid = plan.DeepClone().AsObject(); invalid["from"]!["droneItems"] = new JsonObject { ["900201"] = new JsonArray(), ["999999"] = new JsonArray(9002020) };
        await Reject(async () => { await repository.EquipDrones(player, invalid); }, "Invalid final drone group rejects the complete plan");
        Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}") == mounts, "Rejected multi-drone plan leaves every mount intact");
        await repository.Move(player, Move("inventory", "pet", [9002030], "gears"));
        var context = await repository.Context(player, ship);
        Check(EquipmentStats.S(context["petEquipment"]![0]!["slot"]) == "gear" && EquipmentStats.N(EquipmentStats.Compute(context)["laserCount"]) == 6, "PET mount has its canonical slot and is excluded from the hero's damage");
        decimal oldCredits = await Scalar<decimal>($"SELECT credits FROM {q}.player_economy WHERE player_id={player}");
        await repository.Sell(player, new JsonObject { ["itemId"] = 9002030, ["quantity"] = 1 }, false);
        Check(await Scalar<decimal>($"SELECT credits FROM {q}.player_economy WHERE player_id={player}") == oldCredits + 125000, "Level-three PET gear sale uses original tier price");
        await repository.Move(player, Move("inventory", "pet", [9002011], "lasers", 2));
        long beforeSave = await Scalar<long>($"SELECT equipment_revision FROM {q}.players WHERE id={player}");
        await repository.SaveLayout(player, ship);
        Check(await Scalar<long>($"SELECT equipment_revision FROM {q}.players WHERE id={player}") == beforeSave, "Saving layout metadata cannot trigger a movement/stat refresh");
        mounts = await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}");
        await repository.Clear(player, ship, 1); await repository.Clear(player, ship, 2);
        Check((await repository.LoadLayout(player, ship)).GetValue<bool>() && await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}") == mounts, "Saved layouts restore ship, drones and PET across both configurations");
        Check(EquipmentStats.N((await repository.Context(player, ship, 2))["petEquipment"]![0]!["id"]) == 9002011, "One physical weapon can be used by the hero and PET in different configurations of the same hull");
        await repository.Sell(player, new JsonObject { ["itemId"] = 9002017, ["quantity"] = 1 }, false);
        Check(!(await repository.LoadLayout(player, ship)).GetValue<bool>() && await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE player_id={player}") == mounts - 1, "Loading a sold saved item reports an incomplete layout and retains all available equipment");
        await repository.Favourite(player, ship, true);
        Check(EquipmentStats.N((await repository.Context(player, ship))["ship"]!["favorite"]) == 1, "Favourite flag persists on the owned hull");
        foreach (var (id, hull) in new[] { (900202L,"ship_phoenix"), (900203L,"ship_defcom") })
            await Execute($"INSERT INTO {q}.owned_ships(id,player_id,loot_id,record) VALUES({id},{player},'{hull}',jsonb_build_object('id',{id},'player_id',{player},'loot_id','{hull}','active_config',1,'hitpoints',700,'shield',0,'nano_hull',0,'favorite',0))");
        await Reject(async () => { await repository.Import(player, ship, 900202); }, "Incompatible target hull rejects configuration import");
        Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE ship_id={ship}") == mounts - 1, "Rejected import cannot detach the origin's equipment");
        await repository.Import(player, ship, 900203); await repository.Activate(player, 900203);
        var pilot = (await new NativePlayerRepository(source, schema).Load(player))!;
        Check(EquipmentStats.N(pilot.Profile["shipId"]) == 900203 && EquipmentStats.S(pilot.Profile["typeId"]) == "ship_defcom" && EquipmentStats.N(pilot.Profile["hitPoints"]) == 700, "Hangar activation uses the canonical owned hull and never heals it");
        Check(await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE ship_id={ship}") == 0 && await Scalar<long>($"SELECT count(*) FROM {q}.equipment_mounts WHERE ship_id=900203") == mounts - 1, "Import moves both configurations including drones/PET without duplicating items");
        await Reject(async () => { await repository.ChangeDesign(player, 900203, "ship_goliath"); }, "Unowned or incompatible hull appearance cannot be equipped");
        await repository.ChangeDesign(player, 900203, "ship_defcom");
        Check((await repository.Context(player, 900203))["ship"]!["design_loot_id"] is null, "Selecting the base appearance removes the design");
        decimal beforeRace = await Scalar<decimal>($"SELECT credits FROM {q}.player_economy WHERE player_id={player}");
        async Task<bool> SellOnce() { try { await repository.Sell(player, new JsonObject { ["itemId"] = 9002016, ["quantity"] = 1 }, false); return true; } catch (ArgumentException) { return false; } }
        bool[] sales = await Task.WhenAll(SellOnce(), SellOnce());
        Check(sales.Count(ok => ok) == 1 && await Scalar<decimal>($"SELECT credits FROM {q}.player_economy WHERE player_id={player}") == beforeRace + (decimal)EquipmentStats.N(EquipmentContent.Default.Meta("equipment_weapon_laser_lf-4")["sellable"]!["credits"]), "Concurrent sales of the same physical item credit once under the PG player lock");
        return assertions;
    }
}
