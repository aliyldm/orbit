# Normal harita düzeni

`game/normal-map-layout.js` yalnız klasik şirket haritaları x-1–x-8, savaş haritaları 4-1–4-5 ve korsan haritaları 5-1–5-3 için veri sağlar. Bunlar 32 harita ve 96 yönlü portal kaydıdır. Galaxy Gate, Black Light, etkinlik ve diğer özel haritalar bu grafiğe eklenmez.

## Gözlenen istemci kaynakları

En güçlü topoloji kanıtı mevcut `client/spacemap/graphics/spacemap-config.xml` dosyasıdır. Her `jumpgate`, kaynak `ref`, benzersiz `key`, `leadsToMap`, şirket, şirket görünürlüğü ve tooltip piksel konumu içerir. Dosya System.Xml ile çözümlenerek modüldeki sabit satırlara aktarılmıştır. Bu bağlantılar eski yerel yansıtılmış güzergâhlardan tahmin edilmemiştir.

| Kanıt | SHA-256 |
|---|---|
| `spacemap-config.xml` | `EC662D3E3E931F43489379BE89E0236C640D124262046B0C3CD07F8E0B1171F3` |
| `maps-config.xml` | `9D154F543410997D41D7081D39DE5EB639D0D7CAF70DF099986BBFC6AB87E6EE` |

`maps-config.xml` gerçek harita adını/kimliğini ve `scaleFactor` değerini verir. `decompiled/main/scripts/net/bigpoint/darkorbit/map/model/Map.as`, temel boyutları 21000×13100 olarak tanımlar ve iki boyutu da scaleFactor ile çarpar. Buna göre 4-4, 4-5, 5-1 ve 5-3 42000×26200; diğer kapsam içi haritalar 21000×13100'dür. Arka plan resminin parallax bölgesi veya piksel boyutu oyun sınırı yerine kullanılmaz.

| Kimlikler | Haritalar |
|---|---|
| 1–4 / 5–8 / 9–12 | MMO / EIC / VRU x-1–x-4 |
| 13–16 | 4-1–4-4 |
| 17–20 / 21–24 / 25–28 | MMO / EIC / VRU x-5–x-8 |
| 29 | 4-5 |
| 91 / 92 / 93 | 5-1 / 5-2 / 5-3 |

Klasik 84 yönlü bağlantının hepsinin ters yönü vardır. Şirketler arası 1-3↔2-3, 1-4↔3-4, 2-4↔3-3 geçitleri; savaş haritalarının birbirine ve x-4/x-5'e bağlantıları; x-5'lerin 4-5'e bağlantıları kaynak XML'den korunur.

