# 24 Ekim devam düzeltmesi

Komuta Merkezi artık brNews.php yerel XMLfeed + ikiBE_local etkinliği, kalıcıokundubilgisi ve gerçek portalbağlantıları ile bağlıdır. Otomatik açılmama tercihi korunur. SHOP/NEWSHOP gerçek akışı aynıportala yönlenir; aşağıdaki127ürün engeli bu istemcide görünür mağaza açığı değildir. [Güncel rapor](command-center-phase-current.md). Tarihsel matrisin diğer satırları için [güncelkalanlar](remaining-work-current.md) üstündür.

# Son ek — 23 Ekim2026

Bu matriste önce gizli olan **ship_warp,battle_pass,trinityTrials,voyagers** artık açıldı. Warp gerçek gemi değiştirmeye, etkinlik ödül yolları ortak sahiplik/ödül defterine bağlıdır. Özgün modern etkinlik haritaları/drop-level hâlâ eksiktir; ayrıntı [güncel kayıtta](second-completion-work.md) ve [native ödül raporunda](native-rewards-current.md). Aşağıdaki23korunan/72gizli sayıları önceki sürüme aittir.

# Oyun içi pencere ve sekme denetimi — 23 Ekim 2026

## Sonuç ve sınır

Kayıtlı `game/templates/init.json` yerleşiminde **95 benzersiz pencere/toolbar öğesi** incelendi. 23 çalışan/yerel kapsamda öğe korunuyor. 72 desteklenmeyen öğe gizli; bunların **27'si eski kayıttan görünür geliyordu ve bu çalışmada gizlendi**. Bu, 72 özelliğin uygulandığı anlamına gelmez. Çalışmayan düğmelerin boş/yükleniyor ekranlarına gitmesi engellenir.

`game/ui-capabilities.js` gerçek kapsam kararını içerir. `game/init.js` son aşamada bu politikayı uygular. Değişiklik sadece özellik çubuğunun `WindowItemCommand`/`ItemCommand` görünürlüğünü ve desteklenmeyen pencerenin `maximized` alanını etkiler. Sunucu işleyicileri, sahiplik, eşya/para, PET motoru, roketler ve ödül defterleri değiştirilmedi. Kayıtlı pencere yerleşimi gizli bir özelliği yeniden açamaz. Şablon nesnesi değiştirilmez.

Kanıt düzeyi **istemci kaynak sözleşmesi + gerçek codec + süreç içi CLI testidir**. Qt/Flash ekranında görsel uçtan uca kontrol yapılmadı; bir işleyicinin varlığı tek başına bütün pencerenin doğru render edildiğinin kanıtı sayılmaz. İstemci tarafında çalışan yardım/minimap/tam ekran gibi sayfalar için ayrıca paket işleyicisi gerekmez.

Makine tarafından okunabilen bütün 95 öğe ve kayıtlı istek listesi: `ingame-window-audit-current.json`.

## İşlev matrisi

