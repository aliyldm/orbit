# Ayarlar ve gizli diroitlerin özgün kısa göstergesi

## Değişen davranış

İstemcinin özgün iki seçeneği ayrı alanlardır: **kendi diroitlerini göster** (`displayMyDrones`) oyuncunun gemisini, **diroitleri göster** (`displayDrones`) diğer gemileri kontrol eder. Son kullanıcı bildirimi üzerine yerel sunucuda genel kutu ana anahtar olarak uygulanır: `displayDrones=false` kaydedilince kendi diroitleri de kapatılır. **22 Ekim düzeltmesi:** genel anahtar kapalıdan açığa geçtiğinde kendi diroitleri de tekrar açılır; önceki asimetrik kural kendi alanını kapalıda bırakıp görünür seçeneğe rağmen modelleri gizliyordu. Genel seçenek değişmeden açıkken kendi kutusu yalnız kendi modellerini gizleyebilir. Kaydedilmiş eski genel-kapalı/kendi-açık birleşimi de yeniden girişte kapalıya düzeltilir. Bu küçük kullanım tercihi yerel uyarlamadır; iki alanın özgün bağımsızlığı birebir korunmuş gibi sunulmaz.

`asd` hesabında gerçek hata birleşimi `displayDrones=true`, `displayMyDrones=false` olarak doğrulandı. Kullanıcının modelleri görmek isteğine uygun olarak yalnız bu iki alan true yapıldı; diğer ayarlar ve cüzdan değişmedi. Yeni istemcinin alınması için yeniden giriş gerekir.

`TopDisplay` içindeki mevcut kısa metin göstergesi artık yalnız ilgili diroit modeli seçeneği kapalıyken gösterilir. Seçenek yeniden açılınca kısa satır kaldırılır. İki ayarın değişim sinyali de canlı dinlenir; HUD yok edilirken dinleyiciler kaldırılır. Diroit sayısı, türü, seviyesi veya ekipmanı bu görünürlük tercihi için değiştirilmez.

Kullanılan gösterge özgün `Drones.simpleDroneRepresentation` metnidir:

- Flax **F**, Iris **I**, Apis **A**, Zeus **Z**.
- Renk, gerçek takılı **istatistik tasarımından** gelir: normal beyaz, Havoc kırmızı `#FF0000`, Hercules mavi `#328fcc`. Kozmetik tasarım için sahte Havoc/Hercules rengi verilmez.
- Son köşeli parantez gerçek ortalama diroit seviyesidir. Örneğin bütün diroitler ilk seviyedeyse `[1]`.

Gemi gizliliği gibi `drones.visible=false` durumları ayrıca korunur; diroit görünürlük ayarını kapatmak gizli gemiler hakkında yeni bilgi üretmez. Uçuş düzeninin mevcut simgesi korunur; yeni UI simgesi veya metin kopyası eklenmez.

## Ayar kaydetme cevabı

Sunucu daha önce Audio/Display/Gameplay/Quality/Quest isteklerini yalnız veritabanına yazıyordu. Şimdi başarılı doğrulama ve kaydın ardından yalnız o sekmenin gerçek native modülünü geri yollar. Beşinin de `HandlerLookup` içinde doğrudan istemci işleyicisi vardır. Bütün `UserSettingsCommand` tekrar oynatılmaz; o komut ayrıca ayarlar penceresini kurar ve ilgisiz sekmeleri yeniden uygular.

- Ses: ses, müzik ve bilgisayar ses düzeyi 0–100; native işleyici ses kaynaklarını günceller.
- Görüntü/arayüz: kutular, madenler, isimler, pencere arka planları, kendi/diğer diroitler ve mevcut native sunum seçenekleri kaydedilir ve geri uygulanır.
- Kalite: native 2D kalite alanları ve 3D alanlarının mevcut sınırları korunur; kaynak kalite tüketicileri istemcidedir.
- Görev: mevcut filtre modülü native görev penceresine gider.
- Klavye: önceki anahtar delta birleştirme ve yeniden girişte yükleme korunur. Pencere konumu/sıfırlama davranışları bu değişiklik için yeniden yazılmaz.

