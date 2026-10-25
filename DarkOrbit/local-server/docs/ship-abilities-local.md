# Klasik gemi yetenekleri

`game/ship-abilities.js`, altı klasik geminin gerçek istemci menü kimliklerini ve efekt protokolünü NPC savaşına bağlar. Yetenek, oyuncunun DB'deki sahip olunan aktif gemisinin temel `loot_id` değeriyle doğrulanır. Yalnız dış görünümü değiştiren tasarım yeteneği kaldırmaz; depodaki başka gemi veya istemcinin gönderdiği görünüm yetenek kazandırmaz. Plus gemiler ve diğer gemilerin yetenekleri bu modülde uygulanmaz ve menüde devre dışı kalır.

| Gemi | Menü | Yetenek ID / cooldown grubu | İşleyen solo etki |
| --- | --- | --- | --- |
| Solace | `ability_solace` | 1 / 36 | Maksimum canın %35'ini, kapasiteye kadar anında tamir eder. Tam canla kullanım reddedilir. |
| Diminisher | `ability_diminisher` | 2 / 37 | Seçili NPC'ye uygulanan lazer kalkan hasarını %50 artırır. Ek hasar gövdeye taşmaz. SAB aktarımına da uygulanır. |
| Spectrum | `ability_spectrum` | 3 / 38 | Gelen NPC lazer hasarını %90, kendi gemisinin lazer hasarını %25 azaltır. Roketleri azaltmaz. |
| Sentinel | `ability_sentinel` | 4 / 39 | NPC lazerinin kalkana ayrılan kısmını %30 azaltır; aynı atışın temel gövde payını azaltmaz. |
| Venom | `ability_venom` | 5 / 40 | Seçili NPC'nin doğrudan canına saniyelik artan hasar verir; gerçek ölüm/ödül akışına bağlıdır. |
| Vengeance Lightning | `ability_lightning` | 6 / 41 | Sunucunun gerçek hareket hızını %30 artırır; var olan hareketin kalan süresi yeniden hesaplanır. |

Diminisher'ın %50 ek kalkan hasarı bu sürümde geminin lazer atışlarıyla sınırlıdır. Roket/alan hasarı için ek yetenek çarpanı uygulanmaz. Sentinel'in kalkan/gövde paylaştırması ve Diminisher bitimindeki yaptırım aşağıdaki yerel politikanın parçasıdır. Grup iyileştirmesi ve PvP yoktur.

## İstemcideki kanıt

`decompiled/main/scripts/net/bigpoint/darkorbit/` altında:

- `InGameCatalog.as:52–62`: klasik yetenek ID'leri 1–6.
- `com/module/CooldownTypeModule.as`: 36–41 grupları.
- `net/AbilityButtonAssembly.as`, `net/netty/handlers/AbilityStartHandler.as`, `AbilityStopHandler.as`: gerçek başlangıç/bitiş logları ve handler davranışı.
- `net/models/skills/AbilityNames.as`: klasik ID'lerin Solace/Diminisher/Spectrum/Sentinel/Venom/SpeedBuff efekt sınıflarına eşlenmesi.
- `net/SkillsAssembly.as`, `net/MapEventsAssembly.as`, `net/ServerCommands.as`: `0|n|SD|A|yetenekId|efektTürü|oyuncuId|hedefId` ve `0|n|SD|D|yetenekId|oyuncuId|hedefId` gerçek eski protokol yolu. Süreli efekt türü 1, tek seferlik zaman aşımı türü 2 (`Effect.as`).
- `net/AbilityEffectActivationAssembly.as`: çoğu klasik yetenek typed efekt komutunun default dalında işlenmez. Bu nedenle yalnız typed komut gönderip efekt varmış gibi kabul edilmez; gerçek eski protokol yolu kullanılır. Menü durumları kaydedilmiş `MenuItemStatusCommand` şablonlarından oluşturulur.