| Pencere/sekme | Yerel durum | İstek → cevap/uygulama | Kaynak ve test kanıtı / açık sınır |
| --- | --- | --- | --- |
| Kullanıcı / gemi HUD (`user`, `ship`) | Destekleniyor | Başlangıç/attribute paketleri; yerel model | `game/init.js`, `stats.js`, `nano-hull.js`; `tests/gameplay.test.js`, `nano-hull.test.js`. Galaxy yüzükleri `gate-rings.js`; günlük rütbe hesaplaması ayrıca tamamlanmış sayılmaz. |
| Mini harita (`minimap`) | Destekleniyor, istemci ağırlıklı | Harita/portal/POI başlatma; hareket için `MoveRequest` | `maps.js`, `gameplay.js`, `protocol.js`; `tests/gameplay.test.js`. |
| Yıldız Sistemi (`spacemap`) | Destekleniyor | `JumpCPUUpdateRequest`/`JumpCPUSelectRequest` veya native `JCPU\|GET/S/J` → `0\|A\|JCPU`, `0\|A\|JV` | `jump-cpu.js`, `cpu.js`, istemci `SpaceMapWindowMediator.as` ve `SetAttributeAssembly.as`; `tests/jump-cpu-native-ui.test.js` 7 test. Alt hedef paneli için etkin konfigürasyonda AJP-01 gerekir. JP-01/02 başka üründür. Kuponsuz 100 U./graf adımı yerel tarife. |
| Portal / kapı geçişi | Destekleniyor; GG akışı ayrı incelemede | `JumpRequest`, `MapAssetActivationRequest` → hazırlık ve `JumpToServerCommand` | `gameplay.js`, `maps.js`, `galaxy-gates.js`; `tests/gameplay.test.js`, `galaxy-gate-portals.test.js`. Dalga sonrası devam/çıkış işi ana çalışmada ayrıca ele alınır. |
| Görevler (`quests`) / merkez görev işareti | Destekleniyor | `QuestList/Info/Accept/CancelRequest`, `QuestGiverApproachedRequest`, `QuestGiverWindowClosedRequest` → list/detail/progress/complete | `handlers/systems.js`, `quest-station.js`; `tests/systems.test.js`, `quest-station.test.js`, `quests-expanded.test.js`. Yakınlık/harita doğrulanır; ilerleme ve ödül hesap başına saklanır. |
| PET (`pet`) | Pencere/komutlar destekleniyor; modül davranışları ayrı audit | `PetRequest`, `PetGearActivationRequest`, `HangarShipRenamePetRequest` → native PET durum/aktivasyon/yakıt | `handlers/pet.js`, `pet.js`, `pet-special.js`; `tests/pet-native-state.test.js`, `pet-catalog-protocols.test.js`, `pet-runtime-expanded.test.js`. Sahip olunan PET'in düğmesi dinamik açılır; bütün modüller yalnız düğme görünüyor diye tamamlandı sayılmaz. |
| Ayarlar: Ses/Görünüm/Oynanış/Kalite/Görev | Kaydetme/geri uygulama destekleniyor; bazı otomasyonlar eksik | `Audio/Display/Gameplay/Quality/QuestSettingsRequest` → ilgili native `*SettingsModule` | `handlers/systems.js`; `tests/settings-runtime.test.js`, `systems.test.js`. Diroit ana kutusu/kendi kutusu yerel uyum kuralıyla çalışır. `autoBoost`, `autoRefinement`, `autoChangeAmmo`, otomatik yeşil anahtar satın alma tüketicileri tamamlanmış değildir. |
| Ayarlar: tuş/pencere/sıfırlama | Destekleniyor | `UserKeyBindingsUpdate`, `WindowSettingsRequest`, `UIWindowUpdateRequest`, `UIWindowSettingsRequest`, `ResetSettingsRequest` | Aynı sistem; delta birleştirme/hesap izolasyonu testli. C konfigürasyon değiştirir; atanmadıysa M harita açar (`tests/map-hotkey-artifact.test.js`). 2D/3D yeniden yükleme `client-view.js` üzerinden tercih edilir; her render seçeneğinin görsel eşitliği sınanmadı. |
| Zenginleştirme: hammadde rafine etme | Destekleniyor | `LabUpdateRequest`, `LabRefinementRequest` → ore/item update | `handlers/lab.js`; `tests/systems-skylab.test.js`. Skylab sayfası açılması zorunlu değil. |
| Zenginleştirme: lazer/roket/hız/kalkan | Destekleniyor | `LabUpdateItemRequest` → `LabUpdateItemCommand`, güncel statlar | `handlers/lab.js`, `stats.js`; `tests/seprom-shop-lab.test.js`. Seprom hasar +%60, kalkan +%40; hız motoruna uygulanmaz. Hız bonusu sadece jeneratör katkısına uygulanır. Tam salvo/tek lazer tüketim ayrıntısı özgünlük açığı olarak kalır. |
| Birleştir: açılış/üretim (`assembly`) | Destekleniyor | Önce içerik/bootstrap; `AssemblyBuild/Collect/CollectAll/SkipRequest`, `AssemblyRecipeSelectRequest`, `AssemblySetFilterRequest` | `assembly.js`, `handlers/assembly.js`; `tests/assembly-native-bootstrap.test.js`, `assembly-module-client.test.js`, `assembly-performance.test.js`. Tek değişiklikte bütün katalog tekrar oynatılmaz; envanter ve değişen tarifler yenilenir. Gold Pass proxy kilidi giderilmiş artefakt testli; her çalışma zamanı yükleme hatası görsel olarak sınanmadı. |
| Birleştir: Geliştirme | Destekleniyor | Hedef-item tarifleri, native `AssemblyBuild/CollectRequest`; toplu seçme/başlatma | Aynı sistem; `tests/assembly-native-tabs.test.js`, `assembly-module-client.test.js`; modül maliyeti `module-policy.js`, sınır/bonus `docs/upgrade-effects-validation.md`. Uygun silah/kalkan/roketatar/diroit geliştirmesi vardır; her katalog eşyası geliştirilebilir değildir. |
| Birleştir: Dağıtma | Destekleniyor, uygun eşyalarda | `DisassemblyRequest` → iş/teslim/envanter | `handlers/assembly.js`; `tests/assembly-native-tabs.test.js`. Takılı öğe/diğer konfigürasyon/PET bağları korunur. |
| Birleştir: Stabilize Et | **Bilerek kapalı / eksik** | `UnstableModuleReroll/Restabilise/RecycleRequest` → açık gerekçe, kesinti yok | `assembly.capabilities()`, `handlers/assembly.js`; `tests/assembly-native-tabs.test.js`. Bireysel modül bonusu/yeniden çekme ledger ve kaynak dağılımları eksik. Çalışıyor diye sunulmaz. |
| Birleştir: Hiper Ocak | **Bilerek kapalı / eksik** | `QuantumFluidCoreRequest` → açık gerekçe, kesinti yok | Aynı sistem. Per-core kalite/stat/yükseltme maliyetleri ve rastgele gemi/bonus tabloları eksik; Flash'ta sekme bulunması yeterli değil. |
| Galaksi kapısı kurucu (`ggBuilder`) | Destekleniyor | `GalaxyGateBuilderInfo/GetGateParts/MultiEnergy/SetupGate/BuyLife/SaveSpinAmountRequest` → native builder yanıtları | `handlers/systems.js`; `tests/systems.test.js`, `systems-gates.test.js`, `systems-gate-rewards.test.js`. Info ilk istekte gönderilir; map initte tekrar gönderilip sekme çoğaltılmaz. Parça/çarpan/sarf gerçek DB'ye bağlı. Ödül miktarlarının bazıları belgeli yerel denge. |
| Destekler (`booster`) | Destekleniyor | Sahip olunan boost/time paketleri; çoğu görüntüleme istemcide | `boosters.js`, `init.js`; `tests/systems-boosters.test.js`. PvP/etkinlik özel destekleri ayrı yetenek denetimine tabi. |
| Native dükkân (`shop`, `new_shop`) | Destekleniyor; kampanya gruplama farkı açık | `ShopItemListRequest`/`ShopItemBuyRequest` → liste/sonuç/envanter | `handlers/shop.js`; `tests/module-shop-sort.test.js`, `payment-local.test.js`. Kredi önce, para birimi içinde artan fiyat. Native tek liste 127 sınırı nedeniyle bütün kampanyaları tek sekmede toplama eksik; portalda 196 teklif Özel Fırsatlar'a taşındı. Bkz. `shop-cleanup-current.md`. |
| Hangar / ekipman (`hangar`, `hangarCannons`) | Destekleniyor | Hangar portal yönlendirmesi; `HangarList/ShipEquipment/ShipDetail/ShipMoveItems/...Request` | `handlers/inventory.js`, `inventory.js`, `drones.js`; `tests/inventory-drones-shop.test.js`, `hangars.test.js`. Normal hangar salonu ekleme 250.000 U., header/HTTP akışıdır. |
| Gemi değiştirme (`ship_warp`) | **Eksik; düğme gizlendi** | İstemci `ShipWarpRequest` gönderir, yerel kayıtlı handler yok | `WarpWindowMediator.as:warp`, `protocol.registeredCommands()`. Portalda offline gemi aktifleştirme bundan farklıdır; native warp zaman/ücret/savaş koşulları yeniden kurulmalı. |
| Pilot sayfası / ArGe (`pilotSheet`) | Destekleniyor | Portal açılır; native `SkillTreeList/UpLevelSkillTree/ConvertResearchPoints/ResetSkillTreeRequest` | `handlers/skills.js`, `skills.js`; `tests/skills.test.js`, `skill-ui.test.js`, `skill-benefits.test.js`. Sıfırlama 300.000 U.; Seprom gereksinimi yok. |
| Skylab (`skylab`) | Mevcut yerel web akışı; isteğe bağlı | İstemci portal `internalSkylab` açar → `web/skylab-api.js` | `tests/systems-skylab.test.js`. Kullanıcının mevcut oynanışında Skylab şart koşulmaz; desteklenen eski sayfa bu auditte silinmedi. |
| Sezon (`seasonPass`) | Desteklenen **yerel uyarlama**, korundu | Status/points/rewards + `SeasonPassRewardClaim/ClaimAll/LevelPurchaseRequest` | `payment-events.js`, `handlers/systems.js`; `tests/payment-events.test.js`. Kalıcı 90 seviye; özgün etkinlik takvimi değil. |
| Trinity/Voyagers/Battle Pass | Native pencereleri eksik; **yerel web ödül akışı korunur** | Native `TrinityTrialsUIRequest` vb. yok; `internalPaymentEvents` yerel ledger/claim vardır | `payment-events.js`/`web/http-server.js`; `tests/payment-events.test.js` bütün ödül satırlarını sınar. Sadece bozuk native düğmeler gizlendi. Satın alınmış bilet, puan, ödül/manifest veya web erişimi değiştirilmedi. |
| Komuta Merkezi (`command_center`) | Yerel haberler bağlı | `EventUpdateCommand` + `/flashAPI/brNews.php`; `NewsInfo/ClickedRequest` ve açılma tercihi | `command-center.js`, `handlers/core.js`, `boot-api.js`. İkiyerelduyuru/portalbağlantısı; sahte canlıkampanya yok. Qtgörselkabulü ayrıca açık. |
| Maden satma penceresi (`ore_trade`) | Destekleniyor; istasyon/CPU şartları | `TradeRequest`, `TradeSellOreRequest`, `MapAssetActivationRequest` → gerçek fiyat/envanter/bakiye | `gameplay.js`, `collectables.js`, `cpu.js`; `tests/gameplay.test.js`, CPU testleri. Toolbar sabit sayfası değil. |
| Ölüm / tamir | Destekleniyor | `KillScreenRepairRequest`/`InstantRepairRequest` → doğrulanmış yeniden doğuş/HP | `respawn.js`, `gameplay.js`; `tests/gameplay.test.js`, ilgili respawn testleri. Üs ücretsiz, en yakın portal 500 U., yerinde 2.000 U.; GG ölüm/checkpoint ayrı kurallı. |
| Günlük (`log`), yardım, tam ekran | Destekleniyor, istemci ağırlıklı | `LegacyModule` standart mesaj; yardım ve tam ekran yerel istemci eylemleri | `GuiManager.as`, `FeatureMenuActionCommand.as`. Ayrı sunucu istek işleyicisi olmaması bu pencereleri eksik yapmaz. |
| Çıkış (`logout`) | Destekleniyor | `UIButtonTriggerRequest(itemId=logout)`, `LogoutCancelRequest` → native zamanlayıcı, close | `handlers/core.js`; hareket/savaş sonrası iptal kontrolü mevcut. |
| Chat/grup/kişiler/klan/açık artırma | **Solo kapsamı dışında; düğmeler gizlendi** | Uygulanmayan çok oyunculu istekler çalışıyor gibi sunulmaz | Kullanıcı çok oyunculu sistemi bu aşamada istemiyor. Bu audit çok oyunculu kod eklemedi. |

