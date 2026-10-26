using System.Security.Authentication;
using System.Text.Json.Nodes;
using DarkOrbit.Server.Equipment;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;

namespace DarkOrbit.Server.Transport;

public sealed partial class NativeGameHub
{
    // HTTP inventory mutations and native firing/configuration share this lock.
    // PostgreSQL also serializes the player's wallet/mounts across connections.
    public Task<JsonObject> Inventory(string token, long player, string action, JsonObject request) => Inventory(player, action, request, null, token);
    private async Task<JsonObject> Inventory(long player, string action, JsonObject request, NativeConnection? expected, string? token = null)
    {
        var gate = pilotLocks.GetOrAdd(player, _ => new SemaphoreSlim(1)); await gate.WaitAsync();
        try
        {
            foreach (string key in new[] { "params", "from", "to" }) if (request[key] is { } value && value is not JsonObject) throw new ArgumentException("Geçersiz istek.");
            if (token is not null && (await tickets.Read(token) is not { } ticket || ticket.PlayerId != player || ticket.ServerId != serverId)) throw new AuthenticationException("Expired inventory session");
            var connection = online.GetValueOrDefault(player);
            if (expected is not null && (expected != connection || expected.IsClosed)) throw new AuthenticationException("Stale native equipment request");
            if (connection is { IsClosed: false } && !await Authorized(connection)) throw new AuthenticationException("Expired game session");
            var p = request["params"] as JsonObject ?? request;
            if (action is "activateShip" or "changeShipModel" or "importConfig" && connection is not null) throw new ArgumentException("Bu işlem için önce oyundan çık.");
            long Ship() => EquipmentRepository.Id(p["hi"] ?? p["hangarId"] ?? request["hi"] ?? request["hangarId"]);
            var merged = request.DeepClone().AsObject(); foreach (var pair in p) merged[pair.Key] = pair.Value?.DeepClone();
            var equipment = players.Equipment;
            JsonNode result = action switch
            {
                "move" => await equipment.Move(player, request),
                "droneEquip" => await equipment.EquipDrones(player, request),
                "moveDroneDesign" => await MoveDesign(player, request),
                "clearConfig" => await equipment.Clear(player, Ship(), EquipmentRepository.Configuration(request["configID"] ?? p["configID"])),
                "sell" => await equipment.Sell(player, merged, false),
                "sellMultiple" => await equipment.Sell(player, merged, true),
                "setFavourite" => await equipment.Favourite(player, Ship(), p["activate"] is JsonValue flag && flag.TryGetValue<bool>(out var b) ? b : EquipmentStats.N(p["activate"]) == 1),
                "activateShip" => await equipment.Activate(player, Ship()),
                "changeShipModel" => await equipment.ChangeDesign(player, Ship(), EquipmentStats.S(request["lootId"] ?? p["lootId"])),
                "saveConfig" => await equipment.SaveLayout(player, Ship()),
                "loadConfig" => await equipment.LoadLayout(player, Ship()),
                "importConfig" => await equipment.Import(player, EquipmentRepository.Id(p["hangarId"]), EquipmentRepository.Id(p["importId"])),
                _ => throw new ArgumentException("Bu hangar işlemi henüz taşınmadı.")
            };
            if (connection is { IsClosed: false } && action is not ("saveConfig" or "setFavourite"))
            {
                try { await RefreshEquipment(connection, action is not ("sell" or "sellMultiple")); }
                catch { connection.Close(); throw; } // A committed mutation is never replayed after a refresh failure.
            }
            var pilot = await players.Load(player) ?? throw new InvalidDataException("Pilot is absent");
            if (connection is { IsClosed: false } && action is "sell" or "sellMultiple")
            {
                foreach (string field in new[] { "credits", "uridium", "ep", "honourPoints", "level" }) connection.Pilot!.Profile[field] = pilot.Profile[field]?.DeepClone();
                connection.Send(new JsonObject { ["_"] = "AttributeCreditsUpdateCommand", ["credits"] = pilot.Profile["credits"]!.DeepClone(), ["uridium"] = pilot.Profile["uridium"]!.DeepClone(), ["jackpot"] = pilot.Profile["jackpot"]?.DeepClone() ?? JsonValue.Create(0) });
                await AmmoStatus(connection);
            }
            var data = new JsonObject { ["ret"] = action is "sell" or "sellMultiple" ? JsonValue.Create(true) : result.DeepClone(),
                ["money"] = new JsonObject { ["credits"] = Math.Floor(pilot.Profile["credits"]!.GetValue<decimal>()).ToString(System.Globalization.CultureInfo.InvariantCulture), ["uridium"] = Math.Floor(pilot.Profile["uridium"]!.GetValue<decimal>()).ToString(System.Globalization.CultureInfo.InvariantCulture) } };
            if (action is "sell" or "sellMultiple") data["update"] = result.DeepClone();
            return new JsonObject { ["isError"] = 0, ["data"] = data };
        }
        finally { gate.Release(); }
    }
    private async Task<JsonNode> MoveDesign(long player, JsonObject request)
    {
        var side = EquipmentStats.S(request["from"]?["target"]) == "drone" ? request["from"] : request["to"];
        if (EquipmentStats.S(side?["slotset"]) is not ("design" or "visual")) throw new ArgumentException("Geçersiz diroit tasarım yuvası.");
        return new JsonObject { ["success"] = await players.Equipment.Move(player, request, false), ["newEffects"] = new JsonObject { ["1"] = new JsonObject(), ["2"] = new JsonObject() } };
    }
    // Called only while holding this pilot's lock; returns the refreshed pilot.
    private async Task RefreshEquipment(NativeConnection connection, bool force = false)
    {
        var old = connection.Pilot!;
        if (old.Profile["shipId"] is null) return; // Protocol-only synthetic verification fixtures.
        long revision = await players.EquipmentRevision(old.PlayerId);
        if (!force && revision == EquipmentStats.N(old.Profile["equipmentRevision"], -1) && DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() < EquipmentStats.N(old.Profile["equipmentExpiresAt"])) return;
        var fresh = await players.Load(old.PlayerId) ?? throw new InvalidDataException("Pilot is absent");
        bool sameHull = JsonNode.DeepEquals(old.Profile["shipId"], fresh.Profile["shipId"]);
        if (sameHull)
        {
            fresh.Profile["hitPoints"] = Math.Min(EquipmentStats.N(old.Profile["hitPoints"]), EquipmentStats.N(fresh.Profile["hitMax"]));
            fresh.Profile["nanoHull"] = Math.Min(EquipmentStats.N(old.Profile["nanoHull"]), EquipmentStats.N(fresh.Profile["maxNanoHull"]));
            if (JsonNode.DeepEquals(old.Profile["activeConfig"], fresh.Profile["activeConfig"])) fresh.Profile["shield"] = Math.Min(EquipmentStats.N(old.Profile["shield"]), EquipmentStats.N(fresh.Profile["shieldMax"]));
        }
        if (!await players.SaveVitals(fresh, connection.RedisLease!)) throw new AuthenticationException("Lost equipment vitals owner");
        var position = await directory.Reconfigure(connection.MapLease, fresh.Dead ? 0 : fresh.Speed) ?? throw new AuthenticationException("Lost map lease");
        fresh.Profile["cloaked"] = old.Cloaked; // Live cloak is owned by the session until its CPU ledger is ported.
        connection.Pilot = fresh with { MapId = connection.Map.MapId, X = position.X, Y = position.Y };
        await directory.Status(connection.MapLease, fresh.Faction, fresh.Dead, old.Cloaked, connection.Jumping);
        var stop = Movement(new MapMotion(old.PlayerId, position.X, position.Y, 0)); connection.Send(stop);
        foreach (var peer in Peers(connection.Map, connection)) peer.Send(stop);
        connection.Send(new JsonObject { ["_"] = "AttributeShipSpeedUpdateCommand", ["newSpeed"] = fresh.Speed, ["displaySpeed"] = fresh.Speed });
        connection.Send(new JsonObject { ["_"] = "AttributeShieldUpdateCommand", ["shieldNow"] = fresh.Profile["shield"]!.DeepClone(), ["shieldMax"] = fresh.Profile["shieldMax"]!.DeepClone() });
        connection.Send(EquipmentCommands.Hitpoints(fresh.Profile)); connection.Send(EquipmentCommands.Modules(fresh.Profile)); connection.Send(EquipmentCommands.AvailableFormations(fresh.Profile));
        connection.Send(new JsonObject { ["_"] = "UpdateCargoSpaceCommand", ["cargoSpaceMax"] = fresh.Profile["cargoSpaceMax"]!.DeepClone() });
        connection.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = $"0|S|CFG|{EquipmentStats.N(fresh.Profile["activeConfig"])}" });
        connection.Send(new JsonObject { ["_"] = "AttributeCreditsUpdateCommand", ["credits"] = fresh.Profile["credits"]!.DeepClone(), ["uridium"] = fresh.Profile["uridium"]!.DeepClone(), ["jackpot"] = fresh.Profile["jackpot"]?.DeepClone() ?? JsonValue.Create(0) });
        if (!JsonNode.DeepEquals(old.Profile["expansionStage"], fresh.Profile["expansionStage"]))
        {
            var expansion = new JsonObject { ["_"] = "ShipExtensionsCommand", ["userId"] = old.PlayerId, ["extensionStage"] = fresh.Profile["expansionStage"]!.DeepClone() };
            connection.Send(expansion); foreach (var peer in Peers(connection.Map, connection)) peer.Send(expansion);
        }
        foreach (var decoration in fresh.PublicDecorations()) { connection.Send(decoration); foreach (var peer in Peers(connection.Map, connection)) peer.Send(decoration); }
    }
    private async Task ChangeConfiguration(NativeConnection connection, int config)
    {
        var gate = pilotLocks[connection.Pilot!.PlayerId]; await gate.WaitAsync();
        try
        {
            if (online.GetValueOrDefault(connection.Pilot.PlayerId) != connection || connection.Jumping || connection.Pilot.Dead || config is not (1 or 2) || connection.Pilot.Profile["shipId"] is null) return;
            await players.Equipment.Switch(connection.Pilot.PlayerId, EquipmentRepository.Id(connection.Pilot.Profile["shipId"]), config);
            await RefreshEquipment(connection, true);
        }
        finally { gate.Release(); }
    }
    private async Task NativeMoveItems(NativeConnection connection, JsonObject command)
    {
        var request = new JsonObject { ["hangarId"] = command["hangarId"]!.DeepClone(),
            ["from"] = new JsonObject { ["target"] = command["source"]!.DeepClone(), ["items"] = command["items"]!.DeepClone(), ["configId"] = command["configId"]!.DeepClone(), ["slotset"] = command["slotSet"]!.DeepClone(), ["droneId"] = command["droneId"]?.DeepClone() },
            ["to"] = new JsonObject { ["target"] = command["destination"]!.DeepClone(), ["configId"] = command["configId"]!.DeepClone(), ["slotset"] = command["slotSet"]!.DeepClone(), ["droneId"] = command["droneId"]?.DeepClone() } };
        int result = 0; string? error = null;
        try { await Inventory(connection.Pilot!.PlayerId, "move", request, connection); result = 1; }
        catch (ArgumentException e) { error = e.Message; }
        connection.Send(new JsonObject { ["_"] = "HangarShipMoveItemsCommand", ["result"] = result, ["errorMessage"] = error });
    }
    private async Task NativeClearEquipment(NativeConnection connection, JsonObject command)
    {
        int result = 0; string? error = null;
        try { await Inventory(connection.Pilot!.PlayerId, "clearConfig", new JsonObject { ["hangarId"] = command["shipId"]!.DeepClone(), ["configID"] = command["configId"]!.DeepClone() }, connection); result = 1; }
        catch (ArgumentException e) { error = e.Message; }
        connection.Send(new JsonObject { ["_"] = "HangarShipClearConfigCommand", ["resultId"] = result, ["errorMessage"] = error });
    }
    private async Task NativeHangarOperation(NativeConnection connection, JsonObject command, string action, string response)
    {
        int result = 0; string? error = null;
        var request = new JsonObject { ["hangarId"] = (command["originShipId"] ?? command["shipId"])?.DeepClone(), ["importId"] = command["targetShipId"]?.DeepClone(), ["lootId"] = command["lootId"]?.DeepClone(), ["activate"] = DarkOrbit.Server.Equipment.EquipmentStats.N(command["favourite"]) == 1 };
        try
        {
            var reply = await Inventory(connection.Pilot!.PlayerId, action, request, connection);
            result = action == "loadConfig" && reply["data"]!["ret"]?.GetValue<bool>() == false ? 2 : 1;
        }
        catch (ArgumentException e) { error = e.Message; }
        var message = new JsonObject { ["_"] = response, ["resultId"] = result, ["errorMessage"] = error };
        if (action == "importConfig") message["shipId"] = command["targetShipId"]?.DeepClone();
        if (action == "loadConfig") { message["title"] = null; message["description"] = null; }
        connection.Send(message);
    }
    private async Task ChangeFormation(NativeConnection connection, string id)
    {
        var gate = pilotLocks[connection.Pilot!.PlayerId]; await gate.WaitAsync();
        try
        {
            if (online.GetValueOrDefault(connection.Pilot.PlayerId) != connection || connection.Jumping || connection.Pilot.Dead || connection.Pilot.Profile["shipId"] is null) return;
            try
            {
                await players.Equipment.Formation(connection.Pilot.PlayerId, EquipmentRepository.Id(connection.Pilot.Profile["shipId"]), id);
                await RefreshEquipment(connection, true);
            }
            catch (ArgumentException e) { connection.Send(new JsonObject { ["_"] = "LegacyModule", ["message"] = "0|A|STD|" + e.Message }); }
        }
        finally { gate.Release(); }
    }
}
