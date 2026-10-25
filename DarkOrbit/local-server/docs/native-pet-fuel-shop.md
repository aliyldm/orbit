# Özgün dükkânda PET yakıtı — 21 Ekim 2026

Normal yol: **Dükkân → P.E.T./Modüller → FUEL 100**. Yakıt, mevcut iki sütunlu ürün listesinde kendi özgün simgesiyle bulunur. Aynı seçim/önizleme, miktar alanı, 10/100/1000/MAX seçenekleri, fiyat ve Satın al düğmesi kullanılır. Ayrı form, panel veya sabit bağlantı eklenmez.

Üç sabit bağlantı (`P.E.T. Yakıtı`, `Montaj Atölyesi`, `Eşya Geliştirme`) kaldırıldı. PET sayfasına enjekte edilen yakıt paneli ve bu panelin bağımsız JavaScript dosyası silindi. Tanılama amaçlı mevcut web yolları bu değişiklikte silinmedi.

## Kullanılan özgün sözleşme

- Kaydedilmiş `internalDock~internalDockPetGear.html` sayfasında ürün yerleşimi ve özgün dükkân kodu var, fakat yakıt satırı kayıtta eksikti. `web/portal/shop-pet-fuel.js`, PET ürününün özgün tile yapısını aynen kullanarak yakıtı normal listeye ekler; `numItems` 13 olur.
- Gerçek kimlik `resource_pet-fuel`; ürün resmi mevcut `/do_img/global/items/resource/pet-fuel_100x100.png` dosyasıdır. Türkçe istemci kaynaklarında ad `P.E.T. yakıtı`, kod `FUEL 100`, açıklama `P.E.T.'in sadece yakıtla çalışır.` olarak bulunur.
- İstemci kataloğundaki birim fiyat **0,25 U.** olarak kullanılır. Örneğin 1.000 yakıt 250 U., 3 yakıt 0,75 U. tüketir.
- Özgün `Shop.Item.isPetFuel()` ve `getCalculatedMaxAmount()` zaten `User.Pet.hasPet`, `getFuel()` ve `getMaxFuel()` üzerinden PET sahibi olmayı, boş depo alanını ve bakiyeyi denetliyor. Portal bunlara oyuncunun gerçek PET seviyesi/yakıtı/100.000 kapasitesini verir.
- Satın alma özgün `Shop.processPurchase` üzerinden aynı `/ajax/shop.php` isteğini gönderir. Mevcut sunucu işlemi gerçek PET deposunu artırır; ayrı envanter yakıt nesnesi oluşturulmaz.
- Özgün callback'in beklediği `userPet` alanı PET/yakıt alımında gerçek seviye, depo ve kapasiteyle döner; mevcut `petFuel` alanı da korunur. Böylece depoyu ve seçilebilecek azami miktarı hemen yeniler. Yeni hesap önce PET'i, ardından aynı sayfada yenilemeden yakıtı alabilir. Başka bir ürün alınması PET sahipliğini yanlışlıkla kapatmaz. Depo dolunca yakıt alım düğmesi kapanır.

Ek olarak `economy.balance()` yanıtındaki Uridyum yuvarlaması kaldırıldı. Önceki yanıt gerçek 0,25 U. kalan bakiyeyi 0 bildiriyor, yenilemeye kadar son yakıt birimini almayı engelliyordu. Gerçek fiyat, para düşümü ve işlem akışı değişmedi; yanıt artık gerçek kesirli değeri taşır. Portalın JavaScript bakiye verisi de kesri korur.

Önceki gemi açıklaması script-kaçırma ve sahiplik bazlı diroit fiyatı düzeltmeleri korunur. Değişen dükkân yardımcı betikleri için önbellek sürüm anahtarı güncellenir.

## Doğrulama

`tests/pet-fuel-shop.test.js` — **7/7 geçti**. Sabit düğme/panel yokluğu, normal listede tek ürün/simge ve 13 satır, PET sahibi olmayan hesap, bakiye/depo sınırı, özgün JavaScript'in gerçek satın alma isteği ve callback'i, 1.000 yakıt/250 U. işlemi, dolu depo, 3 birim/0,75 U. kesirli bakiye, tekrar yükleme ve yeni hesapta PET alıp aynı sayfada yakıt alma kontrol edilir.

`node --test tests/pet-fuel-shop.test.js tests/portal-shop-render.test.js tests/shop-ui.test.js tests/payment-local.test.js tests/inventory-drones-shop.test.js` — **50/50 geçti**. Çıktı `logs/native-pet-fuel-tests.log` içindedir. Test hesapları yalnızca bellek içi veritabanında oluşturuldu; gerçek hesaplar değiştirilmedi. Bu alt görevde tarayıcı ekran görüntüsü alınmadı.
