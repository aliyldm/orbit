# SpaceSearch ve kayıtlı açılış durumunun denetimi

18 Ekim 2026. İnceleme `game/templates/init.json`, `logs/session-6182-2.json`, mevcut codec ve decompile edilmiş istemci kaynaklarıyla sınırlıdır. Aşağıdaki indeksler şablon komut dizisinde sıfırdan başlar; kaynak dosya değiştirilirse değişebilir.

## SpaceSearch ne yapar?

`SpaceSearchRequest` hedef, oyuncu veya NPC arama komutu değildir. Gezegen keşfi ve sektör ödülleri içeren ayrı bir etkinliğin komutudur. `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/porting/SpaceSearch/SpaceSearchRequest.as` sabitleri:

| action | Gerçek enum | İşlem |
|---|---|---|
| 0 | `ACTION_ssAtlas` | Atlas bilgisini iste |
| 1 | `ACTION_ssSearch` | Kaynak harcayarak keşif |
| 2 | `ACTION_ssSectorRewardsList` | Sektör ödülleri listesi |
| 3 | `ACTION_ssSectorRewardsGet` | Sektör ödülü al |
| 4 | `ACTION_ssMissionList` | Etkinlik görevleri |

Yanıt türleri `SpaceSearchInfoCommand`, `SpaceSearchEventsCommand`, `SpaceSearchSectorRewardsCommand`, `SpaceSearchMissionListCommand`'dır. Atlas yanıtı gezegen indeksi, yüzde, harcanan lootId, hesap miktarı ve maliyet taşır. `SpaceSearchUIMediator.explore_btn_click` keşif maliyetini eldeki kaynakla karşılaştırır ve yetersizlikte `package_event-deal-ftl-s` mağaza bağlantısını açar. `SpaceSearchEventsCommandHandler` gelen gezegen/etkinlik/ödül listelerinden ödül penceresi oluşturur.

Kayıtta tam **102** istemci isteğinin hepsi `action=0,id=0,count=0` şeklindedir. Kayıtta hiçbir SpaceSearch atlas/keşif/ödül/görev yanıtı yoktur. Bunları üreten istemci davranışı `net/netty/handlers/spaceSearch/UpdateSpaceSearchKeyCommandHandler.as` içindedir: sunucudan her `UpdateSpaceSearchKeyCommand` geldiğinde otomatik Atlas isteği gönderir. Kayıtlı sunucu bu sırada sürekli anahtar miktarı 0 yollamaktadır. Bu gözlem etkinliğin çalıştığını veya 102 kullanıcı araması yapıldığını göstermez.

Yerel `client/spacemap/graphics/ui/windows/space_search/` varlıkları ve gezegen/ödül yapılandırma XML'i mevcut değildir. `resources.xml` bu UI XML'lerinin adlarını listeler, fakat listelenmeleri içeriklerinin kurtarıldığı anlamına gelmez. `SpaceSearchXML.as` beklenen `planets`, `planetEvents`, `rangeBoundPackageEntry` yapısını açıklar; gerçek veri setini içermez.

Bu nedenle uydurma gezegenler, sahte ödüller veya hedef arama işleyicisi eklenmedi. Etkinlik desteklenmiyorsa açılıştaki `UpdateSpaceSearchKeyCommand` kaldırılmalıdır. Atlas isteğine yeniden aynı anahtar paketini göndermek istemcinin tekrar Atlas istemesine yol açar. Tam destek için gerçek etkinlik veri seti, keşif olasılıkları/ilerlemesi ve atomik kaynak/ödül işlemleri gerekir.

## Şablondan yeniden oynatılmaması gereken hesap/etkinlik durumu

