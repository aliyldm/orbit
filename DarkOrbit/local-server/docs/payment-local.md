# Yerel Payment ürünleri — 21 Ekim 2026

Kullanıcının isteği: menüde Payment olarak gösterilen tekliflerin her biri **1.000.000 Uridyum** olsun. Çok oyunculu sistem veya gerçek ödeme eklenmez.

## Uygulanan kapsam

- Kaydedilmiş beş dükkân sayfasındaki **196 Payment satırının tamamı** sabit 1.000.000 U. fiyatına çevrilir: 129 özel teklif, 30 gemi tasarımı, 22 kişiselleştirme, 10 lazer/sürücü/mercek, 5 gemi teklifi.
- **173 teklifin tam teslim içeriği** kayıtlı `lootItems`, tekil gemi tasarımı kimliği veya incelenmiş Türkçe açıklamayla eşleştirildi. Son işlev denetimi bunların 11'ini çalışmayan bileşenleri nedeniyle kapatır; **162 teklif satın alınabilir**. Güncel durum ve gerekçeler `shop-product-audit.md` içindedir.
- **23 teklif**, tam miktar/içerik kaydı bulunmadığı, bileşeni katalogda olmadığı veya destek etkisi henüz uygulanmadığı için açıklamalı biçimde kapalıdır. Fiyatları 1.000.000 U. olarak gösterilir; tıklama/istek para çekmez ve başarılı teslim bildirmez. Bir paket görselinin loot ID'sini bütün paket sanıp eksik ürün teslim etmiyoruz.
- Payment menüsü özgün Özel Teklifler dükkânına açılır. Portal ürün satırları, native ShopItemCommand ve satın alma sunucusu aynı fiyatı kullanır; `isPaymentItem=false`, indirim faktörü 1 uygulanır. Tekrarlanabilir paketlerde miktar seçimi ve bütün bileşenlerin çoğaltılması desteklenir; benzersiz ürünler tek adetle sınırlıdır. Ayrıntılar: `payment-quantity-and-portal-countdown.md`.
- Normal kredi/Uridyum tekliflerinin fiyatları, PET kademeleri ve diroit fiyat basamakları korunur. Tek bir paketin ikonu olan Seprom/UCB-100 gibi ürünlere belirsiz paket alias'ı verilmez. Gerçek tekil ürüne karşılık gelen ve normal teklifi olmayan kanonik kimlikler aynı sabit fiyatı kullanabilir.

## Teslim ve kayıt davranışı

Bir satın alma tek SQLite işlemi içinde bakiyeyi düşürür ve bütün bileşenleri teslim eder. Herhangi bir depolama/kapasite/sahiplik hatası, önceki bütün teslimleri ve para düşümünü geri alır. Canlı oyuncunun henüz kaydedilmemiş para/TP değerleri korunur; bellek ancak commit sonrası güncellenir.

Gemiler `ships`, gemi tasarımları `ship_designs`, gerçek ekipman ve cephane `items`, destek süreleri `player_boosters`, Seprom gibi klasik madenler `player_resources` içine gider. Uridyum içeren paketler gerçek bakiyeyi artırır; sahte `currency_uridium` envanter nesnesi verilmez. Örneğin 300.000 U. paketi 1.000.000 U. ücretle alınır, net düşüm 700.000 U.'dur.

Biletler Sezon ve Biletler sayfasından etkinleştirilir; Gold/Extra yerel 90 seviyelik sezonu, Trinity/Voyagers kaynaklı ödül tablolarını kullanır. Özgün modern etkinlik haritaları yerine açıkça yerel GG ilerleme köprüsü vardır. Modern ekipman savaş işlevleri, 122 PET kaplamasının takılması ve kaynaklı destek etkileri bağlanmıştır. Bütün modern gemi yeteneklerinin veya özel efektlerin tamamlandığı iddia edilmez. Ayrıntılar: payment-events-local.md, modern-equipment-local.md, payment-cosmetics-boosters.md. HM7 gerçek ekipman kimliğiyle teslim edilir; sınırlı CPU kullanımları CPU modülünün kalıcı şarj defterinde ilk kullanımda oluşturulur.

