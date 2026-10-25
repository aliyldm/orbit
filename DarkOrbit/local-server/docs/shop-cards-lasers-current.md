# Gemi kartı düzeltmesi ve eksik lazerler

23 Ekim 2026. **Dağıtıldı: PID24408, solo HTTP8095/TCP8096, healthOK.** Otomatik onay denetimindeki iki taşıma hatası kullanıcı bağlantıyı yenileyip devam etmeyi seçince çözüldü. Yeni yedek alındı; PID3096 kimliği doğrulanarak kayıtlarını kaydedip kapatıldı ve yeni sürüm arka planda başlatıldı.

## Tamamlanan kod

- Gemi resimleri `/do_img/...` yolundan isteniyordu, oysa dosyalar `/client/do_img/...` altında. İkon adresleri düzeltildi;80 dosya gerçek HTTP üzerinden200/PNG olarak doğrulandı.
- Eski `.itemList_singleItem div {height:104px}` kuralı isim etiketinin13px yüksekliğini eziyor, siyah etiket bütün resmi ve fiyatı örtüyordu. `.itemList_singleItem .localShipName` ile doğru özgüllük kullanıldı. CSS sürümü `20261023shipcards2`.
- Gerçek tam portal HTML/CSS/script ve statik sunumuyla ayrı headless tarayıcıda80/80 gemi resmi yükleniyor; kart100px, isim/fiyat13px, satır aralığı105px. `logs/ship-cards-preview/shop.png` ve `report.json`.
- Kullanıcının “mf5” dediği ürün katalogdaki **LF-5 Mortifer (`lf-5-mf`)** olarak yorumlandı. Beş özel lazer önceden kampanya paketlerinde vardı ama normal Silahlar sayfasında kanonik ürün olarak yoktu.
- `game/laser-shop.js`: gerçek `LaserType`26 ürünün tamamı normal Silahlar listesine eklendi. Eski fiyatlar korunur; SL-02 yerleşik10.000U.; yerleşik sentinel4294967295 fiyatı olan özel lazerler yerel1.000.000U. Normal kredi/Uridium fiyatları değişmez. 500k gemi fiyatı lazerlere uygulanmaz.
- `web/portal/shop-lasers.js`: gerçek ikon, ad, fiyat, çoklu satın alma ve mevcut `modern-lasers.details` açıklaması; HST-1/HST-2 korunur.26lazer+2roketatar. 196kampanya manifesti ve ürünleri korunur.
- Eksik17 özgün100x100 lazer resmi yapılandırılmış resmî CDN'den yerel klasöre alındı. `logs/laser-shop-asset-cache.json`. Yeni resim üretilmedi.
- Ayrı tarayıcıda LF-5MF'ye native liste kaydırma/seçim yapıldı; kart, önizleme ve1m fiyatı görünüyor. `logs/laser-cards-preview/shop.png`; raporda seçiliID=equipment_weapon_laser_lf-5-mf,28/28resim,105pxsatır. Headless başlangıç animasyonu testte sonlandırıldı; açık Qt penceresine girdi verilmedi.

## Doğrulama

**890/890 test**,327JS/0sözdizimi hatası. Gerçek HTTP/TCP **22.575komut PASS**.26lazerin her biri ayrı DB'de gerçek ekipman olarak satın alındı; eski ekipman korunur ve bedeli doğru düşer.80gemi+26lazer resmi doğru HTTP adresi ve PNG imzasıyla denetlendi. Silah bonus/formülleri bu çalışmada değiştirilmedi; orijinalle%100eşitlik iddiası yok.

Kayıtlar `logs/shop-cards-lasers-tests.log`, `shop-cards-lasers-network.log`, `ship-cards-browser-test.log`, `laser-cards-browser-test.log`. Gerçek hesaplara satın alma/hediye uygulanmadı, migration eklenmedi.

## Üretim korunumu

Dağıtım öncesi yedek `backups/darkorbit-before-2026-10-23T17-34-31-367Z.db`. Bu yedekte3hesap/3oyuncu/**14gemi** var; önceki13gemi kaydına göre kullanıcının yeni satın alımı korunmuştur. Yeni hediye/satın alma tekrar uygulanmaz.

`logs/shop-cards-lasers-production-check.json`: **60tablonun tüm satır/kolonları bu son yedekle birebir aynı**, değişen tablo yok; integrityOK/FK0. Yeni üretim sunucusunda26lazer resmi de HTTP200/PNG olarak tekrar doğrulandı. Açık portalın yeni kart/CSS listesini alması için sayfa yenilenir; gerçek Qt UI girdisi verilmedi.
