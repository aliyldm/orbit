# Gemi dükkânı ve diroit fiyatı düzeltmeleri — 21 Ekim 2026

## Gemi dükkânının bozulması

Kaydedilmiş gemi açıklamaları kendi HTML tablosunu ve küçük tooltip scriptlerini içeriyor. Portal, oyuncunun bakiyesi/fiyatları için `itemData` nesnesini yeniden JSON'a çevirirken `JSON.stringify` kullanıyordu. Bu işlem açıklamanın içindeki `</script>` metnini ham olarak dış scriptin içine yazıyordu. HTML ayrıştırıcısı JavaScript dizgesini dikkate almadan dış scripti orada bitiriyordu; kalan JSON, ekranda uzun metin ve görünür `\n` karakterleri olarak beliriyordu. Shop yapılandırması da yarıda kesiliyordu.

`web/portal/render.js` artık inline JSON içindeki `<` karakterlerini `\u003c` olarak yazar. JSON çözüldüğünde özgün açıklama aynen geri gelir; dış HTML scripti erken kapanmaz. U+2028/U+2029 da eski JavaScript çalışma ortamlarına uygun kaçırılır. Kaydedilmiş açıklama metinleri veya gemi özellikleri değiştirilmez.

## Diroit fiyatının eski görünmesi

Sunucu Flax/Iris alımında sahip olunan adede göre doğru tutarı zaten çekiyor ve `dronePrices` içinde sonraki fiyatı gönderiyordu. İstemci de bu cevabı alıyordu. Ancak `Shop.Itemlist.updateItemCost`, fiyatı `.itemList_singlePrice strong` içinde ararken kaydedilmiş sayfalardaki fiyat, sınıfsız bir stil div'i içindeydi. Dolayısıyla liste güncellemesi boş DOM seçimine gidiyordu.

- Portal ilk açılışta fiyat div'lerine gereken sınıfı ve güncel veritabanı fiyatını yazar; sayfa yenilendiğinde de liste doğru görünür.
- `client/resources/js/shop/itemlist.js`, hem eski `strong` biçimini hem mevcut çıplak fiyat div'ini günceller. Gerekirse son doğrudan fiyat div'ini tanır ve sınıfını ekler.
- Mevcut gerçek satın alma callback'i bu düğümleri, seçili ürün önizlemesini, fiyat alanını ve satın al butonunu hemen günceller. Satın alma miktarı/debit hesabı değiştirilmedi.
- Değişen shop helper URL'lerine yerel sürüm anahtarı eklenir; eski CDN sorgu kimliğiyle önbellekte kalan dosya tekrar kullanılmaz.

## Doğrulama

`node --test tests/portal-shop-render.test.js` — **5/5 geçti**:

1. Gemi açıklaması HTML script sınırından taşmaz, yapılandırma eksiksiz derlenir, çözülen açıklama özgünüyle aynıdır.
2. Bütün kayıtlı dükkân sayfalarının Shop yapılandırmaları gerçek HTML script sınırları kullanılarak derlenir.
3. Iris ve Flax satın alındıktan sonra yeniden üretilen listede ve seçili ürün verisinde 24.000 U. / 200.000 C. sonraki fiyatları görünür.
4. Gerçek ekonomi satın alma cevabı ve gerçek JavaScript callback'i, sayfa yenilenmeden sınıfsız fiyat düğümlerini/önizlemeyi günceller; asıl çekim ilk Iris için 15.000 U., Flax için 100.000 C. olarak kalır. Bakiye yetersizleşince buton kapanır.
5. Sekizinci standart diroitten sonra iki satır da anında kapanır; dokuzuncu istek bakiye çekmez.

Ayrıca `portal-shop-render` (ilk dört test), `shop-ui`, `inventory-drones-shop`, `payment-local`, `payment-contents` birlikte **50/50 geçti**. Son eklenen kapasite testi ayrı çalıştırmada geçti. Testler yalnızca bellek içi veritabanı kullanır. Tarayıcıda tam görsel ekran testi bu alt görevde yapılmadı; gerçek hesaplara ürün veya para verilmedi.