## Kanıt ve dosyalar

- `web/portal/pages/internalDock~internalDockCustomization.html`, `~internalDockLaser.html`, `~internalDockShipModel.html`, `~internalDockShips.html`, `~internalDockSpecials.html`: özgün SKU, açıklama, ürün resmi, `lootItems`, `isPaymentItem`.
- `web/portal/shop.json`: önceki dükkân tekliflerinin fiyat/sınıf kaydı.
- `docs/client-map.items.json`, `game/db/catalog.json`: gerçek bileşen kimlikleri, eşya sınıfı, taban ekipman özellikleri.
- `game/payment.js`: kayıtlı satır envanteri, sabit fiyat, güvenli alias, uygunluk, atomik teslim bileşenleri, yerel Payment sayfası.
- `game/payment-bundles.js`: incelenmiş açıklamalardan açıkça listelenen tarifler. Bilinmeyen bileşen adları saklanır ve ilgili tarif kapatılır.
- `game/economy.js`, `game/handlers/shop.js`, `web/portal/render.js`: alışveriş ve istemci bağlantıları.

Özellikle SR-5 ve CC-D bazı paket açıklamalarında geçer, fakat gönderilmiş istemci eşya kataloğunda gerçek bileşen kimlikleri bulunmaz; benzer isimli başka cephane verilmez. Belirsiz miktarlı üyelik/aylık paketlere varsayılan ödüller uydurulmaz.

## Doğrulama

Aşağıdaki ilk alt görev sayıları tarihsel kayıttır; güncel çalışma ve kapalı ürün denetimi latest-local-validation.md ve shop-product-audit.md içindedir.

`node --test tests/payment-local.test.js` — **11/11**. 173 etkin teklifin her biri ayrı test hesabında satın alınıp tam bileşen teslimi ve 1.000.000 U. brüt düşüm doğrulanır. 23 kapalı teklifin her biri para/eşya değişikliği yapmadan reddedilir. Ayrıca işlem ortası DB hatası, tekrar sahip olunan tasarım, yetersiz bakiye, sahte miktar, canlı oyuncunun bekleyen ödülleri, codec, bütün 196 portal satırı, indirim ve proxy kaldırılması sınanır.

`node --test tests/shop-ui.test.js tests/inventory-drones-shop.test.js tests/payment-local.test.js` — **38/38**. Native dükkân listelerinde 173 açık teklifin tamamının bulunduğu da doğrulandı. Veritabanı sadece `:memory:` idi; gerçek hesaba ürün veya para verilmedi, sunucu bu alt görevde yeniden başlatılmadı.

## Teklif envanteri

196 tekliften 162 tanesi satın alınabilir; 23 eksik manifest ve 11 işlevsiz bileşenli teklif kapalıdır. Her teklif 1.000.000 U.

