# Normal harita NPC profilleri

`game/normal-map-spawns.js` yalnız dağılım/niyet verisi sunar; DB'ye yazmaz,
sunucuyu başlatmaz, NPC istatistiklerini değiştirmez. Üç şirket için x-1…x-8,
4-5 ve 5-1…5-3 olmak üzere 28 haritayı kapsar. 4-1…4-4, etkinlik, BL ve kapı
haritaları bu modülden nüfus almaz.

## Kaynak ve yerel ayar sınırı

[Standart NPC SSS tablosu](https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/)
klasik harita ailelerini;
[Boss SSS tablosu](https://board-en.darkorbit.com/threads/boss-alien-faq.801/)
Boss konumlarını verir. Kaydedilmiş ham HTML/metinler
`decompiled/gate-source-evidence/npc-standard-en.*` ve `npc-boss-en.*`
dosyalarıdır. Kaynaklardaki x, üç şirketin ortak harita son ekidir.

[Almanca NPC SSS'si](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/)
Uber ailelerini 4-5'e yerleştirir. [İkinci sayfa](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2)
korsanların yaşam alanlarını belirtir. İlgili yerel kayıtlar `npc-de.*` ve
`npc-de-page2.*` dosyalarıdır. Genel `5-X` ifadesi 5-1…5-3 için kullanılır;
bu profil kapsamından 5-4'e genişletilmez.

NPC adetleri, başlangıç noktaları ve yeniden doğma sürelerinin özgün sunucu
değerleri bu kaynaklarda bulunmaz. Adetlerin tamamı `localPopulation:true`,
sürelerin tamamı `localRespawn:true` ile işaretlidir. Modül nokta koordinatı
belirlemez. Normal türler için 30, Boss için 90, Uber/Cubikon/Battleray için
120 saniye yerel yeniden doğma aralığı seçilmiştir. Bunlar bir NPC öldükten
sonra uygulanacak yerel sürelerdir.

## Yerel nüfus tablosu

Parantezler adetleri gösterir; tür üyeliği kaynaklıdır, adetler yereldir.

| Harita | Normal türler | Boss türleri |
|---|---|---|
| x-1 | Streuner (20) | yok |
| x-2 | Streuner (24), Lordakia (16) | Streuner (1), Lordakia (1) |
| x-3 | Lordakia (6), Saimon (6), Mordon (8), Devolarium (16) | Mordon (1), Saimon (1), Devolarium (1) |
| x-4 | Lordakia (6), Saimon (6), Mordon (8), Sibelon (16) | Saimon (1), Sibelon (1) |
| x-5 | Lordakia (8), Sibelonit (12), Lordakium (12) | Sibelonit (1), Lordakium (1) |
| x-6 | Kristallin (16), Kristallon (12), Cubikon (2) | Kristallin (1) |
| x-7 | Kristallin (12), Kristallon (18) | Kristallin (2), Kristallon (1) |
| x-8 | StreuneR (24) | StreuneR (2) |

4-5'te Streuner, Lordakia, Saimon, Mordon, Devolarium, Sibelon, Sibelonit,
Lordakium, Kristallin, Kristallon ve StreuneR ailelerinin her Boss ve Uber
türünden birer tane seçilmiştir. Beş korsan Uber türünden de birer tane vardır.
Buraya normal Cubikon, etkinlik Curcubitor veya kapı imparatoru eklenmez.

5-1, 5-2 ve 5-3'te Interceptor (20), Barracuda (10), Saboteur (6), Annihilator
(6), Uber Interceptor (1) ve Uber Barracuda (1) bulunur. Yalnız 5-2'ye Uber
Saboteur (1) ve Uber Annihilator (1), yalnız 5-3'e Battleray (1) eklenir.
Almanca özel konum listeleri, İspanyolca Uber korsanların daha genel `5-x`
ifadesine göre daha dar bir üyelik sınırı olarak seçilmiştir.

23 Ekim 2026 nüfus güncellemesi, büyük NPC aramayı kolaylaştırmak için bu adetleri değiştirir. Özellikle 1-7/2-7/3-7 üzerinde 18'er Kristallon vardır; büyük NPC sayısı artarken x-5/x-7'deki bazı küçük türler azaltılmıştır. Sayılar özgün DarkOrbit sunucusunun kurtarılmış nüfus değerleri değildir; kullanıcı isteğine göre yerel denge ayarıdır. Tür üyeliği, Boss/Uber adetleri, saldırganlık ve yeniden doğma süreleri korunur. [Geçiş ve test raporu](normal-population-current.md).

## Saldırganlık ve özel mekanizmalar

[İspanyolca NPC SSS'si](https://board-es.darkorbit.com/threads/faqs-aliens.135697/)
`Comportamiento` alanıyla saldırgan/pasif ayrımını ve korsan özelliklerini
verir; yerel kaydı `npc-es.*` dosyalarıdır. İngilizce açık anlatımı olan türler
için o anlatım önceliklidir: Streuner, Lordakium, Cubikon, StreuneR, Boss
Streuner ve Boss StreuneR önce ateş edilmesini bekler. İspanyolca Streuner/Boss
Streuner/Boss StreuneR için farklı sınıflandırmalar içerir; bu çelişki gizlenmez.

Diğer türlerde İspanyolca sınıflandırma kullanılır. Lordakium/Kristallon ve
onların Boss/Uber türleri pasiftir. Uber Streuner ve Uber StreuneR pasiftir.
Uber korsanlarda Interceptor saldırgan, diğer dört tür pasiftir. Temel korsanlar
saldırgandır. `aggressionSourceIds` seçimi belirtir; bunlar kapı kataloğunun
genel `aggressive:true` değerini normal haritalarda geçersiz kılmalıdır.

`effects` yalnız doğrulanmış mekanizma etiketleridir. Saboteur yavaşlatması,
EMP ile temizlenmesi, Barracuda'nın canı azaldığında patlaması, Annihilator'ın
Hellstorm ateşi ve Battleray'in Interceptor koruması/iyileştirmesi kaynakta
vardır. Barracuda'nın yaklaşık on saniyesi ayrıca yaklaşık bilgi olarak
saklanır. Patlama formülü, tetikleme oranı, yarıçap, iyileştirme miktarı ve
roket döngüsü bu modülden özgün sunucu kuralı olarak çıkarılamaz.

Temel üç korsan için bu mekanizmaların çalıştırılması `npc-special-attacks.js`
adaptörüne eklendi; [uygulama ve sayısal sınırlar](npc-special-attacks-local.md)
ayrı tutulur. Uber ailelerindeki etiketler otomatik yetenek mirası değildir;
bu güncellemede Uber/gate özel saldırıları etkinleştirilmez.

Cubikon saldırıya uğrayınca Protegit muhafızları oluşturur. Protegit satırı
`dependentOn:'cubikon'`, `spawnTrigger:'parent-attacked'` taşır; seçilen 20
muhafız **her ana NPC için yerel adettir**, bağımsız harita nüfusu değildir.
Battleray için 10 Interceptor, Uber Battleray için 10 Uber Interceptor aynı
şekilde yerel muhafız adedidir; `parent-present` tetikleyicisi taşır.

## Entegrasyon sözleşmesi

`get('1-6')`, `get('4-5')` veya `get('x-6')` düzenlenebilir derin kopya döndürür.
Desteklenmeyen ad boş dizi döndürür. `profiles` ve `suffixProfiles` sabit
başvuru verisidir; `effects` ve `SOURCES` ayrıca dışa açılır.

Satır biçimi: `{key,count,respawnMs,aggressive,localPopulation,localRespawn,
localAggression,sourceIds,aggressionSourceIds,dependentOn?,spawnTrigger?}`.
`dependentOn` taşıyan satırlar normal `map_spawns` nüfusundan çıkarılmalı;
ana NPC tarafından üretilmelidir. Aynı `key`, bağımsız ve muhafız rolünde aynı
profilde bulunabilir. NPC anahtarları `npc-catalog` ile çözülür. Modül kendi
başına mekanizmaları veya kaynak ödüllerini uygulamaz.

Doğrulama: `node --test tests/normal-map-spawns.test.js` — sekiz test; üyelik,
Boss/Uber sınırları, gerçek katalog kimlikleri, muhafız ilişkileri, kaynaklı
saldırganlık, kopya izolasyonu ve kaydedilmiş kanıt işaretleri kontrol edilir.

## Yerel istemci yerleşim denetimi

`client/spacemap/graphics/spacemap-config.xml` içindeki `<npcs><map ref>`
listeleri, yorumlarında harita adını ve NPC adını belirtir. Buradaki `npc id`
görsel tip değildir; `decompiled/pet-patterns/game.xml` içindeki `npcId` ile
eşleştirilmiştir. Normal klasik üyelikte bu daha özel kaynak, genel forum
tablosundan önce gelir: x-3'te Boss Saimon (mantıksal 17, görsel 25) vardır.
Bu nedenle üç şirketin x-3 profiline birer yerel Boss Saimon eklenmiştir.

Mevcut klasik ve korsan profillerinin geri kalanı istemcinin yerleşik listesiyle
uyumludur; Protegit gibi bağımlı muhafızlar liste karşılaştırmasından ayrılır.
Sekizinci test, iki XML'i okuyup klasik mantıksal kimliklerin iki yönlü
üyeliğini doğrular.

Bu turda bilinçli kapsam dışı kalan yeni sürüm/koşullu yerleşikler:

- Recruit Streuner 152 ve Aider Streuner 153: x-1/x-2 öğretici NPC'leri.
- Plagued Kristallin mantıksal 161, görsel 252: x-6 yeni sürüm çeşidi.
- Purpose XXI mantıksal 174, görsel 214: x-8 Black Light çeşidi.
- Deadly Battleray mantıksal 121: 4-1…4-5 listesinde görünür; İspanyolca SSS
  PvP haritaları arasında koşullu dolaşım ve yirmi dakikalık süre anlatır.
  Her haritaya kalıcı bir kopya eklemek bu davranışı temsil etmez.

Bunlar sırf yeni oldukları için etkinlik NPC'si sayılmamıştır; klasik kapsam
seçimi nedeniyle bu turda üretilmezler. Kaynakta bulunmayan rastgele etkinlik
Curcubitor'u kalıcı nüfusa eklenmez.

## Normal NPC kargo tablosu

`game/normal-npc-cargo.json`, yukarıdaki profillerde ve bağımlı muhafızlarda
kullanılan **45 NPC anahtarının tamamı** için açık cevher satırlarını saklar.
35 klasik/Boss/Uber/Cubikon/Protegit ve 10 korsan türü kapsanır. Biçimi
`{key:[{type,amount}]}` şeklindedir; NPC istatistikleri veya başka ödüller
bu dosyada bulunmaz.

| Cevher | Protokol kimliği |
|---|---:|
| Prometium | 0 |
| Endurium | 1 |
| Terbium | 2 |
| Xenomit | 3 |
| Prometid | 4 |
| Duranium | 5 |
| Promerium | 6 |
| Palladium | 8 |

Seçilen kaynak sürümü, katalogdaki Almanca normal NPC sürümüyle aynıdır:
`npc-de.txt` ve `npc-de-page2.txt` içinde her NPC'nin kendi açık cevher satırları
alınmıştır. Boss/Uber için nominal dört/sekiz kat formülü uygulanmamıştır.
Örneğin Boss Streuner'ın Terbium'u 10, Uber Streuner'ınki 20; StreuneR
Prometid miktarları 15, Boss için 32, Uber için 120'dir. Kaynakta Boss StreuneR
için Promerium satırı yoktur; başka kaynaktan veya çarpanla eklenmez.
Uber Barracuda'nın açık 100 Promerium'u ve Uber Annihilator'ın 200 Prometid'i
de seçilen kayıtta yazıldığı gibi korunur. Bunlar kaynak hatası olabilecek
alışılmadık değerlerdir; bu turda başka sürümle sessizce düzeltilmemiştir.

Sıfır veya hiç belirtilmeyen cevherler diziye alınmaz. Etkinliğe bağlı aurus,
bifenon ve benzeri olasılıklı kaynaklar kalıcı cevher tablosuna eklenmez. Kapı
anahtarları, modern kapsam dışı NPC'ler ve bilinmeyen türler için kayıt yoktur.
Eksik anahtar, doğrulanmış bir cevher iddiası değildir. Bu tablo normal katalog
tanımının `cargo` alanına bağlanır. Sonraki ödül denetimi `npc-cargo.js` ile
kaynaklı kapı varyantlarını da ayırdı ve bilinmeyen türlerdeki genel10+10
fallback'ini kaldırdı; [güncel kargo denetimi](npc-cargo-reward-audit.md).

Kaynakların HTML SHA-256 kimlikleri (`*.source.json` kayıtları):

- `npc-de`: `4052db3ed638a857fe1675d42cc7cd6fd4acbb8608dc1452ed7b8d9d23a11c1e`
- `npc-de-page2`: `7e4a1440ff91ab41801c46504bb8b11c046e737324ad54692ad9668c1bbe775a`

İki snapshot 20 Ekim 2026 06:21 UTC'de alınmıştır. Üretilen JSON SHA-256:
`1d6dc0e4eb0c344abd188f712a0c1bf4f586c2a30ee072275915b05af5a7a084`.

`node --test tests/normal-npc-cargo.test.js` dört test çalıştırır. Dördüncü
test, 45 NPC'nin her birinin kargosunu saklanan kaynak başlıklarından ve
cevher satırlarından yeniden ayrıştırarak JSON'la karşılaştırır. Diğerleri
gerçek protokol kimliklerini, profil kapsamını ve nominal çarpma ile
bozulabilecek özel miktarları doğrular.