**Kapsam sınırı:** Bir Gameplay kutucuğunun kaydedilip istemciye uygulanması sunucu tarafındaki her otomasyonu tamamlamaz. `autoBoost`, `autoRefinement`, `autoChangeAmmo` ve otomatik yeşil korsan anahtarı satın alma için mevcut ayrı sunucu tüketicileri bu incelemede yeniden oluşturulmamıştır. CPU'ların kendi mevcut otomasyonları bu seçeneklerden ayrıdır. Sohbet/çok oyunculu sistemler açılmaz. 2D/3D renderer değiştirme hâlâ istemciyi yeniden yüklemeyi gerektirir; diroit görünürlüğü için yeniden giriş gerekmez.

## İstemci kaynağı ve gerçek artefakt

Kaynaklar `decompiled/main/scripts/net/bigpoint/darkorbit` altında:

- `net/netty/HandlerLookup.as`: doğrudan beş ayar modülü işleyicisi.
- `net/netty/handlers/settings/DisplaySettingsHandler.as`: iki diroit ayarının farklı bindable değişkenleri.
- `mvc/settingsFUI/model/SettingsWindowFUIProxy.as`: kendi/diğer diroit kutucukları doğrudan ayrı değişim sinyalini üretir.
- `map/view2D/display/ship/drones/DronesFormation2D.as`, `map/view3D/display3D/ship/drones/DronesFormation3D.as`: fiziksel modellerin kaynak seçeneği.
- `map/model/ship/drones/Drone.as`, `Drones.as`: özgün harf, tasarım rengi ve ortalama seviye metni.
- `map/hud/ship/TopDisplay.as`: yama mevcut kısa metnin yalnız gizlenmiş model ayarında gösterilmesini sağlar.
- `decompiled/pet-patterns/game.xml`: tasarım ID 1 Havoc kırmızısı, ID 2 Hercules mavisi.

**Yamanın hedefi `client/spacemap/main.swf` dosyasıdır; hangarın `inventory.swf` dosyası değildir.** İçe aktarılan tek kaynak sınıf TopDisplay'dir. Çıktı yeniden decompile edilerek yeni koşul ve dinleyiciler doğrulandı. 258 SWF etiketi sayısı korundu; ABC dışındaki bütün medya/UI etiketlerinin SHA256 değerleri önceki artefaktla bire bir aynı kaldı.

Yedek, derleme ve doğrulama:

- `decompiled/settings-drone-patch/main-before.swf`
- `decompiled/settings-drone-patch/main-patched.swf`
- `decompiled/settings-drone-patch/verified/scripts/.../TopDisplay.as`
- `decompiled/settings-drone-patch/artifact-verification.json`

Önceki SHA256 `688499ddc51f235e30fb5d49f4e067bf952b1bdc55908d2a4cb8ab6f00aad8bb`; kurulan yama `37bdd3e3482a151b1dadef2f6499be5498d6a2c7299a74704a73d5fe54404171`. Kurulum öncesi dosya hash'i yeniden kontrol edildi; eşzamanlı başka MAIN değişikliği üstüne yazılmadı. İstemcinin yeni MAIN'i yüklemesi için bu yamanın ilk kullanımında oyun kapatılıp açılmalıdır; sonrasındaki kutucuk değişimleri canlıdır.

## Doğrulama ve sınırı

İlgili doğrulama: `node --test tests/settings-runtime.test.js tests/systems.test.js`. Güncel toplam sonuç `docs/hotkeys-hangars-pet-validation.md` belgesinde tutulur.

Yeni testler beş sekmenin gerçek native paket cevabını, doğrulama/sınırlarını, oyuncu ayrımını, kendi/diğer diroit tercihlerinin yeniden girişte aynı yüklenmesini, gerçek sahip olunan dört türün legacy paketini, gerçek Havoc/Hercules istatistik tasarımı kimliklerini ve derlenmiş sınıfın değişim dinleyicilerini denetler. AS yeniden decompile doğrulaması gerçek Flash ekranında görsel uçtan uca doğrulama yapıldığı anlamına gelmez.