| SKU | Teklif | Durum |
| --- | --- | --- |
| package_dd-rb-02 | Robo-bat Diroit Renkleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_dd-s-02 | Skull Diroit Renkleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_dd-r-02 | Reaper Diroit Renkleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_dd-f-01 | Hailstorm Diroit | Teslim açık |
| package_dd-p-01 | Harika M.A.S.Q.U.E. Diroiti | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_pd-pc-01 | Arctic, Kırmızı ve Yeşil P.E.T. | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_pd-c-01 | Yeşil Chimera P.E.T. | Teslim açık |
| package_pd-c-02 | Turuncu Chimera P.E.T. | Teslim açık |
| package_pd-c-03 | Kırmızı Chimera P.E.T. | Teslim açık |
| package_masqueChimera | Kırmızı Kutu | Teslim açık |
| package_expo-tartarus | Tartarus Uzay Gemisi, P.E.T. ve Diroit | Teslim açık |
| package_poisonA-EliteSet | Poison A-Elite Uzay Gemisi, P.E.T. ve Diroit | Teslim açık |
| package_event-deal-poisenPusatSet | Poison Pusat Uzay Gemisi, P.E.T. ve Diroit | Teslim açık |
| package_event-deal-poisenSpectrumSet | Poison Spectrum Uzay Gemisi, P.E.T. ve Diroit | Teslim açık |
| package_event-deal-blaze-spectrum-full | Blaze Spectrum Uzay Gemisi, P.E.T. ve Diroit | Teslim açık |
| package_event-deal-blaze-pusat-full | Blaze Pusat Uzay Gemisi, P.E.T. ve Diroit | Teslim açık |
| package_deal-frozenMirage | Donmuş Mirage Uzay Gemisi Kaplamaları | Teslim açık |
| package_deal-spectrumChroma | Spectrum Chroma Uzay Gemisi Kaplamaları | Teslim açık |
| package_deal-pusatChroma | Pusat Chroma Uzay Gemisi Kaplamaları | Teslim açık |
| package_deal-phantomChimera | Phantom Chimera Uzay Gemisi Kaplamaları | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_f-s-02 | Harika Uzay Gemisi Kaplamaları | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_f-s-0201 | Göz Alıcı Kaplamalar | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-laser-osl | Odysseus Lazeri | Teslim açık |
| package_event-deal-laser-lf5mf | LF-5 Mortifer | Teslim açık |
| package_event-deal-laser-lf5al | LF-5-Anchorlock | Teslim açık |
| package_event-deal-laser-prl | Prometheus Lazeri | Teslim açık |
| package_event-deal-laser-aml | Asmodeus Lazeri | Teslim açık |
| package_event-deal-voyagers-igni-p | IgniDrive Prime | Teslim açık |
| package_event-deal-voyagers-igni-a | IgniDrive Apex | Teslim açık |
| package_event-deal-voyagers-igni-l | IgniDrive Lite | Teslim açık |
| package_event-deal-voyagers-gl-o | Grav-Merceği Omega | Teslim açık |
| package_event-deal-voyagers-gl-c | Grav-Merceği Kron | Teslim açık |
| ship_defcom_design_defcom-expo2016 | Expo16 Defcom Tasarımı | Teslim açık |
| ship_yamato_design_yamato-expo2016 | Expo16 Yamato Tasarımı | Teslim açık |
| ship_pusat_design_pusat-blaze | Blaze Pusat Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-albania | Arnavutluk G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-austria | Avusturya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-belgium | Belçika G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-croatia | Hırvatistan G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-czech-republic | Çekya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-england | İngiltere G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-france | Fransa G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-germany | Almanya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-hungary | Macaristan G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-iceland | İzlanda G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-independence | USA G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-italy | İtalya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-northern-ireland | K. İrlanda G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-poland | Polanya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-portugal | Portekiz G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-republic-of-ireland | İrlanda G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-romania | Romanya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-russia | Rusya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-slovakia | Slovakya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-spain | İspanya G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-sweden | İsveç G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-switzerland | İsviçre G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-turkey | Türkiye G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-ukraine | Ukrayna G-Champion Tasarımı | Teslim açık |
| ship_g-champion_design_g-champion-wales | Galler G-Champion Tasarımı | Teslim açık |
| ship_spectrum_design_spectrum-blaze | Blaze Spectrum Tasarımı | Teslim açık |
| ship_a-elite_design_a-elite-poison | Poison A-Elite Tasarımı | Teslim açık |
| package_s-os-01 | Yamato ve Defcom Gemileri | Teslim açık |
| package_pack-defcom-raven | Defcom Raven | Teslim açık |
| package_pack-yamato-ronin | Yamato Ronin | Teslim açık |
| package_pack-g-ignite | Goliath Ignite | Teslim açık |
| package_pack-n-ambassador | Nostromo Ambassador | Teslim açık |
| package_event-deal-stellar2019-1 | Gösteriş Meraklısı Paketi | Teslim açık |
| package_event-deal-stellar2019-2 | Maceraperest Paketi | Teslim açık |
| package_event-deal-stellar2019-3 | Öncü Paketi | Teslim açık |
| package_event-deal-stellar2019-4 | Kâşif Paketi | Teslim açık |
| package_event-deal-stellar2019-5 | Gezgin Paketi | Teslim açık |
| deal_best-subscription | Muhteşem Üyelikler | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| deal_plagueAlertBooster | Özel Yeni Destekler! | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| deal_booty-key-overhaul-march-blue | Mavi Ganimet Anahtarı | Teslim açık |
| deal_booty-key-overhaul-march-red | Kırmızı Ganimet Anahtarı | Teslim açık |
| deal_blacklightMindfireBundle | Mindfire Ganimeti | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-halloween-s-corn-pack | Cadılar Bayramı İkramları Paketi | WIZ-X hedefin görünüşünü geçici değiştirir; bu dönüşüm etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-halloween-corn-pack | Büyük Cadılar Bayramı İkramları Paketi | WIZ-X hedefin görünüşünü geçici değiştirir; bu dönüşüm etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-halloween-ammo-pack | Korkunç Cephane Paketi | Teslim açık |
| package_event-deal-halloween-mega-pack | Mega Cadılar Bayramı Paketi | Bu teknolojinin etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-month-deluxe | Aylık Deluxe Paket | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-orcus-bundle | Black Light Gemi Paketi | Teslim açık |
| package_event-deal-bpk-l | SBA Paketleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-unstable-shard-xl | Kararsız Parça Paketleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-special-gear-xl | Özel Modül Paketi XL | Teslim açık |
| package_event-deal-special-gear-l | Özel Modül Paketi L | Teslim açık |
| package_event-deal-special-gear-m | Özel Modül Paketi M | Teslim açık |
| package_event-deal-special-gear-s | Özel Modül Paketi S | Teslim açık |
| package_event-deal-polychromium-pack | Polikrom Paketleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-permitplus | İzin Plus Paketleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-astralkey | Astral Ganimet Anahtarı Paketleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-stellar2022-1 | Gözcü Paketi | Teslim açık |
| package_event-deal-stellar2022-2 | Selef Paketi | Teslim açık |
| package_event-deal-stellar2022-3 | Gardiyan Paketi | Teslim açık |
| package_event-deal-stellar2022-4 | Öncü Paketi | Teslim açık |
| package_deal-salvage-core-all | Kurtarma Çekirdeği Teklifleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-restabilize-boost | Stabilizasyon Destek Paketi | Teslim açık |
| package_event-deal-dmg-npc-boosters | NPC Destek Paketi | Teslim açık |
| package_event-deal-dmg-npc-buster | NPC Patlatma Paketi | Teslim açık |
| package_event-deal-dmg-npc-ammo | NPC Cephanesi Paketi | Teslim açık |
| package_event-deal-phantasm-berserker | Phantasm Berserker Paketi | Teslim açık |
| package_event-deal-phantasm-sentinel | Phantasm Sentinel Paketi | Teslim açık |
| package_event-deal-phantasm-fullpack | Phantasm Gemi Tasarımı Paketi | Teslim açık |
| package_event-deal-pre-aa-ranking-2023 | Astral Tedarik Paketleri | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-goldpass | Sezon Bileti | Teslim açık |
| package_event-deal-ship-ult-berserker | Berserker Nihai Paketi | Teslim açık |
| package_event-deal-ship-ult-spectrum | Spectrum Nihai Paketi | Teslim açık |
| package_event-deal-ult-cyborg | Cyborg Nihai Paketi | Teslim açık |
| package_event-deal-aa-feature-dim-2023 | Diminisher Vitrin Paketi | Teslim açık |
| package_event-deal-aa-feature-sent-2023 | Sentinel Vitrin Paketi | Teslim açık |
| package_event-deal-aa-feature-pusat-2023 | Pusat Vitrin Paketi | Teslim açık |
| package_event-deal-aa-feature-zeph-2023 | Zephyr Vitrin Paketi | Teslim açık |
| package_event-deal-season-point | Sezon Puanı Paketi | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-goldpass-premium | Sezon Bileti Premium Paketi | Teslim açık |
| package_event-deal-basilisk | Basilisk | Teslim açık |
| package_event-deal-firepower | PVP Ateş Gücü Paketi | Teslim açık |
| package_event-deal-resistance | Direnç Paketi | Teslim açık |
| package_event-deal-bp-halloween | Savaş Bileti Cadılar Bayramı Paketi | Teslim açık |
| package_event-deal-dusklight-cyborg | Dusklight Cybrog Paketi | Teslim açık |
| package_event-deal-dusklight-spectrum | Dusklight Spectrum Paketi  | Teslim açık |
| package_event-deal-team-dusklight | Dusklight Tasarımları Takım Paketi | Teslim açık |
| package_event-deal-dusklight-hecate-plus | Dusklight Hecate Plus Paketi | Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-dusk-citadel-plus | Dusklight Citadel Plus Paketi | Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-dusklight-fullpack | Dusklight Perseus Paketi  | Teslim açık |
| package_event-deal-aa-zephyr-design-2024 | Zephyr Tasarım Paketi | Teslim açık |
| package_event-deal-aa-pusat-design-2024 | Pusat Tasarım Paketi | Teslim açık |
| package_event-deal-aa-sent-design-2024 | Sentinel Tasarım Paketi | Teslim açık |
| package_event-deal-aa-dim-design-2024 | Diminisher Tasarım Paketi | Teslim açık |
| package_event-deal-extra-goldpass | Ekstra Altın Bilet | Teslim açık |
| package_event-deal-double-goldpass | Sezon Bileti İkili Paketi | Teslim açık |
| package_event-deal-dusklight-berserker | Dusklight Berserker Paketi | Teslim açık |
| package_event-deal-dusklight-spectrum-p | Dusklight Spectrum Plus Paketi | Teslim açık |
| package_event-deal-dusklight-double | Dusklight Tasarımları Paketi | Teslim açık |
| package_event-deal-halloween-tech | Cadılar Bayramı Teknoloji Paketi | Bu teknolojinin etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-halloween-discovery | Mitik Cadılar Bayramı Paketi | Teslim açık |
| package_event-deal-halloween-l-corn-pack | Mega Cadılar Bayramı İkramları Paketi | WIZ-X hedefin görünüşünü geçici değiştirir; bu dönüşüm etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-wholesome-goldpass | Sezon Bileti Erdemli Paketi | Teslim açık |
| package_event-deal-wholesome-extrapass | Sezon Bileti Ekstra Paketi | Teslim açık |
| package_event-deal-dse-key-g | Normal Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-b-s | Küçük Nadir Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-b-m | Orta Nadir Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-b-l | Büyük Nadir Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-p-s | Küçük Epik Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-p-m | Orta Epik Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-p-l | Büyük Epik Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-r-s | Küçük Efsanevi Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-r-m | Orta Efsanevi Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-r-l | Büyük Efsanevi Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-mix-1 | Kudretli Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-mix-2 | Seçkin Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-dse-key-mix-3 | Basit Yankı Anahtarı Paketi | Teslim açık |
| package_event-deal-levelup-s | Küçük Kaynak Teklifi | Teslim açık |
| package_event-deal-levelup-m | Orta Kaynak Teklifi | Teslim açık |
| package_event-deal-levelup-l | Büyük Kaynak Teklifi | Teslim açık |
| package_event-deal-levelup-xl | Devasa Kaynak Teklifi | Teslim açık |
| package_event-deal-lf5al-s | Anchorlock Ustası Paketi S | Teslim açık |
| package_event-deal-lf5al-m | Anchorlock Ustası Paketi M | Teslim açık |
| package_event-deal-lf5al-l | Anchorlock Ustası Paketi L | Teslim açık |
| package_event-deal-powerup-booster-25 | Güçlü Destek Paketi 2025 | Teslim açık |
| package_event-deal-powerup-ammo-25 | Güçlü Cephane Paketi 2025 | Teslim açık |
| package_event-deal-powerup-uri-25 | Güçlü Uridium Paketi 2025 | Teslim açık |
| package_event-deal-season-point-lf5mf | Sezon Ateş Gücü Tedarik Paketi | Teslim açık |
| package_event-deal-laser-osl-triple | Üçlü OSL Paketi | Teslim açık |
| package_event-deal-armory-token | Cephanelik Jetonu | Teslim açık |
| package_event-deal-mega-armory-token | Mega Cephanelik Jetonu | Teslim açık |
| package_event-deal-armory-token-m | Orta Cephanelik Jetonu Paketi | Teslim açık |
| package_event-deal-armory-token-l | Büyük Cephanelik Jetonu Paketi | Teslim açık |
| package_event-deal-mega-armory-token-s | Küçük Mega Cephanelik Jetonu Paketi | Teslim açık |
| package_event-deal-mega-armory-token-m | Orta Mega Cephanelik Jetonu Paketi | Teslim açık |
| package_event-deal-mega-armory-token-l | Büyük Mega Cephanelik Jetonu Paketi | Teslim açık |
| package_event-deal-s-h-pusat-plus | Enerji Helios Pusat Plus | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-s-h-solace-plus | Enerji Helios Solace Plus | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-s-h-goliath-plus | Enerji Helios Goliath Plus | Paketin tam içeriği kayıtta bulunmuyor; eksik ürün teslim etmemek için satın alma kapalı. |
| package_event-deal-trinity-token | Trinity Jetonu Paketi | Teslim açık |
| package_event-deal-xyralith-s | Küçük Xyralith Paketi | Teslim açık |
| package_event-deal-xyralith-m | Orta Xyralith Paketi | Teslim açık |
| package_event-deal-xyralith-l | Büyük Xyralith Paketi | Teslim açık |
| package_event-deal-xyralith-xl | Lüks Xyralith Paketi | Teslim açık |
| package_event-deal-tt-ammo-2604 | Trinity VIP Özel Paketi | Teslim açık |
| package_event-deal-tt-resource-2604 | Trinity VIP Değer Paketi | Teslim açık |
| package_event-deal-tt-coupon-2604 | Trinity Jetonu Özel Paketi | Teslim açık |
| package_event-deal-tt-mix-2604 | Trinity Jetonu Değer Paketi | Teslim açık |
| package_event-deal-voyagers-vip-badge | Gezginler VIP Rozeti | Teslim açık |
| package_event-deal-voyagers-vip-special | Gezginler VIP Özel Paketi | Teslim açık |
| package_event-deal-voyagers-resource-s | Gezginler Ham Madde Paketi S | Teslim açık |
| package_event-deal-voyagers-resource-m | Gezginler Ham Madde Paketi M | Teslim açık |
| package_event-deal-voyagers-resource-l | Gezginler Ham Madde Paketi L | Teslim açık |
| package_event-deal-voyagers-ammo | IgniDrive Prime Cephane Paketi | Teslim açık |
| package_event-deal-voyagers-artificer | IgniDrive Prime Usta Paketi | Teslim açık |
| package_event-deal-trinity-vip-discount | Trinity VIP Rozeti Paketi | Teslim açık |
| package_event-deal-modules-resource-hp | HP Modülleri Ham Madde Paketi | Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-modules-resource-shd | SHD Modülleri Ham Madde Paketi | Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-modules-resource-dmg | DMG Modülleri Ham Madde Paketi | Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı. |
| package_event-deal-modules-resource-spc | SPC Modülleri Ham Madde Paketi | Bu gemi yükseltme modülünün istatistik etkisi henüz uygulanmadığı için satın alma kapalı. |
| equipment_extra_hmd-07 | Ticaret Diroiti HM7 | Teslim açık |
