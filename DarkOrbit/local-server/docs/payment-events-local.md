# Payment biletleri, sezon ve kaynak tüketicileri

Giriş: **Payment → Sezon ve Biletler**, doğrudan `/indexInternal.es?action=internalPaymentEvents`.
Sayfa oturumdaki oyuncuyu kullanır; URL veya POST ile başka oyuncu seçilemez. GET sadece görüntüler. Değişiklikler POST ile yapılır ve sonucu gösterir.

## Çalışan akış

- Gold Pass, Extra Gold Pass, Trinity VIP, Voyagers VIP ve Battle Pass önce gerçek envantere teslim edilir. Sayfadaki **Etkinleştir** düğmesi oyuncunun kendi biletini tüketip kalıcı hesabına yazar. Extra önce Gold ister; etkin bilet tekrar tüketilemez.
- Önceden satın alınmış bilet/puanlar da aynı ekranda kullanılabilir. Göç işlemi eski envantere dokunmaz.
- `resource_season-pass-point` tüketilerek sezon puanına dönüşür. 9.000 sınırını aşan her puan 10 şeref olur. Gold/Extra açılmadan kazanılan seviyeler sonradan o ödül yollarında da kullanılabilir.
- Ödüller bir kez teslim edilir. Ödül, kaynak ve makbuz aynı SQLite işlemi içindedir. Tek veya toplu teslimatta hata olursa o işlemin tamamı geri alınır.
- Aktif oyundaki bakiye önce işlem içine alınır. Başarılı işlemden sonra bakiye, şeref, kargo, anahtar, cephane, envanter ve varsa PET yakıtı gerçek durumla güncellenir. Konum, canlı HP/kalkan/NanoHull bu işlem tarafından yüklenmez veya sıfırlanmaz.
- Görevler kabul edilmiş normal görev olmasa da gerçek sunucu NPC ölümü, bonus kutusu ve kapı tamamlanması olaylarıyla ilerler. Tekil olay kimliği yeniden oynatılırsa ikinci kez sayılmaz.

## Kalıcı yerel sezon

Bu belirli bir orijinal sezonun kopyası değildir. **90 seviye, seviye başına 100 puan, kalıcı sezon**, aşağıdaki görevler ve ödül miktarları açık yerel dengedir. Seviye satın alma ilk 50 seviyeye kadar 10.000 U./seviye; mevcut kısmi puan korunur. Ödüllerin tam otoriter listesi `game/payment-events.js` içindeki `seasonReward` fonksiyonudur.

| Dönem | Görev | Puan |
|---|---|---:|
| Günlük | 20 NPC | 50 |
| Günlük | 10 bonus kutusu | 40 |
| Haftalık | 200 NPC | 200 |
| Haftalık | 3 klasik GG tamamlama | 300 |
| Sezon | 2.000 NPC | 1.500 |
| Sezon | 20 klasik GG tamamlama | 2.000 |

Günlük sınır Türkiye saatine göre 05:30, haftalık sınır pazartesi 05:30'dur. Görev aynı dönemde bir kez puan verir. Sabit görev seçimi yereldir; orijinal günlük/haftalık rastgele görev havuzu, reroll ve NOVA görev bonusu yeniden oluşturulmamıştır.

Free/Gold/Extra ödül listeleri, üyelik durumu, puan, tek ödül ve toplu ödül talepleri ile seviye satın alma native Flash paketlerine de bağlanır. Protokolde ödül seviyeleri **0–89**, veritabanı ve web ekranında **1–90**; bu dönüşüm testlidir. Seviye satın alma başarı/hata cevabı gerçek `SeasonPassLevelPurchaseCommand` ile döner. Native görev sekmesine sahte özgün görevler yüklenmez; görev ilerlemesinin kullanılabilir arayüzü web sayfasıdır.

Native kanıt:

- `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/SeasonPassStatusCommand.as`: Gold/Extra işaretleri, seviye maliyetleri ve süre.
- Aynı dizinde `SeasonPointsInfoCommand`, `SeasonPassRewardInfoCommand`, `SeasonPassRewardModule`, `SeasonPassRewardClaimRequest`, `SeasonPassRewardClaimAllRequest`, `SeasonPassLevelPurchaseRequest/Command`.
- `mvc/gui/windows/seasonPass/rewards/model/SeasonPassUIRewardsProxy.as`: gelen ödül seviyesini sıfır tabanlı dizi indisi olarak kullanır.
- `mvc/gui/windows/seasonPass/main/model/SeasonPassUIData.as`: başına sıfır eklenen kümülatif seviye maliyetleri.

