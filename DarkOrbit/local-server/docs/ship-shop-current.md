# Hangardaki gemilerin satışı ve dükkân menüsü

**24 Ekim düzeltmesi:** Kullanıcı fiyat kapsamını yalnız Plus gemileri olarak netleştirdi. Aşağıdaki tüm gemilere 500k anlatımı tarihseldir; etkin kural ve dağıtım [plus-prices-current.md](plus-prices-current.md) içindedir.

23 Ekim 2026. Kullanıcı hangarda bulunan bütün gemileri dükkâna eklemeyi ve her birinin fiyatını 500.000 Uridium yapmayı istedi. Ardından sol menüde kesilen Özel Fırsatlar sekmesinin erişilebilir olmasını istedi.

## Sonuç

- Kaydedilmiş native `getHangarList` yanıtındaki 80 farklı gerçek gemi, Plus gemileri dahil, Gemiler sekmesindedir. Kaynak listede bulunmayan NPC veya tasarım kimlikleri gemi diye eklenmez.
- Portal, native oyun içi gemi teklifleri, satın alma bedeli ve hangarın `shipInfo.price` alanı aynı sabit **500.000 Uridium** kullanır. Eski kredi/ücretsiz gemiler de kullanıcının “hepsi” talebine dahildir. Hesap indirimi bu sabit fiyatı değiştirmez.
- Gemiler tek tek alınır; satın alma, para düşümü ve gerçek `ships` satırının tam canla eklenmesi aynı transaction içindedir. Aktif gemi ve ekipmanı satın alma sırasında değişmez. Yeni gemiler hangar listesine gelir.
- Kullanıcının özel fiyatı `game/ship-shop.js` içindedir. Özgün `ship_types` istatistik/fiyat kanıtları ve eski sahiplikler yeniden yazılmadı. Birleştir tarifleri, kampanya paketleri ve tasarım ürünleri bu gemi fiyatından ayrıdır. Yeni gemiler için özel yetenek sistemi genişletilmedi; mevcut kısmi uygulama durumu geçerlidir.
- Yeni portal satırları gerçek gemi istatistiklerini ve yerel ikonları kullanır. Şirkete göre adlandırılmış dokuz gemi mevcut MMO ikonundan, Spectrum Plus mevcut kendi tasarım ikonundan gösterilir. Yeni görsel üretilmedi. Mevcut gemi açıklamaları korunur.
- Sol kategoriler özgün 397px panel içinde tema renkleriyle kaydırılabilir. Aktif sekme aşağıda kaldığında sayfa açılırken görünür alana kayar. CSS sürüm anahtarı yenilendi.

## Doğrulama / dağıtım

**PID3096**, solo HTTP8095/TCP8096, healthOK. Önceki PID18004 kayıtlarını kaydederek kapatıldı.

- **888/888 test**, **323 JavaScript / 0 sözdizimi hatası**.
- 80 geminin tamamı ayrı bellek DB'sinde satın alındı; fiyat, can, teslim, aktif geminin korunması, yetersiz para/çoklu gemi isteği/SQL hatasında rollback doğrulandı.
- Gerçek HTTP/TCP testinde **22.556 komut** çözüldü. Native katalogda 80 gövde/fiyatı, portalda 80 satır, Pusat Plus ve Solace Plus satın alımı ve gerçek FlashAPI hangar sahipliği/fiyatı denetlendi. Native kategorideki mevcut beş kampanya paketi ayrı ürün olarak korunur.
- Menü özgün assetlerle ayrı headless Edge test sayfasında görüntülendi. Panel397px, içerik431px, kaydırma34px; Özel Fırsatlar düğmesi tamamen görünür. `logs/shop-navigation-preview.png` ve `shop-navigation-preview-dom.html`. Bu, kullanıcının açık Qt/Flash penceresine verilen bir UI girdisi değildir.
- Dağıtım öncesi yedek `backups/darkorbit-before-2026-10-23T17-10-47-470Z.db`. Üretim DB'sindeki **60 tablonun bütün satır/kolonları yedekle aynı**. Hesap, bakiye, ilerleme, gemi/envanter ve P.E.T. verisi değiştirilmedi. Yeni migration veya hediye yok; integrityOK/FK0.

Test kayıtları `logs/ship-shop-tests.log`, `ship-shop-network.log`, `ship-shop-database.log`; üretim kanıtı `logs/ship-shop-production-check.json`.