## Açık iş listesi

1. Native gemi warp akışı (liste/koşul/zaman/ücret/iptal); yalnız web hangar değişimi bunun yerine sayılmamalı.
2. Komuta Merkezi yerel haber akışı bağlandı; gerçek Qtgörsel kabulü açık.
3. Oynanış otomasyon kutucuklarının ayrı sunucu tüketicileri: autoBoost/autoRefinement/autoChangeAmmo/yeşil anahtar otomatik alımı.
4. Stabilize ve Hiper Ocak için kaynakça + bireysel eşya durum defterleri. Doğrulanmamış rastgele bonus/maliyet üretilmemeli.
5. SHOP/NEWSHOP portal yönlendirmesi doğrulandı;127öğe sınırı bu istemcinin açılan dükkân yoluna aitdeğil.
6. Dispatch, NOVA/assistant, synthesis, drive/update_engine, pathfinder, sıralamalar ve modern etkinlik pencereleri için gerçek sunucu uygulamaları; şu an gizli.
7. Qt/Flash görsel kontrolü: açılış-yükleyici-kapanış-tekrar açılış, yenileme sonrası liste/scroll/seçim, 2D/3D görünümü. CLI başarısı bunu tek başına doğrulamaz.

## Kaynak sözleşmesi

- `decompiled/main/scripts/net/bigpoint/darkorbit/mvc/gui/featuresMenu/controller/logic/FeatureMenuActionCommand.as`: istemci tarafı toggle, web yönlendirmeleri ve özel request gönderimleri ayrıdır. `UIButtonTriggerRequest` işleyicisi pencere verisi sağlayan genel bir sihirli handler değildir; kayıt/çıkış içindir.
- `.../mvc/gui/GuiConstants.as`: pencere kimlikleri; `WARP_CONTROLS = hangarCannons`, `SHIP_WARP_WINDOW = ship_warp` birbirinden ayrıdır.
- `.../mvc/gui/windows/warp/view/WarpWindowMediator.as`: `ShipWarpRequest` gönderimi.
- `.../mvc/gui/windows/synthesis/model/CannonSynthesisProxy.as`: `SynthesisInventoryRequest`, karşılığı yerelde yok.
- `.../mvc/gui/windows/spacemap/view/SpaceMapWindowMediator.as`: AJP panel ve legacy düğme paketi.
- `game/protocol.js:registeredCommands()` mevcut gerçek kayıt listesini verir; bilinmeyen istek ilk kez loglanır ve sahte başarı üretilmez.

