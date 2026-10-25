# Payment paket içeriği ek doğrulaması — 20 Ekim 2026

Bu inceleme, fiyatı 1.000.000 Uridyum olan kayıtlı Payment tekliflerinin eksik teslim tariflerini tamamlar. Ürün görseli tek başına paket içeriği kabul edilmez. Miktarları bulunamayan içerikler tahmin edilmez.

## Kullanılan kanıtlar

- Yerel özgün kayıt: `web/portal/pages/internalDock~internalDockCustomization.html` ve `internalDock~internalDockSpecials.html` içindeki `itemData` açıklamaları, gerçek `imageVars.loot_id` ve varsa `lootItems`.
- Yerel istemci eşya tanımı: `docs/client-map.items.json` ve `decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as`.
- [24 Temmuz 2019 tarihli resmî Stellar Pathfinder duyurusu](https://board-en.darkorbit.com/threads/stellar-pathfinder-bundles-available-for-a-limited-time-only.124363/), beş 2019 paketinin tam listesi ve bir kez satın alma kuralı. [Fransızca Aralık 2019 duyurusu](https://board-fr.darkorbit.com/threads/stellar-pathfinder-bundles-decembre2019.130391/) aynı dönem içeriğini ayrıca doğrular.
- [Perseus Grace resmî açıklaması](https://board-en.darkorbit.com/threads/faq-perseus-grace-event.128748/) Perseus anahtarı ve Dusklight paketi kimliğini doğrular; belirli paket miktarları yerel Türkçe ürün açıklamasından alınır.
- [Tartarus resmî gemi açıklaması](https://board-en.darkorbit.com/threads/tartarus-ship.115771/) ana geminin varsayılan renginin Hot-Fusion Red olduğunu belirtir. [Resmî Tartarus set yanıtı](https://board-en.darkorbit.com/threads/gi-tartarus-set.116073/) içeriğin gemi, 10 Phantom diroit tasarımı ve 1 Chimera PET tasarımı olduğunu ayrıca doğrular.
- [Ekim 2025 resmî duyurusu](https://board-en.darkorbit.com/threads/october-sync.129908/) Deluxe takvimin 28 günlük ve kaçırılan günün ödülünün kaçırıldığı bir ürün olduğunu doğrular. Tam günlük ödül tablosu bu kayıtta bulunmadığı için takvim ödülleri buradan uydurulmaz.

## Tamamlanan tarifler

| Teklif | Kaynakta doğrulanan ve uygulanan içerik |
| --- | --- |
| Stellar2019-1 | Goliath, 5 kararsız LF-4, 5 BO2, 15 hız, 2 Iris, PET, 10.240.000 TP, 3.000 Seprom, 5.000 U. |
| Stellar2019-2 | Goliath, 10 kararsız LF-4, 10 BO2, 15 hız, 4 Iris, PET, Kamikaze 3, 10.240.000 TP, 3.000 Seprom, 100.000 U. |
| Stellar2019-3 | Aegis, 20 kararsız LF-4, 15 BO2, 15 hız, 4 Iris, PET, Kamikaze 3, 10.240.000 TP, 3.000 Seprom, 50.000 UCB, 25.000 CC-D, 200.000 U. |
| Stellar2019-4 | Hammerclaw, 25 kararsız LF-4, 25 BO2, 16 hız, 8 Iris, PET, Kamikaze 3, 327.680.000 TP, 5.000 Seprom, 100.000 UCB, 25.000 CC-D, 400.000 U. |
| Stellar2019-5 | Cyborg, 25 kararsız LF-4, 5 hiperplazmoid, 30 BO2, 16 hız, 8 Iris, PET, Kamikaze 3, 327.680.000 TP, 10.000 Seprom, 200.000 UCB, 25.000 RSB, 25.000 CC-D, 400.000 U. |
| Kırmızı Kutu / masqueChimera | 10 kırmızı Phantom diroit tasarımı, 1 kırmızı Chimera PET tasarımı. Renk, ürün adı ve doğrudan PET kimliğiyle belirlenir. |
| Tartarus expo seti | 1 varsayılan kırmızı Tartarus gemisi, 10 kırmızı Phantom diroit tasarımı, 1 kırmızı Chimera PET tasarımı. Bunlar diroit gövdesi değildir. |
| Halloween ammo | 1.500 K-300M, 4.000 CC-A, 4.000 RSB-75, 3.500 SBL-100. |
| Halloween mega | 10'ar saat DMG-B02 / SHD-B02 / CD-B02, 10.000 SBL-100, 10 anti-mayın vericisi. |
| Orcus bundle | 1 Orcus, 2 Black Light Cipher, 3 Black Light Decoder. |
| Dusklight fullpack | Hecate ve Spectrum Dusklight tasarımları, kalkan protokolü 4, 5.000 UCB-100, 5 Perseus anahtarı, 100 ekstra enerji. Cyborg görseli teslim listesine alınmaz. |
| Zephyr tasarım paketi | Ullrin ve Nobilis Zephyr, 700 K-300M, 10.000 UCB-100. |
| Pusat tasarım paketi | Poison, Inferno ve Carbonite Pusat, 700 K-300M, 10.000 UCB-100. |
| Halloween battle pass | 1 savaş bileti, 5 savaş bileti anahtarı, 3.500 SBL-100. |
| Powerup booster 2025 | 20 saat NPC-B01; 10'ar saat NPC-B02, DMG-B01, DMG-B02, DMG-H01; 5 saat SHD-B02. |

Stellar2019 kayıtları `once:true` taşır. Gerçek fiyat 1.000.000 U. düşüldükten sonra paketin kendi Uridyum ödülü ayrıca eklenir. Örneğin 400.000 U. içeren paket net 600.000 U. tüketir. Oyuncunun PET/diroit kapasitesi uygun değilse bütün işlem geri alınır; sessiz eksik teslim yapılmaz.

## Düzeltilen kimlik eşlemeleri

- **CC-A → `ammunition_laser_spacecup_group-a`; CC-D → `ammunition_laser_spacecup_group-d`.** CC-D, Stellar2022-3 özgün satırında doğrudan görsel loot kimliği olarak da bulunur. Böylece dört 2022 paketinin içeriği tam teslim edilebilir.
- **SR-5 → `ammunition_specialammo_sr-5`**, **K-300M → `ammunition_specialammo_k-300m`**. İstemci `ItemDataProvider.as:2743` ve `:3386` tanımları ve paket görselleri aynı kimliği verir. Önceki JSON çıkarımı bunları atlamıştı; cephane tanımları ve çalışma davranışı ayrı ekipman değişikliğiyle tamamlanır.
- **K-3000M** Zephyr açıklamasındaki yazım hatasıdır. Aynı satırın görsel kimliği K-300M'dir; ayrı, var olmayan mühimmat üretilmez.
- **AI-SM4**, mevcut dört kademeli kalkan ailesinin dördüncü kademesi olarak yorumlanıp canonical `equipment_aiprotocol_ai-sm1`, `pet_level=4` biçiminde kaydedilir. Bu pazarlama kısaltmasının seviye eşlemesi bir çıkarımdır; bağımsız `ai-sm4` tanımı yoktur. Gerçek istemci varyant tablosunda dördüncü giriş `ai-sm13`, kalkan bonusu %6'dır. Yeni, istemcinin tanımadığı `ai-sm4` nesnesi oluşturulmaz.
- Beş saatlik SHD-B02, iki katına yuvarlanmaz; `boosterHours` tam süreyi taşır.

## Miktar/çeşit kanıtı hâlâ bulunmayan teklifler

Aşağıdaki 23 satırın ödeme sonrası tam seçimleri veya miktarları kaydedilmemiştir. Kaynakta olmayan listeyi aynı isimli bir görselden türetmek güvenilir değildir. Bu alt görev bunları açmaz:

| Grup | SKU'lar | Eksik kanıt |
| --- | --- | --- |
| Seçimli kozmetik, 4 | `package_dd-rb-02`, `package_dd-s-02`, `package_dd-r-02`, `package_dd-p-01` | Satın alma sonrası renk seçimi ve teslim adedi. |
| Diğer kozmetik, 4 | `package_pd-pc-01`, `package_deal-phantomChimera`, `package_f-s-02`, `package_f-s-0201` | Arctic gerçek kimliği, belirli renkler veya tam set listesi. |
| Üyelik/özel paket, 4 | `deal_best-subscription`, `deal_plagueAlertBooster`, `deal_blacklightMindfireBundle`, `package_event-deal-month-deluxe` | Tam abonelik/destek içerikleri ve süreleri; Deluxe günlük tablo. |
| Miktarı belirsiz kaynak paketi, 8 | `package_event-deal-bpk-l`, `package_event-deal-unstable-shard-xl`, `package_event-deal-polychromium-pack`, `package_event-deal-permitplus`, `package_event-deal-astralkey`, `package_deal-salvage-core-all`, `package_event-deal-pre-aa-ranking-2023`, `package_event-deal-season-point` | Adetler, paket alt seçenekleri ve ek bileşenler. |
| Helios malzemesi, 3 | `package_event-deal-s-h-pusat-plus`, `package_event-deal-s-h-solace-plus`, `package_event-deal-s-h-goliath-plus` | Malzemenin paket başına miktarı. Tarif için 4 LEG gerektiği, pakette kaç Energy bulunduğunu söylemez. |

## Doğrulama

`node --test tests/payment-contents.test.js` — **8/8 geçti**. Bağımsız kaynak beklentileriyle beş 2019 manifestinin gerçek satın alınması, CC-D teslimleri, özel cephane kimlikleri, bir kez alım kuralı, yanıltıcı görselli Perseus paketi, PET kademesi, Tartarus kozmetik/gövde ayrımı ve tam destek süreleri kontrol edilir. Testler yalnızca `:memory:` veritabanı kullanır; oyuncu hesaplarına ürün/para verilmez. Katalog/veritabanı uygunluk kontrolü **173 açık, 23 belirsiz içerikten kapalı teklif** verdi.

Teslim edilmesi, her modern gemi yeteneğinin veya her kaynak değişim sisteminin bu dosyada tamamlandığı anlamına gelmez. Buradaki kapsam, miktarı doğrulanmış tam paket teslimi ve ilgili atomik satın alma koşullarıdır.
