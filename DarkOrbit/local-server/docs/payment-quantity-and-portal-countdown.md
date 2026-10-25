# Payment adedi ve portal yenileme döngüsü — 21 Ekim 2026

## Tekrarlanabilir ürün adedi

Sabit fiyat **birim/paket başına 1.000.000 U.** olarak kalır. Özgün dükkân sayfalarında tekrarlanabilir ürünler artık normal miktar seçicisini ve 10/100/1000/MAX düğmelerini kullanır. Örneğin üç cephane paketi 3.000.000 U. tutar ve açıklamadaki her bileşenin üç katını teslim eder. Ayrı bir satın alma paneli eklenmez.

Payment menüsü aynı sayfa isteğinde özgün **Özel Teklifler** dükkânını gösterir; özel kart katalog arayüzü veya yeni bir miktar formu açmaz. Diğer teklifler kendi özgün gemi, tasarım, lazer ve kişiselleştirme sekmelerindedir. Katalogdaki 173 açık teklifin **77'si çoklu**, **96'sı tekli** alınır; içeriği doğrulanmamış 23 teklif kapalı kalır.

`payment.maxAmount` aynı kuralı portal ürün JSON'una, ekonomi teklifine ve native `ShopItemCommand` paketine verir. Gemi, gemi/PET/diroit tasarımı, PET gövdesi, diroit gövdesi, `maxQuantity=1` nesne ve tek seferlik paketler bir adetle sınırlandırılır. Tekrarlanabilir lazer/sürücü gibi ekipmanlar ayrı kullanılabilir satırlar olarak, yığılabilir kaynak ve cephane gerçek adet toplamı olarak teslim edilir. Destek içeren paketlerde bütün süreler de aynı adetle çarpılır.

Yerel işlem güvenlik sınırı en fazla **1.000 paket**tir; paket başına çok sayıda ayrı ekipman varsa mevcut teslim sınırına göre daha düşük olabilir. Oyuncunun bakiyesi, gerçek eşya/depo kapasitesi ve eşyanın özgün katalog sınırı ayrıca uygulanır. Bu sayı özgün DarkOrbit'in evrensel sınırı olarak ileri sürülmez.

Ekonomi tek SQLite işlemi içinde toplam brüt bedeli çeker ve bütün ölçeklenmiş içeriği verir. Yetersiz para, benzersiz ürünün çoklu isteği, bozuk adet, stok taşması veya ara teslim hatası bütün işlemi reddeder; kısmi teslim/para kaybı oluşmaz. İçinde Uridyum olan paketin ödülü de aynı adetle gerçek bakiyeye eklenir. Tek seferlik satın alma makbuzu korunur.

Özgün satın alma isteği `/ajax/shop.php` üzerinden seçilen `amount` değerini gönderir. Yerel Payment ürünlerinde yeterli bakiye denetimi toplam bedelle yapılır; kaydedilmiş satırın birim `salePrice` değeri çoklu alımda yanlış bir yeterlilik sonucu vermez. Sabit Payment tekliflerine hesap indirimi uygulanmaz.

## İlk sayfanın tekrar tekrar açılması

Kaydedilmiş `internalStart.html` içindeki haber sayaçları `Date.now()` değerini sabit kampanya bitiş zamanlarıyla karşılaştırıyordu. Örneğin `1792360799`, 18 Ekim 2026'ya aittir. Süre dolduğunda özgün `printTime` fonksiyonu `location.reload()` çağırıyordu. Sunucu aynı kaydı yeniden sunduğu için her yeni sayfa bir saniye sonra tekrar kendini yeniliyordu.

Portal kişiselleştirmesi artık yalnızca bu kayıtlı haberlerin otomatik yenileme dalını kaldırır. Süresi dolmuş sayaç `00:00:00` gösterir; kalan süresi olan sayaç ve haber yerleşimi özgün biçimde çalışır. Kampanya tarihleri ileri alınmaz, gerçek olmayan yeni etkinlik süresi eklenmez. Normal menü yönlendirmeleri veya oyun penceresinin kendi davranışı değiştirilmez.

## Testler

- `tests/payment-bulk.test.js` — 8 test: üç paket bedeli/tam bileşenleri, ayrı ekipman satırları, yığılabilir kaynaklar, gerçek Uridyum ödülü, benzersiz ürün kısıtı, adet/bakiye sınırı, işlem ortası geri alma, stok taşması, tam destek süresi, özgün miktar seçicisinin gönderdiği istek/native paket ve Payment menüsünün özgün dükkâna açılması.
- `tests/portal-news-countdown.test.js` — 1 test: özgün kayıt gerçek sayaçlarıyla yeniden yükleme hatasını üretir; aynı sayaçlar kişiselleştirilmiş HTML'de beş tur çalıştırıldığında yeniden yükleme olmaz ve pozitif süre biçimi korunur.
- İlgili Payment/içerik/yakıt/portal/dükkân grubu **43/43 geçti**; kayıt `logs/portal-payment-quantity-tests.log` içindedir. Testler yalnızca `:memory:` veritabanını kullanır; gerçek hesaplar değiştirilmedi.
