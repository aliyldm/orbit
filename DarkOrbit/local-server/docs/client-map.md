# DarkOrbit Flash istemcisi — işlev haritası

Kaynak: `decompiled/main/scripts` (main.swf, JPEXS) ve bu iş için decompile edilen diğer SWF'ler.
Amaç: sunucu tarafını yazarken her özellik için **istemcinin ne gönderdiği → hangi cevabı beklediği → cevabı hangi sınıfın işleyip neyi güncellediği** zincirini tek yerde görmek.

Dosyalar:

| Dosya | İçerik |
|---|---|
| `docs/client-map.md` | bu belge: öncelikli özellik zincirleri, eski metin protokolü, sabitler; Ek A/B otomatik tablolar |
| `docs/client-map.json` | makine-okur harita: `s2c` (komut → handler, bildirimler, proxy'ler, pencereler), `c2s` (istek → gönderen sınıf/fonksiyon, tetikleyen bildirim zinciri, enum sabitleri), `legacy` (metin protokolü sabitleri + alan okuma satırları), `notifications` (PureMVC kayıtları), `constants` (pencere id'leri, enum'lar, GG sabitleri, 249 harita) |
| `docs/client-map.items.json` | istemciye gömülü eşya kataloğu (3041 lootId: gemi istatistikleri ve slotları, fiyatlar, cephane, ekipman, drone, booster…) |

Satır/dosya bağlantıları `decompiled/main/scripts/net/bigpoint/darkorbit/` altına göredir; aşağıda kısaca `…/` diye yazıldı.

---

## 1. Decompile envanteri

`client/spacemap` altında 193 SWF var. Her birinin tag listesi okundu (DoABC tag 72 / DoABC2 tag 82); 193'ünün hepsinde ABC bloğu var, fark boyutta:

* **DoABC ≥ 1000 bayt olan 43 SWF** (main.swf hariç) decompile edildi → `decompiled/<swf-yolu-uzantısız>/scripts` (+ `.export.log`). main.swf zaten `decompiled/main` altında, tekrar yapılmadı.
* **DoABC < 1000 bayt olan 149 SWF** (lazer/roket/motor/duman/maske/efekt SWF'leri) yalnızca tek bir `MovieClip` sembol sınıfı stub'ı içeriyor (173–278 bayt ABC); mantık yok, atlandı.

Decompile edilenlerde gerçekten **mantık içerenler**:

| SWF | Ne var |
|---|---|
| `preloader.swf` (83 script) | `DarkOrbitPreloader`, `GameclientLoader`: flashvars okur, `loadingscreen.swf?__cv=` ve `main.swf` yükler, `/crossdomain.xml`, `/_assets/assets.swf`; hata → `BpEventStream`. Sunucuya soket açmaz. |
| `loadingscreen.swf` (211+25 script) | PureMVC mini uygulama: yükleme çubuğu, reklam, **bonus takvimi** (`flashAPI/dailyLogin.php`, kitap alma `flashAPI/dailyLogin.php?doBook=1`), `flashAPI/loadingScreen.php`, `xml/assets_loadingScreen.xml`, `resource_loadingScreen.xml`, `resource_items.xml`, çeviri. Oyun soketi yok. |
| `graphics/ui/ui.swf`, `graphics/ui/windows/galaxygatebuilder/common.swf`, `…/settings/settingsWindowFUI.swf` | `fl.controls.*` bileşen kütüphanesi (Button, ScrollBar, FocusManager…) + sembol sınıfları; GG builder'daki `CustomCrollBar`. Ağ kodu yok. |
| `graphics/assets/replacementShips.swf` (1115), `graphics/ui/icons.swf` (446) | gemi/ikon sembol sınıfları. |
| Diğer `graphics/ui/**`, `audio/sounds/**` | sembol sınıfları (her biri ~15 satır `extends MovieClip/Sound`). |

**Sonuç:** Oyunun bütün ağ/oyun/UI mantığı main.swf'de. Pencere SWF'leri yalnızca görsel varlık. Aşağıdaki her şey main.swf'den.

---

## 2. İstemci ağ mimarisi (bilinmesi gerekenler)

| Konu | Yer | Davranış |
|---|---|---|
| S→C dağıtım | `…/net/netty/HandlerLookup.as` `init()` + `execute()` | `handlerLookup[ModülID] = HandlerSınıfı` sözlüğü (480 atama, 477 farklı komut; 3 komut iki kez atanmış — son atama geçerli). Handler'da statik `run(cmd)` varsa çağrılır, yoksa PureMVC `ICommand` yaratılıp `execute(ServerCommandNotification(cmd))`. Sözlükte olmayan modül **sessizce yok sayılır**. |
| C→S gönderim | `…/net/ConnectionManager.as:377` `sendRequest()` | Tek çıkış noktası. Netty istekleri ya doğrudan `connectionManager.sendRequest(x)` ile ya da `sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST, x)` → `SendNettyRequest` komutu ile gelir. |
| **Login kuyruğu** | `ConnectionManager.filterAndSendLoginRequests` (`:365`) | `loginMode` açıkken yalnızca `VersionRequest, LoginRequest, KillScreenRepairRequest, ChannelCloseRequest` gider; diğer her istek kuyruğa alınır. `loginMode` sadece **`LoginResponse{status:0}`** gelince kapanır (`…/net/netty/handlers/login/LoginResponseHandler.as`) ve kuyruk boşaltılır. → Sunucu LoginResponse(0) göndermezse istemci `ReadyRequest`, `MoveRequest` vb. hiçbir şey yollamaz. |
| **Ölüyken filtre** | `ConnectionManager.isCommandDeathRelated` (`:393`) | `Hero.isKilled` iken yalnızca `KillScreenRepairRequest, KeepAlive, ChannelCloseRequest` gider. `Hero.isKilled=false` sadece `ShipInitializationCommand` işlenince olur (`…/net/ShipAssembly.as:254`). |
| Eski metin protokolü | S→C: `LegacyModule{message}` → `LegacyModuleHandler.run` → `ConnectionManager.onData(message)`; C→S: `ConnectionManager.sendCommand(cmd, args)` → `LegacyModule{message: cmd|a|b…}` | Ayrıntı §4. |
| Keep-alive | `ConnectionManager.handlePingTick` | `KeepAlive{MouseClick}` periyodik; sunucu `StayinAlive` gönderebilir (handler boş). |
| Sunucu adresi | `ConnectionManager.connectToMap(mapId)` | `Settings.defaultGameServer` (flashvar `localGS`/`localGs`; `"1"` → `localhost`) varsa her zaman o; yoksa `maps.php` XML'inde `<map id=…><gameserverIP>`. Port varsayılanı `5001`, `ip:port` biçimi destekli. |

### 2.1 Giriş / harita yükleme zinciri

| # | İstemci gönderir | Sunucudan bekler | İşleyen |
|---|---|---|---|
| 1 | soket bağlanınca `VersionRequest{version: VersionHash}` | `VersionCommand{version, equal:true}` | `VersionHandler` → `ConnectionManager.handleVersionResponse` (equal=false → bağlantı hatası) |
| 2 | `LoginRequest{userID, factionID, sessionID, version:"do-lz4-block-v3", instanceId, isMiniClient}` | `LoginResponse{status:0}` (diğer kodlar: 1 Error, 2 ShuttingDown, 3 InvalidData, 4 WrongInstanceId, 5 WrongServer, 6 InvalidSessionId, 7 ShipIsDestroyed, 8 PlayerIsLoggedOut, 9 IPRestricted → log mesajı) | `LoginResponseHandler`: `loginMode=false`, kuyruk gönderilir, `CONNECTION_SUCCESS` |
| 3 | — | `ShipInitializationCommand` (kendi gemi, HP/kalkan/kargo/kredi/uri/EP/level/…), `UserSettingsCommand`, `UILayoutCommand` (özellik menüsü), `MenuInitializationCommand` (cephane/slot bar), `LegacyModule` açılış satırları, harita varlıkları (`ShipCreateCommand`, `JumpgateCreateCommand`, `AddBoxCommand`…) | `ShipInitializationHandler` → `ShipAssembly.assembleHeroInit` (Hero.* alanları, `isKilled=false`), `ParseFeaturesMenuData`, `ParseItemsControlMenuDataCommand` |
| 4 | Hero + harita yüklenince `ReadyRequest{MAP_LOADED_2D/3D}`, `ReadyRequest{UI_READY}`, legacy `"LF|w"` | — | `ConnectionManager.dispatchSpacemapLoaded` |

---

## 3. Öncelikli özellikler — istek → beklenen cevap → işleyen sınıf

### 3.1 Özellik menüsü ve `UIButtonTriggerRequest` itemId'leri

Menü tamamen sunucu güdümlü: `UILayoutCommand{featureBars}` → `ParseFeaturesMenuData` → `FeaturesMenuProxy` (hangi buton hangi barda). Butona tıklama: `FeaturesMenuMediator` → `FeaturesMenuNotifications.ACTION_TRIGERRED` → **`…/mvc/gui/featuresMenu/controller/logic/FeatureMenuActionCommand.as`**.

Bar tipine göre davranış:

| Bar (`FeatureItemVO.barId`) | İstemci ne yapar | Sunucuya |
|---|---|---|
| `gameFeaturesBar` | pencereyi **yerelde** oluşturur/açar-kapatır (`GuiNotifications.TOGGLE_WINDOW_BY_ID`), sonra | `UIButtonTriggerRequest{itemId}` — sunucunun o pencereyi dolduracak komutu göndermesi beklenir |
| `genericFeaturesBar` | `logout` (sayaç; zaten açıksa iptal), `fullscreen` (yerel), `shop` (§3.4), diğerleri pencere toggle | `logout` ve `shop` için `UIButtonTriggerRequest` |
| `gameNewFeaturesBar` | **her zaman önce** `UIButtonTriggerRequest{itemId}`, sonra aşağıdaki tablo | ✓ |

`gameNewFeaturesBar` itemId → istemci eylemi (`runGenericActionNewGame`):

| itemId | İstemci eylemi | Not |
|---|---|---|
| `hangar` | `JavascriptProxy.referToURL("internalDock")` | **Web sayfası** (oyun içi pencere değil) |
| `pilotSheet` | `referToURL("internalPilotSheet")` | web |
| `clan` | `referToURL(Hero.isInClan ? "internalClan" : "internalNewClan")` | web |
| `skylab` / `auction` / `nova` / `vouchers` / `message` / `logbook` | `internalSkylab` / `internalAuction` / `internalCaptain` / `internalEvoucher` / `internalMessaging` / `internalHistory` | web |
| `new_shop` | `CommandCenterNotifications.TRIGGER_SHOP_ACTION` | §3.4 |
| diğer (`stellar_pathfinder`…) | pencere toggle | |

`referToURL` = `ExternalInterface.call("InternalMapRevolution.referToURL", action, textKey, template, focus, category, lootID, openPage)` (`…/net/JavascriptProxy.as:120`). **Local web sayfasında `InternalMapRevolution` tanımlı değil** (web/ altında aranıp bulunamadı) → bu butonlar şu an hiçbir şey açmaz. Sunucu tarafı için seçenek: oyun sayfasına bu JS fonksiyonunu ekleyip ilgili web sayfasını açtırmak.

Pencere açılınca ek istek gönderen `itemId`'ler (`FeatureMenuActionCommand.actionRequest`):

| itemId (GuiConstants) | Ek istek | Beklenen cevap → handler |
|---|---|---|
| `hangarCannons` (WARP_CONTROLS) | `HangarListRequest{}` | `HangarShipsCommand` → `WarpControlsShipsCommandHandler` (§3.2) |
| `birthday_2025` | `Birthday2025PointRewardRequest{}` | `Birthday2025PointRewardCommand` → `Birthday2025PointRewardCommandHandler`; kapı penceresi `Birthday2025GateWindowCommand` → `DifficultySelectionInfoHandler` |
| `synthesis` | `SynthesisInventoryRequest` | `SynthesisInventoryCommand` → `CannonSynthesisInventoryCommandHandler` |
| `expedition` | `ExpeditionInfoRequest` | `ExpeditionInfoCommand` → `ExpeditionInfoCommandHandler` |
| `trinityTrials` | `TrinityTrialsUIRequest{INIT}` | `TrinityTrialsGateWindowCommand` → `TrinityTrialsGateWindowCommandHandler` |
| `voyagers` | `VoyagersUIRequest{}` | `VoyagersPassCommand` → `SingularityDrivePassCommandHandler`, `VoyagersGateWindowCommand` → `SingularityDriveGateWindowCommandHandler` |

Diğer pencereler `UIButtonTriggerRequest{itemId}` geldiğinde sunucudan kendi veri komutunu bekler; örn. `ship_warp` → `ShipWarpWindowCommand` (§3.2), `ggBuilder` → pencere kendi `GalaxyGateBuilderInfoRequest`'ini yollar (§3.5). Hangi handler'ın hangi pencere id'sine yazdığı `client-map.json` → `s2c.*.windows` alanında; tüm pencere id'leri `constants.guiWindowIds`.

Pencere konum/boyut değişince: `GuiManager` → `SEND_WINDOW_UPDATE_REQUEST` → `UIWindowUpdateRequest{itemId,posX,posY,width,height,maximized}` (cevap beklenmez). Sunucu pencereyi zorla açmak/konumlamak için `WindowItemCommand` → `UpdateWindowItemCommand`; legacy `0|UI|W|MAW|id…` (§4).

### 3.2 Hangar / gemi değiştirme

Flash istemcide üç ayrı hangar parçası var:

**a) Tam hangar (gemi, lazer, jeneratör, drone donanımı) = web sayfası** (`hangar` butonu → `internalDock`). Netty'deki `porting/hangar` isteklerinin çoğu (`HangarShipDetailRequest`, `HangarShipActivateShipRequest`, `HangarShipSaveConfigRequest`, `HangarShipSellItemRequest`, `HangarShipChangeShipModelRequest`, `HangarShipClearConfigRequest`, `HangarShipLoadConfigRequest`, `HangarShipImportConfigRequest`, `HangarShipRepairDroneRequest`, `HangarShipRepairModuleRequest`, `HangarShipSellDroneRequest`, `HangarShipUnlockSlotRequest`, `HangarShipFavouriteRequest`, `HangarShipAutoBuyCpuAmmoRequest`, `HangarShipRenamePetRequest`) ve karşılık komutları **main.swf'de hiç gönderilmiyor/işlenmiyor** (Unity/HTML5 port kalıntısı). Flash için yazmaya gerek yok.

**b) Oyun içi "hangarCannons" penceresi (WarpControls)** — yalnızca top (cannon), top kalkanı, QuantumFluidCore, lens, drive eşyaları (`WarpControlsProxy.isShowByLootType`).

| # | Tetik | İstemci gönderir | Beklenen cevap | İşleyen → güncellediği |
|---|---|---|---|---|
| 1 | özellik butonu `hangarCannons` | `UIButtonTriggerRequest{"hangarCannons"}` + `HangarListRequest{}` (`…/mvc/gui/windows/warpControls/mode/WarpControlsProxy.as:56`) | `HangarShipsCommand{ships[HangarShipBriefCommand], items[InventoryItemPack], allDesignPack, petView, drones}` | `WarpControlsShipsCommandHandler` → `WarpControlsProxy.rcvAllData`: `isActive` gemiyi `_currentShip` yapar, envanteri filtreler, **otomatik** 2. adımı gönderir |
| 2 | (otomatik) | `HangarShipEquipmentRequest{shipId}` | `HangarShipEquipmentCommand{hangarId, shipId, lootId, currentConfigId, shipConfigs, droneConfigs, petConfigs, extrasSlotsSize1/2}` | `HangarShipEquipmentCommandHandler` → `rcvHangarShipEquipmentCommand` → `GuiNotifications.WARP_CONTROLS_INIT` → `WarpControlsUIMediator` pencereyi çizer |
| 3 | sürükle-bırak (`WarpControlsUIMediator:252`) | `HangarShipMoveItemsRequest{hangarId, items[itemId], source:"inventory"/"ship", destination, index, configId, slotSet, droneId}` (slotSet: `cannons`, `cannon_shields`, `QuantumFluidCore`, `drives`, `lenses`) | `HangarShipMoveItemsCommand{result, errorMessage}` | `WarpControlsShipMoveItemsHandler`: `result==1` → **1. adımı yeniden** yollar (tam yenileme); aksi halde `errorMessage` log'a |

`ShipInitializationCommand` işlenince `GuiNotifications.WARP_CONTROLS_UPDATE` de atılır (pencere açıksa yenilenir).

**c) Gemi değiştirme penceresi `ship_warp`**

| # | Tetik | İstemci gönderir | Beklenen cevap | İşleyen |
|---|---|---|---|---|
| 1 | özellik butonu `ship_warp` | `UIButtonTriggerRequest{"ship_warp"}` | `ShipWarpWindowCommand{jumpVoucherCount, uridium, isNearSpacestation, ships[ShipWarpModule{shipId,typeId,shipDesignName,uridiumPrice,voucherPrice,hangarId,hangarName,mapId}]}` | `ShipWarpWindowHandler` → `WarpWindowProxy` (id `ship_warp`) verisi |
| 2 | gemi seçip onay (`WarpWindowMediator.handleConfirmButtonClicked`) | `ShipWarpRequest{shipId}` | başarı: `ShipWarpCompletedCommand{currentShipLootId}` (handler no-op) + yeni gemi için `ShipInitializationCommand`/harita yenilemesi; ret: `ShipWarpNotAllowedCommand` (`ShipWarpNotAllowedHandler`), iptal: `ShipWarpCanceledCommand` (no-op); pencereyi kapat: `ShipWarpWindowCloseCommand` (`ShipWarpWindowCloseHandler` → menü buton seçimi güncellenir) | |

### 3.3 Ekipman (konfigürasyon, drone formasyonu, ekipman hazır)

| İşlev | İstemci gönderir | Beklenen cevap | İşleyen |
|---|---|---|---|
| Konfig 1↔2 değiştir (C tuşu `ChangeConfingCommand`, gemi penceresindeki `InfoField:212`) | **legacy** `S|CFG|<yeniKonfig>|<userID>|<sessionID>` | legacy `0|S|CFG|<konfig>` | `ConnectionManager.onData` → `Settings.selectedConfiguration`, gemi penceresi `TYPE_CONFIGURATION` alanı |
| Konfig sayısı | — | legacy `0|A|CC|<n>` | `SetAttributeAssembly.assembleConfigurationCountUpdate` |
| Drone formasyonu seç | `MenuActionRequest{menuItemId:<formasyon lootId>, ACTIVATE}` (§3.9) | `DroneFormationChangeCommand{uid, selectedFormationId}` (+ ilgili `MenuItemStatusCommand`) | `DroneFormationChangeHandler` → gemi drone traiti |
| Kullanılabilir formasyonlar | — | `DroneFormationAvailableFormationsCommand{availableFormations}` | `DroneFormationAvailableFormationsHandler` |
| Drone görünümü | — | legacy `0|n|d|…` (§4.3) | `MapEventsAssembly.assembleSetDrones` |
| "Ekipman hazır" ipucu | — | `EquipReadyCommand{ready}` | `EquipReadyCommandHandler` → `HintsNotifications.INIT_HINT`, `warpWindowMinimize` |
| Battle station modülü tak | `EquipModuleRequest{battleStationId,itemId,slotId,replace}` (`BattleStationProxy.requestEquipModuleToAsteroid`) | `BattleStation*` komutları | battlestation handler'ları |
| Gemi hız/kalkan/HP güncelle | — | `AttributeShipSpeedUpdateCommand{newSpeed,displaySpeed}`, `AttributeShieldUpdateCommand{shieldNow,shieldMax}`, `AttributeHitpointUpdateCommand`, `HitpointInfoCommand{hitpoints,hitpointsMax,nanoHull,nanoHullMax}` | `Attribute*Handler`, `HitpointInfoHandler` (kendi gemi HPTrait) |

`ConfigChangeRequest{presetId}` netty isteği main.swf'de gönderilmiyor — konfig değişimi legacy `S|CFG` ile.

### 3.4 Dükkan

Flash istemcide **oyun içi dükkan penceresi yok**.

| Tetik | İstemci | Sonuç |
|---|---|---|
| `shop` (generic bar) veya `new_shop` (new bar) | `UIButtonTriggerRequest{"shop"/"new_shop"}` + `TRIGGER_SHOP_ACTION` → `…/mvc/commandCenter/control/CommandCenterTriggerShopCommand.as` | Command Center'da "sales" kategorisinin ilk haberinin `onclick` aksiyonu varsa onu çalıştırır; yoksa `referToURL("internalDock",…,"internalDockShips&checkOffer")` + `openPaymentFromExternal("uridium")` (web) |
| Kill screen "shop" seçeneği | `referToURL("internalDock","seo_tittle_ships","internalDockShips")` | web |
| Exchange shop (porting) | `ExchangeShopRequest` | `ExchangeShopCommand` → handler (`porting/shop/exchange`) |
| Cephane satın alma sonucu (eski) | — | legacy `0|5|o|<kategori b/r>|<lootId>|<adet>` başarı; `0|5|f|F|<U/C>` para yok; `0|5|f|S` kargo dolu (`ConnectionManager.onData` BUY) |

`ShopItemBuyRequest`, `ShopItemListRequest`, `AmmunitionBuyRequest` main.swf'de gönderilmiyor. Slot bar'daki "satın al" ikonları `MenuItemStatusCommand.buyable` ile çizilir; tıklama yine `MenuActionRequest`.

### 3.5 Galaxy Gate builder (pencere id `ggBuilder`)

Pencere: `GuiManager.createGGBuilderWindow()` → `GalaxyGateBuilderDecorator` → `GalaxyGateBuilderModel` (+ `GalaxyGateBuilderProxy` adı `ggBuilder`). Tüm GG handler'ları (`…/net/netty/handlers/galaxygatebuilder/*`) pencere yoksa önce oluşturur, sonra modelin `handle…` metodunu çağırır.

| # | Tetik (`…/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as`) | İstemci gönderir | Beklenen cevap | Model metodu → ne güncellenir |
|---|---|---|---|---|
| 1 | pencere açılışı, init kuyruğu (`manageInitQueue` → `INIT_ITEM_USER_DETAILS`) — önce `common`/`gates` asset SWF'leri yüklenir | `GalaxyGateBuilderInfoRequest{}` | `GalaxyGateBuilderInfoCommand{gates[GalaxyGateBuilderGateModule], money, samples, energy_cost, spinAmounts, spinamount_selected, spinOnSale, bonusRewardsDay, galaxyGateDay}` | `handleInitUserComplete` → `parseInitUserData`: kapı listesi, uridium, ekstra enerji, spin seçenekleri |
| 2 | init `INIT_ITEM_GATE_FULL` ve kapı seçimi (`setGate`) | `GalaxyGateBuilderGetGatePartsRequest{gateId}` | `GalaxyGateBuilderGetGatePartsCommand{gateId, gatePartIds, errorCode}` | `loadGateImage` → kapı parça görselleri |
| 3 | "Enerji üret / spin" (`produce`→`produceRemote`) | `GalaxyGateBuilderMultiEnergyRequest{gateId, spinAmount, useMultiplier}` | `GalaxyGateBuilderMultiEnergyCommand{items[ödül], gatePartIds, money, samples, multiplier, spinamount_selected, gateMode, errorCode}` | ödül listesi (`parseOutputList`), parça ilerlemesi, uridium/enerji |
| 4 | spin miktarı değişti | `GalaxyGateBuilderSaveSpinAmountRequest{spinAmount}` | — | |
| 5 | "Kapıyı hazırla/atla" (`prepareJumpRemote`) | `GalaxyGateBuilderSetupGateRequest{gateId}` | `GalaxyGateBuilderSetupGateCommand{id, livesLeft, lifePrice, errorCode}` | kapı durumu, can/fiyat; ardından sunucu haritada GG portalını (`JumpgateCreateCommand`) yaratmalı |
| 6 | can satın al (`purchaseGateLife`) | `GalaxyGateBuilderBuyLifeRequest{gateId}` | `GalaxyGateBuilderBuyLifeCommand{gateId, livesLeft, lifePrice, money, samples, multiplier, gateMode, errorCode}` | `parseGateLifePurchaseResponse` |
| 7 | kapı içinde (sunucu kendiliğinden) | — | `GalaxyGateBuilderGateWaveUpdateCommand{gateId,currWave}`, `GalaxyGateBuilderGateLifeLostCommand{gateId,livesLeft}`, `GalaxyGateBuilderGateCompleteCommand{gateId,currPart}` | dalga/can/tamamlandı göstergesi |

Kapı sabitleri (istemciye gömülü, `GalaxyGateBuilderModel`): §5.

İlgili diğer "kapı" pencereleri (aynı desen: pencere aç → `…Request` → `…WindowCommand`): Eternal Gate (`EternalGate*Command` → `EternalGateUIWindowProxy`; seçim `EternalGateChooseOptionRequest`), Dispatch (`DispatchGetGateListRequest` pencere aktifken → `DispatchGetGateListCommand`; `DispatchSendGateRequest`, `DispatchCollectGateRewardRequest`), Trinity Trials (`TrinityTrialsGateEnterRequest{attributeType,difficulty}`), Voyagers/Singularity (`VoyagersGateEnterRequest{isFree,instanceLevel}`), Birthday2025 (`Birthday2025GateEnterRequest{level}`).

### 3.6 Görevler (Quest)

