# P.E.T. modül ve protokol kataloğu

Bu belge `game/pet-catalog.js` veri/hesaplama katmanını açıklar. Modülün bulunması bütün modüllerin savaş/harita döngüsüne bağlandığını tek başına kanıtlamaz; çalışma durumu için `pet-local.md` ve güncel doğrulama raporu okunmalıdır.

## Kaynaklar ve doğrulama

- Statik istemci kaynağı: `decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as`, UTF-8 içeriğinin SHA-256 değeri `c717bc9de28cb7fb9ff37847de2cc48ed583c41ca054cfc385559fd6d7671102`. `PetEquipmentAttributes.values` içindeki bütün 27 PET modül/protokol kökü ve seviye varyantları doğrudan aktarıldı. Test, saklanan kaynakla bütün sayısal değerleri karşılaştırır.
- Tip numaraları: `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/PetGearTypeModule.as`. `game.xml` PET menü/görsel karşılıklarını doğrular; gerçek sunucu etki formüllerini içermez.
- [Resmî DE PET rehberi](https://board-de.darkorbit.com/threads/faq-p-e-t-und-ausruestung.118714/) protokol yüzdelerini, aynı tür protokollerin taban değer üzerinden toplanmasını, dakika başına yakıt formülünü, kombo süre/yakıt davranışını açıklar. [Resmî EN PET rehberi](https://board-en.darkorbit.com/threads/pet-10-faq.1228/) 2. kademe için PET 4, 3. kademe için PET 8 şartını ve Alien protokolünün kamikazeye değil lazere etki ettiğini belirtir. DE seviye tablosu 4. kademe için PET 20 şartını belirtir. Kaynaklar 2026-10-20 tarihinde okundu.

Statik veriler canlı sunucunun bütün hesaplama sırasını kanıtlamaz. Özellikle doğruluk, kaçınma, farklı protokol kategorilerinin birbirleriyle çarpılma sırası ve kamikaze mesafe/hasar eğrisi istemci metadatasından çıkarılamaz.

## Klasik modüller

| Modül | Tip | Kademe 1 / 2 / 3 |
|---|---:|---|
| G-AL1 ganimet | 4 | Menzil 700 / 1500 / 3000 |
| G-AR1 kaynak | 5 | Menzil 700 / 1500 / 3000 |
| G-EL1 NPC bulucu | 6 | Menzil 2000 / 3000 / 5000 |
| G-RL1 kaynak bulucu | 7 | Menzil 2000 / 3000 / 5000 |
| G-TRA1 ticaret | 8 | Satış bonusu %5 / %15 / %30; yokluk 300 / 120 / 30 sn |
| G-REP1 PET tamiri | 9 | Saniyede 2000 / 6000 / 12000 HP |
| G-KK1 kamikaze | 10 | Azami 25000 / 45000 / 75000 hasar; bekleme 120 / 60 / 30 sn |
| CSR-02 gemi tamiri | 11 | 5 sn boyunca saniyede 10000 / 15000 / 25000 HP; kullanımda 200 / 400 / 750 yakıt |
| CGM-02 koruma | 12 | Kaynak `deflection_chance`: %65 / %75 / %85 |

Kombo modüller için %35 yakıt artışı ve CSR-02 için 15 saniye bekleme resmî rehberdendir. Anlık kalkanın aktivasyon takvimi metadata içinde yoktur; `deflection_chance` değerini her vuruşa uygulanan sürekli hasar azaltma gibi yorumlamamak gerekir.

Kamikaze ayrıca her kademede %20 PET / %10 oyuncu can eşiği, 163/228/293 yarıçap ve 3/4/5 saniyelik `survival_time` taşır. Bunlar ham metadata olarak korunur. `dmg_reduction`, `min_damage`, `hitpoint_percentage` alanları da `values` içinde bulunur; anlamı kesinleşmeden özgün sunucu formülü olarak kullanılmaz.

Sonraki özel modüllerin ve heat protokolünün metadata kaydı saklanır, `supported:false` döner. Böylece kod bu modülleri çalışıyor gibi menüye ilan etmez.

## Klasik protokoller

| Protokol | Kademe 1 / 2 / 3 / 4 (%) | Etki alanı |
|---|---|---|
| AI-CR1 | 3 / 6 / 12 / 15 | Oyuncu gemisi kargo kapasitesi |
| AI-R1 | 2 / 6 / 12 / 15 | PET toplama ve bulucu menzili |
| AI-S1 | 1 / 2 / 3 / 4 | PET'in aldığı bonus/kargo kutusu miktarı |
| AI-SM1 | 1 / 2 / 4 / 6 | PET kalkanı |
| AI-LM1 | 1 / 2 / 4 / 6 | PET lazer hasarı |
| AI-AIM1 | 1 / 2 / 4 / 6 | PET lazer doğruluğu |
| AI-E1 | 1 / 2 / 3 / 4 | PET'e saldıranın doğruluğu |
| AI-HP1 | 1 / 2 / 4 / 5 | PET canı |
| AI-AL1 | 1 / 3 / 6 / 8 | PET lazerinin NPC hasarı |
| AI-ECO1 | 3 / 3.5 / 4 / 6 | PET yakıt tüketimi |

Aynı kategoride protokoller taban üzerinde toplanır: iki adet 3. kademe radar sonucu `1 + .12 + .12 = 1.24` olur. Salvage `find_chance` alanı da kaynakta korunmuştur; rehberler arası rastgele “malfunction” çelişkisi ve dağılımı çözülmediği için bu katman sahte bir rastgele ödül üretmez. Salvage bir garantili ekipman/anahtar çoğaltma mekanizması değildir.

Klasik yakıt formülü dakika başına `1 + 2×PET seviyesi + 2×takılı protokol + 4×takılı modül` şeklindedir. Tam sayı tüketim için runtime kesirli yakıtı biriktirmelidir; her tick yukarı yuvarlamak ciddi fazla tüketime yol açar. `fuelPerMinute` ekonomi etkisini ve seçili kombo modülün yakıt katsayısını uygular; sayaç/DB yazımı yapmaz.

## API ve seviye kodlaması

`gear(item, level?)`, `protocol(item, level?)` ve `resolve(item, level?)` bir loot ID veya `{loot_id, pet_level}` nesnesi alır. `pet_level` 1 tabanlıdır; normal eşya yükseltmesi olan `upgrade_level` hiçbir zaman PET modül kademesi gibi kullanılmaz. Bilinmeyen/kırık seviyeler `null` döndürür.

İstemcinin varyant soneki sıfır tabanlıdır: `equipment_petgear_g-al10` kademe 1, `...g-al11` kademe 2, `...g-al12` kademe 3. `...g-al12X` ayrı özel varyanttır ve 3. kademe sayısal değerlerini taşır; dördüncü kademe değildir. Protokollerde `...ai-r13` gerçekten kademe 4'tür. Kalıcı kayıt için taban loot ID + `items.pet_level` kullanılır; varyant ID metadata/istemci arayüzünde saklanabilir.

`equippedEffects(rows)` yalnız `protocol` yuvasındaki desteklenen protokolleri işler; yüzde etkileri kesir olarak ve ayrıca `...Multiplier` alanlarıyla döndürür. Aynı fiziksel `id` iki defa gelirse bir defa sayar. Farklı tür hasar protokollerinin birlikte uygulanma sırasını belirlemez. `gearForType(rows,type)` aynı türün takılmış en yüksek kademesini seçer. `entries({supportedOnly,variants})` mağaza/menü için normalize kayıtları listeler; satın alma fiyatı tahmin etmez.

`slotsAtLevel(level)` saklanan `PetAttributes` varyantındaki azami slotları verir; satın alınmış slotları ifade etmez. İstemci PET seviyeleri burada 0–20'dir; sunucunun seviye 1 başlangıcına sessizce kaydırılmaz. İstemci 13. seviyeden itibaren sekiz modül yuvası tanımlar; eski DE rehberi altı der. Bu sürüm farkı metadata içinde görünür bırakılmıştır. Heat/görsel slot kapasitesinin varlığı bu sistemlerin runtime'da uygulandığı anlamına gelmez.

## Doğrulama

`node --test tests/pet-catalog-protocols.test.js`: saklanan istemci sayıları, seviye/varyant normalizasyonu, kademeye erişim, aynı protokolün toplanması, kopya fiziksel satır koruması, on klasik protokolün kapsamı, kombo/kamikaze değerleri, slot sınırları ve yakıt zaman birimi doğrulanır. Gerçek hesap DB'si değiştirilmez.