Üç ödül yolu ve puan taşmasının şerefe dönüşmesi [resmî Season Pass FAQ](https://board-en.darkorbit.com/threads/faq-season-pass.129953/) ile uyumludur. Yerel görev ve ödül tablosu bu kaynaktan alınmış gibi sunulmaz.

## Trinity ve Voyagers

Trinity 40, Voyagers 30 seviyelik Free/VIP ödül içerikleri ve eşikleri 2026 resmî FAQ tablolarına göre kodlanmıştır. Trinity termal/korozif seçenekli ödüllerde oyuncu web ekranından tür seçebilir; varsayılan termaldir. Bu seçim, gizli özgün rastgele algoritmanın bulunduğu iddiası değildir.

- [Resmî Trinity Trials FAQ](https://board-en.darkorbit.com/threads/faq-trinity-trials.130064/)
- [Resmî Voyagers’ Ascent FAQ](https://board-en.darkorbit.com/threads/faq-voyagers-ascent.130327/)

**İlerleme yerel uyarlamadır:** tamamlanan her klasik galaksi kapısı her iki yola 100 puan, ilgili VIP etkinse 110 puan verir. Özgün Trinity/Voyagers etkinlik haritaları, 20 dalga planları, günlük giriş hakları, zorluk/yıldız sistemi ve haritaya özel %20 hasar avantajı henüz uygulanmamıştır. Ekran bu sınırı açıkça gösterir. Bu yüzden bu çalışma tam özgün Trinity/Voyagers etkinliğinin tamamlandığı anlamına gelmez.

Voyagers FAQ'sındaki **200 Ignishard-L01 → IgniDrive Lite** ve **200 Beacon Crystal → GL-Chron** üretimleri aynı sayfada gerçek parça tüketimiyle çalışır. Bu iki tarif kaynaklıdır; diğer anahtar/cephane takasları kaynaklı tarif gibi sunulmaz.

## Battle Pass ve diğer etkinlik kaynakları

Halloween paketindeki gerçek `resource_battle-pass` etkinleştirilebilir. Yerel görevlerin tamamlanan günlük/haftalık/sezon adımlarından sırasıyla 1/2/5 `resource_battle-pass-key` alınır. Bu ayrıca bir kez/oyuncu/görev/dönem olarak kaydedilir; normal sezon puanından bağımsızdır. Anahtarlar sayfadaki iki sabit cephane takasında gerçek olarak tüketilir.

Armory/Mega Armory Token, dört Echo anahtarı ve Candy Corn türleri için de açık miktarlı yerel cephane/anahtar takasları vardır. Bunlar özgün etkinliklerin rastgele kutu havuzları, etkinlik takvimi veya çekiliş algoritmaları değildir. Xyralith, Quantum Prism, Trinity giriş jetonu ve Voyagers giriş jetonu özgün etkinlik haritalarıyla ilgili tüketicilerini henüz kazanmamıştır. Horizon Shard/Containment Node'un gelişmiş özgün refinement sistemi bu modülün kapsamı değildir. Varlıkları envantere teslim etmek bu sistemleri tamamlamaz.

## Tek alımlık paketler ve saatli destekler

Kaynakta hesap başına tek alım olarak belirlenen yeni 2019 Stellar paketleri için `payment_purchase_receipts(player_id,sku)` makbuzu satın almayla aynı işlemde yazılır. Oyuncu tablo gereği hesapla bire birdir. Eşya satma/silme tekrar satın alma hakkı doğurmaz. Başarısız satın almada makbuz da geri alınır. Payment kataloğu alınmış teklifi gerekçesiyle kapatır.

`contents.boosterHours` kaynağın saat miktarını doğrudan gerçek destek süresine çevirir. Powerup paketinin 20/10/5 saatleri tek standart paket süresine yuvarlanmaz. Bütün Payment fiyatları 1.000.000 U. olarak kalır.

## Doğrulama

`node --test tests/payment-events.test.js tests/payment-local.test.js tests/payment-contents.test.js`

Yeni olay testleri; 270 sezon ödülünün tamamının PET gerektirmeden teslimini, 140 Trinity/Voyagers satırının her iki termal/korozif seçeneğiyle teslimini, kilit/oyuncu sahipliğini, tekil makbuzları, saat sınırlarını, taşan puan şerefini, canlı bekleyen bakiyeyi, HP korunmasını, kaynak ve yakıt senkronunu, native codec ve paket tekrarlarını, depolama hatasında toplu rollback'i ve gerçek 200 parça üretimini kapsar. Testler yalnız `:memory:` veritabanı kullanır.