| # | Tetik | İstemci gönderir | Beklenen cevap | İşleyen → güncellediği |
|---|---|---|---|---|
| 0 | harita girişi | — | `QuestGiversAvailableCommand{questGivers}` | `…/net/netty/handlers/QuestGiversAvailableHandler.as` → haritada görev veren ikonları (istasyon) |
| 1 | görev veren ikonuna tıklama (`…/map/model/env/homebase/QuestGiver.as` `handleIconClick`) | `GuiNotifications.OPEN_QUEST_WINDOW` (yerel pencere) + `QuestGiverApproachedRequest{questGiverId}` | `QuestListCommand{list, onlyStarter, maxQuests, maxEventQuests}` | `QuestListHandler`: `QuestProxy`'yi ve görev penceresi komutlarını kaydeder → `createQuestLists` |
| 1b | pencere açılınca proxy hazırsa (`WindowMediator:76`) | `QuestListRequest{}` (`QuestProxy.tryToPopulateQuestGiverWindow`) | `QuestListCommand` | aynı |
| 2 | listede görev seçimi (`REQUEST_DETAILED_QUEST_INFO` → `QuestGiverRequestQuestInfo`) | `QuestInfoRequest{questId}` | `QuestInfoCommand{definition, ratings, playersRating}` | `QuestInfoHandler` → `QuestProxy` detay paneli |
| 3 | "Kabul" (`ACCEPT_QUEST` → `QuestGiverAcceptQuestCommand`) | `QuestAcceptRequest{questId}` | `QuestInitializationCommand{quest: QuestDefinitionModule}` (+ yenilenmiş `QuestListCommand`) | `QuestInitializationHandler` → `QuestAssembly.assembleQuestInitialization` → aktif görev HUD'u |
| 4 | "İptal" (`ABORT_QUEST` → `QuestGiverAbortQuestCommand`; HUD'dan `QuestManager.cancelQuestCallback`) | `QuestCancelRequest{questId}` | `QuestCancelledCommand{id}` | `QuestCancelledHandler` → `questAssembly` |
| 5 | ilerleme (sunucu) | — | `QuestConditionUpdateCommand{questConditionId, state}` | `QuestConditionUpdateHandler` → `QuestProxy`, ayrıca season/battle pass, space search, diminishing quest proxy'leri |
| 6 | bitiş (sunucu) | — | `QuestCompletedCommand{id, rating}` / `QuestFailedCommand{id}` | `QuestCompletedHandler` / `QuestFailedHandler` |
| 7 | aktif görev değiştir (HUD nokta listesi `QuestDotList.onClickPrivilege`, `QuestManager.removeQuest`) | `QuestPrivilegeRequest{questId}` | `QuestPrivilegeCommand{questId}` | `QuestPriviligeHandler` |
| 8 | filtre (`QuestGiverWindowMediator.handleFiltersChanged`) | `QuestSettingsRequest{6 bool}` | `QuestSettingsModule` (açılışta `UserSettingsCommand` içinde) | `QuestSettingsHandler` → filtre butonları |
| 9 | pencere kapandı | `QuestGiverWindowClosedRequest{questGiverId}` | — | |
| — | yeni görev bildirimi | — | `NewQuestsAvailableCommand{newQuestIds}` | `NewQuestsAvailableHandler` → yerelde `LegacyModule("L|n|MSG|0|2|log_msg_new_quests_available")` |

Eski yol: legacy `0|9|ini|…`, `0|9|upd|…`, `0|9|p|…`, `0|9|a|…`, `0|9|c|…`, `0|9|f|…` (`QuestAssembly`), istemci isteği `9|g` (`QuestManager:274`).

### 3.7 Pilot sheet

`pilotSheet` butonu → `UIButtonTriggerRequest{"pilotSheet"}` + `referToURL("internalPilotSheet")` (web). Oyun içi pilot sayfası yok. `InternalPilotBio*Request`, `SkillTreeListRequest`, `UpLevelSkillTreeRequest`, `ResetSkillTreeRequest`, `ConvertResearchPointsRequest` main.swf'de gönderilmiyor. Pilot yetenek **görselleri** sunucudan: legacy `0|SD|…` (`SkillsAssembly`), `0|A|LUP|<level>|<ep>` seviye atlama efekti, `LevelUpCommand{uid,newLevel}` → `LevelUpHandler`.

### 3.8 Harita / portal

| # | Tetik | İstemci gönderir | Beklenen cevap | İşleyen |
|---|---|---|---|---|
| 0 | harita girişi | — | `JumpgateCreateCommand{gateId, factionId, designId, x, y, isVisibleOnMinimap, showBubble, decoratorAssetTypes}` / `JumpGateRemoveCommand{gateId}` | `…/net/netty/handlers/portals/JumpgateCreateHandlerCommand.as` → haritaya `Portal` |
| 1 | portal ikonuna tıklama (`…/map/model/env/Portal.as` `handleIconClicked`; tekrar tıklama gecikmeli kilitli) veya J tuşu (`…/managers/keyboardManager/commands/JumpCommand.as`) | `JumpRequest{}` (alansız; sunucu oyuncunun yakınındaki portalı bulmalı) | başarı: `JumpInitiatedCommand{mapId, gateId}`; ret: legacy `0|k|<gerekenSeviye>` (`jumplevelfalse` mesajı + "erişim reddedildi" sesi). (`JumpDeniedCommand` handler'sız → işe yaramaz) | `ActivatePortalCommand`: portal `jump(10)` animasyonu, `Main.scheduledDisconnect=true`, `Settings.nextMapID=mapId` |
| 2 | (istemci bekler) | — | **soket kapanışı** (sunucu kapatır) — ya da legacy `0|i|<mapId>` → istemci `ChannelCloseRequest{close:true}` yollar ve kendisi kapatır | `ConnectionManager.handleConnectionLost`: `scheduledDisconnect` ise `connectToMap(nextMapID)` |
| 3 | yeniden bağlanma | §2.1 zinciri (Version → Login …) yeni harita için | yeni haritanın `ShipInitializationCommand{mapId…}` + varlıklar | |

Alternatifler: legacy `0|U|<mapId>|<portalId>` (portal animasyonu sesi, logout penceresini kilitler, `scheduledDisconnect`), `ReloginCommand{mapID, delayInMillis}` → gecikmeyle yerel `0|i|<mapID>` (sunucunun istemciyi başka haritaya taşıması için en temiz yol), legacy `0|z` (sunucu değişti: hero/map yüklü bayrakları sıfırla).
Gelişmiş jump CPU (uzay haritası penceresi): legacy `JCPU|J`, `JCPU|S|<mapId>`, `JCPU|GET` ↔ `0|A|JCPU|I|…` / `C|…` / `S|…` (`SetAttributeAssembly.assembleAdvancedJumpCpuCommands`); `CPUInitializationCommand{advancedJumpCPUEquipped, radarCPUEquipped}` → `CpuInitializationCommand`. Netty `JumpCPUSelectRequest/UpdateRequest` gönderilmiyor.
Grup üyesi zıpladı: `MemberJumpCommand{memberId, fromMapId, toMapId}` → `MemberJumpHandler`.

### 3.9 Ölüm / tamir

| # | Olay | İstemci | Sunucu | İşleyen → etkisi |
|---|---|---|---|---|
| 1 | gemi yok edildi | — | `ShipDestroyedCommand{destroyedUserId, explosionTypeId}` | `ShipDestroyedHandler` → `ShipAssembly.assembleShipDestroy`: kendi id'si ise `Hero.isKilled=true`, `HERO_DIED`, `GuiManager.createEndSequence()` (patlama); gemi haritadan kalkar. **Bundan sonra istemci yalnızca KillScreenRepairRequest/KeepAlive/ChannelCloseRequest gönderir.** |
| 2 | kill ekranı | — | `KillScreenPostCommand{killerName, killerEpppLink, playerShipAlias, cause: DestructionTypeModule, options: [KillScreenOptionModule]}` | `KillScreenPostHandler` → `showRepairWindow`; `cause` → `DestructionTypeHandler` (`Killscreen.setDestructionType`); her `option` → `KillScreenOptionHandler` → `Killscreen.addOption(repairType, price.amount, price.type, buttonKey, affordable, cooldownTime)` + açıklama metni |
| 2b | seçenekleri güncelle | — | `KillScreenUpdateCommand{options}` | `KillScreenUpdateHandler` (seçenekleri temizle + yeniden ekle) |
| 3 | "Tamir" butonu (`…/gui/windows/components/Killscreen.as:122` `repair`) | `KillScreenRepairRequest{selection:{repairTypeValue}, requestModule:{userID, sessionID, factionID}}` — seçenek 0 `FREE_PHOENIX` ve 9 `PAYMENT` istek göndermez, web'e yönlendirir + logout | **`ShipInitializationCommand`** (isKilled=false) + harita içeriği; farklı haritada doğacaksa `ReloginCommand`/`0|i|<map>` ile yeniden bağlantı | istemci `cleanup()` ile haritayı temizler → sunucu tam açılış paketlerini yeniden göndermeli |

Repair tipleri (`KillScreenOptionTypeModule`): 0 FREE_PHOENIX, 1 BASIC_REPAIR, 2 AT_JUMPGATE_REPAIR, 3 AT_DEATHLOCATION_REPAIR, 4 AT_SECTOR_CONTROL_SPAWNPOINT, 5 EXIT_SECTOR_CONTROL, 6 BASIC_FULL_REPAIR, 7 RAID_GATE_REPAIR, 8 TDM_REPAIR, 9 PAYMENT, 10 REFRACTION_ZONE_FACTION_BASE, 11 REFRACTION_ZONE_DEATH_LOCATION, 12 WAR_GAME_REPAIR, 13 STRIKE_AND_EXIT.
`KillScreenRepairRequest` aynı zamanda `handlerLookup`'ta (handler boş) — istemci onu bir S→C komutu olarak da tanır ama hiçbir şey yapmaz.

Diğer tamir: `InstantRepairRequest{repairAssetId}` (haritadaki tamir istasyonu ikonu `RepairStation.handleIconClick`), `EmergencyRepairRequest{battleStationId,slotId}` (battle station), pet: `PetRepairCompleteCommand`, `PetUIRepairButtonCommand{enabled,repairCosts}`. Tamir bilgisi: legacy `0|A|REP|<a>|<b>` → `Hero.repairInfo`.

### 3.10 Cephane / roket / lazer (slot bar)

Slot bar (items control menu) tamamen sunucu güdümlü: `MenuInitializationCommand{slotBars, itemBarPosition, categories}` → `ParseItemsControlMenuDataCommand` → `ItemsControlMenuProxy` → `ItemsControlMenuMediator`/`MenuBarsMediator`. Menü öğe id'leri = **lootId** (ör. `ammunition_laser_lcb-10`, `ammunition_rocket_r-310`, drone formasyonları, CPU'lar).

| İşlev | İstemci gönderir | Beklenen cevap | İşleyen |
|---|---|---|---|
| Öğeye tıklama (`ItemsControlMenuMediator` → `SEND_MENU_ACTION_REQUEST` → `…/mvc/gui/itemsControlMenu/controller/requests/SendMenuActionRequestCommand.as`) | `MenuActionRequest{menuItemId, actionType, sourceType}`; `actionType`: 0 SELECT / 1 ACTIVATE (seçim stilinde çift tıklama veya slot bar = ACTIVATE; toggle = SELECT; one-shot = ACTIVATE); `sourceType`: 0 ITEM_BAR (kategori barı) / 1 SLOT_BAR | `MenuItemStatusCommand{menuItemId, selected, activatable, available, visible, blocked, buyable, counterValue, maxCounterValue, counterStyle, iconLootId, toolTipItemBar, toolTipSlotBar}` — seçilen cephanede `selected=true`, öncekinde `false`; sayaç = stok | `UpdateMenuItemStatusCommand` → model + ikon |
| Kısayol tuşu 1–0 / premium slot (`ActivateSlotCommand`, `ActivatePremiumSlotCommand` → `SendHotKeyActionRequestCommand`) | `MenuActionRequest{…, sourceType:1 SLOT_BAR}` | aynı | aynı |
| Slot bar düzenle (sürükle) | `SlotBarConfigSetRequest{menuItemId, slotBarIdFrom, slotIdFrom, slotBarIdTo, slotIdTo}` | (yeni `MenuInitializationCommand` veya status) | |
| Bekleme süresi | — | `MenuItemTimerCommand{menuItemId, time, maxTime, timerState, activatable}`, `MenuItemCooldownGroupTimerCommand{cooldownType, time, maxTime, timerState}` | `UpdateMenuItemTimerCommand`, `UpdateMenuItemCooldownGroupTimerCommand` |
| Vurgu | — | `UIItemAddHighlightCommand` / `UIItemRemoveHighlightCommand` | `AddMenuItemHighlightCommand` / `RemoveMenuItemHighlightCommand` |
| Seçili kategori | — | `RefreshSelectedUICategoryCommand` | `UpdateSelectedCategoryCommand` |
| **Lazer** saldırısı (CTRL `ActivateLaserCommand`; hedef seçiliyken) | `MapAssetNotification.ATTACK_MAP_ASSET` → `MapAssetAttackCommand.startLaserAttack` → `AttackLaserRequest{targetId, targetX, targetY}`; tekrar basınca `AttackAbortLaserRequest{}` (`AbortLaserAttackCommand`) | `AttackLaserRunCommand{attackerId, targetId, laserColor, skilledLaser, isDiminishedBySkillShield, visualType}` (ışın) + `AttackHitCommand{attackerId, victimId, victimHitpoints, victimShield, victimNanoHull, damage, attackType, skilled, strike, cannonType}` / `AttackMissedCommand`; durdurma `AttackAbortLaserCommand{uid}`; menzil dışı `AttackRangeExceededCommand{uid,maxRange,type}` | `AttackLaserRunHandler`, `AttackHitHandler`, `AttackMissedHandler`, `AttackAbortLaserHandlerCommand`, `AttackRangeExceededHandler` |
| **Roket** (SPACE `…/managers/keyboardManager/commands/ActivateRocketCommand.as`) | `AttackRocketRequest{targetId, targetX, targetY}` — not: `(targetX+targetY)%3==0` ise istemci `targetY++` yapar (sunucu doğrulama izi) | `AttackHitCommand{attackType: ROCKET…}` / `AttackMissedCommand`; roket görseli legacy `0|v|<attacker>|<target>|H|<rocketType>|<?>|<?>` (`ROCKET_ATTACK`: `[4]=="H"` isabet, `[5]` desen/tip, `[6]`, `[7]` bool) | `ConnectionManager.onData` `v` → `RocketEffect`/`BezierRocketEffect` |
| Roket bekleme bitti | — | legacy `0|A|RCD` | `SetAttributeAssembly.assembleRocketCooldownCompleted` |
| Roketatar (HST) | — | legacy `0|RL|S|<?>|<a>|<b>` durum, `0|RL|A|<attacker>|<target>|<a>|<b>|M?` saldırı | `RocketLauncherAssembly` |
| Cephane bitti | — | legacy `0|W|<ammoType>|…|<n>` → `GuiManager.noAmmunition`; otomatik değişim `0|4|<ammoType>|…|<n>` | `ConnectionManager.onData` |
| Seçim (hedef kilitleme) | `ShipSelectRequest{targetId, targetX, targetY, posX, posY, clickX, clickY, radius}` (`TryToSelectMapAssetCommand`) | `ShipSelectionCommand{userId, shipType, shield, shieldMax, hitpoints, hitpointsMax, nanoHull, maxNanoHull, shieldSkill}` / `ShipDeselectionCommand` | `ShipSelectionHandler` (kilit + hedef HP penceresi, grup proxy) |

---

## 4. Eski metin protokolü (LegacyModule)

Ayrıştırıcı: `…/net/ConnectionManager.as:548` `onData(message)` — `message.split("|")`; **`[0]` genelde `0`**, `[1]` komut öneki. `[0]=="ERR"` ayrıca ele alınır. Alt modüller `delegateDict[key](parts)` sözlüğüyle çağırır (key genelde `[2]`). Sabitler: `…/net/ServerCommands.as`, `…/net/ClientCommands.as` (tam liste `client-map.json → legacy.serverToClientConsts`).

### 4.1 Üst seviye önekler (`parts[1]`)

| Önek | Sabit | Anlam / alanlar | İşleyen |
|---|---|---|---|
| `PET` | PET | pet komutları, `[2]` alt komut (§4.4) | `PetAssembly` |
| `v` | ROCKET_ATTACK | roket görseli `v|attacker|target|H?|desen|tip|bool` | `RocketEffect` |
| `TX` | TECHS | tech `[2]`: `ECI` zincir şimşek, `A` aktive, `ECB` patlayıcı blob | `TechAssembly` |
| `SD` | SKILL_DESIGNS | `[2]` `A`/`D`/`R` skill görseli aktive/deaktive/kaldır | `SkillsAssembly` |
| `2` | REMOVE_BOX | `2|hash` kutu kaldır | `map.removeEntityByHash` |
| `U` | PLAY_PORTAL_ANIMATION | `U|mapId|portalId` | §3.8 |
| `S` | ClientCommands.SELECT | `S|CFG|n` seçili konfig | §3.3 |
| `i` | PORTAL_JUMP | `i|mapId` → `ChannelCloseRequest`, yeniden bağlan | `portalJump` |
| `y` | BOX_COLLECT_RESPONSE | eski kutu toplama; `formatLegacy` ile `LM|ST|…` biçimine çevrilir | `BoxCollectResponseAssembly` |
| `LM` | LOG_MESSAGE | `LM|<profil>|<tip>|…` toplama/ödül log'u + değer güncelleme (§4.2) | `BoxCollectResponseAssembly` |
| `A` | SET_ATTRIBUTE | özellik güncellemeleri (§4.2) | `SetAttributeAssembly` |
| `9` | QUESTFM_INFO | `ini/upd/p/a/c/f` | `QuestAssembly` |
| `W` | NO_AMMUNITION | `W|ammoType|?|n` | `GuiManager.noAmmunition` |
| `4` | AUTO_AMMUNITION_CHANGE | `4|ammoType|?|n` | (yalnız değişkene yazar) |
| `m`, `SMP`, `s` | NEW_MAP, SET_MAP_PVP_STATUS, CREATE_STATION | **yok sayılır** | — |
| `CSS` | CHANGE_HEALTH_STATION_STATUS | `CSS|0/1` tüm `Station.isEnabled` | |
| `f` | CARGO_FULL | "kargo dolu" log'u | |
| `h` | RESOURCE_DISABLED | log | |
| `q` | REMOVE_ORE | `q|hash` cevher kaldır | |
| `n` | MAP_EVENT | harita olayları (§4.3) | `MapEventsAssembly` |
| `l` | LOGOUT | çıkış tamam → `bpCloseWindow` | |
| `t` | LOGOUT_CANCEL_FROM_SERVER | çıkış sayacını iptal | `GuiManager.logoutCancelFromServer` |
| `5` | BUY | §3.4 | |
| `7` | CLIENT_SETTING | istemci `JCPU|GET` gönderir | |
| `k` | JUMP_FAILED | `k|seviye` | §3.8 |
| `UI` | USER_INTERFACE | `UI|MM|…` minimap, `UI|AR|…` ok, `UI|W|MAW|id…` pencereleri büyüt, `UI|B|SF|…`/`HF` buton parlat | `UserInterfaceAssembly` |
| `RL` | ROCKETLAUNCHER | `S`/`s` durum, `A`/`a` saldırı | `RocketLauncherAssembly` |
| `z` | CHANGE_MAP | sunucu değişti bayrakları | `handleServerChanged` |
| `[0]=ERR` | ERROR | `ERR|1` login hatası, `ERR|2` giriş yapılmamış, `ERR|3` çift giriş (mesaj + bağlantı kes), `4/41/42` yok sayılır | |
| `[0]=KIK` | KICKED | yok sayılır | |

### 4.2 `0|A|…` (SetAttributeAssembly, key=`[2]`) ve `0|LM|…` (BoxCollectResponseAssembly, key=`[3]`)

`0|A|<key>|…` (`…/net/SetAttributeAssembly.as`):

| key | Alanlar → etki |
|---|---|
| `STD` | `[3]` düz metin log |
| `STM` | `[3]` çeviri anahtarı log (`init.js` CPU mesajları bunu kullanıyor) |
| `CSTM` | `[3]` kategori, `[4]` anahtar |
| `EP` | `[3]` toplam EP → `Hero.experiencePoints` |
| `C` | `[3]` kredi, `[4]` uridium → `Hero.creditsAmount/uridiumAmount` |
| `LUP` | `[3]` yeni seviye, `[4]` EP → seviye log'u + `LevelUpEffect` |
| `ACG` | `[3..5]` başarım efekti |
| `c` | `[3]` maks kargo |
| `CC` | `[3]` konfig sayısı |
| `REP` | `[3]`,`[4]` tamir bilgisi → `Hero.repairInfo` |
| `JV` | `[3]` atlama kuponu |
| `BK`, `BKB`, `BKR`, `BKS`, `BKM`, `BKPR`, `BKBB`, `BKBLC`, `BKBLD`, `BKP`, `BKA`, `BKAP`, `BKE`, `BKL`, `BKPG`, `BKLL`, `BKEB`, `BKEG`, `BKEP`, `BKER` | `[3]` sayı → ilgili booty key türü (`[2]` hangisi olduğunu belirler) |
| `HL` | `[4]` hedef id, `[5]` `SHD`/`HPT`, `[6]` yeni değer, `[7]` iyileşme miktarı → HP/kalkan + yeşil balon |
| `VERSION` | `[3]` sunucu sürümü |
| `JCPU` | `[3]` `I`/`C`/`S` jump CPU (§3.8) |
| `IOLOG`, `DCH`, `SON`, `SHS`, `RCD`, `SLA`, `SLC`, `CEC`, `HSGU`, `HSGS`, `SCE`, `KSCE` | I/O log, nişangah, özel teklif, kalkan skill, roket cooldown, toplama ışını aktif/iptal, kaptan enerjisi, skor kapısı/fest pencereleri |
| `SHD`, `v` | **kırık**: delegate `(int,int)`/`(int)` imzalı ama dizi ile çağrılıyor → AS3 ArgumentError. Kalkan/hız için netty `AttributeShieldUpdateCommand` / `AttributeShipSpeedUpdateCommand` kullanın. |

`0|LM|<profil>|<tip>|…` (`…/net/BoxCollectResponseAssembly.as`, `[2]` log profili, `[3]` tip):

| tip | Alanlar → etki |
|---|---|
| `CRE` | `[4]` +kredi (≤0 ise "düşüldü" mesajı), `[5]` toplam → `Hero.creditsAmount` |
| `URI` | `[4]` +uri, `[5]` toplam → `Hero.uridiumAmount` |
| `EP` | `[4]` +EP, `[5]` toplam EP, `[6]` seviye → `Hero.experiencePoints`, `Hero.level` |
| `HON` | `[4]` +onur, `[5]` toplam → `Hero.honorPoints` |
| `HTP` | `[4]` +HP log | `DHP` `[4]` -HP log |
| `EPP` | `[4]` etkinlik puanı |
| `ROK`/`SLU`/`BAT`/`SPL`/`FW`/`RL` | `[4]` lootId, `[5]` adet (bonus roket/slug/lazer pili/…) log |
| `AMI`/`LOT` | `[4]` lootId, `[5]` adet eşya toplandı |
| `JV`, `PFL`, `XEN`, `LOG` | `[4]` adet (kupon, pet yakıtı, ekstra enerji, log dosyası) |
| `BTB`, `BAH` | kutu çok büyük / zaten toplandı |
| `MIN`, `SLE`, `DIS`, `NB`, `QFC`, `BMP`, `SLA`, `SLC`, `CAR` | mayın, kalan oyuncu, indirim, booster, QFC, banking çarpanı, toplama ışını, cevher |
| bilinmeyen tip | `BPLocale.getItem(tip)` boş değilse log'a yazılır |

### 4.3 `0|n|…` harita olayları (MapEventsAssembly, key=`[2]`)

| key | Anlam / alanlar |
|---|---|
| `d` | **drone'lar**: `n|d|shipId|[formasyonId|]` + 4'lü gruplar `tip|seviye|statsDesign|visualDesign` (`(len-4)%4==0` ise formasyon yok). Gemi yoksa `PendingDroneInitialization`'a saklanır. |
| `e` | drone sayısı gösterimi `n|e|shipId|a/b/c` |
| `t` | **unvan**: `n|t|shipId|?|titleKey` → `ship.info.titleID` |
| `trm` | unvanı kaldır `n|trm|shipId` |
| `MSG` | `n|MSG|tip|mod|anahtar[:kategori]|replacement` → log / ekran mesajı / global bildirim |
| `pvp` | `n|pvp|shipId|0/1` ateşkes kazanıldı/kaybedildi log'u |
| `p` | set portal — **boş fonksiyon** |
| `LSH`/`USH`, `INV` | hedefi griye çek / geri al, görünmez |
| `w`, `s` | düşman uyarısı, düşman doğuşu |
| `MAL`, `EMAL`, `SMB`, `ISH`, `EMP`, `BT`, `NNK`, `GOPM`, `PMME`, `MIN`, `BOOOM`, `SAB_SHOT`, `HEAL_RAY`, `fx` | efektler (malus, smartbomb, instashield, EMP, patlamalar, SAB, iyileşme ışını, genel fx) |
| `Spawn`/`Despawn` | doğuş efekti |
| `TX`, `SD` | tech / skill tasarımı güncelle |
| `fbo` | booster bulundu |
| `FWI`, `FWG` | havai fişek |
| `ssi`/`ssc`/`sss`, `isi`/`isc`/`isw`, `ctb`, `SCEL`, `SCEKL`, `KSMSG`, `KILL_COUNTER_VISUAL_PERK`, `PROMETHEUS_KILL_COUNTER_VISUAL_PERK` | skor tablosu, invasion, CTB, etkinlik canları, killstreak, kill sayacı |

### 4.4 Diğer alt modüller

* `0|PET|<key>`: `I` init, `D` deaktive, `Z` yok edildi, `S` durum, `R` tamir, `W` pencere kilidi, `TW` takas, `NOFL`/`FL` yakıt yok/var, `IDLE`, `SL` lazer dur, `RESET`, `RB` tamir butonu, `Q` banner kaldır, `EV` evasion; `A|EP/HPT/SHD/FL/LUP`, `G|LS/TL/SEL/A/R` (gear), `E|A/R` (buff).
* `0|POI|CRE/RDY/REM/ENT/LEA` (POIAssembly; netty `MapAddPOICommand` tercih edilir).
* Ayarlar (`SettingsAssembly`, key=`[0]`): `DISPLAY_*`, `QUALITY_*`, `AUTO_*`, `PLAY_*` … (netty `UserSettingsCommand` tercih edilir).
* Tam alan okuma satırları: `client-map.json → legacy.assemblyDelegates` (219 delegate).

### 4.5 İstemci → sunucu metin komutları (`ConnectionManager.sendCommand`)

| Mesaj | Gönderen | Anlam |
|---|---|---|
| `S|CFG|<n>|<userID>|<sessionID>` | `ChangeConfingCommand`, `InfoField:212` | konfig değiştir (§3.3) |
| `JCPU|J`, `JCPU|S|<mapId>`, `JCPU|GET` | `SpaceMapWindowMediator`, `GuiManager:1154`, `onData('7')` | gelişmiş jump CPU |
| `i|<shipId>` (REQUEST_SHIP) | `MoveHandler` (bilinmeyen gemi `MoveCommand`'ı alınınca) | o geminin `ShipCreateCommand`'ını iste |
| `9|g` | `QuestManager:274` | görev bilgisini iste (eski) |
| `XCP|<miktar>` | `OreTradeModule:352` | palladium takası |
| `TWC` | `GuiManager:1016` | takas penceresi küçültüldü |
| `UI|VID|WD|<id>` | `VideoWindow:314` | video penceresi kapandı |
| `LF|w` | `dispatchSpacemapLoaded` | harita yüklendi bayrağı |

---

## 5. İstemcide bulunan sabitler

| Ne | Nerede | Çıktı |
|---|---|---|
| **Eşya kataloğu** (3041 lootId: 722 gemi/tasarım kaydı — `shipId`, `speed`, `maxHitPoints`, `maxNanoHull`, `maxSpace` (kargo), `maxLaser`, `maxGen`, `maxSpecials`, `ep`/`honourPoints` (muhtemelen yok edilme ödülü), `credits`/`uridium` fiyatı, `slotable.slots`; cephane `damage`/`range`/`credits`; lazer `damage` + `upgradable`; jeneratör `output`/`spread`; drone, booster, CPU, tarif, …) | `…/items/ItemDataProvider.as` `initialize()` (139k satır düz atama) | `docs/client-map.items.json` |
| Haritalar (249: id, ad, tür, `home` = ana harita faksiyonu: 1-1→MMO, 2-1→EIC, 3-1→VRU) | `client/spacemap/graphics/maps-config.xml` ("maps-config"); dinamik kısım (`gameserverIP`) `xml/maps.php` | `client-map.json → constants.maps` |
| Galaxy Gate parça/dalga sayıları | `GalaxyGateBuilderModel` | aşağıda |
| Kill screen tamir tipleri, LoginResponse durumları, MenuAction sabitleri, cephane tipleri | `com/module/*` | `constants.*` |
| Pencere id'leri (GuiConstants, 300+), özellik menüsü id'leri | `mvc/gui/GuiConstants.as`, `FeaturesMenuConstants.as` | `constants.guiWindowIds`, `constants.featuresMenu` |
| Seviye/EP tablosu | **yok** — seviye her zaman sunucudan gelir (`ShipInitializationCommand.level`, `0|LM|ST|EP|+|toplam|seviye`, `0|A|LUP`, `LevelUpCommand`) | — |
| Ship ability id'leri, sesler, unvan anahtarları | `…/InGameCatalog.as` | — |

Galaxy Gate (gateId → parça / dalga): 1 alpha 34/40, 2 beta 48/40, 3 gamma 82/40, 4 delta 128/29, 5 epsilon 99/30, 6 zeta 111/46, 7 kappa 120/29, 8 lambda 45/21, 12 kronos 21/50, 13 hades 45/12, 19 streuner 100/54.

Not: katalogdaki gemi `maxHitPoints` değerleri bilinen orijinallerden 100 000 fazla (ör. Goliath 356 000); istemci bunları yalnız gösterim/tooltip için kullanır, gerçek değerler `ShipInitializationCommand`'dan gelir.

---

## 6. Sunucu yazarken dikkat

* Handler'ı olmayan komut sessizce düşer: gönderilecek her komutun Ek A'da olduğundan emin olun (ör. `JumpDeniedCommand`, `ShopItem*Command`, `HangarShip*Command` (Equipment/MoveItems/Ships hariç), `QuestListUpdateCommand` işlenmez).
* `LoginResponse{status:0}` şart (yoksa istemci sonraki tüm istekleri kuyrukta tutar).
* Ölümden sonra `ShipInitializationCommand` gelmeden istemci hareket/saldırı göndermez.
* Harita değişimi = soket yeniden bağlantısı; local'de `localGS` flashvar'ı ile aynı sunucuya döner.
* Hangar, pilot sheet, klan, skylab, açık artırma, dükkan sayfaları **web** (`InternalMapRevolution.referToURL`) — oyun soketi değil.
* Bütün C→S isteklerin gönderen yeri ve tetik zinciri: Ek B / `client-map.json → c2s`. 126 istek main.swf'de hiç gönderilmiyor.

---

## Ek A — S→C komut → istemci handler tablosu (otomatik)

Kaynak: `net/netty/HandlerLookup.as` (`handlerLookup[X.getLibcomModuleId()] = Handler`). 477 kayıt. "Bildirim → dinleyen" sütunu PureMVC zinciridir (`sendNotification` → `registerCommand` / `listNotificationInterests`).

| Komut (id) | Handler | Bildirim → dinleyen | Kullandığı proxy/model | Pencere |
|---|---|---|---|---|
| AbilityEffectActivationCommand (275) | [AbilityEffectActivationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AbilityEffectActivationHandler.as) |  | SkillsAssembly, AbilityEffectActivationAssembly |  |
| AbilityEffectDeActivationCommand (282) | [AbilityEffectDeActivationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AbilityEffectDeActivationHandler.as) |  | MapEventsAssembly |  |
| AbilityStartCommand (279) | [AbilityStartHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AbilityStartHandler.as) |  | AbilityButtonAssembly, AbilityEffectActivationAssembly |  |
| AbilityStopCommand (278) | [AbilityStopHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AbilityStopHandler.as) |  | AbilityButtonAssembly, SkillsAssembly, MapEventsAssembly, AbilityEffectDeactivationAssembly |  |
| AccountStatusChangeCommand (-16529) | [AccountStatusChangeHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AccountStatusChangeHandlerCommand.as) |  |  |  |
| ActivationZoneStatusCommand (11704) | [ActivationZoneStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ActivationZoneStatusHandler.as) |  | POIZoneManager |  |
| ActivePerkUpdateCommand (-20339) | [ActivePerkUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/captain/ActivePerkUpdateHandler.as) |  |  |  |
| AddBeaconCommand (2850) | [AddBeaconHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/AddBeaconHandler.as) |  |  |  |
| AddBoxCommand (-4037) | [AddBoxHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/AddBoxHandler.as) |  |  |  |
| AddFireworkBoxCommand (-9316) | [AddFireworkBoxHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/AddFireworkBoxHandler.as) |  |  |  |
| AddMineCommand (14466) | [AddMineHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/AddMineHandler.as) |  |  |  |
| AddOreCommand (147) | [AddOreHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/AddOreHandler.as) |  |  |  |
| AgatusEventBossInfoCommand (-31334) | [AgatusEventBossInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/agatusEvent/AgatusEventBossInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | AgatusEventUIWindowProxy | agatus_event |
| AgatusEventInfoCommand (29551) | [AgatusEventInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/agatusEvent/AgatusEventInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | AgatusEventUIWindowProxy | agatus_event |
| AgatusEventTimeInfoCommand (1555) | [AgatusEventTimeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/agatusEvent/AgatusEventTimeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | AgatusEventUIWindowProxy | agatus_event |
| ArenaStatusCommand (-1736) | [OpenJackpotStatusWindowCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/jackpotBattle/statusWin/control/OpenJackpotStatusWindowCommand.as) |  |  |  |
| ArenaSurvivorsUpdateCommand (18936) | [ArenaStatusReainingPlayerUpdateCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/jackpotBattle/statusWin/control/ArenaStatusReainingPlayerUpdateCommand.as) | UPDATE_REMAINING_PLAYER→JackPotStatusUiMediator |  |  |
| ArmoryUnlockDrawCommand (4642) | [ArmoryUnlockDrawCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/handler/ArmoryUnlockDrawCommandHandler.as) |  |  | armoryUnlockAlert |
| ArmoryUnlockInfoCommand (18999) | [ArmoryUnlockInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/handler/ArmoryUnlockInfoCommandHandler.as) |  | ArmoryUnlockInfoProxy | armoryUnlock |
| AssemblyRecipeContentModule (-1655) | [AssemblyRecipeContentHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AssemblyRecipeContentHandler.as) | INIT→InitAssemblySystemCommand<br>WARP_CONTROLS_UPDATE→WarpControlsUIMediator | AssemblyProxy |  |
| AssemblyRecipeRemoveCommand (-16092) | [AssemblyRecipeRemoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AssemblyRecipeRemoveHandler.as) | INIT→InitAssemblySystemCommand | AssemblyProxy |  |
| AssemblyRecipeStatusUpdateCommand (-29164) | [AssemblyRecipeStatusUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AssemblyRecipeStatusUpdateHandler.as) |  | AssemblyProxy |  |
| AssemblyWindowSettingsModule (-18373) | [AssemblyWindowSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/filter/AssemblyWindowSettingsHandler.as) |  | RecipeUserSettingsFilterProxy, UpgradeTypeUserSettingsFilterProxy |  |
| AssetCreateCommand (-14859) | [AssetCreateHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/assets/AssetCreateHandlerCommand.as) |  |  |  |
| AssetInfoCommand (80) | [AssetInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/assets/AssetInfoHandler.as) | BATTLE_STATION_ASSET_CLICKED→HandleBattleStationAssetClicked<br>UPDATE_BATTLESTATION_VIEW→UpdateBattleStationView<br>UPDATE_BATTLESTATION_MODULE_VIEW→UpdateBattleStationModuleView<br>MAP_ASSET_UPDATE_HP→MapAssetUpdateHp<br>MAP_ASSET_UPDATE_SHIELD→MapAssetUpdateShield |  |  |
| AssetRemoveCommand (3245) | [AssetRemoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/assets/AssetRemoveHandler.as) |  |  |  |
| AsteroidProgressCommand (6002) | [AsteroidProgressCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/AsteroidProgressCommandHandler.as) |  | BattleStationProxy |  |
| AttackAbortLaserCommand (10141) | [AttackAbortLaserHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/AttackAbortLaserHandlerCommand.as) | ABORT_LASER_ATTACK→AbortLaserAttackCommand |  |  |
| AttackHitAssetCommand (5) | [AttackHitAssetHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/AttackHitAssetHandler.as) | MAP_ASSET_UPDATE_HP→MapAssetUpdateHp |  |  |
| AttackHitCommand (28) | [AttackHitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/AttackHitHandler.as) |  |  |  |
| AttackHitNoLockCommand (-1145) | [AttackHitNoLockCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AttackHitNoLockCommandHandler.as) |  |  |  |
| AttackLaserRunCommand (3) | [AttackLaserRunHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/AttackLaserRunHandler.as) |  |  |  |
| AttackMissedCommand (163) | [AttackMissedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/AttackMissedHandler.as) |  |  |  |
| AttackRangeExceededCommand (1059) | [AttackRangeExceededHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/AttackRangeExceededHandler.as) |  |  |  |
| AttributeBoosterUpdateCommand (101) | [AttributeBoosterUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AttributeBoosterUpdateHandler.as) | CREATE→InitBoosterSystemCommand | BoosterProxy |  |
| AttributeOreCountUpdateCommand (106) | [AttributeOreCountUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/attribute/AttributeOreCountUpdateHandler.as) |  |  |  |
| AttributeShieldUpdateCommand (248) | [AttributeShieldUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/attribute/AttributeShieldUpdateHandler.as) |  |  |  |
| AttributeShipSpeedUpdateCommand (96) | [AttributeShipSpeedUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/attribute/AttributeShipSpeedUpdateHandler.as) |  |  | ship |
| AttributeSkillShieldUpdateCommand (103) | [AttributeSkillShieldUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/attribute/AttributeSkillShieldUpdateHandler.as) |  |  |  |
| AudioSettingsModule (271) | [AudioSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/settings/AudioSettingsHandler.as) | PRELOAD_LIST→PreloadListCommand | AudioManager |  |
| AvailableModulesCommand (6001) | [AvailableModulesCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/AvailableModulesCommandHandler.as) |  | BattleStationProxy |  |
| BattlePassInfoCommand (-4678) | [BattlePassInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlePass/BattlePassInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | BattlePassWindowProxy | battle_pass |
| BattlePassKeyExchangeInfoCommand (-24460) | [BattlePassKeyExchangeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlePass/BattlePassKeyExchangeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | BattlePassWindowProxy | battle_pass |
| BattlePassKeyExchangeUpdateCommand (-24325) | [BattlePassKeyExchangeUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlePass/BattlePassKeyExchangeUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | BattlePassWindowProxy | battle_pass |
| BattlePassUpdateStatusCommand (27810) | [BattlePassUpdateStatusCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlePass/BattlePassUpdateStatusCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | BattlePassWindowProxy | battle_pass |
| BattlePassWindowSettingsModule (6392) | [BattlePassWindowSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/filter/BattlePassWindowSettingsHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | BattlePassWindowProxy | battle_pass |
| BattleStationBuildingStateCommand (6003) | [BattleStationBuildingStateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/BattleStationBuildingStateHandler.as) |  | BattleStationProxy |  |
| BattleStationBuildingUiInitializationCommand (6016) | [BattleStationBuildUIInitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/BattleStationBuildUIInitHandler.as) | OPEN_BUILDING_UI_BUBBLE→OpenBuildingUIBubbleCommand | BattleStationProxy |  |
| BattleStationErrorCommand (6012) | [EquipModuleBattleStationErrorHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/EquipModuleBattleStationErrorHandler.as) |  | BattleStationProxy |  |
| BattleStationManagementUiInitializationCommand (6004) | [BattleStationManagementUIInitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/BattleStationManagementUIInitHandler.as) | OPEN_BUILDING_UI_BUBBLE→OpenBuildingUIBubbleCommand | BattleStationProxy |  |
| BattleStationNoClanUiInitializationCommand (6030) | [BattleStationNoClanUiInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/BattleStationNoClanUiInitializationHandler.as) | OPEN_BUILDING_UI_BUBBLE→OpenBuildingUIBubbleCommand |  |  |
| BattleStationStatusCommand (6005) | [BattleStationStatusCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/BattleStationStatusCommandHandler.as) |  | BattleStationProxy |  |
| BeaconCommand (29630) | [BeaconHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/BeaconHandler.as) |  | ProfileProxy | logout |
| Birthday2025GateWindowCommand (-31204) | [DifficultySelectionInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/anniv19/handler/DifficultySelectionInfoHandler.as) | UPDATE→DifficultySelectionMediator |  | difficultySelection |
| Birthday2025PointRewardCommand (2833) | [Birthday2025PointRewardCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/birthdaygate2025/Birthday2025PointRewardCommandHandler.as) |  | BirthdayGate2025Proxy |  |
| BoosterFoundOnMapCommand (187) | [BoosterFoundOnMapHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/BoosterFoundOnMapHandler.as) |  | MapEventsAssembly |  |
| CCInitCommand (-21591) | [CCInitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/ccCommands/control/CCInitHandler.as) |  | CCClientServerCommunicationProxy, CCCommandsProxy, CCCommandsMediator |  |
| CPUInitializationCommand (-3967) | [CpuInitializationCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/CpuInitializationCommand.as) |  | SpaceMapDataProxy, SpaceMapWindowProxy, spaceMapProxy, spaceMapBattleStationIconProxy | spacemap |
| CTBBeaconCapturedCommand (220) | [CTBBeaconCapturedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/capture/CTBBeaconCapturedHandler.as) |  |  |  |
| CTBBeaconPositionCommand (222) | [CTBBeaconPositionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/capture/CTBBeaconPositionHandler.as) |  |  | ctb |
| CTBBeaconReleasedCommand (221) | [CTBBeaconReleasedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/capture/CTBBeaconReleasedHandler.as) |  |  |  |
| CTBMatchStateCommand (219) | [CTBMatchStateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/capture/CTBMatchStateHandler.as) | PRELOAD_LIST→PreloadListCommand |  | ctb |
| CTBScoreUpdateCommand (218) | [CTBScoreUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/capture/CTBScoreUpdateHandler.as) |  |  | ctb |
| CTBSetHomeZonesCommand (198) | [CTBSetHomeZonesHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/capture/CTBSetHomeZonesHandler.as) |  |  |  |
| CameraLockToCoordinatesCommand (2280) | [CameraLockToCoordinatesHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/camera/CameraLockToCoordinatesHandler.as) |  | UserInterfaceAssembly |  |
| CameraLockToHeroCommand (2281) | [CameraLockToHeroHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/camera/CameraLockToHeroHandler.as) |  | UserInterfaceAssembly |  |
| CameraLockToShipCommand (2282) | [CameraLockToShipHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/camera/CameraLockToShipHandler.as) |  | UserInterfaceAssembly |  |
| CannonAttackCommand (14081) | [CannonAttackHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/cannon/CannonAttackHandler.as) |  |  |  |
| CannonUnstableModuleModule (14378) | [UnstableModuleModuleHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UnstableModuleModuleHandler.as) |  | RerollProxy |  |
| CaptchaExplodeCommand (18458) | [CaptchaExplodedCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/captcha/CaptchaExplodedCommandHandler.as) |  |  |  |
| CaptchaResolvedCommand (11117) | [CaptchaResolvedCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/captcha/CaptchaResolvedCommandHandler.as) |  |  |  |
| CaptchaTriggerCommand (11676) | [CaptchaTriggerCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/captcha/CaptchaTriggerCommandHandler.as) | LOG_MESSAGE→LogMessageCommand |  |  |
| ChangeClanFirmaCommand (-7044) | [ChangeClanFirmaCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/controller/ChangeClanFirmaCommandHandler.as) |  |  |  |
| ChannelCloseRequest (260) | [ChannelCloseRequestHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ChannelCloseRequestHandler.as) |  |  |  |
| ChatParamCommand (26607) | [ChatParamCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/controller/ChatParamCommandHandler.as) |  | DOChatProxy |  |
| ChrominUpdateCommand (6247) | [ChrominUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/chrominEvent/ChrominUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ChrominWindowProxy | chrominEvent |
| ClanRelationChangedCommand (24945) | [ClanRelationChangedCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ClanRelationChangedCommandHandler.as) |  |  |  |
| ClanTagChangedCommand (4444) | [ClanTagChangedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ClanTagChangedHandler.as) |  |  |  |
| ClearMarkersCommand (871) | [ClearMarkersHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ClearMarkersHandler.as) |  |  |  |
| CombatMusicCommand (-12650) | [CombatMusicHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/CombatMusicHandler.as) |  |  |  |
| CombatStateCommand (11) | [CombatStateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/combat/CombatStateHandler.as) |  |  |  |
| CommandCenterDontShowInfoCommand (11805) | [CommandCenterDontShowInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/commandCenter/CommandCenterDontShowInfoCommandHandler.as) |  | CommandCenterProxy | command_center |
| CommandCenterInfoCommand (5593) | [CommandCenterInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/commandCenter/CommandCenterInfoHandler.as) |  | CommandCenterProxy | command_center |
| CompanyHierarchyInitializationCommand (6007) | [CompanyHierarchyInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/CompanyHierarchyInitializationHandler.as) |  | CompanyHierarchyProxy |  |
| ContactListBlockInvitationsModule (25806) | [ContactListBlockInvitationsHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListBlockInvitationsHandlerCommand.as) | UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER→ContactsWindowUpdateBlockNotificationsFromServerCommand |  |  |
| ContactListEntryAttributeCommand (26896) | [ContactListUpdateContactAttributesHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListUpdateContactAttributesHandlerCommand.as) | CONTACT_ATTRIBUTES_UPDATE_FROM_SERVER→ContactsWindowContactAttributesUpdateCommand |  |  |
| ContactListEntryModule (7492) | [ContactListEntryModuleHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListEntryModuleHandlerCommand.as) |  |  |  |
| ContactListEntryTypeCommand (4076) | [ContactListUpdateContactTypeHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListUpdateContactTypeHandlerCommand.as) | CONTACT_TYPES_UPDATE_FROM_SERVER→ContactsWindowContactTypesUpdateCommand |  |  |
| ContactListInitializationCommand (17529) | [ContactListInitializationHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListInitializationHandlerCommand.as) | NEW_CONTACTLIST_FROM_SERVER→ContactsWindowNewContactListCommand<br>NEW_FILTERSETTINGS_FROM_SERVER→ContactsWindowNewFilterSettingsFromServerCommand<br>UPDATE_BLOCK_NOTIFICATIONS_FROM_SERVER→ContactsWindowUpdateBlockNotificationsFromServerCommand |  |  |
| ContactListRemoveContactsCommand (-13415) | [ContactListRemoveContactsHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListRemoveContactsHandlerCommand.as) | DELETE_CONTACTS→ContactsWindowDeleteContactsCommand |  |  |
| ContactListUpdateContactsCommand (-22989) | [ContactListUpdateContactsHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactListUpdateContactsHandlerCommand.as) | CONTACTS_UPDATE_FROM_SERVER→ContactsWindowContactsUpdateCommand<br>ADD_HIGHLIGHT→AddItemHighlightCommand | AudioManager | contacts, windows |
| ContactUiUnblockCommand (14139) | [ContactUiUnblockHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/contactlist/ContactUiUnblockHandlerCommand.as) | SERVER_UNBLOCK_RECEIVED→? | ContactsWindowProxy |  |
| CountdownStatusCloseWindowCommand (4715) | [CountdownStatusCloseWindowHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/CountdownStatusCloseWindowHandler.as) |  | FlexWindowManager |  |
| CountdownStatusCommand (4713) | [CountdownStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/CountdownStatusHandler.as) |  | FlexWindowManager | curcubitor |
| CreateMinimapMark (-24639) | [CreateMinimapMarkCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/minimap/CreateMinimapMarkCommand.as) | PLAY_SOUND_TRIGGER_MODULE→PlaySoundTriggerModuleCommand |  |  |
| Curcubitor2019Command (-17717) | [Curcubitor2019InfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/curcubitor2019/Curcubitor2019InfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | Curcubitor2019UIWindowProxy | curcubitor2019 |
| Curcubitor2019TimeUpdateCommand (17829) | [Curcubitor2019TimeUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/curcubitor2019/Curcubitor2019TimeUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | Curcubitor2019UIWindowProxy | curcubitor2019 |
| DesignSetUpdateCommand (18335) | [DesignSetUpdateHander](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/DesignSetUpdateHander.as) |  |  |  |
| DestructionTypeModule (259) | [DestructionTypeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/DestructionTypeHandler.as) |  |  |  |
| DiminishingQuestAcceptQuestResponse (15373) | [DiminishingQuestAcceptQuestResponseHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/diminishingQuest/DiminishingQuestAcceptQuestResponseHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DiminishingQuestUIWindowProxy | diminish_quests |
| DiminishingQuestInitializationCommand (25740) | [DiminishingQuestInitializationCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/diminishingQuest/DiminishingQuestInitializationCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DiminishingQuestUIWindowProxy | diminish_quests |
| DiminishingQuestRemoveQuestCommand (20982) | [DiminishingQuestRemoveQuestCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/diminishingQuest/DiminishingQuestRemoveQuestCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DiminishingQuestUIWindowProxy | diminish_quests |
| DispatchActiveEventCommand (-7114) | [DispatchActiveEventCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchActiveEventCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchUIWindowProxy | dispatch |
| DispatchGetGateListCommand (-17811) | [DispatchGetGateListCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchGetGateListCommandHandler.as) |  | DispatchGateProxy | dispatch_gate |
| DispatchGetRetrieverListCommand (28793) | [DispatchGetRetrieverListCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchGetRetrieverListCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchRetrieverProxy | dispatch_retriever, dispatch |
| DispatchGetRewardPackageCommand (29655) | [DispatchGetRewardPackageCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchGetRewardPackageCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchRetrieverProxy | dispatch_retriever, dispatch |
| DispatchLootMessageCommand (13943) | [DispatchLootMessageCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchLootMessageCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchUIWindowProxy | dispatch |
| DispatchMessageCommand (20921) | [DispatchMessageCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchMessageCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchUIWindowProxy | dispatch |
| DispatchSlotCostCommand (-13901) | [DispatchSlotCostCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchSlotCostCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchRetrieverProxy | dispatch_retriever, dispatch |
| DispatchSlotInfoCommand (12716) | [DispatchSlotInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/dispatch/DispatchSlotInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | DispatchRetrieverProxy | dispatch_retriever, dispatch |
| DisplayOfferCommand (-5491) | [CreateTargetedOffersWindowCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/targetedOffersWindow/controller/CreateTargetedOffersWindowCommand.as) | LOAD_ASSET→LoadAssetCommand | TargetedOfferProxy | targetedOffers |
| DisplaySettingsModule (270) | [DisplaySettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/settings/DisplaySettingsHandler.as) | SETTINGS_WINDOW_FUI_APPLY_SETTINGS_FROM_SERVER→SettingsWindowFUIApplySettingsFromServerCommand |  |  |
| DominationFactionInfluenceUpdateCommand (-21108) | [DominationFactionInfluenceUpdateHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/dominationWindow/controller/netty/DominationFactionInfluenceUpdateHandlerCommand.as) | INIT→InitDominationWindowMVCActorsAsyncCommand | DominationWindowProxy |  |
| DroneFormationAvailableFormationsCommand (258) | [DroneFormationAvailableFormationsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/DroneFormationAvailableFormationsHandler.as) |  |  |  |
| DroneFormationChangeCommand (257) | [DroneFormationChangeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/DroneFormationChangeHandler.as) |  |  |  |
| EmoteActivationCommand (4739) | [EmoteActivationCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/emote/EmoteActivationCommandHandler.as) |  |  |  |
| EmperorSibelonBuffRingCommand (16790) | [EmperorSibelonBuffRingHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/EmperorSibelonBuffRingHandler.as) |  | EffectManager |  |
| EnergyUpdateCommand (-18807) | [EnergyUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/captain/EnergyUpdateHandler.as) |  |  |  |
| EpicFightMessageCommand (-1090) | [EpicFightMessageHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/EpicFightMessageHandler.as) |  | EpicFightMessageProxy |  |
| EquipReadyCommand (-11031) | [EquipReadyCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/hints/EquipReadyCommandHandler.as) | INIT_HINT→InitHintCommand<br>warpWindowMinimize→WarpWindowMediator |  |  |
| EternalBlacklightBoosterInfoCommand (-1587) | [EternalBlacklightBoosterInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightBoosterInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalBlacklightCpuInfoCommand (26307) | [EternalBlacklightCpuInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightCpuInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalBlacklightInfoCommand (31274) | [EternalBlacklightInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalBlacklightRankInfoCommand (10659) | [EternalBlacklightRankInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightRankInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalBlacklightRankingEventInfoCommand (10857) | [EternalBlacklightEventRankInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightEventRankInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalBlacklightSkillPointInfoCommand (-10680) | [EternalBlacklightSkillPointInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightSkillPointInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalBlacklightWaveInfoCommand (-2405) | [EternalBlacklightWaveInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalBlacklight/EternalBlacklightWaveInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalBlacklightUIWindowProxy | eternal_blacklight |
| EternalGateBoosterInfoCommand (-7278) | [EternalGateBoosterInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalGate/EternalGateBoosterInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalGateUIWindowProxy | eternal_gate |
| EternalGateInfoCommand (24808) | [EternalGateInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalGate/EternalGateInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalGateUIWindowProxy | eternal_gate |
| EternalGateKeyInfoCommand (-32107) | [EternalGateKeyInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalGate/EternalGateKeyInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalGateUIWindowProxy | eternal_gate |
| EternalGateRankInfoCommand (2398) | [EternalGateRankInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalGate/EternalGateRankInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalGateUIWindowProxy | eternal_gate |
| EternalGateSkillPointInfoCommand (-17944) | [EternalGateSkillPointInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalGate/EternalGateSkillPointInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalGateUIWindowProxy | eternal_gate |
| EternalGateWaveInfoCommand (682) | [EternalGateWaveInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eternalGate/EternalGateWaveInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EternalGateUIWindowProxy | eternal_gate |
| EventActivationStateCommand (2211) | [EventActivationStateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/EventActivationStateHandler.as) | ADD_EVENT→AddEventCommand | EventProxy, eventProxy |  |
| EventProgressInfoCommand (27897) | [EventProgressInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eventProgress/service/EventProgressInfoCommandHandler.as) |  |  | eventProgress |
| EventProgressUpdateCommand (32320) | [EventProgressUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eventProgress/service/EventProgressUpdateCommandHandler.as) |  | EventProgressProxy | eventProgress |
| EventRewardConfirmationCommand (10623) | [EventRewardsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/eventRewards/EventRewardsHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | EventRewardsWindowProxy | eventRewards |
| EventUpdateCommand (31317) | [ServerEventUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/serverEvents/ServerEventUpdateHandler.as) |  | ServerEventProxy |  |
| ExchangeShopCommand (-29206) | [ExchangeShopCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/exchangeShop/ExchangeShopCommandHandler.as) |  | StrikeAndExitShopProxy | strikeAndExitShop, strikeAndExitVanguardMart |
| ExpeditionBuyTicketCommand (15621) | [ExpeditionBuyTicketHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionBuyTicketHandler.as) |  | JavascriptProxy |  |
| ExpeditionInfoCommand (2200) | [ExpeditionInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionInfoCommandHandler.as) | SEND_NETTY_REQUEST→SendNettyRequest | ExpeditionInfoProxy | expedition |
| ExpeditionJumpLevelInfoCommand (-3749) | [ExpeditionJumpLevelInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionJumpLevelInfoHandler.as) | SHOW_SELECT→ExpeditionSelectMediator |  | expedition_select |
| ExpeditionSelectedShipListCommand (-3201) | [ExpeditionSelectedShipListHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionSelectedShipListHandler.as) | SHOW_SHIPWARP→ExpeditionShipWarpMediator |  | expedition_shipwarp |
| ExpeditionShipListCommand (-19971) | [ExpeditionShipListHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionShipListHandler.as) | SHOW_SHIPHANGER→ExpeditionShipHangarMediator |  | expedition_shiphangar |
| ExpeditionShowUiCommand (4042) | [ExpeditionShowUiHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionShowUiHandler.as) | SEND_NETTY_REQUEST→SendNettyRequest<br>SHOW_CONFIRM→ExpeditionConfirmMediator |  | expedition_confirm |
| ExpeditionStartInstanceCommand (-10149) | [ExpeditionStartInstanceHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionStartInstanceHandler.as) | START_INSTANCE→ExpeditionInfoTabMediator1 |  |  |
| FactionInfluenceUpdateCommand (26033) | [FactionInfluenceUpdateHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/springfight/FactionInfluenceUpdateHandlerCommand.as) | INIT→InitInfluenceSystemCommand | InfluenceWindowProxy |  |
| FrozenLabyrinthInfoCommand (-12606) | [FrozenLabyrinthInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/frozenLabyrinth/FrozenLabyrinthInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | FrozenLabyrinthUIWindowProxy | frozen_labyrinth |
| FrozenLabyrinthKeyInfoCommand (29323) | [FrozenLabyrinthKeyInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/frozenLabyrinth/FrozenLabyrinthKeyInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | FrozenLabyrinthUIWindowProxy | frozen_labyrinth |
| FrozenLabyrinthRankInfoCommand (-20643) | [FrozenLabyrinthRankInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/frozenLabyrinth/FrozenLabyrinthRankInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | FrozenLabyrinthUIWindowProxy | frozen_labyrinth |
| FrozenLabyrinthSynkInfoCommand (-16228) | [FrozenLabyrinthSynkInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/frozenLabyrinth/FrozenLabyrinthSynkInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | FrozenLabyrinthUIWindowProxy | frozen_labyrinth |
| FrozenLabyrinthTimeInfoCommand (10104) | [FrozenLabyrinthTimeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/frozenLabyrinth/FrozenLabyrinthTimeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | FrozenLabyrinthUIWindowProxy | frozen_labyrinth |
| FrozenLabyrinthTopRankerInfoCommand (-15999) | [FrozenLabyrinthTopRankerInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/frozenLabyrinth/FrozenLabyrinthTopRankerInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | FrozenLabyrinthUIWindowProxy | frozen_labyrinth |
| GalaxyGateBuilderBuyLifeCommand (31119) | [GalaxyGateBuilderBuyLifeCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderBuyLifeCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderGateCompleteCommand (-12924) | [GalaxyGateBuilderGateCompleteCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderGateCompleteCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderGateLifeLostCommand (-9602) | [GalaxyGateBuilderGateLifeLostCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderGateLifeLostCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderGateWaveUpdateCommand (21168) | [GalaxyGateBuilderGateWaveUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderGateWaveUpdateCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderGetGatePartsCommand (6297) | [GalaxyGateBuilderGetGatePartsCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderGetGatePartsCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderInfoCommand (-20312) | [GalaxyGateBuilderInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderInfoCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderMultiEnergyCommand (16029) | [GalaxyGateBuilderMultiEnergyCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderMultiEnergyCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GalaxyGateBuilderSetupGateCommand (-10753) | [GalaxyGateBuilderSetupGateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/galaxygatebuilder/GalaxyGateBuilderSetupGateCommandHandler.as) |  | GalaxyGateBuilderProxy | ggBuilder |
| GameplaySettingsModule (273) | [GameplaySettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/settings/GameplaySettingsHandler.as) |  |  |  |
| GroupCloseCommand (18787) | [GroupCloseHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/GroupCloseHandler.as) |  | groupProxy |  |
| GroupErrorCommand (3575) | [GroupErrorHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/GroupErrorHandler.as) | LOG_MESSAGE→LogMessageCommand |  |  |
| GroupInitializationCommand (11796) | [GroupInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/GroupInitializationHandler.as) |  | groupProxy |  |
| GroupMemberInitializationCommand (30950) | [GroupMemberInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/GroupMemberInitializationHandler.as) |  | lockManager, groupProxy |  |
| GroupMemberUpdateCommand (-4047) | [GroupMemberUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/GroupMemberUpdateHandler.as) |  | groupProxy |  |
| HangarShipEquipmentCommand (-22505) | [HangarShipEquipmentCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warpControls/HangarShipEquipmentCommandHandler.as) |  | WarpControlsProxy |  |
| HangarShipMoveItemsCommand (712) | [WarpControlsShipMoveItemsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warpControls/WarpControlsShipMoveItemsHandler.as) | LOG_MESSAGE→LogMessageCommand | WarpControlsProxy |  |
| HangarShipsCommand (6855) | [WarpControlsShipsCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warpControls/WarpControlsShipsCommandHandler.as) |  | WarpControlsProxy |  |
| HealBeamCommand (7779) | [HealBeamHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/HealBeamHandler.as) |  |  |  |
| HellstormAttackCommand (287) | [HellstormAttackHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/HellstormAttackHandler.as) |  | RocketLauncherAssembly |  |
| HeroMoveCommand (29) | [HeroMoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/HeroMoveHandler.as) |  | eventManager |  |
| HintWindowAddComand (4718) | [HintSystemAddAsyncMacroCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/hintSystem/controller/netty/HintSystemAddAsyncMacroCommand.as) |  |  |  |
| HintWindowListInitCommand (-2840) | [HintSystemInitListAsyncMacroCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/hintSystem/controller/netty/HintSystemInitListAsyncMacroCommand.as) |  |  |  |
| HitpointInfoCommand (1300) | [HitpointInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/HitpointInfoHandler.as) |  |  |  |
| HuntEventNotificationCommand (197) | [HuntEventNotificationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/hunt/HuntEventNotificationHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand<br>DESTROY_SIMPLE_WINDOW→DestroySimpleWindowCommand |  | ranked_hunt |
| HuntEventRankingPointsUpdateCommand (194) | [HuntEventRankingPointsUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/hunt/HuntEventRankingPointsUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | AlienHuntUIWindowProxy | ranked_hunt, killUI |
| HuntInfoCommand (-29644) | [HuntInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/hunt/HuntInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | AlienHuntUIWindowProxy | ranked_hunt |
| HuntRewardCommand (-3504) | [HuntRewardCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/hunt/HuntRewardCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | AlienHuntUIWindowProxy | ranked_hunt, killUI |
| InfiltrationStatusCommand (4712) | [InfiltrationStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/InfiltrationStatusHandler.as) |  |  |  |
| InvasionEventInitCommand (223) | [InvasionEventInitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/invasion/InvasionEventInitHandler.as) |  |  | invasion |
| InventoryItemRemovedCommand (-28530) | [InventoryItemRemovedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/items/InventoryItemRemovedHandler.as) |  | InventoryProxy |  |
| InventoryItemUpdatedCommand (23384) | [InventoryItemUpdatedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/items/InventoryItemUpdatedHandler.as) | WARP_CONTROLS_UPDATE→WarpControlsUIMediator | InventoryProxy |  |
| InvitationBlockModule (-5957) | [InvitationBlockHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/InvitationBlockHandler.as) | UPDATE_BLOCK_INVITATION_STATE→GroupSystemMediator |  |  |
| InvitationErrorCommand (4837) | [InvitationErrorHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/InvitationErrorHandler.as) | LOG_MESSAGE→LogMessageCommand | groupProxy |  |
| InvitationInitializationCommand (-11775) | [InvitationInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/InvitationInitializationHandler.as) |  | groupProxy |  |
| InvitationModeModule (-28295) | [InvitationModeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/InvitationModeHandler.as) |  | groupProxy |  |
| InvitationRemovalCommand (-27715) | [InvitationRemovalHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/InvitationRemovalHandler.as) |  | groupProxy |  |
| JackpotArenaMatchResultCommand (9705) | [OpenJackpotArenaMatchResultCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/jackpotBattle/resultWin/control/OpenJackpotArenaMatchResultCommand.as) |  |  |  |
| JoinClanCommand (-10813) | [JoinClanCommHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/controller/JoinClanCommHandler.as) |  |  |  |
| JumpGateRemoveCommand (4274) | [JumpGateRemoveHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/portals/JumpGateRemoveHandlerCommand.as) |  |  |  |
| JumpInitiatedCommand (19) | [ActivatePortalCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/portals/ActivatePortalCommand.as) |  |  |  |
| JumpToServerCommand (20) | [JumpToServerHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/JumpToServerHandler.as) | END_INSTANCE→ExpeditionInfoTabMediator1 |  |  |
| JumpgateCreateCommand (3389) | [JumpgateCreateHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/portals/JumpgateCreateHandlerCommand.as) |  |  |  |
| KillScreenOptionModule (253) | [KillScreenOptionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/KillScreenOptionHandler.as) |  |  |  |
| KillScreenOptionTypeModule (254) | [KillScreenOptionTypeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/KillScreenOptionTypeHandler.as) |  |  |  |
| KillScreenPostCommand (252) | [KillScreenPostHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/KillScreenPostHandler.as) |  |  |  |
| KillScreenRepairRequest (255) | [KillScreenRepairRequestHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/KillScreenRepairRequestHandler.as) |  |  |  |
| KillScreenUpdateCommand (6777) | [KillScreenUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/KillScreenUpdateHandler.as) |  |  |  |
| KillUiCloseMessageCommand (-29812) | [KillUICloseCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/killUI/service/KillUICloseCommandHandler.as) |  |  | killUI |
| KillUiFullMessageCommand (672) | [KIllUIFullMessageCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/killUI/service/KIllUIFullMessageCommandHandler.as) |  | KillUIWindowProxy |  |
| KillUiInfoMessageCommand (9790) | [KillUIMessageCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/killUI/service/KillUIMessageCommandHandler.as) |  | KillUIWindowProxy |  |
| LMCollectResourcesCommand (203) | [LMCollectResourcesHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/logmessage/LMCollectResourcesHandler.as) |  |  |  |
| LMJackpotLeftShipsCommand (199) | [LMJackpotLeftShipsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/jackpot/LMJackpotLeftShipsHandler.as) | LOG_MESSAGE→LogMessageCommand |  |  |
| LabUpdateItemCommand (135) | [LabUpdateItemHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/refinement/LabUpdateItemHandler.as) |  |  |  |
| LeaderChangeCommand (-15967) | [LeaderChangeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/LeaderChangeHandler.as) |  | groupProxy |  |
| LegacyModule (1) | [LegacyModuleHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/LegacyModuleHandler.as) |  |  |  |
| LevelUpCommand (7513) | [LevelUpHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/LevelUpHandler.as) |  |  |  |
| LockAttributeItemListCommand (18518) | [LockAttributeItemListHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/handler/LockAttributeItemListHandler.as) |  | SingularityDriveProxy |  |
| LogMessageCommand (2590) | [LogMessageHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/logmessage/LogMessageHandler.as) | LOG_MESSAGE→LogMessageCommand<br>ADD_GLOBAL_NOTIFICATION_MESSAGE→AddGlobalNotificationMessageCommand |  |  |
| LoginResponse (13922) | [LoginResponseHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/login/LoginResponseHandler.as) | LOG_MESSAGE→LogMessageCommand |  |  |
| MapAddControlPOIZoneCommand (-3030) | [MapAddControlPOIZoneHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/poi/MapAddControlPOIZoneHandler.as) |  | SectorControlProxy |  |
| MapAddPOICommand (-29100) | [MapAddPOIHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MapAddPOIHandler.as) |  | POIAssembly |  |
| MapAssetActionAvailableCommand (6530) | [AssetActionAvailableHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/assets/AssetActionAvailableHandler.as) | CLOSE_WINDOW→DifficultySelectionMediator |  | singularitydrive_difficultyselect |
| MapAssetAddBillboardCommand (3260) | [MapAssetAddBillboardHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/MapAssetAddBillboardHandler.as) |  |  |  |
| MapAssetIconAddHighlightCommand (-5026) | [MapAssetIconAddHighlightHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/mapElements/common/controller/MapAssetIconAddHighlightHandlerCommand.as) | PLAY_SOUND_TRIGGER_MODULE→PlaySoundTriggerModuleCommand |  |  |
| MapAssetIconRemoveHighlightCommand (509) | [MapAssetIconRemoveHighlightHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/mapElements/common/controller/MapAssetIconRemoveHighlightHandlerCommand.as) |  |  |  |
| MapEventOreCommand (143) | [MapEventOreHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mapEvent/MapEventOreHandler.as) |  |  |  |
| MapRemovePOICommand (6676) | [MapRemovePOIHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MapRemovePOIHandler.as) |  | SectorControlProxy, POIAssembly |  |
| MarkPositionCommand (18323) | [MarkPositionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MarkPositionHandler.as) |  |  |  |
| MarkRangeCommand (-23416) | [MarkRangeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MarkRangeHandler.as) |  |  |  |
| MarkTargetCommand (281) | [MarkTargetHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MarkTargetHandler.as) |  | UserInterfaceAssembly, AbilityEffectActivationAssembly |  |
| MemberDestructionCommand (7651) | [MemberDestructionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/MemberDestructionHandler.as) |  |  |  |
| MemberJumpCommand (-31225) | [MemberJumpHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/MemberJumpHandler.as) |  |  |  |
| MemberLeaveCommand (-7923) | [MemberLeaveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/MemberLeaveHandler.as) |  | DOChatProxy, groupProxy |  |
| MenuInitializationCommand (-8140) | [ParseItemsControlMenuDataCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/ParseItemsControlMenuDataCommand.as) | DATA_READY→ItemsControlMenuMediator/MenuBarsMediator | ItemsControlMenuProxy, menuProxy | LAYOUTS_MAP |
| MenuItemCooldownGroupTimerCommand (31268) | [UpdateMenuItemCooldownGroupTimerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/updates/UpdateMenuItemCooldownGroupTimerCommand.as) |  | ItemsControlMenuProxy, ItemsControlMenuMediator, menuProxy |  |
| MenuItemStatusCommand (24049) | [UpdateMenuItemStatusCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/updates/UpdateMenuItemStatusCommand.as) |  | ItemsControlMenuProxy, ItemsControlMenuMediator, menuProxy, assetsProxy |  |
| MenuItemTimerCommand (-12955) | [UpdateMenuItemTimerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/updates/UpdateMenuItemTimerCommand.as) |  | ItemsControlMenuProxy, ItemsControlMenuMediator, menuProxy |  |
| MessageCommand (11445) | [MessageHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MessageHandler.as) |  |  |  |
| MessageGameEventCommand (176) | [MessageGameEventHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/deathmatch/MessageGameEventHandler.as) | LOG_MESSAGE→LogMessageCommand | ContactsWindowProxy |  |
| MessageLocalizedWildcardCommand (47) | [MessageLocalizedWildcardHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MessageLocalizedWildcardHandler.as) |  |  |  |
| MessageQueueModule (249) | [MessageQueueHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MessageQueueHandler.as) |  |  |  |
| MessageWildcardReplacementModule (48) | [MessageWildcardReplacementHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MessageWildcardReplacementHandler.as) |  |  |  |
| MileageMarketBuyCommand (10344) | [MileageMarketBuyCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mileageMarket/MileageMarketBuyCommandHandler.as) |  | JavascriptProxy |  |
| MileageMarketInfoCommand (28789) | [MileageMarketInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mileageMarket/MileageMarketInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MileageMarketUIProxy | mileageMarket |
| MileageMarketInfoUpdateCommand (-16954) | [MileageMarketInfoUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mileageMarket/MileageMarketInfoUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MileageMarketUIProxy | mileageMarket |
| MileageMarketInsufficientResourcesCommand (-15524) | [MileageMarketInsufficientResourcesCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mileageMarket/MileageMarketInsufficientResourcesCommandHandler.as) |  |  | popup_generic_icon_ok |
| MileageMarketPackageUpdateCommand (-24357) | [MileageMarketPackageUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/mileageMarket/MileageMarketPackageUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MileageMarketUIProxy | mileageMarket |
| MiniClientRewardDayInfoCommand (28159) | [MiniClientRewardDayInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/miniClientReward/MiniClientRewardDayInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MiniClientRewardWindowProxy | miniclient_reward |
| MiniClientRewardInfoCommand (3292) | [MiniClientRewardInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/miniClientReward/MiniClientRewardInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MiniClientRewardWindowProxy | miniclient_reward |
| MonthlyDeluxeDayInfoCommand (-14830) | [MonthlyDeluxeDayInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/monthlyDeluxe/MonthlyDeluxeDayInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MonthlyDeluxeWindowProxy | monthly_deluxe |
| MonthlyDeluxeInfoCommand (-7956) | [MonthlyDeluxeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/monthlyDeluxe/MonthlyDeluxeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MonthlyDeluxeWindowProxy | monthly_deluxe |
| MonthlyDeluxeTimeInfoCommand (-12124) | [MonthlyDeluxeTimeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/monthlyDeluxe/MonthlyDeluxeTimeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | MonthlyDeluxeWindowProxy | monthly_deluxe |
| MoveCommand (90) | [MoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/MoveHandler.as) | SEND_COMMAND→SendCommandCommand |  |  |
| NewQuestsAvailableCommand (21500) | [NewQuestsAvailableHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/NewQuestsAvailableHandler.as) |  |  |  |
| NormalTipsCommand (27710) | [NormalTipsCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/NormalTipsCommandHandler.as) |  |  |  |
| NpcEventBossInfoCommand (-7891) | [NpcEventBossInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/npcEvent/NpcEventBossInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | NpcEventUIWindowProxy | npc_event |
| NpcEventInfoCommand (-26622) | [NpcEventInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/npcEvent/NpcEventInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | NpcEventUIWindowProxy | npc_event |
| NpcEventTimeInfoCommand (-1234) | [NpcEventTimeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/npcEvent/NpcEventTimeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | NpcEventUIWindowProxy | npc_event |
| NpcUndockCommand (11902) | [NpcUndockHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/NpcUndockHandler.as) |  |  |  |
| OreTradeInfoCommand (1870) | [OreTradeInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ore/OreTradeInfoHandler.as) |  | PatternManager |  |
| OutOfBattleStationRangeCommand (6015) | [OutOfBattleStationRangeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/OutOfBattleStationRangeHandler.as) | CLOSE_BUILDING_UI_BUBBLE→CloseBuildingUIBubbleCommand | BattleStationProxy |  |
| POIReadyCommand (6677) | [POIReadyHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/POIReadyHandler.as) |  | POIAssembly |  |
| POIVisualModifierCommand (3530) | [POIVisualModifierHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/poi/POIVisualModifierHandler.as) |  | poiManager |  |
| PVPSummerEventFeverInfoCommand (-24527) | [PVPSummerEventFeverInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pvpSummer/PVPSummerEventFeverInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PvpSummerUIWindowProxy | pvp_summer |
| PVPSummerEventInfoCommand (2371) | [PVPSummerEventInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pvpSummer/PVPSummerEventInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PvpSummerUIWindowProxy | pvp_summer |
| PVPSummerEventReputationUpdateCommand (-18578) | [PVPSummerEventReputationUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pvpSummer/PVPSummerEventReputationUpdateCommandHandler.as) |  |  |  |
| PVPSummerEventSelfReputationUpdateCommand (-30100) | [PVPSummerSelfRepUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pvpSummer/PVPSummerSelfRepUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PvpSummerUIWindowProxy | pvp_summer |
| PVPSummerEventShuffleInfoCommand (-5165) | [PVPSummerEventShuffleInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pvpSummer/PVPSummerEventShuffleInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PvpSummerUIWindowProxy | pvp_summer |
| PageRefreshCommand (-25000) | [PageRefreshRequestCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/common/web/controller/PageRefreshRequestCommand.as) |  | JavascriptProxy |  |
| PayloadEscortInfoCommand (-3264) | [PayloadEscortInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/payloadEscort/PayloadEscortInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PayloadEscortUIWindowProxy | payload_escort |
| PayloadEscortKeyInfoCommand (30582) | [PayloadEscortKeyInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/payloadEscort/PayloadEscortKeyInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PayloadEscortUIWindowProxy | payload_escort |
| PayloadEscortScoreCommand (-13432) | [PayloadEscortRunScoreCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/payloadEscort/PayloadEscortRunScoreCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PayloadEscortUIWindowProxy | payload_escort |
| PayloadEscortTimeInfoCommand (6226) | [PayloadEscortTimeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/payloadEscort/PayloadEscortTimeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PayloadEscortUIWindowProxy | payload_escort |
| PetActivationCommand (232) | [PetActivationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetActivationHandler.as) |  |  |  |
| PetBlockUICommand (246) | [PetBlockUIHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetBlockUIHandler.as) |  |  |  |
| PetBuffCommand (239) | [PetBuffHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetBuffHandler.as) |  |  |  |
| PetDeactivationCommand (156) | [PetDeactivationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetDeactivationHandler.as) |  |  |  |
| PetEvasionCommand (228) | [PetEvasionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetEvasionHandler.as) |  |  |  |
| PetExperiencePointsUpdateCommand (159) | [PetExperiencePointsUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetExperiencePointsUpdateHandler.as) |  |  |  |
| PetFuelCargoFullMessage (10597) | [PetFuelCargoFullMessageCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/cargo/PetFuelCargoFullMessageCommand.as) | LOG_MESSAGE→LogMessageCommand |  |  |
| PetFuelUpdateCommand (162) | [PetFuelUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetFuelUpdateHandler.as) |  |  |  |
| PetGearActivationChangeCommand (4943) | [PetGearActivationChangeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/PetGearActivationChangeHandler.as) |  |  |  |
| PetGearAddCommand (234) | [PetGearAddHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetGearAddHandler.as) |  |  |  |
| PetGearLocatorUpdate (237) | [PetGearLocatorUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetGearLocatorUpdateHandler.as) |  |  |  |
| PetGearRemoveCommand (233) | [PetGearRemoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetGearRemoveHandler.as) |  |  |  |
| PetGearResetCommand (235) | [PetGearResetHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetGearResetHandler.as) |  |  |  |
| PetGearSelectCommand (236) | [PetGearSelectHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetGearSelectHandler.as) |  |  |  |
| PetHarvestEffectCommand (241) | [PetHarvestEffectHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetHarvestEffectHandler.as) |  |  |  |
| PetHeatUpdateCommand (-7571) | [PetHeatUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetHeatUpdateHandler.as) |  |  |  |
| PetHeroActivationCommand (155) | [PetHeroActivationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetHeroActivationHandler.as) |  | PetAssembly |  |
| PetHitpointsUpdateCommand (158) | [PetHitpointsUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetHitpointsUpdateHandler.as) |  |  |  |
| PetIdleModeCommand (242) | [PetIdleModeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetIdleModeHandler.as) |  |  |  |
| PetInitializationCommand (229) | [PetInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetInitializationHandler.as) |  |  |  |
| PetIsDestroyedCommand (227) | [PetIsDestroyedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetIsDestroyedHandler.as) |  |  |  |
| PetLaserAttackStopCommand (243) | [PetLaserAttackStopHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetLaserAttackStopHandler.as) |  |  |  |
| PetLevelUpdateCommand (160) | [PetLevelUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetLevelUpdateHandler.as) |  |  |  |
| PetLocatorGearInitializationCommand (166) | [PetLocatorGearInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetLocatorGearInitializationHandler.as) |  |  |  |
| PetOutOfFuelCommand (226) | [PetOutOfFuelHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetOutOfFuelHandler.as) |  |  |  |
| PetPurchasedCommand (231) | [PetPurchasedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetPurchasedHandler.as) |  |  |  |
| PetRepairCompleteCommand (230) | [PetRepairCompleteHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetRepairCompleteHandler.as) |  |  |  |
| PetShieldUpdateCommand (161) | [PetShieldUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetShieldUpdateHandler.as) |  |  |  |
| PetStatusCommand (157) | [PetStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetStatusHandler.as) |  |  |  |
| PetTradeWindowShowCommand (247) | [PetTradeWindowShowHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetTradeWindowShowHandler.as) |  |  |  |
| PetUIRepairButtonCommand (244) | [PetUIRepairButtonHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/pet/PetUIRepairButtonHandler.as) |  |  |  |
| PingCommand (-7327) | [PingHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/group/PingHandlerCommand.as) |  |  |  |
| PlaySoundCommand (-6623) | [PlayGenericSoundCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/common/sounds/controller/PlayGenericSoundCommand.as) |  | AudioManager |  |
| PlayVisualEffectCommand (7872) | [PlayVisualEffectCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/PlayVisualEffectCommandHandler.as) |  | PatternManager |  |
| PlayerInfluenceUpdateCommand (-22034) | [PlayerInfluenceUpdateHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/springfight/PlayerInfluenceUpdateHandlerCommand.as) | INIT→InitInfluenceSystemCommand | InfluenceWindowProxy |  |
| PlayerUpdateCommand (12409) | [PlayerUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/PlayerUpdateHandler.as) | RELATED_DATA_CHANGED→GroupSystemMediator |  |  |
| PlutusInfoCommand (-28603) | [PlutusInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/plutus/PlutusInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PlutusUIWindowProxy | plutus |
| PlutusPointsUpdateCommand (19266) | [PlutusPointsUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/plutus/PlutusPointsUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PlutusUIWindowProxy | plutus |
| PlutusStatusCommand (-16910) | [PlutusStatusCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/plutus/PlutusStatusCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PlutusUIWindowProxy | plutus |
| PopupErrorMessageCommand (9421) | [PopupErrorMessageCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/PopupErrorMessageCommandHandler.as) |  |  | popup_generic_icon_ok |
| PreBlackFridaySalesInfoCommand (-17183) | [PreBlackFridaySalesInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/PreBlackFridaySalesInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PreBlackFridaySalesUIProxy | preBlackFridaySales |
| PublicWorldBossInfoCommand (2610) | [PublicWorldBossInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBossPublic/PublicWorldBossInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | WorldBossUIOverviewProxy, WorldBossUIRewardsProxy | worldBoss_overview, worldBoss_rewards, publicWorldBoss |
| PublicWorldBossRaidCommand (13647) | [PublicWorldBossRaidCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBossPublic/PublicWorldBossRaidCommandHandler.as) |  | WorldBossUIProgressProxy | worldBoss_progress |
| PublicWorldBossRankCommand (8687) | [PublicWorldBossRankCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBossPublic/PublicWorldBossRankCommandHandler.as) |  | WorldBossUIRankingRewardsProxy | worldBoss_ranking_rewards |
| QualitySettingsModule (269) | [QualitySettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/settings/QualitySettingsHandler.as) |  |  |  |
| QuantumFluidCoreDataListCommand (29283) | [QuantumFluidCoreDataListCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/hyperforge/control/QuantumFluidCoreDataListCommandHandler.as) |  | HyperforgeProxy |  |
| QuestCancelledCommand (2006) | [QuestCancelledHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestCancelledHandler.as) |  | questAssembly |  |
| QuestCompletedCommand (2004) | [QuestCompletedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestCompletedHandler.as) |  | _seasonPassMissionProxy, questAssembly, battlePassProxy, seasonPassMissionProxy, TabSpaceSearchMissionsProxy | battle_pass, seasonPass_missions |
| QuestConditionUpdateCommand (2014) | [QuestConditionUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestConditionUpdateHandler.as) |  | QuestProxy, _diminishQuestProxy, _seasonPassMissionProxy, questAssembly, questProxy | battle_pass, seasonPass_missions, diminish_quests |
| QuestFailedCommand (2005) | [QuestFailedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestFailedHandler.as) |  | questAssembly |  |
| QuestGiversAvailableCommand (2345) | [QuestGiversAvailableHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/QuestGiversAvailableHandler.as) |  | QuestProxy, FlexWindowManager |  |
| QuestInfoCommand (2090) | [QuestInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestInfoHandler.as) |  | QuestProxy |  |
| QuestInitializationCommand (2017) | [QuestInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestInitializationHandler.as) |  | questAssembly |  |
| QuestListCommand (2075) | [QuestListHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestListHandler.as) |  | QuestProxy, FlexWindowManager |  |
| QuestPrivilegeCommand (2022) | [QuestPriviligeHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestPriviligeHandler.as) |  | questAssembly |  |
| QuestSettingsModule (7337) | [QuestSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/settings/QuestSettingsHandler.as) | UPDATE_FILTERS_REQUEST→SelectedFiltersChangedCommand<br>UPDATE_FILTER_BUTTONS→QuestGiverWindowMediator |  |  |
| RankRewardCommand (-18128) | [RankRewardCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/RankRewardCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PlutusUIWindowProxy, PvpSummerUIWindowProxy, PayloadEscortUIWindowProxy, EternalGateUIWindowProxy, EternalBlacklightUIWindowProxy | plutus, pvp_summer, payload_escort, eternal_gate, eternal_blacklight, tiered_arena, rogue_lite, titleFrenzy_ranking_rewards, titleFrenzy |
| RefreshSelectedUICategoryCommand (-1859) | [UpdateSelectedCategoryCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/updates/UpdateSelectedCategoryCommand.as) | REFRESH_SELECTED_CATEGORY_ITEMS_BAR→ItemsControlMenuMediator |  |  |
| ReloginCommand (-30607) | [ReloginHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ReloginHandler.as) |  |  |  |
| RemoveCollectableCommand (-6137) | [RemoveCollectableHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/RemoveCollectableHandler.as) |  |  |  |
| RemoveMineCommand (19063) | [RemoveMineHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/RemoveMineHandler.as) |  |  |  |
| RemoveMinimapMark (4195) | [RemoveMinimapMarkCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/minimap/RemoveMinimapMarkCommand.as) |  |  |  |
| RerollWindowSettingsModule (-21113) | [RerollWindowSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/RerollWindowSettingsHandler.as) |  | RerollProxy |  |
| ReturneeLoginBundleBuyCommand (-13061) | [ReturneeLoginBundleBuyCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/returneeLogin/ReturneeLoginBundleBuyCommandHandler.as) |  | JavascriptProxy |  |
| ReturneeLoginBundleInfoCommand (27915) | [ReturneeLoginBundleInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/returneeLogin/ReturneeLoginBundleInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ReturneeLoginBundleProxy | returnee_login_bundle, returnee_login |
| ReturneeLoginInitialRewardClaimableInfoCommand (399) | [ReturneeLoginInitialRewardClaimableInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/returneeLogin/ReturneeLoginInitialRewardClaimableInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ReturneeLoginOverviewProxy | returnee_login_overview |
| ReturneeLoginInitialRewardInfoCommand (-18923) | [ReturneeLoginInitialRewardInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/returneeLogin/ReturneeLoginInitialRewardInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ReturneeLoginOverviewProxy | returnee_login_overview |
| ReturneeLoginRewardDayInfoCommand (16089) | [ReturneeLoginRewardDayInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/returneeLogin/ReturneeLoginRewardDayInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ReturneeLoginCalendarProxy | returnee_login_calendar |
| ReturneeLoginRewardInfoCommand (10175) | [ReturneeLoginRewardInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/returneeLogin/ReturneeLoginRewardInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ReturneeLoginCalendarProxy | returnee_login_calendar, returnee_login |
| RewardContentCommand (-6548) | [RewardContentCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/RewardContentCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | PvpSummerUIWindowProxy, TieredArenaUIWindowProxy | pvp_summer, tiered_arena |
| RogueLiteCashOutCommand (-22050) | [RogueLiteCashOutCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteCashOutCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteCpuInfoCommand (-8355) | [RogueLiteCpuInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteCpuInfoCommandHandler.as) |  | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteDisableEquipCommand (13418) | [RogueLiteDisableEquipCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteDisableEquipCommandHandler.as) |  | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteInfoCommand (-26562) | [RogueLiteInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteInventoryCommand (19867) | [RogueLiteInventoryCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteInventoryCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteRankEventInfoCommand (-8724) | [RogueLiteRankEventInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteRankEventInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteRankInfoCommand (-18627) | [RogueLiteRankInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteRankInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteScoreInfoCommand (-17553) | [RogueLiteScoreInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteScoreInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteSelectRewardCommand (-18395) | [RogueLiteSelectRewardCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteSelectRewardCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RogueLiteUIWindowProxy | rogue_lite |
| RogueLiteSelectShipCommand (-8107) | [RogueLiteSelectShipCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rogueLite/RogueLiteSelectShipCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand<br>MAXIMIZE_WINDOW_BY_ID→GuiMediator | RogueLiteSelectionUIWindowProxy | rogue_lite_selection |
| RzoneStatusCommand (-30853) | [RZoneStatusCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/refractionzoneWindow/comhandlers/RZoneStatusCommandHandler.as) | Init→RZoneInitCommand | RZoneStatusProxy |  |
| SeasonPassCaptainLimitCommand (-4955) | [SeasonPassCaptainLimitCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassCaptainLimitCommandHandler.as) |  |  |  |
| SeasonPassLevelPurchaseCommand (-15205) | [SeasonPassLevelPurchaseCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassLevelPurchaseCommandHandler.as) |  |  | seasonPass_popup_error |
| SeasonPassMissionInfoCommand (-21317) | [SeasonPassMissionInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassMissionInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | SeasonPassUIMissionsProxy | seasonPass_missions, seasonPass |
| SeasonPassRewardClaimCommand (-17601) | [SeasonPassRewardClaimCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassRewardClaimCommandHandler.as) |  | SeasonPassUIRewardsProxy | seasonPass_rewards |
| SeasonPassRewardInfoCommand (-20276) | [SeasonPassRewardInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassRewardInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | SeasonPassUIRewardsProxy | seasonPass_rewards, seasonPass |
| SeasonPassRewardUnclaimedInfoCommand (-8237) | [SeasonPassRewardUnclaimedInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassRewardUnclaimedInfoCommandHandler.as) | SEND_NETTY_REQUEST→SendNettyRequest |  | seasonPass, seasonPass_popup_purchaseLevels, seasonPass_popup_error, seasonPass_popup_buyGoldPass, seasonPass_popup_refresh, seasonPass_popup_seasonEnd |
| SeasonPassStatusCommand (-5303) | [SeasonPassStatusCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassStatusCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | SeasonPassUIProxy, SeasonPassUIRewardsProxy, SeasonPassUIMissionsProxy | seasonPass, seasonPass_rewards, seasonPass_missions |
| SeasonPointsInfoCommand (6987) | [SeasonPointsInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPointsInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | SeasonPassUIProxy | seasonPass |
| SectorControlCaptureParticipationCommand (6678) | [SectorControlCaptureParticipationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/sectorcontrol/SectorControlCaptureParticipationHandler.as) | UPDATE_PROGRESS_BAR_MODEL_SECTOR→UpdateProgressBarParticipationCommand<br>UPDATE_PROGRESS_BAR_MODEL_PROGRESS→UpdateProgressBarProgressCommand | SectorControlProxy |  |
| SectorControlDraftConfirmationCommand (7124) | [SectorControlShowDraftConfirmationDialogCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/controller/SectorControlShowDraftConfirmationDialogCommand.as) |  | FlexWindowManager |  |
| SectorControlErrorCommand (7123) | [SectorControlShowErrorDialogCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/controller/SectorControlShowErrorDialogCommand.as) |  | FlexWindowManager |  |
| SectorControlMatchDetailCommand (527) | [SectorControlUpdateMatchDetailsCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/controller/SectorControlUpdateMatchDetailsCommand.as) |  | SectorControlProxy |  |
| SectorControlMatchOverviewCommand (521) | [SectorControlUpdateMatchesOverviewCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/controller/SectorControlUpdateMatchesOverviewCommand.as) | OPEN_SECTOR_CONTROL_LOBBY_WINDOW→SectorControlShowLobbyWindowAsyncMacroCommand | SectorControlProxy |  |
| SectorControlMatchStateInfoCommand (6667) | [SectorControlMatchStateInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/sectorcontrol/SectorControlMatchStateInfoHandler.as) | INIT→CreateSectorControlUiCommand<br>UPDATE_FACTION_CONTROL_POINT_BONUSSES_MODEL→UpdateSectorControlPointBonussesCommand<br>UPDATE_FACTION_TICKETS_MODEL→UpdateSectorControlTicketsModelCommand<br>UPDATE_FACTION_PLAYERS_MODEL→UpdateSectorControlPlayersModelCommand |  |  |
| SectorControlSectorStateCommand (-27294) | [SectorControlSectorStateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/sectorcontrol/SectorControlSectorStateHandler.as) | UPDATE_PROGRESS_BAR_MODEL_PROGRESS→UpdateProgressBarProgressCommand | SectorControlProxy, poiManager |  |
| ServerChangeCommand (21) | [ServerChangedHandlerCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ServerChangedHandlerCommand.as) |  | ConnectionProxy |  |
| ShipBoostEventBoostInfoCommand (-19749) | [ShipBoostEventBoostInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/shipBoostEvent/ShipBoostEventBoostInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ShipBoostEventWindowProxy | ship_boost_event |
| ShipBoostEventInfoCommand (12398) | [ShipBoostEventInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/shipBoostEvent/ShipBoostEventInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ShipBoostEventWindowProxy | ship_boost_event |
| ShipBoostEventUpdateInfoCommand (-24292) | [ShipBoostEventUpdateInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/shipBoostEvent/ShipBoostEventUpdateInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | ShipBoostEventWindowProxy | ship_boost_event |
| ShipCreateCommand (83) | [ShipCreateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipCreateHandler.as) |  |  |  |
| ShipDeselectionCommand (17) | [ShipDeselectionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipDeselectionHandler.as) |  |  |  |
| ShipDesignAddedCommand (-17887) | [SimpleCommand](../decompiled/main/scripts/org/puremvc/as3/multicore/patterns/command/SimpleCommand.as) |  |  |  |
| ShipDestroyedCommand (30) | [ShipDestroyedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipDestroyedHandler.as) |  |  |  |
| ShipExtensionsCommand (288) | [ShipExtensionsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipExtensionsHandler.as) |  |  |  |
| ShipInitializationCommand (49) | [ShipInitializationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipInitializationHandler.as) | WARP_CONTROLS_UPDATE→WarpControlsUIMediator |  |  |
| ShipRemoveCommand (52) | [ShipRemoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipRemoveHandler.as) |  |  |  |
| ShipSelectionCommand (50) | [ShipSelectionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/ShipSelectionHandler.as) | SHIP_SELECTED→ContactsWindowShipSelectedCommand | GroupProxy |  |
| ShipUpgradeModuleUpdateCommand (-27026) | [ShipUpgradeModuleUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/attribute/ShipUpgradeModuleUpdateHandler.as) |  |  |  |
| ShipWarpCanceledCommand (1010) | [SimpleCommand](../decompiled/main/scripts/org/puremvc/as3/multicore/patterns/command/SimpleCommand.as) |  |  |  |
| ShipWarpCompletedCommand (1001) | [SimpleCommand](../decompiled/main/scripts/org/puremvc/as3/multicore/patterns/command/SimpleCommand.as) |  |  |  |
| ShipWarpModule (293) | [ShipWarpHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warp/ShipWarpHandler.as) |  |  |  |
| ShipWarpNotAllowedCommand (1002) | [ShipWarpNotAllowedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warp/ShipWarpNotAllowedHandler.as) |  |  |  |
| ShipWarpWindowCloseCommand (1011) | [ShipWarpWindowCloseHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warp/ShipWarpWindowCloseHandler.as) | UPDATE_BTNS_SELECTIONS→FeaturesMenuMediator | GuiProxy | ship_warp |
| ShipWarpWindowCommand (291) | [ShipWarpWindowHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/warp/ShipWarpWindowHandler.as) |  | WarpWindowProxy | ship_warp |
| SpaceBallInitializeScoreCommand (190) | [SpaceBallInitializeScoreHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceball/SpaceBallInitializeScoreHandler.as) |  |  |  |
| SpaceBallUpdateScoreCommand (191) | [SpaceBallUpdateScoreHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceball/SpaceBallUpdateScoreHandler.as) |  |  | spaceball |
| SpaceBallUpdateSpeedCommand (192) | [SpaceBallUpdateSpeedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceball/SpaceBallUpdateSpeedHandler.as) |  |  |  |
| SpacePlagueBossSummoningProgressCommand (-6643) | [SpacePlagueBossSummoningProgressHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/SpacePlagueBossSummoningProgressHandler.as) |  | PlagueWindowProxy |  |
| SpacePlagueInfectionStatusCommand (-6245) | [SpacePlagueInfectionStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/SpacePlagueInfectionStatusHandler.as) |  | PlagueWindowProxy |  |
| SpacePlagueRatingStatusCommand (316) | [SpacePlagueRatingStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/SpacePlagueRatingStatusHandler.as) |  | PlagueWindowProxy |  |
| SpacePlagueStatusCommand (6926) | [SpacePlagueStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/SpacePlagueStatusHandler.as) | INIT→InitPlagueSystemCommand | PlagueWindowProxy |  |
| SpaceSearchEventsCommand (-22757) | [SpaceSearchEventsCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceSearch/SpaceSearchEventsCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | SpaceSearchRewardProxy | space_search_reward |
| SpaceSearchInfoCommand (-30954) | [SpaceSearchInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceSearch/SpaceSearchInfoCommandHandler.as) |  | SpaceSearchUIProxy |  |
| SpaceSearchMissionListCommand (-4822) | [SpaceSearchMissionListCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceSearch/SpaceSearchMissionListCommandHandler.as) |  | TabSpaceSearchMissionsProxy |  |
| SpaceSearchSectorRewardsCommand (-10623) | [SpaceSearchSectorRewardsCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceSearch/SpaceSearchSectorRewardsCommandHandler.as) |  | TabSpaceSearchRewardsProxy |  |
| SpaceStationCommand (31556) | [SpaceStationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/SpaceStationHandler.as) |  |  |  |
| StarmapStationCommand (1150) | [StarmapStationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/StarmapStationHandler.as) |  | SpaceMapDataProxy, spaceMapStationIconProxy |  |
| StartCapsuleCollectCommand (18803) | [StartCapsuleCollectHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/StartCapsuleCollectHandler.as) |  |  |  |
| StationModuleModule (6017) | [StationModuleModuleHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/battlestations/StationModuleModuleHandler.as) |  | BattleStationProxy |  |
| StayinAlive (8427) | [StayingAliveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/StayingAliveHandler.as) |  |  |  |
| StopCapsuleCollectCommand (27706) | [StopCapsuleCollectHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/StopCapsuleCollectHandler.as) |  |  |  |
| StrikeAndExitInfoCommand (-17332) | [StrikeAndExitInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/strikeandexit/StrikeAndExitInfoCommandHandler.as) |  | StrikeAndExitOverviewProxy | strikeAndExitOverview |
| StrikeAndExitMapInfoCommand (-4652) | [StrikeAndExitMapInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/strikeandexit/StrikeAndExitMapInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | StrikeAndExitInfoProxy | strikeAndExitInfo |
| StrikeAndExitRemoveScoreCommand (-24105) | [StrikeAndExitRemoveScoreCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/strikeandexit/StrikeAndExitRemoveScoreCommandHandler.as) |  |  | strikeAndExitInfo |
| StrikeAndExitScoreCommand (24793) | [StrikeAndExitScoreCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/strikeandexit/StrikeAndExitScoreCommandHandler.as) |  |  |  |
| SynthesisInventoryCommand (15651) | [CannonSynthesisInventoryCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/synthesis/model/CannonSynthesisInventoryCommandHandler.as) |  | CannonSynthesisProxy |  |
| SynthesisListCommand (17270) | [CannonSynthesisListCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/synthesis/model/CannonSynthesisListCommandHandler.as) |  | CannonSynthesisProxy |  |
| TdmResultCommand (17419) | [TDMResultHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TDMResultHandler.as) | ADD_GLOBAL_NOTIFICATION_MESSAGE→AddGlobalNotificationMessageCommand |  |  |
| TeamDeathMatchDetailCommand (1527) | [TeamDeathMatchDetailHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchDetailHandler.as) |  |  |  |
| TeamDeathMatchDraftConfirmationCommand (19521) | [TeamDeathMatchDraftConfirmationHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchDraftConfirmationHandler.as) | OPEN_PARTICIPATION_POPUP→TeamDeathMatchParticipationPopupMediator |  |  |
| TeamDeathMatchErrorCommand (9131) | [TeamDeathMatchErrorHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchErrorHandler.as) | OPEN_LEVEL_TOO_LOW_POPUP→TeamDeathMatchErrorPopUpMediator<br>OPEN_MATCH_ENDED_POPUP→TeamDeathMatchErrorPopUpMediator<br>OPEN_NO_MATCH_FOR_FACTION_POPUP→TeamDeathMatchErrorPopUpMediator |  |  |
| TeamDeathMatchOverviewCommand (1521) | [TeamDeathMatchOverviewHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchOverviewHandler.as) |  |  |  |
| TeamDeathMatchOverviewInitCommand (2521) | [TeamDeathMatchOverviewInitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchOverviewInitHandler.as) |  |  |  |
| TeamDeathMatchResultScreenCommand (26900) | [TeamDeathMatchResultScreenHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchResultScreenHandler.as) | SHOW→OpenTDMResultWindowAsyncMacroCommand |  |  |
| TeamDeathMatchStatusUpdateCommand (1667) | [TeamDeathMatchStatusUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tdm/TeamDeathMatchStatusUpdateHandler.as) | UPDATE→OpenTdmStatusWindowMacroAsyncCommand/UpdateTdmStatusWindowCommand |  |  |
| TieredArenaEventInfoCommand (24128) | [TieredArenaEventInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tieredArena/TieredArenaEventInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TieredArenaUIWindowProxy | tiered_arena |
| TieredArenaEventReputationUpdateCommand (-25367) | [TieredArenaEventReputationUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tieredArena/TieredArenaEventReputationUpdateCommandHandler.as) |  |  |  |
| TieredArenaEventScheduleInfoCommand (14407) | [TieredArenaEventFeverInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tieredArena/TieredArenaEventFeverInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TieredArenaUIWindowProxy | tiered_arena |
| TieredArenaEventSelfReputationUpdateCommand (2853) | [TieredArenaSelfRepUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tieredArena/TieredArenaSelfRepUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TieredArenaUIWindowProxy | tiered_arena |
| TieredArenaEventTierUpdateCommand (-7443) | [TieredArenaEventTierUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/tieredArena/TieredArenaEventTierUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TieredArenaUIWindowProxy | tiered_arena |
| TitleFrenzyInfoCommand (23966) | [TitleFrenzyInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/titleFrenzy/TitleFrenzyInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TitleFrenzyUIOverviewProxy, TitleFrenzyUIRankingRewardsProxy | titleFrenzy_overview, titleFrenzy_ranking_rewards, titleFrenzy |
| TitleFrenzyOwnerUpdateCommand (-25143) | [TitleFrenzyOwnerUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/titleFrenzy/TitleFrenzyOwnerUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TitleFrenzyUIOverviewProxy | titleFrenzy_overview, titleFrenzy |
| TitleFrenzyRankingInfoCommand (-15662) | [TitleFrenzyRankingInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rankings/TitleFrenzyRankingInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RankingsUIEventsProxy | rankings_events, rankings |
| TitleFrenzyScheduleUpdateCommand (-15423) | [TitleFrenzyScheduleUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/titleFrenzy/TitleFrenzyScheduleUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | TitleFrenzyUIOverviewProxy | titleFrenzy_overview, titleFrenzy |
| TrainingArenaPerformanceEntryCommand (27700) | [TrainingArenaPerformanceEntryHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingArenaPerformanceEntryHandler.as) |  | tgProxy |  |
| TrainingArenaPerformanceInfoCommand (31918) | [TrainingArenaPerformanceInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingArenaPerformanceInfoHandler.as) |  | tgProxy |  |
| TrainingArenaRankInfoCommand (-8718) | [TrainingArenaRankInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingArenaRankInfoHandler.as) |  | tgProxy |  |
| TrainingArenaSeasonInfoCommand (19157) | [TrainingArenaSeasonInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingArenaSeasonInfoHandler.as) |  | tgProxy |  |
| TrainingArenaSeasonRewardEntryCommand (29408) | [TrainingArenaSeasonRewardEntryHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingArenaSeasonRewardEntryHandler.as) |  |  |  |
| TrainingGroundFightInfoCommand (-13847) | [TrainingGroundFightInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingGroundFightInfoHandler.as) | UPDATE_FIGHT_PHASE_INFO→UpdateFightStateCommand |  |  |
| TrainingGroundPlayerCombatStatusInfoCommand (-7356) | [TrainingGroundPlayerCombatStatusInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingGroundPlayerCombatStatusInfoHandler.as) | UPDATE_PARTICIPANT_IN_COMBAT→? |  |  |
| TrainingGroundRemainingTimeToTimeoutCommand (-26058) | [TrainingGroundRemainingTimeToTimeoutHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingGroundRemainingTimeToTimeoutHandler.as) | UPDATE_FIGHT_PHASE_COUNTDOWN→? |  |  |
| TrainingGroundRoundInfoCommand (-1923) | [TrainingGroundRoundInfoHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingGroundRoundInfoHandler.as) | UPDATE_ROUND_NUMBER→? |  |  |
| TrainingGroundStatusCommand (27320) | [TrainingGroundStatusHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/traininggrounds/TrainingGroundStatusHandler.as) | CREATE_WINDOW→CreateTraininggroundsWindowCommand | TraininggroundsProxy |  |
| TrinityTrialsDropLevelCommand (21794) | [TrinityTrialsDropLevelCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/handler/TrinityTrialsDropLevelCommandHandler.as) |  | TrinityTrialsMainProxy |  |
| TrinityTrialsDropLevelOptionalCommand (30148) | [TrinityTrialsDropLevelOptionalCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/handler/TrinityTrialsDropLevelOptionalCommandHandler.as) |  |  |  |
| TrinityTrialsGateWindowCommand (16953) | [TrinityTrialsGateWindowCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/handler/TrinityTrialsGateWindowCommandHandler.as) |  | TrinityTrialsMainProxy |  |
| TrinityTrialsPassCommand (-14347) | [TrinityTrialsPassCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/handler/TrinityTrialsPassCommandHandler.as) |  | TrinityTrialsMainProxy |  |
| TrinityTrialsRewardDescriptionCommand (24874) | [TrinityTrialsRewardDescriptionCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/handler/TrinityTrialsRewardDescriptionCommandHandler.as) |  | TrinityTrialsMainProxy |  |
| UIItemAddHighlightCommand (-29889) | [AddMenuItemHighlightCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/updates/AddMenuItemHighlightCommand.as) | ADD_HIGHLIGHT→AddItemHighlightCommand<br>PLAY_SOUND_TRIGGER_MODULE→PlaySoundTriggerModuleCommand |  | windows |
| UIItemRemoveHighlightCommand (19062) | [RemoveMenuItemHighlightCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/updates/RemoveMenuItemHighlightCommand.as) | REMOVE_HIGHLIGHT→RemoveItemHighlightCommand |  | windows |
| UILayoutCommand (-29223) | [ParseFeaturesMenuData](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/featuresMenu/controller/ParseFeaturesMenuData.as) | DATA_READY→FeaturesMenuMediator<br>CHECK_BOUNDS_AND_SAVE_POS→CheckFeaturesMenuBoundsCommand<br>FEATURE_INIT→FeatureInitCommand | FeaturesMenuProxy, menuProxy | LAYOUTS_MAP |
| UIWindowSettingsCommand (340) | [UIWindowSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UIWindowSettingsHandler.as) |  |  |  |
| UnstableModuleModule (22318) | [UnstableModuleModuleHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UnstableModuleModuleHandler.as) |  | RerollProxy |  |
| UnstableModuleRecycleResultCommand (1810) | [UnstableModuleRecycleResultCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UnstableModuleRecycleResultCommandHandler.as) |  | RerollProxy |  |
| UnstableModuleRestabilizeResultCommand (-17488) | [UnstableModuleRestabilizeResultCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/reroll/control/UnstableModuleRestabilizeResultCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand<br>MAXIMIZE_WINDOW_BY_ID→GuiMediator | RerollResultWindowProxy | reroll_popup |
| UnstableModulesListCommand (-13472) | [UnstableModulesListCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UnstableModulesListCommandHandler.as) |  | RerollProxy |  |
| UnstableModulesShardCommand (-24468) | [UnstableModulesShardCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UnstableModulesShardCommandHandler.as) |  | RerollProxy |  |
| UpdateSpaceSearchKeyCommand (-31102) | [UpdateSpaceSearchKeyCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceSearch/UpdateSpaceSearchKeyCommandHandler.as) | SEND_NETTY_REQUEST→SendNettyRequest |  |  |
| UridiumBankClaimCommand (31718) | [UridiumBankClaimCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/uridiumBank/UridiumBankClaimCommandHandler.as) |  | JavascriptProxy |  |
| UridiumBankInfoCommand (21088) | [UridiumBankInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/uridiumBank/UridiumBankInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | UridiumBankWindowProxy | uridium_bank |
| UserInventoryModule (-13149) | [UserInventoryHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/items/UserInventoryHandler.as) |  | DiscountProxy, InventoryProxy |  |
| UserKeyBindingsUpdate (801) | [UserKeyBindingsUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/UserKeyBindingsUpdateHandler.as) |  | keyboardManager |  |
| UserSettingsCommand (-27265) | [UpdateUserSettingsCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/common/controller/settings/UpdateUserSettingsCommand.as) |  |  |  |
| VIPMerchantExchangeBuyCommand (-25665) | [VIPMerchantExchangeBuyCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/vipMerchantExchange/VIPMerchantExchangeBuyCommandHandler.as) |  | JavascriptProxy |  |
| VIPMerchantExchangeInfoCommand (-19630) | [VIPMerchantExchangeInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/vipMerchantExchange/VIPMerchantExchangeInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | VIPMerchantExchangeUIProxy | vipMerchantExchange |
| VIPMerchantExchangeInsufficientResourcesCommand (-24613) | [VIPMerchantExchangeInsufficientResourcesCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/vipMerchantExchange/VIPMerchantExchangeInsufficientResourcesCommandHandler.as) |  |  | vipMerchantExchange_popup |
| VIPMerchantExchangePackageUpdateCommand (-17447) | [VIPMerchantExchangePackageUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/vipMerchantExchange/VIPMerchantExchangePackageUpdateCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | VIPMerchantExchangeUIProxy | vipMerchantExchange |
| VersionCommand (667) | [VersionHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/VersionHandler.as) |  |  |  |
| VideoWindowCreateCommand (2270) | [VideoWindowCreateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/videowindow/VideoWindowCreateHandler.as) | VideoWindowCreate→VideoWindowCommand |  |  |
| VideoWindowNextPageCommand (2271) | [VideoWindowNextPageHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/videowindow/VideoWindowNextPageHandler.as) | NextStep→VideoWindowCommand |  |  |
| VideoWindowRemoveCommand (2272) | [VideoWindowRemoveHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/videowindow/VideoWindowRemoveHandler.as) | VideoWindowRemove→VideoWindowCommand |  |  |
| VisualModifierCommand (280) | [VisualModifierHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/VisualModifierHandler.as) | RING_EFFECT→BoosterStationEffectCommand | SkillsAssembly, AbilityEffectActivationAssembly, MapEventsAssembly, VisualModifierAssembly |  |
| VoyagersGateWindowCommand (14061) | [SingularityDriveGateWindowCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/handler/SingularityDriveGateWindowCommandHandler.as) |  | SingularityDrivePassProxy | singularitydrive_difficultyselect |
| VoyagersPassCommand (-18932) | [SingularityDrivePassCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/handler/SingularityDrivePassCommandHandler.as) |  | SingularityDrivePassProxy |  |
| WarGameInitLobbyCommand (-31315) | [WarGameInitLobbyHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wargame/WarGameInitLobbyHandler.as) |  | WargameLobbyProxy | wargame_lobby |
| WarGameLobbyStatusModule (7507) | [WarGameLobbyStatusModuleHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wargame/WarGameLobbyStatusModuleHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | WargameLobbyProxy | wargame_lobby |
| WarGameScoreUpdateCommand (25477) | [WarGameScoreUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wargame/WarGameScoreUpdateHandler.as) | CLOSE_WINDOW_BY_ID→GuiMediator<br>CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | WargameEventProxy | wargame_lobby, wargame_event |
| WarGameStatusUpdateCommand (-7158) | [WarGameStatusUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wargame/WarGameStatusUpdateHandler.as) | CLOSE_WINDOW_BY_ID→GuiMediator<br>CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | WargameEventProxy | wargame_lobby, wargame_event |
| WarGameTeamCountUpdateCommand (14497) | [WarGameTeamCountUpdateHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wargame/WarGameTeamCountUpdateHandler.as) | CLOSE_WINDOW_BY_ID→GuiMediator<br>CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | WargameEventProxy | wargame_lobby, wargame_event |
| WindowItemCommand (-5398) | [UpdateWindowItemCommand](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/controller/updates/UpdateWindowItemCommand.as) | TOGGLE_ALL_WINDOWS→ToggleAllWindowsCommand<br>UPDATE_ITEMS_VISIBILITY→UpdateMenuItemsVisibilityCommand<br>UPDATE_BTNS_SELECTIONS→FeaturesMenuMediator |  |  |
| WindowSettingsModule (272) | [WindowSettingsHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/settings/WindowSettingsHandler.as) |  | ItemsControlMenuProxy |  |
| WordPuzzleLetterAchievedCommand (6277) | [WordPuzzleLetterAchievedHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wordpuzzle/WordPuzzleLetterAchievedHandler.as) | wordPuzzleLetterAchieved→WordPuzzleSetLettersCommand |  |  |
| WordPuzzleWindowInitCommand (6278) | [WordPuzzleWindowInitHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/wordpuzzle/WordPuzzleWindowInitHandler.as) | wordPuzzleInitAndWindowCreate→WordPuzzleInitWindowCommand |  |  |
| WorldBossInfoCommand (-721) | [WorldBossInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBoss/WorldBossInfoCommandHandler.as) |  |  |  |
| WorldBossInfoUpdateCommand (26573) | [WorldBossInfoUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBoss/WorldBossInfoUpdateCommandHandler.as) |  |  |  |
| WorldBossRankingInfoCommand (-29839) | [WorldBossRankingInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/rankings/WorldBossRankingInfoCommandHandler.as) | CREATE_SIMPLE_WINDOW→CreateSimpleWindowCommand | RankingsUIEventsProxy | rankings_events, rankings |
| WorldBossRankingRewardsInfoCommand (-8871) | [WorldBossRankingRewardsInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBoss/WorldBossRankingRewardsInfoCommandHandler.as) |  |  |  |
| WorldBossRewardsInfoCommand (20286) | [WorldBossRewardsInfoCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBoss/WorldBossRewardsInfoCommandHandler.as) |  |  |  |
| WorldBossRewardsTierUpdateCommand (22099) | [WorldBossRewardsTierUpdateCommandHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/worldBoss/WorldBossRewardsTierUpdateCommandHandler.as) |  |  |  |

**Handler'ı olmayan 331 "Command" sınıfı** (istemci yok sayar; çoğu porting/* Unity/HTML5 portundan kalma veya başka komutun alt modülü): AbilityStatusFullCommand, AbilityStatusSingleCommand, AchievementEarnedCommand, AchievementEndCommand, AddMapEntityCommand, AdvertisementViableCommand, AmmunitionBuyCommand, AmmunitionEmptyCommand, AmmunitionFallbackCommand, AmmunitionPrizeInfoCommand, AttackRocketCommand, AttributeConfigCountUpdateCommand, AttributeCreditsUpdateCommand, AttributeHitpointUpdateCommand, AttributeLevelUpUpdateCommand, AttributeSkillRepairUpdateCommand, AttributeSpaceUpdateCommand, ClientLoggedInCommand, CollectionBeamStartCommand, CollectionBeamStopCommand, CooldownReachedCommand, CooldownStartedCommand, CPUInfoAimCommand, CPUInfoAutoRocketCommand, CPUInfoAutoRocketLauncherCommand, CPUInfoCloakCommand, CPUInfoHomeJumpCommand, CPUInfoTradeDroneCommand, DebuggingServerShipPositionCommand, DroneRemovedCommand, EternalBlacklightBoosterCommand, EternalGateBoosterCommand, EternalGateSelectionCommand, ExtraInfoCommand, HealCommand, ItemCommand, JumpCPUPowerupStatusCommand, JumpCPUSelectCommand, JumpCPUUpdateCommand, JumpDeniedCommand, SeasonPassRefreshCountCommand, LMBoxCollectionCancelledCommand, LMCollectAmmunitionCommand, LMCollectBankingMultiplierCommand, LMCollectCreditsCommand, LMCollectExperiencePointsCommand, LMCollectHonorPointsCommand, LMCollectLogFilesCommand, LMCollectUridiumCommand, LMColletJackpotCommand, LMDiscountInfoCommand, LMGGEnergyCollectedCommand, LMInvisibilityDetectorInfoCommand, LMItemCollectedCommand, LMLootCollectedCommand, LMMineExplodedCommand, LoginErrorCommand, LogoutCommand, MapChangedCommand, MapEventAttackedObjectOwnedCommand, MapEventAttackedObjectReleasedCommand, MapEventCloakStateCommand, MapEventDroneInfoCommand, MapEventEMPActivationCommand, MapEventEnemyWarningCommand, MapEventInstashieldActivationCommand, MapEventMapTitleUpdateCommand, MapEventSetShipAttackableCommand, MapEventSmartbombExplosionCommand, MapEventTitleUpdateCommand, MenuCategoryInitializationCommand, MenuItemInitializationCommand, MenuItemToolTipReplacementCommand, MessageKeyListWildcardCommand, MessageLocalizedCommand, MessageMapEventCommand, ModuleStatusUpdateCommand, NameChangeCommand, PerformanceTrackingGetCommand, PlayerQueueAlreadyRegisteredCommand, PlayerQueueRegistrationCommand, AchievementInfoCommand, AchievementListCommand, AchievementTitleCommand, AchievementValueCommand, EventANewHopeActionCommand, EventANewHopeContributorCommand, EventANewHopeContributorListCommand, EventANewHopeQuestCommand, EventANewHopeStatusCommand, EventQuestCompletedCommand, EventQuestListCommand, EventReturnOfHeroActionCommand, EventReturnOfHeroContributorCommand, EventReturnOfHeroContributorListCommand, EventReturnOfHeroQuestCommand, EventReturnOfHeroStatusCommand, EventUnityClientRewardQuestCommand, AllowUnityOnlyCommand, ArmoryUnlockClaimCommand, ArmoryUnlockClaimInfoCommand, ArmoryUnlockClaimInfoGroupCommand, ArmoryUnlockLootShowCommand, ArmoryUnlockLootShowListCommand, AuctionBidCommand, AuctionDataCommand, AuctionHistoryCommand, AuctionListCommand, AuctionQuickBuyCommand, AuctionTestCommand, GetNamFlagCommand, UpdateNamFIagCommand, AutopilotInfoCommand, AutopilotInfoSaveCommand, BalanceInfoCommand, BalanceInfoListCommand, BattleStationHistoryInfoCommand, BattleStationHistoryListCommand, BattleStationOverviewInfoCommand, ClanBattleStationInfoCommand, Birthday2025GateRewardCommand, CaptainCommand, CaptainDismissBackCommand, CaptainGetResourcesBackCommand, CaptainPerkCommand, CaptainPerkUpgradLevelCommand, CaptainPerkUpgradLevelCostCommand, CaptainRosterListCommand, CaptainUpdateActiveBackCommand, CaptainUpgradPerkBackCommand, ApplyAcceptCommand, ApplyClanCommand, ApplyDeclineCommand, ChangeClanDescriptionCommand, ChangeClanLeaderCommand, ChangeClanTaxCommand, ClanAddNewsCommand, ClanAllInfoCommand, ClanApplyInfoCommand, ClanApplyInfoListCommand, ClanDeleteAllMessageCommand, ClanDeleteDiploCommand, ClanDeleteMessageCommand, ClanDeleteOpenDiploCommand, ClanDeleteRankCommand, ClanDiploInfoCommand, ClanDiploReqInfoCommand, ClanEditDiploOfferCommand, ClanFilterSearchInfoCommand, ClanInfoCommand, ClanListCommand, ClanMemberInfoCommand, ClanMemberListCommand, ClanMessageInfoCommand, ClanMessageListCommand, ClanNameTagInfoCommand, ClanNewDiplomacyCommand, ClanNewRankCommand, ClanNewsInfoCommand, ClanNewsListCommand, ClanRankInfoCommand, ClanRankListCommand, ClanReportAdminCommand, ClanSearchNameTagCommand, ClanSendAllMessageCommand, ClanSendMessageCommand, ClanTaxInfoCommand, ClanTaxLogCommand, ClanTestCommand, ClearClanCommand, CompanyDateInfoCommand, DelClanCommand, DeleteClanApplyCommand, DeleteClanCommand, DeleteClanMemberCommand, DeleteMyRankCommand, EditClanInfoCommand, EditClanMemberCommand, EditClanRanksCommand, FoundClanCommand, LeaveClanCommand, LoginInitClanCommand, LoginInitMyApplyCommand, NotifyNewDiploCommand, NotifyNewDiploReqCommand, PayoutClanCommand, ShowClanInfoCommand, DailyLoginClaimTodayCommand, DailyLoginRewardDayCommand, EndEventSummaryScoreCommand, EventLootShowCommand, EventPaymentActorCommand, EventSummaryScoreCommand, SpecialEventPaymentActorCommand, UpdateEventSummaryScoreCommand, EvoucherHistoryInfoCommand, EvoucherHistoryListCommand, ExpeditionClearanceTimeCommand, ExpeditionJumpTargetLevelCommand, ExpeditionRankUserInfoCommand, ExpeditionRewardCommand, ExpeditionSelectShipCommand, ExpeditionShipCommand, HallOfFameDataCommand, HallOfFameDataListCommand, HallOfFameTopDataListCommand, HangarShipActivateShipCommand, HangarShipAutoBuyCpuAmmoCommand, HangarShipBriefCommand, HangarShipChangeShipModelCommand, HangarShipClearConfigCommand, HangarShipDetailCommand, HangarShipFavouriteCommand, HangarShipImportConfigCommand, HangarShipLoadConfigCommand, HangarShipRenamePetCommand, HangarShipRepairDroneCommand, HangarShipRepairModuleCommand, HangarShipSaveConfigCommand, HangarShipSellDroneCommand, HangarShipSellItemCommand, HangarShipUnlockSlotCommand, InventoryItemModifyCommand, LockAttributeItemRerollCommand, LogbookDataCommand, LogbookDataListCommand, LotteryEventFlushCommand, LotteryLogCommand, LotteryLogRewardCommand, LotteryRequestCommand, ArgStackCommand, BaseStackCommand, PassEventCommand, InternalPilotBioUpdateResultsCommand, InternalPilotBioUserProfileCommand, ShopItemBuyCommand, ShopItemCommand, ShopItemLevelDataCommand, ShopItemListCommand, ConvertResearchPointsCommand, ResetSkillTreeCommand, SkillTreeInfoCommand, SkillTreeListCommand, UpdateCargoSpaceCommand, UpLevelSkillTreeCommand, SkylabActiveRobotsLeftTimeCommand, SkylabCollectorInfoCommand, SkylabMainViewCommand, SkylabMainViewModuleCommand, SkylabModuleProductivityCommand, SkylabModuleUpgradeCommand, SkylabRobotPriceCommand, SkylabStorageInfoCommand, SkylabStorageOreCommand, SkylabUnifiedReceiptCommand, SkylabViewModuleBackCommand, SkylabXenoInfoCommand, EventCommand, PlanetCommand, SpotLightPositionCommand, SynthesisCostLootCommand, SynthesisGroupCommand, SynthesisModuleCommand, SynthesisModuleListCommand, AbsUserMessageInfoCommand, BlackListAddCommand, BlackListDeleteCommand, BlackListGetCommand, ContactBaseInfoCommand, ContactFriendAcceptTipsCommand, ContactFriendInfoCommand, ContactInvitationInfoCommand, ContactListBlockInvitationsTipsCommand, ContactListCommand, UserMessageAuctionInfoCommand, UserMessageClanInfoCommand, UserMessageDeleteCommand, UserMessageGetTargetCommand, UserMessageInboxListCommand, UserMessageInfoCommand, UserMessageInfoInfoCommand, UserMessageInitCommand, UserMessageLootCommand, UserMessageNewCommand, UserMessageNoteAddCommand, UserMessageNoteDeleteCommand, UserMessageNoteInfoCommand, UserMessageNoteListCommand, UserMessageNoteUpdateCommand, UserMessageOutboxListCommand, UserMessageParentInfoCommand, UserMessageSendCommand, UserMessageSystemInfoCommand, UserMessageTargetInfoCommand, UserMessageUpdateStatusCommand, VoyagersGateStarRewardCommand, QuestListRemoveCommand, QuestListUpdateCommand, RankInfoCommand, SectorControlBonusCommand, SectorControlTicketCountCommand, SettingSetCommand, SettingsOldFlashCommand, ShipSpawnChildSwarmCommand, SlotBarInitializationCommand, SlotInfoCommand, TechActivationCommand, TechDeactivationCommand, TechStatusCommand, TradeReplyCommand, TrainingGroundConfirmationStatusCommand, TrainingGroundFightStatusCommand, TrainingGroundLookingForOpponentStatusCommand, TrainingGroundPreparingForFightStatusCommand, TrainingGroundRegistrationStatusCommand, TrainingGroundRegistrationUnavailableLowGearScoreCommand, TrainingGroundRegistrationUnavailableStatusCommand, TrainingGroundSummingUpStatusCommand, UIArrowCommand, UIButtonActionCommand, UICamLockToCoordinatesCommand, UICamLockToHeroCommand, UICamLockToShipCommand, UIFeatureBarCommand, UILayerAdvertisementCommand, UIMinimapMarkerCommand, UIMinimapNoiseCommand, UIWindowActionCommand, UIWindowBlockModeCommand, UIWindowCreateCommand, UIWindowDestroyCommand

## Ek B — C→S istek → gönderen istemci kodu (otomatik)

Kaynak: `new XRequest(` geçen yerler (ModuleFactory hariç) + gönderen sınıfın kayıtlı olduğu bildirim ve o bildirimi yollayanlar. 315 istek; "—" = main.swf içinde gönderen yok (Flash istemci bu isteği hiç yollamaz).

| İstek (id) | Alanlar | Gönderen (sınıf.fonksiyon) | Tetikleyen bildirim ← kimden |
|---|---|---|---|
| AchievementListRequest (9237) | displayTitleId:int | — |  |
| ActivationRequest (33) | activationTypeValue:short | — |  |
| ActivationStatedRequest (32) | activationType:short, active:bool | — |  |
| AmmunitionBuyRequest (41) | ammunitionType:module, amount:int | — |  |
| ApplyAcceptRequest (12260) | applyId:int | — |  |
| ApplyClanRequest (1657) | clanId:int, message:utf | — |  |
| ApplyDeclineRequest (31508) | applyId:int | — |  |
| ArenaMatchEndRequest (-16461) |  | [JackpotArenaMatchResultUiMEdiator.onRemove](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/jackpotBattle/resultWin/view/JackpotArenaMatchResultUiMEdiator.as) |  |
| ArmoryUnlockClaimRequest (-2172) | index:int | [ArmoryUnlockTab3DataAssigner.sendExchangeRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/tab3/ArmoryUnlockTab3DataAssigner.as) |  |
| ArmoryUnlockDrawRequest (-32404) | count:int, type:int | [ArmoryUnlockTab1Mediator.onExplore01BtnClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/tab1/ArmoryUnlockTab1Mediator.as)<br>[ArmoryUnlockTab1Mediator.onExplore10BtnClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/tab1/ArmoryUnlockTab1Mediator.as)<br>[ArmoryUnlockTab2Mediator.onExplore01BtnClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/tab2/ArmoryUnlockTab2Mediator.as)<br>[ArmoryUnlockTab2Mediator.onExplore10BtnClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/tab2/ArmoryUnlockTab2Mediator.as) |  |
| ArmoryUnlockInfoRequest (15247) |  | [ArmoryUnlockUIMediator.handleFinalContentLoaded](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/ArmoryUnlockUIMediator.as)<br>[ArmoryUnlockUIMediator.tsbChanged](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/ArmoryUnlockUIMediator.as) |  |
| ArmoryUnlockSelectGroupRequest (28987) | group:int | [ArmoryUnlockTab2Mediator.lockSelectedShip](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/armoryUnlock/tab2/ArmoryUnlockTab2Mediator.as) |  |
| AssemblyBuildRequest (3034) | targetItemId:double, amount:double, recipeLootId:utf | [AssemblyWindowMediator.requestBuild](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/assembly/view/AssemblyWindowMediator.as)<br>[UpgradeWindowMediator.handleBuildClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/view/UpgradeWindowMediator.as)<br>[SingularityDriveTabMediator1.onBuildHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/mediator/tab/SingularityDriveTabMediator1.as) |  |
| AssemblyCollectAllRequest (22374) | allRequests:vector | [UpgradeWindowMediator.handleCollectAllClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/view/UpgradeWindowMediator.as) |  |
| AssemblyCollectRequest (-20634) | recipeLootId:utf, targetItemId:double | [AssemblyWindowMediator.requestCollect](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/assembly/view/AssemblyWindowMediator.as)<br>[DisassemblyMediator.handleCollectClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/disassembly/view/DisassemblyMediator.as)<br>[UpgradeWindowMediator.handleCollectClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/view/UpgradeWindowMediator.as)<br>[UpgradeWindowMediator.handleCollectAllClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/view/UpgradeWindowMediator.as)<br>[SingularityDriveTabMediator1.handleCollectClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/mediator/tab/SingularityDriveTabMediator1.as) |  |
| AssemblyRecipeSelectRequest (-24397) | recipeLootId:utf | [AssemblyWindowMediator.handleFirstSelection](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/assembly/view/AssemblyWindowMediator.as) |  |
| AssemblySetFilterRequest (-14495) | assemblyWindowSettingsModule:module, filterType:short | [SaveAssemblyFilterSettingsCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/assembly/control/SaveAssemblyFilterSettingsCommand.as)<br>[SaveDisassemblyFilterSettingsCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/disassembly/control/SaveDisassemblyFilterSettingsCommand.as)<br>[SaveUpgradeFilterSettingsCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/control/SaveUpgradeFilterSettingsCommand.as) | SAVE_ASSEMBLY_FILTER_SETTINGS ← AssemblyWindowMediator<br>SAVE_DISASSEMBLY_FILTER_SETTINGS ← <br>SAVE_UPGRADE_FILTER_SETTINGS ← DisassemblyMediator/UpgradeWindowMediator |
| AssemblySkipRequest (-520) | recipeLootId:utf, targetItemId:double | [UpgradeWindowMediator.handleSkipClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/view/UpgradeWindowMediator.as)<br>[SingularityDriveTabMediator1.handleSkipClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/mediator/tab/SingularityDriveTabMediator1.as) |  |
| AttackAbortLaserRequest (25) |  | [AbortLaserAttackCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/mapElements/common/controller/AbortLaserAttackCommand.as) | ABORT_LASER_ATTACK ← ActivateLaserCommand/ShipManager/AttackAbortLaserHandlerCommand |
| AttackLaserRequest (4) | targetId:int, targetX:int, targetY:int | [MapAssetAttackCommand.startLaserAttack](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/mapElements/common/controller/MapAssetAttackCommand.as) | ATTACK_MAP_ASSET ← ActivateLaserCommand/HitTestResolver |
| AttackRocketRequest (89) | targetId:int, targetX:int, targetY:int | [ActivateRocketCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/keyboardManager/commands/ActivateRocketCommand.as) |  |
| AuctionBidRequest (22621) | lootId:utf, type:utf, price:double | — |  |
| AuctionListRequest (4874) | auctionType:utf | — |  |
| AuctionQuickBuyRequest (24829) | lootId:utf, type:utf | — |  |
| AuctionTestRequest (-11925) | args:vector | — |  |
| AudioSettingsRequest (267) | sound:int, music:int, voice:int, playCombatMusic:bool | [GuiManager.saveAudioSettings](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as) |  |
| AutopilotInfoRequest (21747) |  | — |  |
| AutopilotInfoSaveRequest (-19755) | autopilotInfos:utf | — |  |
| BalanceInfoListRequest (773) | page:int | — |  |
| BattlePassCollectRequest (-4688) |  | [BattlePassUIWindowMediator.handleCollectRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/battlePass/view/BattlePassUIWindowMediator.as) |  |
| BattlePassKeyExchangeRequest (-16874) | exchangeReward:utf | [BattlePassUIWindowMediator.sendClaimRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/battlePass/view/BattlePassUIWindowMediator.as) |  |
| BattlePassSetFilterRequest (-17140) | battlePassWindowSettingsModule:module | [BattlePassUIWindowMediator.saveBattlePassFilterSettings](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/battlePass/view/BattlePassUIWindowMediator.as) |  |
| BattleStationHistoryListRequest (-611) | startIndex:int | — |  |
| Birthday2025ClaimRequest (5351) | rewardLevel:int | [BirthdayGate2025ViewMediator.clickItem](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/birthdaygate2025/view/BirthdayGate2025ViewMediator.as)<br>[BirthdayGate2025ViewMediator.onClickClaimAll](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/birthdaygate2025/view/BirthdayGate2025ViewMediator.as) |  |
| Birthday2025GateEnterRequest (5598) | level:int | [DifficultySelectionMediator.onClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/anniv19/view/DifficultySelectionMediator.as) |  |
| Birthday2025PointRewardRequest (-31954) | openWindow:bool | [BirthdayGate2025Proxy.sendViewInitRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/birthdaygate2025/model/BirthdayGate2025Proxy.as) |  |
| BlackListAddRequest (-10087) | blackUserId:int | — |  |
| BlackListDeleteRequest (10736) | blackUserId:int | — |  |
| BlackListGetRequest (-22343) |  | — |  |
| BuildStationRequest (6006) | battleStationId:int, buildTimeInMinutes:int | [BattleStationProxy.requestBeginBuildBattleStation](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battlestationswindow/model/BattleStationProxy.as) |  |
| CCInitRequest (28898) |  | — |  |
| CCommandRequest (-16209) | attributes:vector, name:utf | [CCHistoryEntry.read](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/ccCommands/model/CCHistoryEntry.as)<br>[CCCRootCommandPanel.listener](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/ccCommands/view/comps/CCCRootCommandPanel.as) |  |
| CaptainActionRequest (11090) | perkId:int, upgradeLevel:int, captainId:int, command:utf | — |  |
| CaptchaCollectRequest (-25837) | index:int | [EventManager.handleMoveComplete](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EventManager.as) |  |
| ChangeClanDescriptionRequest (-25809) | desc:utf | — |  |
| ChangeClanFirmaRequest (5985) | firma:int | — |  |
| ChangeClanLeaderRequest (-6023) | newLeaderId:int | — |  |
| ChangeClanTaxRequest (23774) | tax:int | — |  |
| ChangeLeaderRequest (-1319) | memberId:int | [GroupSystemMediator.handleChangeLeader](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| ChannelCloseRequest (260) | close:bool | [ConnectionManager.portalJump](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ConnectionManager.as) |  |
| ChatAuthenticateUserRequest (18709) | endpointId:utf, language:utf | [DOChatProxy.sendChatDisconnectedAuthentication](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/model/DOChatProxy.as)<br>[DOChatProxy.resendGameSeverAuth](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/model/DOChatProxy.as)<br>[DOChatProxy.onBan](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/model/DOChatProxy.as) |  |
| ClaimUnityClientRewardRequest (19132) | questId:int | — |  |
| ClanAddNewsRequest (-6590) | newsMessage:utf | — |  |
| ClanApplyInfoListRequest (2904) |  | — |  |
| ClanBattleStationInfoRequest (23079) |  | — |  |
| ClanDeleteAllMessageRequest (24495) |  | — |  |
| ClanDeleteDiploRequest (-4889) | diploId:int | — |  |
| ClanDeleteMessageRequest (5478) | messageId:int | — |  |
| ClanDeleteOpenDiploRequest (-10734) | toClanId:int, diploId:int | — |  |
| ClanDeleteRankRequest (-27777) | deleteRankId:int | — |  |
| ClanEditDiploOfferRequest (-5174) | status:utf, diploId:int | — |  |
| ClanFilterSearchRequest (4228) | memberType:int, orderType:int, recruitionType:int, start:int, factionType:int, range:int, lookup:utf, rankType:int, desc:bool | — |  |
| ClanListRequest (-30656) | type:int | — |  |
| ClanMemberListRequest (-18572) |  | — |  |
| ClanMessageListRequest (8404) |  | — |  |
| ClanNewDiplomacyRequest (28149) | diploClanID:int, diploForm:int, diploId:int, status:utf, desc:utf, clanId:int | — |  |
| ClanNewRankRequest (-11351) | newRank:utf | — |  |
| ClanNewsListRequest (28516) |  | — |  |
| ClanRankListRequest (25741) |  | — |  |
| ClanReportAdminRequest (-719) | diploId:int | — |  |
| ClanSearchNameTagRequest (13300) | lookup:utf | — |  |
| ClanSendAllMessageRequest (11037) | msgText:utf, subject:utf | — |  |
| ClanSendMessageRequest (29570) | toUserId:int, subject:utf, msgText:utf | — |  |
| CollectBoxRequest (26) | itemHash:utf, boxX:int, boxY:int, posX:int, posY:int | [EventManager.handleMoveComplete](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EventManager.as) |  |
| CommandCenterGetDontShowRequest (-16975) |  | [CommandCenterMediator.sendCommandCenterGetDontShowRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/commandCenter/view/CommandCenterMediator.as) |  |
| CommandCenterNewsClickedRequest (30716) | eventId:double, newsId:utf | [CommandCenterNewsClickedCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/commandCenter/control/CommandCenterNewsClickedCommand.as)<br>[CommandCenterProxy.internalAdd](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/commandCenter/model/CommandCenterProxy.as) | CONTENT_CLICKED ← CommandCenterMediator |
| CommandCenterNewsInfoRequest (-8448) | newsInfo:vector | [CommandCenterProxy.requestInfo](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/commandCenter/model/CommandCenterProxy.as) |  |
| CommandCenterUpdateDontShowRequest (19653) | inspected:bool | [CommandCenterMediator.sendCommandCenterUpdateDontShowRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/commandCenter/view/CommandCenterMediator.as) |  |
| CompanyHierarchyRequest (6009) |  | [Headquarters.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/homebase/Headquarters.as) |  |
| ConfigChangeRequest (35) | presetId:short | — |  |
| ContactListRequest (1883) | startIndex:int | — |  |
| ContactRequest (13422) | contactRequestType:short, userId:int, userName:utf | [ContactsWindowProxy.inviteSelectedUser](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as)<br>[ContactsWindowProxy.removeSelectedUser](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as)<br>[ContactsWindowProxy.blockSelectedUser](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as)<br>[ContactsWindowProxy.unblockUser](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as)<br>[ContactsWindowProxy.removeOutgoingRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as)<br>[ContactsWindowProxy.acceptPendingRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as)<br>[ContactsWindowProxy.declinePendingRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/model/ContactsWindowProxy.as) |  |
| ConvertResearchPointsRequest (-31223) |  | — |  |
| DailyLoginClaimTodayRequest (-28303) |  | — |  |
| DailyLoginRewardDayRequest (23964) |  | — |  |
| DeflectorShieldStatusChangeRequest (6010) | battleStationId:int, minutes:int | [BattleStationProxy.requestDeactivateDeflector](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battlestationswindow/model/BattleStationProxy.as) |  |
| DelClanRequest (30723) |  | — |  |
| DeleteClanApplyRequest (-9150) | applyId:int | — |  |
| DeleteClanMemberRequest (-14580) | removeUserID:int | — |  |
| DeleteClanRequest (-24284) |  | — |  |
| DeleteMyRankRequest (-24564) |  | — |  |
| DiminishingQuestAcceptQuestRequest (7023) | questId:int, acceptabilityStatus:module | [DiminishingQuestUIWindowProxy.requestAcceptQuest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/diminishingQuest/model/DiminishingQuestUIWindowProxy.as) |  |
| DisassemblyRequest (12941) | recipeLootId:utf, itemId:double | [DisassemblyMediator.handleBuildClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/disassembly/view/DisassemblyMediator.as) |  |
| DispatchBuySlotRequest (28475) |  | [DispatchRetrieverMediator.onClickAddSlot](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/retriever/view/DispatchRetrieverMediator.as) |  |
| DispatchCollectGateRewardRequest (19963) | gateId:short | [DispatchGateListItemAssigner.handleClickCollect](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/gate/view/components/DispatchGateListItemAssigner.as) |  |
| DispatchCollectRetrieverRequest (-2733) | slotId:short | [DispatchRetrieverListItemAssigner.onClickCollectDispatch](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/retriever/view/components/DispatchRetrieverListItemAssigner.as) |  |
| DispatchGetGateListRequest (-24583) |  | [DispatchGateMediator.handleViewActive](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/gate/view/DispatchGateMediator.as) |  |
| DispatchGetRetrieverListRequest (13627) | statusType:short | [DispatchRetrieverMediator.onClickTabButton](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/retriever/view/DispatchRetrieverMediator.as) |  |
| DispatchGetRewardPackageRequest (-31483) | dispatchId:int | [DispatchRetrieverListItemAssigner.onClickShowRewardChancesPopup](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/retriever/view/components/DispatchRetrieverListItemAssigner.as) |  |
| DispatchInstantCompleteRequest (17027) | slotId:short | [DispatchRetrieverMediator.onClickBtnQuickDelivery](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/retriever/view/DispatchRetrieverMediator.as) |  |
| DispatchSendGateRequest (28073) | gateId:short | [DispatchGateMediator.handleHireGate](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/gate/view/DispatchGateMediator.as) |  |
| DispatchSendRetrieverRequest (20576) | dispatchId:int | [DispatchRetrieverMediator.onClickBtnHire](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/dispatch/retriever/view/DispatchRetrieverMediator.as) |  |
| DisplaySettingsRequest (266) | displayPlayerName:bool, displayResources:bool, displayBoxes:bool, displayHitpointBubbles:bool, displayChat:bool, displayDrones:bool, displayCargoboxes:bool, displayPenaltyCargoboxes:bool, showNotOwnedItems:bool, displayWindowBackground:bool, displayMinimapBackground:bool, displayNotifications:bool, preloadUserShips:bool, alwaysDraggableWindows:bool, shipHovering:bool, showSecondQuickslotBar:bool, useAutoQuality:bool, displayUse2d:bool, displaySetting3DqualityAntialias:int, displaySetting3DqualityBackground:int, displaySetting3DqualityEffects:int, displaySetting3DqualityLights:int, displaySetting3DqualityTextures:int, displaySetting3DqualityZones:int, displaySetting3DsizeTextures:int, displaySetting3DtextureFiltering:int, proActionBarEnabled:bool, proActionBarKeyboardInputEnabled:bool, proActionBarAutohideEnabled:bool, displayMyDrones:bool, pixelatedRenderingEnabled:bool | [GuiManager.saveDisplaySettings](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as) |  |
| DropRequest (34) | toDrop:short | — |  |
| EchoRequest (3360) | message:utf | — |  |
| EditClanInfoRequest (-29616) | clanName:utf, clanHp:int, clanTS:utf, newFraction:int, recuritingInfo:int, recruitingStatus:int, clanTag:utf | — |  |
| EditClanMemberRequest (6745) | memberId:int, rankId:int | — |  |
| EditClanRanksRequest (6844) | ranks:vector | — |  |
| EggTriggerRequest (-31527) | eggTriggerType:short | [EasterEggPingManager.checkPingPattern](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EasterEggPingManager.as)<br>[EasterEggEventKeyboardHandler.handle](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/hotkeysHandlers/gameplay/EasterEggEventKeyboardHandler.as)<br>[FireworkBox.fire](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/collectable/FireworkBox.as)<br>[ShipAssembly.checkPacmanEasterEgg](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ShipAssembly.as) |  |
| EmergencyRepairRequest (6011) | battleStationId:int, slotId:int | [BattleStationProxy.requestModuleRepair](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battlestationswindow/model/BattleStationProxy.as) |  |
| EquipModuleRequest (6013) | battleStationId:int, itemId:int, slotId:int, replace:bool | [BattleStationProxy.requestEquipModuleToAsteroid](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battlestationswindow/model/BattleStationProxy.as) |  |
| EternalBlacklightChooseOptionRequest (18974) | choosenOption:int | [EternalBlacklightUIWindowMediator.selectBooster](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eternalBlacklight/view/EternalBlacklightUIWindowMediator.as) |  |
| EternalGateChooseOptionRequest (21881) | choosenOption:int | [EternalGateUIWindowMediator.selectBooster](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eternalGate/view/EternalGateUIWindowMediator.as) |  |
| EventANewHopeActionRequest (-14707) | actionType:short, id:int, exchange:utf | — |  |
| EventProgressCollectRequest (-29981) |  | [EventProgressWindowMediator.handleConfirmationCollectButtonClickEvent](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eventProgress/view/EventProgressWindowMediator.as) |  |
| EventProgressResetRequest (32321) |  | [EventProgressWindowMediator.handleConfirmationResetButtonClickEvent](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eventProgress/view/EventProgressWindowMediator.as) |  |
| EventReturnOfHeroActionRequest (-9814) | actionType:short, exchange:utf, id:int | — |  |
| EvoucherHistoryListRequest (1550) |  | — |  |
| ExchangeShopRequest (7050) | eId:int, eventName:utf, action:short, shopId:utf | [StrikeAndExitShopMediator.refreshData](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/strikeAndExit/root/shop/view/StrikeAndExitShopMediator.as)<br>[StrikeAndExitShopMediator.sendExchangeConfirmationRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/strikeAndExit/root/shop/view/StrikeAndExitShopMediator.as)<br>[StrikeAndExitVanguardMartMediator.refreshData](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/strikeAndExit/root/vanguardMart/view/StrikeAndExitVanguardMartMediator.as)<br>[StrikeAndExitVanguardMartMediator.sendExchangeConfirmationRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/strikeAndExit/root/vanguardMart/view/StrikeAndExitVanguardMartMediator.as) |  |
| ExpeditionActivateShipRequest (-21218) | hangarId:double | [ExpeditionShipWarpMediator.onConfirmClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/mediator/ExpeditionShipWarpMediator.as) |  |
| ExpeditionBackRequest (-1653) |  | [ExpeditionConfirmMediator.onCancelClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/mediator/ExpeditionConfirmMediator.as) |  |
| ExpeditionBuyTicketRequest (-27470) |  | [ExpeditionConfirmMediator.onSubmitClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/mediator/ExpeditionConfirmMediator.as) |  |
| ExpeditionInfoRequest (8991) |  | [ExpeditionInfoCommandHandler.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionInfoCommandHandler.as)<br>[ExpeditionInfoProxy.sendExpeditionInfoRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/model/ExpeditionInfoProxy.as) |  |
| ExpeditionJumpTargetLevelRequest (-19463) | jumpTargetLevel:int | [ExpeditionSelectMediator.onJumpClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/mediator/ExpeditionSelectMediator.as) |  |
| ExpeditionResetRequest (17211) |  | [ExpeditionConfirmMediator.onSubmitClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/mediator/ExpeditionConfirmMediator.as) |  |
| ExpeditionSelectShipRequest (-14686) | hangarId:vector | [ExpeditionShipHangarMediator.onConfirmClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/mediator/ExpeditionShipHangarMediator.as) |  |
| ExpeditionShipListRequest (16736) |  | [Hangar.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/homebase/Hangar.as)<br>[ExpeditionShowUiHandler.run](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/expedition/handler/ExpeditionShowUiHandler.as) |  |
| FollowRequest (12117) | memberId:int | [GroupSystemMediator.handleFlyToMember](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| FoundClanRequest (19714) | clanTag:utf, clanDescription:utf, clanName:utf | — |  |
| GalaxyGateBuilderBuyLifeRequest (30847) | gateId:byte | [GalaxyGateBuilderModel.purchaseGateLife](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as) |  |
| GalaxyGateBuilderGetGatePartsRequest (27618) | gateId:byte | [GalaxyGateBuilderModel.getGateImageRemote](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as) |  |
| GalaxyGateBuilderInfoRequest (-30943) |  | [GalaxyGateBuilderModel.initUserRemote](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as) |  |
| GalaxyGateBuilderMultiEnergyRequest (24604) | spinAmount:byte, useMultiplier:bool, gateId:byte | [GalaxyGateBuilderModel.produceRemote](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as) |  |
| GalaxyGateBuilderSaveSpinAmountRequest (-9432) | spinAmount:byte | [GalaxyGateBuilderModel.saveSpinAmountRemote](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as) |  |
| GalaxyGateBuilderSetupGateRequest (1978) | gateId:byte | [GalaxyGateBuilderModel.prepareJumpRemote](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as) |  |
| GameplaySettingsRequest (265) | autoBoost:bool, autoRefinement:bool, quickslotStopAttack:bool, doubleclickAttack:bool, autoChangeAmmo:bool, autoStart:bool, autoBuyGreenBootyKeys:bool, showBattlerayNotifications:bool, showLowHealthWarning:bool | [GuiManager.saveGameplaySettings](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as) |  |
| GetNamFIagRequest (8408) |  | — |  |
| GroupInvitationBlockToggleRequest (-26820) |  | [GroupSystemMediator.handleInvitationBlockChanged](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| GroupInvitationRequest (3333) | candidateId:int | [ContactsWindowMediator.inviteToGroupClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/contactsWindow/view/ContactsWindowMediator.as) |  |
| GroupMemberSelectRequest (-2023) | targetId:int | [GroupSystemMediator.handleTryToSelectMapAsset](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| HallOfFameDataListRequest (-29656) | requested:short | — |  |
| HallOfFamePagesRequest (-18768) | type:short, page:int | — |  |
| HallOfFameTopRequest (-29300) | type:short | — |  |
| HangarListRequest (-20062) |  | [WarpControlsProxy.sendListRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/warpControls/mode/WarpControlsProxy.as) |  |
| HangarShipActivateShipRequest (-8903) | shipId:double | — |  |
| HangarShipAutoBuyCpuAmmoRequest (-31905) | itemId:double, ammoLootId:utf | — |  |
| HangarShipChangeShipModelRequest (23923) | shipId:double, lootId:utf | — |  |
| HangarShipClearConfigRequest (3923) | wipe:int, configId:int, shipId:double | — |  |
| HangarShipDetailRequest (692) | shipId:double | — |  |
| HangarShipEquipmentRequest (-9516) | shipId:double | [WarpControlsProxy.sendHangarShipEquipmentRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/warpControls/mode/WarpControlsProxy.as) |  |
| HangarShipFavouriteRequest (12147) | favourite:byte, shipId:double | — |  |
| HangarShipImportConfigRequest (21301) | originShipId:double, targetShipId:double | — |  |
| HangarShipLoadConfigRequest (19090) | shipId:double | — |  |
| HangarShipMoveItemsRequest (-22607) | items:vector, source:utf, hangarId:int, destination:utf, droneId:int, index:int, configId:int, slotSet:utf | [WarpControlsProxy.shipsItemMoveRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/warpControls/mode/WarpControlsProxy.as) |  |
| HangarShipRenamePetRequest (7600) | name:utf | — |  |
| HangarShipRepairDroneRequest (4613) | shipId:double, droneId:int | — |  |
| HangarShipRepairModuleRequest (7088) | itemId:double | — |  |
| HangarShipSaveConfigRequest (-6731) | shipId:double | — |  |
| HangarShipSellDroneRequest (-8898) | droneId:double | — |  |
| HangarShipSellItemRequest (21806) | itemList:vector | — |  |
| HangarShipUnlockSlotRequest (1542) | slotset:utf | — |  |
| HarvestRequest (94) | itemHash:utf | [EventManager.handleMoveComplete](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EventManager.as) |  |
| HintWindowClosedRequest (-15966) | closedWindow:module, wasOpenedFromArchive:bool | [HintSystemCloseWindowCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/hintSystem/controller/hintWindow/HintSystemCloseWindowCommand.as) | CLOSE_HINTWINDOW ← HintSystemHintWindowMediator |
| HuntRewardRequest (-2028) | ranking:int, rewardType:short | [AlienHuntUIWindowMediator.loadClanRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/alienHunt/view/AlienHuntUIWindowMediator.as)<br>[AlienHuntUIWindowMediator.loadPlayerRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/alienHunt/view/AlienHuntUIWindowMediator.as) |  |
| InstantRepairRequest (-13736) | repairAssetId:int | [RepairStation.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/homebase/RepairStation.as) |  |
| InternalPilotBioRequest (14848) | userId:double | — |  |
| InternalPilotBioUpdateRequest (26511) | age:int, interest:utf, privacySettingsSkilltree:short, privacySettingsUserInfo:short, month:int, city:utf, privacySettingsMessages:short, day:int, country:utf, userId:double, privacySettingsClan:short, sex:utf, privacySettingsEquipment:short, year:int, contact:utf | — |  |
| InternalPilotBioUpdateStatusRequest (-17772) | statusMessage:utf | — |  |
| InternalPilotBioUpdateUserNameRequest (-10518) | userName:utf | — |  |
| InvitationAcceptRequest (-2962) | inviterId:int | [GroupSystemMediator.handleInvitationAccept](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| InvitationCancelRequest (-29222) | candidateId:int | [GroupSystemMediator.handleInvitationRevoke](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| InvitationCreationRequest (9075) | name:utf | [DOChatMediator.handleGroupInviteRequested](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/chatclient/view/DOChatMediator.as)<br>[GroupSystemMediator.handleInvite](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| InvitationModeRequest (-23588) | mode:module | [GroupSystemMediator.handleInvitationBehaviorChanged](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| InvitationRejectRequest (19983) | inviterId:int | [GroupSystemMediator.handleInvitationReject](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| JumpCPUSelectRequest (37) | mapId:int | — |  |
| JumpCPUUpdateRequest (36) |  | — |  |
| JumpRequest (10) |  | [JumpCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/keyboardManager/commands/JumpCommand.as)<br>[Portal.handleIconClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/Portal.as) |  |
| KeepAlive (2) | MouseClick:bool | [ConnectionManager.handlePingTick](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ConnectionManager.as) |  |
| KickMemberRequest (-11982) | memberId:int | [GroupSystemMediator.handlekickMember](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| KillScreenRepairRequest (255) | selection:module, requestModule:module | [Killscreen.repair](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/windows/components/Killscreen.as) |  |
| LabRefinementRequest (132) | toProduce:module | [RefinementManager.onOkBtn](../decompiled/main/scripts/net/bigpoint/darkorbit/refinement/RefinementManager.as) |  |
| LabUpdateItemRequest (133) | itemToUpdate:module, updateWith:module | [GameClientRefactoringKeyboardHandler.testOreBuffLaser](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/hotkeysHandlers/GameClientRefactoringKeyboardHandler.as)<br>[GameClientRefactoringKeyboardHandler.testOreBuffGen](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/hotkeysHandlers/GameClientRefactoringKeyboardHandler.as)<br>[SourceRefinementModule.onOkCountWindow](../decompiled/main/scripts/net/bigpoint/darkorbit/refinement/SourceRefinementModule.as) |  |
| LabUpdateRequest (137) |  | [RefinementManager.refreshItemList](../decompiled/main/scripts/net/bigpoint/darkorbit/refinement/RefinementManager.as) |  |
| LeaveClanRequest (-25070) |  | — |  |
| LeaveGroupRequest (11779) |  | [GroupSystemMediator.handleleaveGroup](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| LockAttributeItemRerollRequest (25491) | targetItemId:double, lockIndexList:vector | [SingularityDriveTabMediator2.onRerollHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/mediator/tab/SingularityDriveTabMediator2.as) |  |
| LogBoxInformationRequest (32545) | length:int, clipSize:utf, quality:int, endian:utf, classId:int, pixelColor:int, adler32Checksum:int, crc32Checksum:int, typeId:int | — |  |
| LogbookDataListRequest (-23737) | startIndex:int | — |  |
| LoginInitClanRequest (-7006) |  | — |  |
| LoginRequest (7) | userID:int, factionID:short, sessionID:utf, version:utf, instanceId:int, isMiniClient:bool | [KillScreenRepairRequest.KillScreenRepairRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/com/module/KillScreenRepairRequest.as)<br>[ConnectionManager.sendLoginRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ConnectionManager.as) |  |
| LogoutCancelRequest (15) |  | [GuiManager.cancelLogout](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as) |  |
| LotteryRequest (-14383) | quantity:int | — |  |
| MapAssetActivationRequest (6587) | mapAssetId:int | [DefaultClickIconEntityAction.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/traits/clickIcon/action/DefaultClickIconEntityAction.as)<br>[BattleStation.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battleStation/BattleStation.as) |  |
| MenuActionRequest (8766) | actionType:short, sourceType:short, menuItemId:utf | [SendHotKeyActionRequestCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/requests/SendHotKeyActionRequestCommand.as)<br>[SendMenuActionRequestCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/requests/SendMenuActionRequestCommand.as) | SEND_HOT_KEY_ACTION_REQUEST ← ActivatePremiumSlotCommand/ActivateSlotCommand<br>SEND_MENU_ACTION_REQUEST ← ItemsControlMenuMediator |
| MileageMarketEventBuyRequest (3885) |  | [MileageMarketUIMediator.onBuyBtnClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/mileageMarket/view/MileageMarketUIMediator.as) |  |
| MileageMarketExchangeRequest (-5333) | packageId:utf, claimedDiscountSteps:int | [MileageMarketUIMediator.sendApplyConfirmationRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/mileageMarket/view/MileageMarketUIMediator.as) |  |
| MileageMarketPackageBuyRequest (-11778) | packageId:utf | [MileageMarketUIMediator.sendBuyRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/mileageMarket/view/MileageMarketUIMediator.as) |  |
| MiniClientRewardClaimRequest (13545) |  | [MiniClientRewardMediator.handleClaimReward](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/miniClientReward/view/MiniClientRewardMediator.as) |  |
| MonthlyDeluxeClaimRequest (19242) |  | [MonthlyDeluxeMediator.handleClaimReward](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/monthlyDeluxe/view/MonthlyDeluxeMediator.as) |  |
| MoveRequest (82) | positionX:int, targetY:int, targetX:int, positionY:int | [EventManager.queueMoveRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EventManager.as) |  |
| OfferRequest (5390) | packageName:utf, acceptedOffer:bool | — |  |
| PayoutClanRequest (-30116) | reason:utf, amount:int, payoutUserId:int | — |  |
| PerformanceTrackingSendInfoRequest (150) | version:utf, fps:int, memoryUsage:int, optionalPerformanceValues:vector | — |  |
| PetGearActivationRequest (154) | gearTypeToActivate:module, optParam:short | [PetWindowAssembly.requestGearActivation](../decompiled/main/scripts/net/bigpoint/darkorbit/net/PetWindowAssembly.as) |  |
| PetRequest (153) | petRequestType:short | [PetAssembly.sendPetRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/net/PetAssembly.as)<br>[PetWindowAssembly.sendPetRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/net/PetWindowAssembly.as) |  |
| PingMemberRequest (28238) | memberId:int | [GroupSystemMediator.handlePingMember](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/groupsystem/view/GroupSystemMediator.as) |  |
| PingPositionRequest (7747) | x:int, y:int | [EventManager.onMouseDown](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EventManager.as)<br>[MinimapMediator.handleMapClick](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/minimap/MinimapMediator.as) |  |
| ProActionBarOpenStateChangeRequest (12937) | proActionBarOpened:bool | [MenuBarsMediator.proActionBarToggleHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/view/MenuBarsMediator.as) |  |
| PublicWorldBossRequest (-23921) | action:int | [WorldBossUIMediator.?](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/worldBoss/root/WorldBossUIMediator.as) |  |
| QualitySettingsRequest (264) | qualityAttack:short, qualityBackground:short, qualityPresetting:short, qualityCustomized:bool, qualityPOIzone:short, qualityShip:short, qualityEngine:short, qualityExplosion:short, qualityCollectables:short, qualityEffect:short | [GuiManager.saveQualitySettings](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as) |  |
| QuantumFluidCoreRequest (-29807) | ItemId:double, type:short | [HyperforgeWindowMediator.handleForge](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/hyperforge/view/HyperforgeWindowMediator.as)<br>[HyperforgeWindowMediator.handleRecycleOk](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/hyperforge/view/HyperforgeWindowMediator.as) |  |
| QuestAcceptRequest (2035) | questId:int | [QuestProxy.sendAcceptQuestRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/questWindow/model/QuestProxy.as) |  |
| QuestCancelRequest (2024) | questId:int | [QuestManager.cancelQuestCallback](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/QuestManager.as)<br>[QuestProxy.sendAbortQuestRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/questWindow/model/QuestProxy.as) |  |
| QuestGiverApproachedRequest (3350) | questGiverId:int | [QuestGiver.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/homebase/QuestGiver.as) |  |
| QuestGiverWindowClosedRequest (-27219) | questGiverId:int | [QuestGiverWindowMediator.handleViewRemoveEvent](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/questWindow/view/QuestGiverWindowMediator.as) |  |
| QuestInfoRequest (2073) | questId:int | [QuestProxy.requestDetailedQuestInfo](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/questWindow/model/QuestProxy.as) |  |
| QuestListRequest (2074) |  | [QuestProxy.tryToPopulateQuestGiverWindow](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/questWindow/model/QuestProxy.as) |  |
| QuestPrivilegeRequest (2023) | questId:int | [QuestManager.removeQuest](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/QuestManager.as)<br>[QuestDotList.onClickPrivilege](../decompiled/main/scripts/net/bigpoint/darkorbit/questfm/QuestDotList.as) |  |
| QuestSettingsRequest (-20925) | unattemptedFilter:bool, unavailableFilter:bool, completedFilter:bool, availableFilter:bool, inLevelRangeFilter:bool, attemptedFilter:bool | [QuestGiverWindowMediator.handleFiltersChanged](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/questWindow/view/QuestGiverWindowMediator.as) |  |
| RankRewardRequest (-4475) | ranking:int, rankType:short | [EternalBlacklightUIWindowMediator.loadRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eternalBlacklight/view/EternalBlacklightUIWindowMediator.as)<br>[EternalGateUIWindowMediator.loadRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/eternalGate/view/EternalGateUIWindowMediator.as)<br>[PayloadEscortUIWindowMediator.loadRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/payloadEscort/view/PayloadEscortUIWindowMediator.as)<br>[PlutusUIWindowMediator.loadRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/plutus/view/PlutusUIWindowMediator.as)<br>[PvpSummerUIWindowMediator.loadRepRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/pvpSummer/view/PvpSummerUIWindowMediator.as)<br>[PvpSummerUIWindowMediator.loadRepPerKillRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/pvpSummer/view/PvpSummerUIWindowMediator.as)<br>[RogueLiteUIWindowMediator.onHoverRankRewardInfoBtn](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/roguelite/view/RogueLiteUIWindowMediator.as)<br>[TieredArenaUIWindowMediator.loadRepRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/tieredArena/view/TieredArenaUIWindowMediator.as)<br>[TitleFrenzyUIRankingRewardsMediator.onHoverRankingRewardInfoBtn](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/titleFrenzy/rankingRewards/view/TitleFrenzyUIRankingRewardsMediator.as) |  |
| RankingsEventsInfoRequest (-13945) | rankType:short | [RankingsUIEventsMediator.sendUpdateDataRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/rankings/events/root/view/RankingsUIEventsMediator.as) |  |
| ReadyRequest (14) | readyTypeStr:utf, readyType:short | [ConnectionManager.sendReadyUI](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ConnectionManager.as)<br>[ConnectionManager.sendMapLoadedRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ConnectionManager.as) |  |
| RerollWindowSettingsRequest (-26179) | rerollWindowSettingsModule:module | [RerollWindowMediator.handleSaveConfirmationPopup](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/reroll/view/RerollWindowMediator.as) |  |
| ResetSettingsRequest (343) |  | [SettingsWindowDecorator.handleConfirmResetSettingsButtonClick](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/SettingsWindowDecorator.as)<br>[SettingsWindowFUIMediator.handleConfirmResetSettingsButtonClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/settingsFUI/view/SettingsWindowFUIMediator.as) |  |
| ResetSkillTreeRequest (-21035) |  | — |  |
| ReturneeLoginBundleBuyRequest (-10262) | packageId:utf | [ReturneeLoginBundleMediator.onBuyBtnClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/returneelogin/bundle/view/ReturneeLoginBundleMediator.as) |  |
| ReturneeLoginHideUIItemRequest (30608) |  | [ReturneeLoginBundleMediator.endFeature](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/returneelogin/bundle/view/ReturneeLoginBundleMediator.as)<br>[ReturneeLoginCalendarMediator.endFeature](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/returneelogin/calendar/view/ReturneeLoginCalendarMediator.as) |  |
| ReturneeLoginRewardClaimRequest (-10357) | isClaimDaily:bool | [ReturneeLoginCalendarMediator.onClaimBtnClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/returneelogin/calendar/view/ReturneeLoginCalendarMediator.as)<br>[ReturneeLoginOverviewMediator.onClaimBtnClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/returneelogin/overview/view/ReturneeLoginOverviewMediator.as) |  |
| RewardContentRequest (-31241) | rewardType:short | [PvpSummerUIWindowMediator.loadNextMilestoneRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/pvpSummer/view/PvpSummerUIWindowMediator.as)<br>[TieredArenaUIWindowMediator.loadRepParticipationRewards](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/tieredArena/view/TieredArenaUIWindowMediator.as) |  |
| RogueLiteChangeEquipmentRequest (18935) | modifiedItemIds:vector | [RogueLiteUIWindowMediator.onInventorySaveClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/roguelite/view/RogueLiteUIWindowMediator.as) |  |
| RogueLiteSelectRewardRequest (-4336) | lootId:utf | [RogueLiteUIWindowMediator.onRewardSelected](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/roguelite/view/RogueLiteUIWindowMediator.as) |  |
| RogueLiteSelectShipRequest (12101) | loadoutId:utf | [RogueLiteSelectionUIWindowMediator.selectLoadout](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/roguelite/view/RogueLiteSelectionUIWindowMediator.as) |  |
| RzoneCancelRequest (-27327) |  | [RZoneStatusWindowMediator.handleConfirmationNoClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/refractionzoneWindow/view/RZoneStatusWindowMediator.as) |  |
| RzoneCancelSignUpRequest (15435) |  | [RZoneStatusWindowMediator.handleRegisterCancelClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/refractionzoneWindow/view/RZoneStatusWindowMediator.as) |  |
| RzoneConfirmRequest (-31070) |  | [RZoneStatusWindowMediator.handleConfirmationYesClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/refractionzoneWindow/view/RZoneStatusWindowMediator.as) |  |
| RzoneLeaveMapRequest (21559) |  | [RZoneStatusWindowMediator.handleLeaveClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/refractionzoneWindow/view/RZoneStatusWindowMediator.as) |  |
| RzoneSignUpRequest (10716) |  | [RZoneStatusWindowMediator.handleRegisterClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/refractionzoneWindow/view/RZoneStatusWindowMediator.as) |  |
| SeasonPassLevelPurchaseRequest (-20579) | amount:int | [SeasonPassUIPurchaseLevelsMediator.onUpgradeClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/seasonPass/purchaseLevels/SeasonPassUIPurchaseLevelsMediator.as) |  |
| SeasonPassRefreshRequest (-12901) | questId:int, costType:short | [SeasonPassMissionItemAssigner.onRefreshMission](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/seasonPass/missions/view/component/SeasonPassMissionItemAssigner.as)<br>[SeasonPassRefreshConfirmMediator.reroll](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/seasonPass/refreshMissions/SeasonPassRefreshConfirmMediator.as) |  |
| SeasonPassRewardClaimAllRequest (18132) | spcId:int | [SeasonPassUIRewardsMediator.onClickClaimAll](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/seasonPass/rewards/view/SeasonPassUIRewardsMediator.as)<br>[SeasonPassRewardUnclaimedInfoCommandHandler.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/seasonPass/SeasonPassRewardUnclaimedInfoCommandHandler.as) |  |
| SeasonPassRewardClaimRequest (8899) | level:int, extGoldPass:bool, goldPass:bool | [SeasonPassUIRewardsMediator.onClickClaim](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/seasonPass/rewards/view/SeasonPassUIRewardsMediator.as) |  |
| SectorControlDraftConfirmationRequest (7125) | accepted:bool | [SectorControlDraftConfirmationPopUpMediator.sendDraftConfirmationRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/components/popups/SectorControlDraftConfirmationPopUpMediator.as) |  |
| SectorControlMatchDetailRequest (524) | matchId:int | [SectorControlLobbyWindowMediator.handleItemListSelectionChanged](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/SectorControlLobbyWindowMediator.as) |  |
| SectorControlMatchExitRequest (6521) |  | [SectorControlLeaveGamePopUpMediator.handleOKButtonClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/components/popups/SectorControlLeaveGamePopUpMediator.as) |  |
| SectorControlMatchJoinRequest (525) | matchId:int | [SectorControlLeaveQueuePopUpMediator.handleOKButtonClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/components/popups/SectorControlLeaveQueuePopUpMediator.as)<br>[SectorControlLobbyWindowMediator.joinMatch](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/SectorControlLobbyWindowMediator.as) |  |
| SectorControlMatchLeaveQueueRequest (5255) |  | [SectorControlLobbyWindowMediator.leaveMatch](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/SectorControlLobbyWindowMediator.as) |  |
| SectorControlMatchOverviewRequest (520) |  | [SectorControlEnterPoint.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControl/map/SectorControlEnterPoint.as)<br>[SectorControlLobbyWindowMediator.handleSendMatchOverviewRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/sectorControlWindow/view/SectorControlLobbyWindowMediator.as) |  |
| SettingRemoveRequest (87) | key:utf, immediately:bool | — |  |
| SettingSetRequest (84) | key:utf, value:utf, immediately:bool | — |  |
| ShipSelectRequest (165) | targetId:int, targetX:int, targetY:int, posX:int, posY:int, clickX:int, clickY:int, radius:int | [TryToSelectMapAssetCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/mapElements/common/controller/TryToSelectMapAssetCommand.as) | TRY_TO_SELECT_MAPASSET ← HitTestResolver |
| ShipWarpRequest (290) | shipId:int | [WarpWindowMediator.handleConfirmButtonClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/warp/view/WarpWindowMediator.as) |  |
| ShopItemBuyRequest (17210) | lootId:utf, category:utf, level:utf, buyCategory:utf, amount:int, action:utf, petName:utf | — |  |
| ShopItemListRequest (9325) | category:utf | — |  |
| ShowClanInfoRequest (1670) | clanId:int | — |  |
| SkillTreeListRequest (-6951) |  | — |  |
| SkylabActionRequest (26206) | countEndurium:int, countPromerium:int, countDuranium:int, countSeprom:int, construction:utf, countTerbium:int, countXenomit:int, transportMode:utf, subaction:utf, countPrometid:int, countPrometium:int | — |  |
| SkylabPurchaseRobotRequest (-27491) | construction:utf, robotType:int | — |  |
| SkylabViewModuleRequest (-15147) | moduleName:utf | — |  |
| SlotBarConfigSetRequest (32104) | slotIdTo:int, menuItemId:utf, slotBarIdFrom:utf, slotIdFrom:int, slotBarIdTo:utf | [SendSlotBarConfigSetRequestCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/itemsControlMenu/controller/requests/SendSlotBarConfigSetRequestCommand.as) | SEND_SLOT_BAR_CONFIG_REQUEST ← ItemsControlMenuMediator |
| SpaceSearchRequest (1558) | id:int, action:short, count:int | [FeatureInitCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/common/controller/FeatureInitCommand.as)<br>[TabSpaceSearchMissionsMediator.refreshData](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/spaceSearch/objectives/missions/TabSpaceSearchMissionsMediator.as)<br>[TabSpaceSearchRewardsMediator.refreshData](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/spaceSearch/objectives/rewards/TabSpaceSearchRewardsMediator.as)<br>[TabSpaceSearchRewardsMediator.sendExchangeRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/spaceSearch/objectives/rewards/TabSpaceSearchRewardsMediator.as)<br>[SpaceSearchUIMediator.explore_btn_click](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/spaceSearch/ui/SpaceSearchUIMediator.as)<br>[SpaceSearchUIMediator.serverNotification](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/spaceSearch/ui/SpaceSearchUIMediator.as)<br>[UpdateSpaceSearchKeyCommandHandler.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/spaceSearch/UpdateSpaceSearchKeyCommandHandler.as) | FEATURE_INIT ← ParseFeaturesMenuData |
| StrikeAndExitInfoRequest (-17444) |  | [StrikeAndExitOverviewMediator.?](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/strikeAndExit/root/overview/view/StrikeAndExitOverviewMediator.as) |  |
| SummonNPCRequest (9826) | amount:int, npcTypeString:utf | — |  |
| SynthesisInventoryRequest (23219) |  | [CannonSynthesisProxy.sendInitInventoryRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/synthesis/model/CannonSynthesisProxy.as) |  |
| SynthesisItemRequest (-722) | synthesisId:utf, itemIds:vector | [CannonSynthesisViewMediator.sendUpgradeRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/synthesis/ui/CannonSynthesisViewMediator.as) |  |
| TeamDeathMatchDetailRequest (1524) | matchId:int | [TeamDeathMatchLobbywindowMediator.handleItemListSelectionChanged](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/lobbyWindow/view/TeamDeathMatchLobbywindowMediator.as) |  |
| TeamDeathMatchDraftConfirmationRequest (7199) | accepted:bool | [TeamDeathMatchParticipationPopupMediator.handleJoinButtonClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/popups/view/TeamDeathMatchParticipationPopupMediator.as)<br>[TeamDeathMatchParticipationPopupMediator.handleLeaveQueueButtonClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/popups/view/TeamDeathMatchParticipationPopupMediator.as)<br>[TeamDeathMatchParticipationPopupMediator.handleTimerCompleteHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/popups/view/TeamDeathMatchParticipationPopupMediator.as) |  |
| TeamDeathMatchExitRequest (21835) |  | [TDMLeaveGamePopUpMediator.handleOKButtonClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/spawnPoint/view/TDMLeaveGamePopUpMediator.as) |  |
| TeamDeathMatchJoinRequest (1525) | matchId:int | [TeamDeathMatchLobbywindowMediator.handleJoinButtonClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/lobbyWindow/view/TeamDeathMatchLobbywindowMediator.as) |  |
| TeamDeathMatchLeaveQueueRequest (13255) |  | [TeamDeathMatchLobbywindowMediator.handleLeaveButtonClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/lobbyWindow/view/TeamDeathMatchLobbywindowMediator.as) |  |
| TeamDeathMatchOverviewInitRequest (1520) |  | [TDMEnterPoint.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/tdm/map/TDMEnterPoint.as) |  |
| TechActivationRequest (69) | activationTechType:module | — |  |
| TrackVariableRequest (-24553) | data:vector | [EventManager.flushMapClickTracking](../decompiled/main/scripts/net/bigpoint/darkorbit/managers/EventManager.as) |  |
| TradeRequest (81) |  | [GuiManager.onTradeWindowMaximizeClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/GuiManager.as)<br>[Refinery.handleIconClick](../decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/homebase/Refinery.as)<br>[BattleStationBuildWindowBase.requestOreTrade](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battlestationswindow/view/BattleStationBuildWindowBase.as) |  |
| TradeSellOreRequest (131) | toSell:module | [OreTradeModule.handleSellButtonClick](../decompiled/main/scripts/net/bigpoint/darkorbit/gui/elements/OreTradeModule.as) |  |
| TrainingGroundCancelRequest (3375) |  | [TraininggroundsWindowMediator.handleCancelRequested](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/traininggrounds/view/TraininggroundsWindowMediator.as) |  |
| TrainingGroundConfirmRequest (-32337) |  | [TraininggroundsWindowMediator.handleFightRequested](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/traininggrounds/view/TraininggroundsWindowMediator.as) |  |
| TrainingGroundSignUpRequest (-24550) |  | [TraininggroundsWindowMediator.handleMatchRequested](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/traininggrounds/view/TraininggroundsWindowMediator.as) |  |
| TrinityTrialsClaimPassRewardRequest (23601) | rewardLevel:int, isVip:bool | [TrinityTrialsMainProxy.sendPassCliamRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/model/TrinityTrialsMainProxy.as) |  |
| TrinityTrialsDropLevelOptionalRequest (4087) | costLootAmount:int, costLootId:utf | [TrinityTrialsMainProxy.sendUpLevelRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/model/TrinityTrialsMainProxy.as) |  |
| TrinityTrialsGateEnterRequest (-12375) | attributeType:int, difficulty:int | [TrinityTrialsSelectViewMediator.onClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/TrinityTrialsSelectViewMediator.as) |  |
| TrinityTrialsUIRequest (-21996) | optionalType:short | [TrinityTrialsMainProxy.sendUIRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/trinityTrials/model/TrinityTrialsMainProxy.as) |  |
| UIButtonTriggerRequest (24564) | itemId:utf | [FeatureMenuActionCommand.sendButtonTriggerRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/featuresMenu/controller/logic/FeatureMenuActionCommand.as) | ACTION_TRIGERRED ← LogoutKeyboardCommand/FeaturesMenuMediator |
| UIWindowNextPageRequest (119) | windowId:int | — |  |
| UIWindowSettingsRequest (341) | windowSettings:vector | — |  |
| UIWindowUpdateRequest (18219) | posX:int, width:int, posY:int, itemId:utf, height:int, maximized:bool | [SendWindowUpdateRequest.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/controller/requests/SendWindowUpdateRequest.as) | SEND_WINDOW_UPDATE_REQUEST ← GuiManager |
| UnequipModuleRequest (6018) | battleStationId:int, itemId:int | [BattleStationProxy.requestUnEquipModuleFromAsteroid](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/battlestationswindow/model/BattleStationProxy.as) |  |
| UnstableModuleRecycleRequest (-17156) | itemId:int, recycleReturns:int | [RerollWindowMediator.handleRecycleOk](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/reroll/view/RerollWindowMediator.as) |  |
| UnstableModuleRerollRequest (-18820) | itemId:int, rerollCount:int, rerollCost:int | [RerollWindowMediator.handleReroll](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/reroll/view/RerollWindowMediator.as) |  |
| UnstableModuleRestabiliseRequest (14934) | isSalvage:bool, itemId:int | [RerollResultWindowMediator.confirm](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/reroll/view/RerollResultWindowMediator.as) |  |
| UpLevelSkillTreeRequest (23021) | id:utf | — |  |
| UpdateNamFIagRequest (3583) | open:bool | — |  |
| UridiumBankClaimRequest (-19380) |  | [UridiumBankMediator.handleClaimUridiumBank](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/uridiumbank/view/UridiumBankMediator.as) |  |
| UserMessageDeleteRequest (-21683) | inbox:bool, deleteIds:vector | — |  |
| UserMessageGetTargetRequest (-26127) |  | — |  |
| UserMessageInboxListRequest (15573) | startIndex:int | — |  |
| UserMessageInitRequest (28994) |  | — |  |
| UserMessageLootRequest (-11902) | ids:vector | — |  |
| UserMessageNoteAddRequest (-5164) | body:utf, subject:utf | — |  |
| UserMessageNoteDeleteRequest (-8223) | noteId:int | — |  |
| UserMessageNoteListRequest (3853) |  | — |  |
| UserMessageNoteUpdateRequest (-27566) | noteId:int, subject:utf, body:utf | — |  |
| UserMessageOutboxListRequest (-8115) | startIndex:int | — |  |
| UserMessageSendRequest (-17587) | recipientType:utf, recipients:vector, parentType:int, parentId:int, body:utf, hCaptchaToken:utf, subject:utf | — |  |
| UserMessageUpdateStatusRequest (26787) | inbox:bool, status:int, ids:vector | — |  |
| VIPMerchantExchangeBuyRequest (-15948) |  | [VIPMerchantExchangeUIMediator.onBuyBtnClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/vipMerchantExchange/view/VIPMerchantExchangeUIMediator.as) |  |
| VIPMerchantExchangeRequest (28017) | lootId:utf | [VIPMerchantExchangeUIMediator.sendExchangeRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/vipMerchantExchange/view/VIPMerchantExchangeUIMediator.as) |  |
| VersionRequest (666) | version:utf | [ConnectionManager.sendVersionRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/net/ConnectionManager.as) |  |
| VoyagersClaimPassRewardRequest (28522) | isVip:bool, rewardLevel:int | [SingularityDrivePassProxy.sendPassCliamRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/model/SingularityDrivePassProxy.as) |  |
| VoyagersGateEnterRequest (927) | isFree:bool, instanceLevel:int | [SingularDriveSelectViewMediator.onClickHandler](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/mediator/SingularDriveSelectViewMediator.as) |  |
| VoyagersUIRequest (-310) |  | [SingularityDrivePassProxy.sendUIRequest](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/windows/singularityDrive/model/SingularityDrivePassProxy.as) |  |
| WarGameExitRequest (4519) |  | [WarGameExitPoint.openLeaveMatchDialog](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/wargame/map/WarGameExitPoint.as) |  |
| WarGameInitLobbyRequest (16640) |  | [WargameRequestDataCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/wargame/control/WargameRequestDataCommand.as) | UPDATE_LOBBY ← WargameLobbyProxy/WargameLobbyMediator |
| WarGameJoinRequest (5159) |  | [WargameLobbyMediator.handleSignUpClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/wargame/view/lobby/WargameLobbyMediator.as) |  |
| WarGameLeaveQueueRequest (-31331) |  | [WargameLobbyMediator.handleLeaveClicked](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/wargame/view/lobby/WargameLobbyMediator.as) |  |
| WindowSettingsRequest (268) | minimapScale:int, mainmenuPosition:utf, barStatus:utf, genericFeatureMenuPosition:utf, genericFeatureMenuOrder:utf, gameFeatureMenuPosition:utf, gameFeatureMenuOrder:utf, slotmenuPosition:utf, slotMenuOrder:utf, slotmenuPremiumPosition:utf, slotMenuPremiumOrder:utf, slotmenuProActionPosition:utf, slotMenuProActionOrder:utf, stageSize:utf, hideAllWindows:bool | [SaveBarsSettingsCommand.execute](../decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/controller/SaveBarsSettingsCommand.as) | SAVE_BARS_SETTINGS ← InfoField/ZoomableWindow/MenuPositionsAbstractCommand/ChangeWindowsPositionsCommand/ConfigModePopupMediator |
