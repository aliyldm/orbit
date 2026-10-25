# Yalnız Plus gemilerinde 500.000 Uridium

24 Ekim 2026. Kullanıcı 500k fiyat isteğinin yalnızca Plus gemileri için olduğunu açıkladı. Önceki bütün 80 gövdeye uygulanan fiyat kuralı kaldırıldı.

- Hangarın 80 gerçek gövdesi dükkânda kalır. Sadece `-plus` ile biten 12 model 500.000 Uridiumdur.
- Diğer gemilerde kaydedilmiş normal portal fiyatı ve para birimi geri kullanılır. Örnek: Goliath 50.000 U., Pusat ve Solace 250.000 U., Liberator 40.000 C., Bigboy 285.000 C., Phoenix ücretsiz.
- Portal satırı olmayan normal gemiler için kaydedilmiş native hangar fiyatı kullanılır. Payment işaretli veya normal satın alma fiyatı olmayan özel gövdeler önceki yerel özel ürün kuralıyla 1.000.000 U. olur; Cyborg/Mimesis gibi fiyatı olmayan gemiler yanlışlıkla ücretsiz yapılmaz. Paket manifestleri ve 196 kampanya fiyatı değiştirilmedi.
- Ortak `game/ship-shop.js` teklifi; portal kartı/seçim bedeli, native dükkân, gerçek satın alma ve FlashAPI hangar fiyatında kullanılır. Kredi kartlarının arka planı ve para birimi doğru gösterilir. Kredi önce, ardından aynı para birimi içinde ucuzdan pahalıya sıralama korunur.
- Sahiplik, daha önceki satın alımlar, bakiyeler ve gövde istatistikleri yeniden yazılmaz. Bu işlemde iade/hediye/migration yok.

## Doğrulama ve dağıtım

- 898/898 test, 331 JS / 0 sözdizimi hatası. 80 geminin tamamı ayrı bellek DB'sinde doğru para biriminden alınarak teslim, can, aktif ekipmanın korunması ve fiyat doğrulandı. Plus yetersiz para/çoklu alım/SQL hatası rollback testleri geçti.
- Gerçek HTTP/TCP testinde 22.616 komut çözüldü. İki Plus gemisinin gerçek satın alımı, 80 fiyat/para birimi ve hangar/portal uyumu doğrulandı.
- Ayrı headless Edge portalında 80/80 görsel, kredi fiyatları, sıralama ve kart yerleşimi doğrulandı; `logs/ship-cards-preview/shop.png`. Kullanıcının Qt penceresine girdi gönderilmedi.
- Eski PID25352 kimliği doğrulanıp kayıtları kaydederek kapatıldı. Yeni **PID27320**, solo HTTP8095/TCP8096, healthOK.
- Son kayıt sonrası yedek `backups/darkorbit-before-2026-10-23T21-49-44-573Z.db`. Üretimin 60 tablosundaki bütün satır/kolonlar bu yedekle aynı; integrityOK/FK0; 3 hesap, 3 oyuncu, 14 gemi korunur.
- Kanıtlar `logs/plus-price-tests.log`, `plus-price-focused.log`, `plus-price-network.log`, `plus-price-preview.log`, `plus-price-database.log`, `plus-price-production-check.json`.

MAIN/SWF, lazer sesi, Cubikon ve geliştirme bonusları bu değişiklikte aynı kaldı. Portalı yenilemek yeni fiyatları gösterir.