## Test çalışması

`logs/ingame-window-audit-tests.log`: **129 test, 129 başarılı, 0 başarısız/atlanmış**.

Çalıştırılanlar: `ui-capabilities`, `settings-runtime`, `systems`, `jump-cpu-native-ui`, `quest-station`, `assembly-native-bootstrap`, `assembly-native-tabs`, `assembly-performance`, `assembly-module-client`, `seprom-shop-lab`, `payment-events`, `hotbar`, `gameplay`, `systems-boosters`.

Yeni üç test: gerçek kayıtlı yerleşimde sınıflandırma/codec/şablon değişmezliği; sezon paketleri ve desteklenen istemci eylemlerinin korunması; gerçek `World` başlangıcında kaydedilmiş maximized tercihlerinin desteklenmeyen pencereyi tekrar açamaması. Hesap testleri bellek içi SQLite kullanır; üretim hesabı değiştirilmez.

## Tam toolbar envanteri

Aşağıdaki tablo kayıtlı 95 benzersiz ID'yi kapsar. PET görünürlüğü sahipliğe göre sonradan açılır; bu tablo şablon görünürlüğünü gösterir. İşlev korunmuş olmak, eski şablonda gizli olan öğeyi zorla açmak anlamına gelmez.

| ID | Önceki şablon | Son kapsam |
| --- | --- | --- |
| `vipMerchantExchange` | Kapalı | Gizli / uygulanmadı |
| `mileageMarket` | Kapalı | Gizli / uygulanmadı |
| `cli` | Kapalı | Gizli / uygulanmadı |
| `user` | Açık | Korundu |
| `ship` | Açık | Korundu |
| `ship_warp` | Açık | Gizli / uygulanmadı |
| `chat` | Açık | Gizli / uygulanmadı |
| `group` | Açık | Gizli / uygulanmadı |
| `minimap` | Açık | Korundu |
| `spacemap` | Açık | Korundu |
| `quests` | Açık | Korundu |
| `refinement` | Açık | Korundu |
| `assembly` | Açık | Korundu |
| `log` | Açık | Korundu |
| `pet` | Kapalı | Korundu |
| `contacts` | Açık | Gizli / uygulanmadı |
| `booster` | Açık | Korundu |
| `dispatch` | Açık | Gizli / uygulanmadı |
| `ggBuilder` | Açık | Korundu |
| `trinityTrials` | Açık | Gizli / uygulanmadı |
| `expedition` | Açık | Gizli / uygulanmadı |
| `strikeAndExit` | Kapalı | Gizli / uygulanmadı |
| `rankings` | Açık | Gizli / uygulanmadı |
| `eternal_blacklight` | Kapalı | Gizli / uygulanmadı |
| `spaceball` | Kapalı | Gizli / uygulanmadı |
| `invasion` | Kapalı | Gizli / uygulanmadı |
| `ctb` | Kapalı | Gizli / uygulanmadı |
| `tdm` | Kapalı | Gizli / uygulanmadı |
| `ranked_hunt` | Kapalı | Gizli / uygulanmadı |
| `highscoregate` | Kapalı | Gizli / uygulanmadı |
| `scoreevent` | Kapalı | Gizli / uygulanmadı |
| `infiltration` | Kapalı | Gizli / uygulanmadı |
| `word_puzzle` | Kapalı | Gizli / uygulanmadı |
| `sectorcontrol` | Kapalı | Gizli / uygulanmadı |
| `jackpot_status_ui` | Kapalı | Gizli / uygulanmadı |
| `curcubitor` | Kapalı | Gizli / uygulanmadı |
| `influence` | Kapalı | Gizli / uygulanmadı |
| `plutus` | Kapalı | Gizli / uygulanmadı |
| `chrominEvent` | Kapalı | Gizli / uygulanmadı |
| `pvp_summer` | Kapalı | Gizli / uygulanmadı |
| `tiered_arena` | Kapalı | Gizli / uygulanmadı |
| `battle_pass` | Açık | Gizli / uygulanmadı |
| `curcubitor2019` | Kapalı | Gizli / uygulanmadı |
| `frozen_labyrinth` | Kapalı | Gizli / uygulanmadı |
| `npc_event` | Açık | Gizli / uygulanmadı |
| `payload_escort` | Kapalı | Gizli / uygulanmadı |
| `eternal_gate` | Kapalı | Gizli / uygulanmadı |
| `agatus_event` | Kapalı | Gizli / uygulanmadı |
| `rogue_lite` | Açık | Gizli / uygulanmadı |
| `preBlackFridaySales` | Kapalı | Gizli / uygulanmadı |
| `ship_boost_event` | Kapalı | Gizli / uygulanmadı |
| `traininggrounds` | Kapalı | Gizli / uygulanmadı |
| `spaceplague` | Kapalı | Gizli / uygulanmadı |
| `domination` | Kapalı | Gizli / uygulanmadı |
| `rzone` | Kapalı | Gizli / uygulanmadı |
| `eventProgress` | Kapalı | Gizli / uygulanmadı |
| `wargame_event` | Kapalı | Gizli / uygulanmadı |
| `wargame_lobby` | Kapalı | Gizli / uygulanmadı |
| `diminish_quests` | Kapalı | Gizli / uygulanmadı |
| `worldBoss` | Kapalı | Gizli / uygulanmadı |
| `titleFrenzy` | Kapalı | Gizli / uygulanmadı |
| `publicWorldBoss` | Kapalı | Gizli / uygulanmadı |
| `voyagers` | Açık | Gizli / uygulanmadı |
| `space_search` | Kapalı | Gizli / uygulanmadı |
| `birthday_2025` | Kapalı | Gizli / uygulanmadı |
| `hangar` | Açık | Korundu |
| `hangarCannons` | Açık | Korundu |
| `pilotSheet` | Açık | Korundu |
| `skylab` | Açık | Korundu |
| `clan` | Açık | Gizli / uygulanmadı |
| `auction` | Açık | Gizli / uygulanmadı |
| `nova` | Açık | Gizli / uygulanmadı |
| `vouchers` | Açık | Gizli / uygulanmadı |
| `message` | Açık | Gizli / uygulanmadı |
| `new_shop` | Açık | Korundu |
| `logbook` | Açık | Gizli / uygulanmadı |
| `armoryUnlock` | Açık | Gizli / uygulanmadı |
| `unity_client_reward` | Açık | Gizli / uygulanmadı |
| `a_new_hope` | Kapalı | Gizli / uygulanmadı |
| `return_of_hero` | Kapalı | Gizli / uygulanmadı |
| `synthesis` | Açık | Gizli / uygulanmadı |
| `update_engine` | Açık | Gizli / uygulanmadı |
| `returnee_login` | Kapalı | Gizli / uygulanmadı |
| `monthly_deluxe` | Açık | Gizli / uygulanmadı |
| `miniclient_reward` | Açık | Gizli / uygulanmadı |
| `uridium_bank` | Açık | Gizli / uygulanmadı |
| `seasonPass` | Açık | Korundu |
| `command_center` | Açık | Korundu |
| `shop` | Açık | Korundu |
| `assistant` | Açık | Gizli / uygulanmadı |
| `settings` | Açık | Korundu |
| `help` | Açık | Korundu |
| `logout` | Açık | Korundu |
| `fullscreen` | Açık | Korundu |
| `stellar_pathfinder` | Açık | Gizli / uygulanmadı |
