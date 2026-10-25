# P.E.T. etkinlik ve native pencere eşleşmesi

21 Ekim 2026. Sunucu değişikliği; istemci SWF'si veya arayüz yerleşimi değiştirilmez.

Haritada P.E.T. görünürken pencerede başlat üçgeni çıkmasının nedeni, ekipman/yakıt yenilemesinin `PetInitializationCommand` göndermesiydi. Native `PetWindowAssembly.init` içindeki `toggleRepairButtonVisbility(false)` durdur düğmesini gizler ve başlat düğmesini gösterir. Önceki `pet.refresh` / `pet.purchased` akışları aynı paketin arkasından gelmesi gereken `PetHeroActivationCommand` komutunu filtreliyordu. Harita varlığı dururken pencere pasif duruma dönüyordu. Üçgene tekrar basılması da sunucudaki etkin P.E.T. nedeniyle sessizce reddediliyordu.

Artık aynı yenilemenin sonunda etkin P.E.T. için native kahraman aktivasyonu ve gerçek durum paketi gönderilir. `PetHeroActivationHandler` pencerenin `activatePet()` metoduyla durdur düğmesini ve dinleyicisini geri getirir. Bu komut yeni bir P.E.T. üretmek için kullanılmaz: gerçek `ShipManager.createPet` aynı kimlik ve görünüm varsa mevcut varlığı döndürür. Açık `LAUNCH` isteği zaten etkin P.E.T.'e geldiğinde aynı runtime'ı, canı, yakıtı ve konumu koruyarak pencereyi yeniden eşler; `TOGGLE` ve `DEACTIVATE` ayrı native anlamlarını korur.

Geri çağırma can/yakıtı önce kaydeder, runtime'ı sonlandırır, native deactivation ve gerçek `ShipRemoveCommand` gönderir. Eski bir varlık için tekrarlanan geri çağırma da kaldırma onayını gönderir. Veritabanı hatası halinde etkin runtime ve pencere korunur; istek yeniden denenebilir. PET hedefini tutan NPC `petAggro` bağı kaldırılır. Mevcut yerel savaş sırasında geri çağırma kuralı değiştirilmez; yeni, doğrulanmamış bir geri çağırma bekleme süresi eklenmez.

İkinci bir sıra hatası da kamikaze sonrası oluşuyordu: native destruction tamir düğmesini açtıktan sonra deactivation onu tekrar başlat düğmesine çeviriyordu. Ölü P.E.T. için kaldırma sonrasında `petIsAlive:false` başlangıcı gönderilerek son durum tamir olur. Can, yakıt ve kamikaze bekleme kaydı yenilenmez. Locator yenilemesinde gerçek hedef listesi ve runtime seçimi, ticaret yokluğunda da native idle durumu korunur. Harita geçişi mevcut aktif PET'i tek kez yeniden kurar; çıkış sonrasında P.E.T. pasif kalır.

Kaynak kanıtları `decompiled/main/scripts/net/bigpoint/darkorbit/` altında:

- `com/module/PetRequest.as`: LAUNCH=0, DEACTIVATE=1, TOGGLE=2, REPAIR=4.
- `net/PetWindowAssembly.as`: `init`, `toggleRepairButtonVisbility`, `activatePet`, `petDeactivation`, `petDestroyed`, `setRepairButtonState`. Sonuncusu tamir düğmesinin görünürlüğünü değiştirmez; yalnız etkinlik ve bedel ipucunu değiştirir.
- `net/netty/handlers/pet/PetHeroActivationHandler.as`: varlık ve native etkin pencereyi bağlar.
- `map/model/ship/ShipManager.as:createPet`: aynı kimlik/görünüm için tek varlık sağlar.
- `net/netty/handlers/pet/PetDeactivationHandler.as` ve `PetAssembly.assemblePetDeactivation`: pencere/effect sıfırlaması harita varlığını tek başına kaldırmaz; ayrı `ShipRemoveCommand` gereklidir.

`tests/pet-native-state.test.js` 6 entegrasyon testi, gerçek native paket kodlayıcısı ve SQLite kullanır. Dar bir kaynak tabanlı pencere durumu izdüşümü; etkin harita varlığıyla son düğme durumunu birlikte denetler. Başlat → yakıt → ekipman → geri çağırma, tekrar istekleri, kayıt hatası, savaş, harita/yeniden giriş, kamikaze/tamir ve locator/idle geçişleri kapsanır. Bu testler Flash görsel işleyicisini çalıştırmaz; çizilmiş ekran doğrulaması olarak sunulmaz.
