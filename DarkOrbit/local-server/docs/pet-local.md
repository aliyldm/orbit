# P.E.T. yerel oyun döngüsü

20 Ekim 2026. Klasik PET modülleri ve protokolleri sunucu, SQLite, portal hangarı ve oyun paketlerine bağlıdır. Bütün modern PET sistemlerinin veya eski sunucu formüllerinin birebir tamamlandığı iddia edilmez.

## Kullanım

Portal **Dükkan → P.E.T./Modüller/YZ Protokolleri** üzerinden satın alınır. Kademe seçimi gerçek `level` alanıyla sunucuya gider; 2. kademe PET 4, 3. kademe PET 8 gerektirir. Fiyatlar `docs/pet-shop-levels.json` içindeki kaydedilmiş portal kademe fiyatlarıdır. Normal eşya yükseltmesi `upgrade_level`, PET kademesi `pet_level` alanından ayrıdır.

Hangarda **P.E.T.** sekmesinden lazer, kalkan, modül ve protokoller takılır. İki konfigürasyon ve kaydet/yükle bağımsız gerçek eşya kimliklerini kullanır. PET panelinde yalnız takılı klasik modüller görünür; pasif ve koruma temel modlardır. Gemi tamir kısayolu CSR-02 gerektirir.

## Çalışan davranışlar

| Mod | Davranış |
|---|---|
| Pasif / koruma | Takip; gerçek takılı PET lazerleri ve oyuncunun seçili cephanesini tüketen NPC saldırısı; SAB, RSB beklemesi, doğruluk ve hasar dağılımı |
| Otomatik ganimet / kaynak | Gerçek PET konumuyla yaklaşma/toplama; kademe ve radar menzili; korsan anahtarlı kutuları açmaz |
| NPC / kaynak bulucu | Mantıksal NPC/cevher seçenekleri, en yakın hedef koordinatı; sonuç yoksa -1,-1; sahte hedef kimliği reddi |
| Ticaret | İstasyon dışında sahip olunan bir cevher türünün satışı, kademeye göre %5/%15/%30 gelir; 300/120/30 sn yokluk ve kalıcı bekleme |
| PET tamiri | Kademeye göre saniyede 2000/6000/12000 PET HP |
| Kamikaze | Gerçek saldırgan ve düşük HP koşulu, hedefe hareket, gecikmeli alan hasarı, PET imhası ve 120/60/30 sn kalıcı bekleme |
| Kombo gemi tamiri | 200/400/750 ek yakıt; 5 sn boyunca 10000/15000/25000 HP/sn; 15 sn kalıcı bekleme; oyuncu hasar alınca korumaya geçer |
| Kombo koruma | Koruma saldırısı ve yerel olasılıksal PET kalkan savunması; özgün kalkan aktivasyon takvimi doğrulanmadı |

On klasik protokol: lazer/NPC hasarı, kalkan, can, doğruluk, kaçınma, kargo, salvage, radar ve ekonomi. Aynı tür protokoller toplanır. Oyuncu ArGe/cevher hasar bonusları PET'e otomatik kopyalanmaz. Alien ve lazer çarpanları yerelde birlikte çarpılır; hesaplama sırası istemcide kanıtlanmış değildir. Salvage yalnız PET'in topladığı normal bonus/NPC kargolarına uygulanır; korsan anahtarı veya ekipman çoğaltmaz. Kargo protokolü yalnız aktif PET sahibine etki eder; kapatıldığında mevcut cevher silinmez.

Yakıt kapasitesi **100000**; hız oyuncu hızıyla aynıdır. Dakika tüketimi `1 + 2×seviye + 2×takılı protokol + 4×takılı modül`, ekonomi ve kombo katsayılarıyla uygulanır. Kesir `pets.fuel_fraction` içinde saklanır; her saniye yukarı yuvarlanmaz, kapalı/çevrimdışı PET yakıt harcamaz. Uzun duran tick en fazla 5 saniye işler. Yakıt alımı birim 0,25 Uridyum ile atomiktir.

Aktif PET gerçek NPC, görev ve kapı XP'sinin %5'ini alır. Seviye 1 başlangıcı korunur; sonraki eşik `8000×L³`, azami seviye 15'tir. Mevcut seviye/XP düşürülmez; sonraki XP'de yeni tabloya göre değerlendirilir. Görsel tipler 1–3:12, 4–6:13, 7–9:14, 10–12:15, 13–15:22. Seviye değişimi yeni durum paketi gönderir.