| Paket / indeks | Doğrulanan kayıtlı değer | Öneri |
|---|---|---|
| `ChatParamCommand` 107 | `ingrid-chat-prod.darkorbit.com:8774` ve dış `crossdomain.xml` | Yerel sohbet backend'i yokken kaldır; istemciyi canlı sohbete yönlendirme |
| `AttributeBoosterUpdateCommand` 39 | XP +%25; `booster_ep-dlb`, 10.661 saniye | Gerçek DB booster durumundan üret veya bu kayıtlı desteği kaldır |
| `UridiumBankInfoCommand` 90 | Bankada 2.150/34.500 uridium | DB bankası uygulanana kadar kaldır |
| `RogueLiteRankEventInfoCommand` 76 | Etkinlik açık; canlı sıralama listesi | Yerel etkinlik/sıralama yoksa kaldır |
| `NpcEventInfoCommand` 77 | Curcubitor etkinliği, sonraki doğuşa 1.619 saniye | Gerçek etkinlik zamanlayıcısı yoksa kaldır |
| `RogueLiteInfoCommand` 84 | Kayıtlı CPU/geçit durumu | Yerel rogue-lite backend'i yoksa kaldır |
| `MiniClientRewardInfoCommand` 85 | `isClaimable=true`, 1.261.616 saniye | Gerçek günlük ödül/claim kaydı yoksa kaldır |
| `ReturneeLoginRewardInfoCommand` 86, `ReturneeLoginInitialRewardInfoCommand` 87, `ReturneeLoginBundleInfoCommand` 88 | Kayıtlı geri dönüş kampanyası ödülleri | Yeni hesabın kampanya durumu olarak gönderme |
| `SeasonPassStatusCommand` 91 | Ağustos 2026 pazarlaması, 656.816 saniye | Yerel sezon backend'i yoksa kaldır |
| `BattlePassInfoCommand` 92 | `pass_halloween2026.xml`, sürüyor durumunda görevler | Yerel battle pass yoksa kaldır |
| `EventUpdateCommand` 93 | 67 etkinlik; kayıt tarihi ve kalan süreler | Gerçek yerel etkinlik listesiyle değiştir veya kaldır |
| `SeasonPassMissionInfoCommand` 94 | Kayıtlı görev koşulları/yenileme sayaçları | Yerel sezon görevleri yoksa kaldır |
| `BattlePassKeyExchangeInfoCommand` 95 | Canlı kampanyanın takas kataloğu/limitleri | Yerel takas backend'i yoksa kaldır |
| `BattlePassWindowSettingsModule` 96 | Desteklenmeyen battle pass filtreleri | İlgili kampanya kaldırılınca bu bağlam da kaldırılabilir |
| `MonthlyDeluxeInfoCommand` 97 | Ödül listesi, negatif abonelik bitiş süresi | Gerçek abonelik kaydı yoksa kaldır |
| `SeasonPointsInfoCommand` 98, `SeasonPassRewardInfoCommand` 99 | Kayıtlı sezon puan/ödül bağlamı | Yerel sezon yoksa kaldır |
| `EventUnityClientRewardQuestCommand` 102 | Unity kampanyasının görevleri | Desteklenmeyen görevleri oynatıcıya başlatma |
| `EventActivationStateCommand` 114 | Tür 15, `active=true` | Yerel özellik gerçekten etkin değilse kaldır |
| `DispatchActiveEventCommand` 151 | Etkinlik 2 | Yerel dispatch etkinliği yoksa kaldır |
| `ShipUpgradeModuleUpdateCommand` 129–132 | Başka oyuncuların kimlikleri, birinde `[4,1,2]` modülleri | Oyuncunun kendi DB modülleri dışındaki kayıtları kaldır |

Bunlar yalnızca görünmez metadata değildir. `MiniClientRewardInfoCommandHandler` pencere oluşturur; `SeasonPassMissionInfoCommandHandler` görev proxy'sini doldurur; `AttributeBoosterUpdateHandler` booster arayüzünü oluşturup kategorileri günceller. Bu paketler yeni hesapta desteklenmeyen ödül ve ilerleme arayüzleri oluşturabilir.

Güncel DB destekli değiştirmeler uygulanmıştır: kullanıcı ayarları, tuş atamaları, görev listesi/aktif koşullar, pet, envanter/ekipman, kaynaklar, rafineri geliştirmeleri ve Galaxy Gate bilgileri. `systems.buildInit` artık hem `GalaxyGateBuilderInfoCommand` hem de başlangıç Alpha parça yanıtını DB'den üretir; kayıttaki bir bedava enerji ve bonus kapı günü yeniden oynatılmaz.

## Ayrı ele alınması gereken menü değerleri

`MenuInitializationCommand` içinde `equipment_extra_cpu_jp` için kullanılabilir=true ve sayaç=10 bulunur; başlangıç hesabının böyle bir CPU'su yoktur. `equipment_extra_repbot_rep` sahip olunmasa da kullanılabilir/etkinleştirilebilir görünür. Bunlar ekipman sahipliğinden üretilmelidir. Buna karşılık `buy_ammunition_*` sayaçlarındaki 1.000/100 rakamları satın alma paket miktarlarıdır; sahip olunan cephane sayısı diye sıfırlanmamalıdır. `drone_formation_default` başlangıçta kullanılabilir olabilir.

`UILayoutCommand`, `MenuInitializationCommand`, `AssemblyRecipeContentModule`, `SynthesisListCommand` gibi büyük paketler statik UI/katalog tanımlarını da içerir. Sadece boyutlarına veya isimlerine göre tümü silinmemelidir; kullanıcıya özgü sahiplik, sayaç ve işlem desteği ayrı değerlendirilmelidir.