Korsan güzergâhı 4-5→5-1→5-2→5-3→4-4 yönündedir. Her adımda üç şirket yoluna ait toplam 12 portal vardır; uydurma ters kapı eklenmez. Bu yön [resmî Pirate Map FAQ](https://board-en.darkorbit.com/threads/pirate-map-faq.1013/) ile ayrıca doğrulanmıştır. Aynı FAQ korsan erişimini seviye 12 olarak belirtir.

`SpaceMapConfig.as` ve `SpaceMapToolTipAssigner.as:addMapGates`, `visibleOwnFaction=true` olan geçidin tooltip ikonunu yalnız eşleşen şirket için gösterir. XML'de bu bayrak 5-1, 5-2 ve 5-3 çıkışlarında açıktır; 4-5 girişlerinde kapalıdır. Modülde `ownOnly/factionId` korunur ve `portalsFor(mapId,factionId)` bu görünürlük filtresini uygular. Bunun gerçek sunucudaki atlama reddine de karşılık geldiği kayıttan gözlenmemiştir; yerel sunucunun aynı şirket filtresini erişim kuralı olarak kullanması açık bir yerel uygulama kararıdır.

## Dünya koordinatlarının kanıt sınırı

XML kendi yorumunda konumların **tooltip pikselleri** olduğunu söyler. Bunlar doğrudan 21000 birimlik dünya koordinatları değildir. Dünya konumu doğrulanmış dört portal kaynak noktası aynen korunur:

| İstemci anahtarı | Oyun portal kimliği | Kaynak | Konum |
|---:|---:|---|---|
| 1 | 150000168 | 1-1→1-2 | 18500,11500 |
| 2 | 150000169 | 1-2→1-1 | 2000,2000 |
| 3 | 150000170 | 1-2→1-3 | 18500,2000 |
| 5 | 150000172 | 1-2→1-4 | 18500,11500 |

Kayıtlar `logs/session-6182-2.json`, mevcut `docs/gameplay-local.md` ve `game/templates/init.json` içinde tanımlıdır. İlk iki geçişin varışları 2300,2300 ve 18100,11100 olarak korunur. Harita 1'in başlangıcı 3267,2635 ve istasyon merkezi 2000,2000 değişmez. EIC/VRU başlangıç değerleri de önceki yerel kayıtlarla uyumlu tutulur.

Diğer portal dünya noktaları **yerel izdüşümdür**: tooltip (31,30) noktası (2000,2000), (293,177) noktası (18500,11500) olacak şekilde iki eksen ayrı doğrusal dönüştürülür, sonra haritanın native ölçeği uygulanır. Böylece kaynakta aynı köşede görünen kapılar aynı dünya köşesinde kalır; tüm noktalar harita sınırları içindedir. Ters geçidi olan varışlar ilgili portalın biraz iç tarafına yerleştirilir. Tek yönlü korsan varışları yerel sağ kenar düzenindedir; 5-3 çıkışı resmî FAQ'nın tarif ettiği gibi 4-4'ün üst kısmına gelir. Bunlar canlı sunucunun yakalanmış koordinatları olarak sunulmaz.

Oyun portal kimliği `150000167 + nativeKey` olarak üretilir. Bu, doğrulanmış dört kimlikle aynıdır; diğer kimliklerin aynı canlı sunucu düzeninde olduğu iddia edilmez. Modül `coordinateSource`, `arrivalSource` ve `topologySource` alanlarını ayrı tutar.

## Seviye ve istasyonlar

[Almanca resmî XP FAQ](https://board-de.darkorbit.com/threads/faq-erfahrungspunkte.2886/) ile mevcut Türkçe `resource_faq.xml:xp_effect_p` aynı doğrudan geçiş ayrımını yapar: kendi x-3/x-4 haritaları seviye 2'de açılır; aralarındaki doğrudan yol seviye 3 gerektirir. Düşmanın x-3/x-4 haritasına giriş 5, doğrudan x-3↔x-4 geçişi 6 gerektirir. İngilizce Levels FAQ bu ayrımı sadeleştirerek kendi x-4'ünü 3'te listeler; burada daha ayrıntılı DE+istemci sürümü seçilir.

| Hedef | Kendi şirketi | Düşman şirket |
|---|---:|---:|
| x-1 / x-2 | 1 / 1 | 16 / 13 |
| x-3 / x-4 | 2 / 2 | 5 / 5 |
| Doğrudan x-3↔x-4 | 3 | 6 |
| x-5 | 10 | 14 |
| x-6 / x-7 | 11 | 15 |
| x-8 | 12 | 17 |

4-1–4-3 erişimi 8, 4-4 erişimi 9'dur. 4-5 için [İngilizce resmî Levels FAQ](https://board-en.darkorbit.com/threads/levels-faq.843/) açıkça 12 der; başka eski listelerdeki 10 yerine bu sürüm seçilir. Korsan haritaları 12'dir. Bu modül XP kazanma/seviye yükselme formülünü değiştirmez.

[Resmî kargo satışı FAQ](https://board-en.darkorbit.com/threads/how-to-sell-cargo.2058/) x-1 ve x-8 üslerinin varlığını doğrular; korsan FAQ 5-2 ticaret üssünü doğrular. Modül üç ana üs, üç üst üs ve tarafsız korsan ticaret noktası döndürür. Yalnız 1-1'in merkezi yakalanmıştır; diğer merkezler açık yerel yansıma/yerleşimdir. x-8 üsleri `is_start` yapılmaz; ana respawn şirketin x-1 haritası kalır. İstasyonun var olması, 15 Palladium→1 enerji takasının veya düşman üs satışı gibi bütün ticaret işlevlerinin bu veri modülünde uygulanmış olduğu anlamına gelmez.

## Entegrasyon sözleşmesi

- `maps`: DB alanları `id,name,faction_id,is_start,width,height,start_x,start_y` ve kaynak metadata'sı.
- `portals`: mevcut DB alanları `id,map_id,x,y,target_map,target_x,target_y,min_level,design_id`; ek olarak native anahtar, şirket/görünürlük ve koordinat kanıtı.
- `stations` ve `station(mapId)`: `x,y,factionId,radius,kind`; istasyon bulunamazsa `null`.
- `accessLevel(mapId,factionId)`: harita erişim seviyesi. Bilinmeyen harita/geçersiz şirkette `Infinity`; bu normal harita yardımcısı Galaxy Gate erişiminin yerine geçmez.
- `portalAccessLevel(portal,factionId)`: doğrudan x-3/x-4 kuralını da ekler. DB'nin tek `min_level` sütunu şirketten bağımsız en düşük sınırdır; tam denetimde bu yardımcı kullanılmalıdır.
- `getMap`, `portalsFor`, `portalVisible`, `projectTooltip`, `SOURCES`: sorgu ve kaynak denetimi yardımcıları.

Eski yerel normal portal kimlikleri yeni native anahtarlarla çakışabilir; yalnız eksikleri INSERT etmek eski yanlış bağlantıları korur. Kök entegrasyonun sürümlü normal dünya migration'ı yalnız kapsam içindeki harita/portal düzenini değiştirmeli; hesap, oyuncu, gemi, envanter ve Galaxy Gate kayıtlarına dokunmamalıdır. Bu modül DB veya seed dosyası değiştirmez.

`tests/normal-map-layout.test.js`: kaynak hash/kimlik/ölçek eşitliği, 96 gerçek yönlü bağlantı, yakalanmış noktalar/varışlar, bütün koordinatların sınırlar içinde olması, klasik karşılıklı yollar, korsan tek yönlülüğü ve şirket çıkışları, üç ana üsten tüm 32 haritaya erişim, şirket/seviye ve doğrudan yol ayrımı, istasyon/respawn ayrımı. On test başarılıdır; başka haritaların yakalanmamış dünya koordinatlarını gerçek sunucu verisi olarak doğrulamaz.