İmha tamiri FAQ'nin 0..15 tablosunu kullanır: `0,0,0,10,20,30,50,70,90,120,150,180,220,260,300,350` Uridyum; premium ücretsizdir. FAQ düşük seviye açıklamasıyla tablosu çelişir; tablo seçilmiştir. `config.pet.repairCost` açık yerel override olabilir.

## Kalıcılık ve istemci

Migration 007 sahipliği/ekipmanı oluşturur. **019**, mevcut PET ve iki konfigürasyon satırlarını koruyarak yakıt sınırını büyütür, protokol yuvasını açar, `items.pet_level`, kesirli yakıt ve `pet_gear_state` beklemelerini ekler. Başarısız satın alma/satış/tamir işleminde ilgili bakiye, stok ve kayıt geri alınır. Yabancı eşya veya aynı konfigürasyonda iki yerde kullanım reddedilir.

Ticaret yokluğu, kamikaze ve gemi tamiri beklemesi mod değiştirme, kapat/aç veya yeniden girişle silinmez. Devam eden CSR tamiri ve kamikaze hazırlığı oturum/harita değişiminde sürdürülmez; eski hedefe sonradan hasar uygulanmaz. Normal açık PET atlama sonrası yeni oyuncu konumunda tekrar açılır.

Eski hangarın `general.pet` alanları I/L/LV/PN/HP/FU/lockedSlots, konfigürasyon `pet.EQ` ve gerçek `itemInfo.levels` verileri üretilir. Protokoller type23, kademe sıfır tabanlı LV ile gönderilir. Aktivasyon durum paketinden önce gönderilir. Bulucu, ticaret, buff ve tamir görselleri gerçek codec/legacy komutlarını kullanır.

## Kaynaklar ve yerel kararlar

[Modül/protokol metadata](pet-catalog-local.md), [özel modül paket/FAQ kanıtları](pet-special-gears-evidence.md), `ItemDataProvider.as`, `PetGearTypeModule.as` ve `decompiled/pet-patterns/game.xml` temel kaynaklardır. main.swf SHA-256: `688499ddc51f235e30fb5d49f4e067bf952b1bdc55908d2a4cb8ab6f00aad8bb`. Gömülü game.xml SHA-256: `0359deecaca0a80466d3ae9829511c4bb89711f1f794a4034c67f1d080bc7263`, MD5: `8e862ced6d19447d051139697b4db264`.

- PET taban canı hâlâ yerel `10000+(L−1)×2000`; imha tamiri tam HP verir. Slot satın alma takvimi yoktur: önceki yerel 6 lazer/12 kalkan/6 modül açık kalır, 12 protokol açılmıştır. Görsel/heat yuvası ve seviye 16–20 yoktur.
- Kamikaze için istemcinin 163/228/293 yarıçapı, %20 PET/%10 oyuncu can eşiği, 3/4/5 sn hazırlık ve 25000/45000/75000 hasarı seçilir. FAQ yarıçapları 250/350/450'dir; dönüşüm kanıtlanmadı. Yerelde yarıçap içinde tam hasar ve normal NPC kalkan emilimi uygulanır. Özgün mesafe düşüşü/minimum hasar/HP oranı formülü bilinmiyor. Korunmuş NPC'ler hasar almaz, istasyon yanında çalışmaz. KAM sesi/BOOOM efekti özgün uyarı animasyonunu kanıtlamaz.
- Kombo kalkanı her gelen PET vuruşunda %65/%75/%85 tam savuşturma olarak **yerelde** yorumlanır; sürekli hasar azaltma değildir. Özgün ISH çevrimi çıkarılmadı.
- PET tamir modülü tam cana kadar çalışır; kaynaklardaki farklı süre sınırları aktarılmaz. Ticaret bir istekle bir cevher türünü hemen satar, sonra PET yokluğu başlar; özgün çoklu sepet/geri dönüşte teslim akışı birebir kurulmadı.
- Salvage arıza/rastgelelik mekanizması ve bütün modern tasarım/ısı/özel modlar açık eksiktir. Gerçek Flash arayüzünde görsel uçtan uca oynanış doğrulaması yapılmadı.

## Doğrulama

`tests/pet.test.js`:14 temel test; `tests/pet-catalog-protocols.test.js`:9 kaynak/hesap testi; `tests/pet-runtime-expanded.test.js`:15 runtime, kötü istek, rollback, cooldown, görev XP'si ve dolu eski PET migration testi. `tools/test-network.js`: gerçek HTTP alımı → Flash hangar takma → TCP mod seçme ve görev kabulü → bonus toplama → tekil ödül teslimi. Üretim hesabına test ödülü veya PET eklenmez.
