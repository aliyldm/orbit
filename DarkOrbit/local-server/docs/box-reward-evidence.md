# Bonus ve korsan kutusu doğrulama kanıtları

2026-10-20. Bu belge özgün istemcinin sözleşmesini ve yayımlanmış resmî kaynakları ayırır. İstemci kutuların ödül ağırlıklarını içermez; katalog fiyatı da sunucunun ganimet olasılığı değildir. Yerel ağırlıklar özgün oran olarak sunulmamalıdır.

## Normal bonus kutusu

Resmî [2013 Bonus Box items FAQ](https://board-en.darkorbit.com/threads/bonus-box-items.796/) tablosu:

| Ödül | Normal harita miktarları |
|---|---|
| LCB-10 / x1 | 10, 20, 50 |
| MCB-25 / x2 | 5, 10, 20 |
| MCB-50 / x3 | 5, 10, 20 |
| Credits | 200, 500, 1000 |
| Uridium | 20, 50, 100 |
| Extra energy | 1 |

Aynı FAQ battle 4-x kutularında %50 fazla ödül bildirir; tablosunda 5 mühimmatın karşılığı 8, diğer x2/x3 miktarları 15/30, Credits 300/750/1500 ve Uridium 30/75/150 bulunur. Extra energy için 4-x tablosu da 1 yazar; bunu otomatik 2 yapmak desteklenmez. Özel etkinlik ekleri aynı başlıkta karışıktır; Xenomit/PLT-2021 gibi ekler normal sürekli havuz için bu kaynaktan tek başına çıkarılamaz.

[DE Bonus-Boxen FAQ](https://board-de.darkorbit.com/threads/faq-bonus-boxen.2985/) de Credits, Uridium miktarlarını ve battle haritasındaki %50 artışı bağımsız doğrular. Yüzdelik kazanma olasılıkları iki kaynakta da verilmez. Jackpot parası/banking çarpanı tarihî gerçek para sistemleridir; yerel ekonomik ödül olarak sessizce yeniden etkinleştirilmemelidir.

## Korsan kutusu ve anahtar eşleşmesi

| Renk | AddBoxCommand.boxType | Envanter loot ID | Anahtar sayısı bildirimi |
|---|---|---|---|
| Yeşil | PIRATE_BOOTY | resource_booty-key | 0\|A\|BK\|n |
| Sarı / altın | PIRATE_BOOTY_GOLD | resource_booty-key | 0\|A\|BK\|n |
| Kırmızı | PIRATE_BOOTY_RED | resource_booty-key-red | 0\|A\|BKR\|n |
| Mavi | PIRATE_BOOTY_BLUE | resource_booty-key-blue | 0\|A\|BKB\|n |

Kanıtlar:

- `decompiled/main/scripts/net/bigpoint/darkorbit/InGameCatalog.as:1553`–1557 renkli kutu tiplerini kaydeder.
- `client/spacemap/templates/tr/flashres.xml:4979`–4988 Türkçe renk adlarını doğrular.
- `map/model/env/collectable/Box.as:17` gelen tipe `box_` öneki ekler.
- `mvc/common/model/assets/UberAssetsLib_LIB_COLLECTABLES_XML.as:5` gömülü DefineBinaryData 192'yi belirtir. Bu XML doğrudan `client/spacemap/main.swf` içinden okunarak doğrulandı: `box_PIRATE_BOOTY` → 2D `pirateBootyBox`, 3D `box_21.zip`; altın → `pirateBootyGoldBox` / `box_22.zip`; kırmızı → `pirateBootyRedBox` / `box_31.zip`; mavi → `pirateBootyBlueBox` / `box_32.zip`.
- `items/ItemDataProvider.as:12080`, 14122, 14174 anahtar loot ID'lerini tanımlar; `docs/client-map.items.json` aynı katalogdan çıkarılmıştır. Katalog yeşil 1500 U., kırmızı 3000 U., mavi 4500 U. metadata içerir. Kırmızı/mavinin resmî Uridium mağaza satışı olduğu bu metadata ile kanıtlanmaz.
- `net/ServerCommands.as:908`–912 ve `net/SetAttributeAssembly.as:480`–493 anahtar sayılarının BK/BKB/BKR bildirimlerini işler. İlk girişte de her üç sayaç gerçek sahiplikten gönderilmeli; satış/ödül/toplama sonrası güncellenmelidir.

[Resmî Beuteboxen FAQ](https://board-de.darkorbit.com/threads/faq-beuteboxen.113680/) yeşilin sürekli, altının Zeus etkinliği sırasında, kırmızı/mavinin kendi etkinlikleri sırasında bulunduğunu söyler. **Altın için ayrı sarı anahtar yoktur; yeşil anahtar kullanılır.** [Zeus FAQ](https://board-de.darkorbit.com/threads/faq-zeus-tag.2991/) altın kutularda Zeus parçalarını doğrular. Etkinlikleri sürekli açık tutmak yerel sunucu tercihidir.

## Toplama protokolü ve davranışı

- `managers/EventManager.as:336`–365: kutuya hareket tamamlandıktan sonra `CollectBoxRequest(hash, boxX, boxY)` gönderilir; `posX/posY` kahramanın konumudur. Bu koordinatlar güvenlik için tek otorite kabul edilmemeli, sunucu konumu esas alınmalıdır.
- Açma bildirimi: **`0|y|SLA|seconds`**. Araya boş/ek parametre konmaz. `net/BoxCollectResponseAssembly.as:565`–574 `formatLegacy` bu diziyi `[0, LOG_MESSAGE, STANDARD, SLA, seconds]` şekline getirir; 362–368 içindeki `param1[4]` artık saniyedir. `CollectorBeamEffect.as:17` süreyi saniyeden milisaniyeye çevirir ve en az 1000 ms uygular.
- İptal: `0|y|SLC`; `BoxCollectResponseAssembly.as:371`–377 kahramandaki COLLECTOR_BEAM etkisini kaldırır.
- Aynı biçimde doğrulanan ödül logları: `0|y|BAT|lootId|amount`, `0|y|ROK|lootId|amount`, `0|y|XEN|amount`, `0|y|JV|amount`, `0|y|LOT|lootId|amount`, `0|y|CRE|delta|newTotal`, `0|y|URI|delta|newTotal`. LOT sabitinin adı `ServerCommands.ITEM_LOOT` (`ServerCommands.as:118`). Logun yanı sıra gerçek envanter/cephane/durum paketleri de güncellenmelidir.

[EN Booty Chest FAQ](https://board-en.darkorbit.com/threads/booty-chest-faq.799/) anahtarı tek kullanımlık, yeşil fiyatını 1500 U. olarak belirtir. Açarken sabit durmak gerekir; hareket toplama işlemini iptal eder. EN metni bu sırada saldırıya izin verir. Eski [DE green FAQ](https://board-de.darkorbit.com/threads/faq-gruene-piratenbeute.2792/) saldırının iptal/anahtar kaybı yaptığını yazar: bu iki eski resmî sayfa çelişir; iptal anında anahtar yakma davranışı tek ve tartışmasız özgün kural diye sunulmamalıdır. Exact açma süresi bu FAQ'larda yoktur, sadece birkaç saniye denir.

EN FAQ'ya göre x-1, Galaxy Gates, group/invasion gates, TDM, jackpot ve ??? haritaları hariç haritalarda bulunurlar; bazı NPC'ler de düşürebilir, korsanlarda ihtimal daha yüksektir. Kesin doğum sayısı, ömrü ve NPC düşürme oranı yayımlanmamıştır.

Yeşil anahtar yokken otomatik satın alma ayarı etkinse ve yeterli Uridium varsa yeşil anahtar alınabilir; bu kırmızı/mavi otomatik satın almayı kanıtlamaz.

## Özgün ganimet havuzu ve bilinmeyenler

Eski [DE green FAQ](https://board-de.darkorbit.com/threads/faq-gruene-piratenbeute.2792/) mühimmat, roket, gemi, CPU, kalkan jeneratörü, booster, Xenomit, mayın, log disk, atlama kuponu, extra energy, LF-4, Apis parçaları ve hardware kategorilerini listeler. **Miktarlar, item bazlı tam liste ve olasılıklar verilmez.** Yerelde uygulanmış desteklenen alt küme bu kategorilerden seçilebilir; tam özgün havuz/olasılık eşitliği iddia edilemez.

[19 Nisan 2017 resmî duyurusu](https://board-en.darkorbit.com/threads/red-and-blue-booty-boxes-updated.118827/) kırmızı/mavi havuzun PET tasarımları ve geliştirilmiş LF-4 malzemelerine dönüştürüldüğünü söyler. [Güncel EN FAQ](https://board-en.darkorbit.com/threads/reworked-red-blue-booty-box-faq.118819/) Temmuz 2026 düzenlemesidir; PET paketleri ve malzemeler için yayımlanmış oranlar mevcut olsa da bunlar eski klasik havuzun oranları değildir. [DE FAQ](https://board-de.darkorbit.com/threads/faq-rote-blaue-beuteboxen.112328/) havuzun düzenli değiştiğini açıkça belirtir. Bunların 2013 klasik oyunla birleştirilmesi kaynak açısından yanlış olur.

## PET

[Resmî moderatör yanıtı, 20 Temmuz 2020](https://board-de.darkorbit.com/threads/pet-auto-sammler-gear.118969/) #5: auto collector yalnızca cargo ve bonus kutularını toplar; korsan kutusu toplama gear'ı yoktur. Bu nedenle PET otomatik toplama adaylarından anahtarlı korsan kutuları hariç tutulmalıdır. Normal mavi bonus kutuları ile mavi anahtarlı korsan kutuları aynı nesne/havuz değildir.
