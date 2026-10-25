# Savaş dengesi doğrulaması — 20 Ekim 2026

Kapsam: yerel tek oyunculu NPC savaşı, klasik lazerler, altı gemi yeteneği. PvP/grup dengesi uygulanmadı. İstemcideki metin veya eşya istatistiği, özel sunucunun tüm hasar formülünü ortaya çıkarmış sayılmaz.

## Doğrudan doğrulanabilen değerler

| Konu | Kanıt | Uygulama |
| --- | --- | --- |
| Lazer hasar aralığı | Resmi [Laser Damage Charts FAQ](https://board-en.darkorbit.com/threads/laser-damage-charts.888/) gerçek hasarı toplam maksimumun %75–100'ü olarak tanımlar. | Simetrik %85–115 yerine %75–100. |
| Temel LF-4 isabeti | Resmi [Permafrost Fissure FAQ](https://board-en.darkorbit.com/threads/permafrost-fissure-faq.117725/), Unstable LF-4'ün normal LF-4 ile aynı %80 isabet, 600 menzil ve 1 saniye bekleme değerlerini verir. | Klasik lazer salvo tabanı %80. Tüm modern lazerlerin birebir aynı olduğu bu kaynaktan çıkarılamaz. |
| Solace | Resmi [Alman gemi FAQ'sı](https://board-de.darkorbit.com/threads/faq-schiffe.2749/), Nano Cluster tablosu. | Anlık; 90 saniye bekleme; kendi maksimum canının %35'i. |
| Diminisher | Aynı FAQ, Diminisher bölümü. | 15 saniye etki, 90 saniye bekleme. Önceki yerel 30/120 saniye düzeltildi. |
| Spectrum | Aynı FAQ; ayrıca [2021 Darksilver Pirates FAQ](https://board-en.darkorbit.com/threads/darksilver-pirates-expansion-faq.127449/) denge değişikliği. | 10 saniye etki, 180 saniye bekleme; gelen lazer -%90, kendi lazeri -%25. Önceki 30 saniye düzeltildi. |
| Sentinel | Alman FAQ, Fortress bölümü. | 35 saniye etki, 180 saniye bekleme. |
| Venom | Alman FAQ; istemcide `items_ability_venom_singularity_tooltip_description`. | 35 saniye etki, 120 saniye bekleme; ilk hasar 1.500, saniyede +200, üst sınır 8.500. |
| Lightning | Alman FAQ, Vengeance bölümü; resmi [Saimon Rebellion FAQ](https://board-es.darkorbit.com/threads/rebelion-saimon-faq.122315/) gemi denge tablosu. | +%30 hız, 5 saniye etki, 180 saniye bekleme. Önceki 90 saniye bekleme düzeltildi. |

Kaynaklar 20 Ekim 2026'da kontrol edildi. Spectrum'un sayıları yerel istemcideki %90/-%25 açıklamasıyla da uyuşur; eski yıllara ait %70/-%45 tablosuyla karıştırılmaz. Süreler yükseltici uygulanmamış temel değerlerdir.

## Sayısal sınırlar ve açık yerel seçimler

- `game/combat-balance.js`: `laserDamage(base, config, random)` kaynaklı aralığı uygular. Aralık içindeki **tek salvo için tek ve düzgün dağılımlı RNG** yerel seçimdir; özgün sunucunun RNG algoritması, her lazeri ayrı zarla mı hesapladığı ve dağılım yoğunluğu bilinmiyor. Bu sistem her lazeri ayrı ayrı doğruladığını iddia etmez. Modern kritik/varyans lazerlerinin özel formülleri kapsam dışıdır.
- `laserHitChance=0.8`: normal LF-4 için kaynaklıdır. Mevcut klasik salvo sistemine ortak taban olarak uygulanır. `hitChance(kind, config, {accuracy, evasion, missReduction})` olasılığı 0–1 aralığında tutar. ArGe isabeti ve kaçınmanın yüzde puan olarak toplanması/çıkarılması yerel formüldür. İstemcideki ArGe tabloları mevcut; özel sunucudaki birleşim sırası yayımlanmamıştır.
- AIM CPU, kalan ıskalama olasılığını %25/%50 azaltır; %25/%50 doğrudan isabet puanı eklemez. Xenomit tüketimi ve takılı/etkin CPU denetimi `cpu.aimChance` içindedir. Örnek: %80 taban + AIM-02 → %90; %80 + %10 ArGe + AIM-02 → %95. Bu birleşim sırası yerel seçimdir.
- **Genel NPC, normal roket ve Hellstorm temel isabet oranları bu incelemede birincil kaynakla tam doğrulanamadı.** Bunlara tahmini %75/%80 özgün oranı atanmıyor; mevcut `%100` yerel varsayılan, `npcHitChance/rocketHitChance/launcherHitChance` ayarlarıyla açıkça değiştirilebilir. Özel NPC türlerinin yayımlanmış isabeti, genel NPC tabanını kanıtlamaz. ArGe/PET protokolleri ve kaçınma kendi akışlarında uygulanır.
- Diminisher'ın bitişindeki kendi kalkan kaybı mevcut kalkanın bir defalık %30 azaltılması olarak korunur. Özgün kalkan havuzu/konfigürasyon ayrıntısı ve SAB'ın ek kalkan hasarından ne kadarını geri aktardığı tam doğrulanmadı. Mevcut sunucu SAB'ın tüm uygulanan kalkan kaybını aktarır.
- Sentinel kalkan hasarını azaltır, aynı atışın gövde payını değiştirmez. Spectrum ve Sentinel yalnız `attackType=1` lazer saldırısını azaltır; roket hasarı bu yetenekler üzerinden yanlışlıkla düşürülmez. NanoHull, gövdeye kalan hasarda `nano-hull.damageHull` tarafından canın önünde tüketilir. Solace yalnız normal canı tamir eder; NanoHull üretmez/sıfırlamaz.
- Hedef menzili, hedef kaybında iptal ve beklemenin aktivasyondan itibaren işlemesi mevcut yerel yaşam döngüsüdür. Etki harita/geçiş/ölüm/çıkışta kalkar, kaydedilmiş bekleme korunur. Modern gemi yeteneklerinin tümü bu altı klasik yeteneğe dahil değildir.

## Ayar uyumluluğu ve testler

Üretim `config.combat` varsayılanı `laserDamageMin:0.75`, `laserDamageMax:1`, `laserHitChance:0.8`. Eski **açık** `damageSpread` ayarı uyumluluk için önceliklidir; örneğin `damageSpread:0` deterministik test/özel sunucu senaryosunda sabit maksimum hasar verir. Böyle bir override özgün denge diye sunulmaz. Süre/bekleme özelleştirmeleri `combat.shipAbilities.<name>.durationMs/cooldownMs` altında kalır.

`node --test tests/combat-balance.test.js tests/ship-abilities.test.js`: 21 test geçti. Aralık uçları ve 10.001 deterministik örnekte üst sınır, eski ayar uyumluluğu, %80 isabet, ArGe/CPU birleşimi ve taşma sınırları, altı yeteneğin gerçek menü sayaçları ve hazır olma eşikleri, roket/lazer ayrımı, NanoHull koruması, DB geri alma ve kalıcı bekleme test edildi. Testler geçici bellek DB'si kullanır; üretim hesabı/eşyası/bakiyesi değiştirilmez. Flash görsel uçtan uca doğrulaması bu sayıların kanıtı olarak gösterilmez.

Önceki sürümün30/120 saniye Diminisher,30 saniye Spectrum ve90 saniye Lightning varsayımları kaldırıldı. `docs/ship-abilities-local.md` tablosu ve çalışan modül güncel kaynaklı değerlerle eşleştirildi.

## 23 Ekim 2026 yeniden inceleme

`itemHitChance` yayımlanmış cephane oranını genel yerel varsayılandan önce kullanır; açık sunucu override'ı yine önceliklidir. OBR-100 artık [resmî Eylül2026 Galactic Strife FAQ](https://board-en.darkorbit.com/threads/galactic-strife-faq-09-2026.130406/) gereği%90 tabandan başlar;6.000PvE hasarı ve650menzil korunur. Çoklu roketatar, her yuvanın kendi geliştirme bonusu ve kesirli yükleme deadline'ı `docs/hellstorm-local.md` içinde açıklanır.79 ilgili test geçti (`logs/combat-launchers-round2-tests.log`).

**Özgün sunucuyla birebir bütün RNG/formül eşitliği doğrulanmış değildir.** [Resmî forumdaki moderatör cevabı](https://board-en.darkorbit.com/threads/missing-shot.30420/) genel isabet oranının yayımlanmadığını açıklar; oyuncu tahminleri%60/%65/%80/%90 gibi farklı sonuçlar verir. Bu nedenle yalnız oyuncu tahmininden PLT-3030'a kesin%65 veya genel NPC'ye hayali bir oran atanmadı. FAQ'nın PLT-3030 için düşük isabet ifadesi sayısal özel oran ihtiyacını doğrular; sayısal değer açık kalır. Aynı nedenle ArGe/kaçınma/CPU kompozisyonu ve yüksek isabet üst sınırı hâlâ kaynak sınırıdır. LF4%80, lazer%75–100,1sn ritim ve yayımlanan yetenek süreleri doğrulanan kısımdır.