Yüzdeler `client/spacemap/templates/tr/resource_items.xml` içindeki `items_ability_*` açıklamalarından gelir. Son `items_ability_spectrum_prismatic-shielding_tooltip_description` tüm gelen lazer hasarını %90 azaltır diye belirtir; eski genel metindeki yalnız kalkan ifadesi yerine bu özgül açıklama kullanılır. Venom'un özgül açıklaması 35 saniye, başlangıç 1.500, saniyede +200 ve üst sınır 8.500 değerlerini verir. Yerel uygulamada ilk hasar birinci saniyededir; 35 vuruşun sonuncusu 8.300 olur, sayısal üst sınır 8.500 korunur.

## Yerel sunucu politikası ve yaşam döngüsü

20 Ekim 2026 denetiminde süre/beklemeler resmî FAQ kaynaklarıyla doğrulandı; eski yerel varsayımlar düzeltildi. [Kaynaklar ve dönem sınırları](combat-balance-audit.md). `config.combat.shipAbilities.<name>.durationMs/cooldownMs` açık yerel override olabilir.

| Yetenek | Süre | Bekleme |
| --- | --- | --- |
| Solace | Anlık | 90 saniye |
| Diminisher | 15 saniye | 90 saniye |
| Spectrum | 10 saniye | 180 saniye |
| Sentinel | 35 saniye | 180 saniye |
| Venom | 35 saniye (kaynak açıklaması) | 120 saniye |
| Lightning | 5 saniye | 180 saniye |

Hedefli kullanım menzili 700, devam eden bağlantının kopma menzili 1500 birimdir; `range/breakRange` ayarlanabilir. NPC nesne kimliği korunur: aynı ID ile gelen başka nesne eski etkiden hasar almaz. Diminisher'ın kaynakta açıklanan bitim sonrası %30 kalkan zayıflaması, yerel olarak doğal bitimde mevcut kendi kalkanından bir kez %30 düşüm şeklinde uygulanır; kurtarılamayan süreli zayıflama formülü uydurulmaz. Erken hedef kaybı/ölüm/harita/çıkış iptalinde bu düşüm yapılmaz.

Başlangıç ve aktif süre gerçek `AbilityStartCommand`, `MenuItemTimerCommand`, `MenuItemCooldownGroupTimerCommand` ile bildirilir; bitişte `AbilityStopCommand` ve gerçek efekt kaldırması gönderilir. Salt menü seçimi (`actionType=0`) etkinleştirmez; etkinleştirme `actionType=1` ister. Her yakalanmış `ability_*` menü öğesi açıkça değerlendirilir; yalnız sahip olunan ve uygulanmış yetenek kullanılabilir. Bekleme `settings.game.shipAbilityCooldowns` içinde aktivasyondan önce transaction ile saklanır. Solace can yazımı da aynı transaction içindedir; DB hatası sahte tamir/başlangıç göndermez. Bekleme yeniden girişle sıfırlanmaz.

Ölüm, çıkış, harita/aktif gemi değişimi ve atlama aktif etkiyi kaldırır; bekleme korunur. Lightning eski hızı geri yükler ve stat yenilenmesinden sonra çarpanı üst üste eklemez. Savaş tick'i hazır menü durumunu bekleme bitiminde günceller.

`node --test tests/ship-abilities.test.js`: 13 test; sahiplik, kozmetik görünüm, yanlış/uygulanmamış yetenekler, gerçek codec/efekt yolu, hedef/menzil, kalkan/gövde hasarı, gerçek Combat.tick, Venom tek ödül, Lightning hareket süresi, kalıcı bekleme, yaşam döngüsü ve üç DB hata geri alma senaryosu. Venom ölüm ödülü kaydedilemezse hedef canı ve bekleyen vuruş geri yüklenir; sahte ölüm/hasar gönderilmeden sonraki tick tekrar deneyebilir. Flash görsel uçtan uca doğrulaması yapılmadı.
