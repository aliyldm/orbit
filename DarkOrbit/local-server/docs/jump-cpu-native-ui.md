# Yıldız Sistemi: özgün Atlama CPU paneli

21 Ekim 2026. Harita penceresine yeni HTML katmanı veya düğme eklenmemiştir.

Özgün istemcide alt hedef/bedel/atlama kuponu paneli yalnız **AJP-01 — Gelişmiş Atlama CPU** etkin gemi konfigürasyonunda takılıysa açılır. JP-01 / JP-02 ana üs dönüş CPU'larıdır; bunların 10 / 20 fiziksel kullanımı, Yıldız Sistemi'ndeki atlama kuponu sayısı değildir. İnceleme anındaki üretim oyuncusunda takılı JP-02 vardır, AJP-01 yoktur. Dolayısıyla mevcut gizli panel bu donanım için beklenen özgün davranıştır. Oyuncuya ücretsiz CPU veya kupon verilmemiş, farklı CPU türleri birbirine dönüştürülmemiştir. Kaynak katalogda AJP-01 bedeli 75.000 Uridium'dur.

Bulunan gerçek eksiklikler düzeltildi:

- Oyundayken envanterden CPU takma/çıkarma yalnız genel menüyü yeniliyordu. `inventory.refresh → cpu.notify` artık gerçek `CPUInitializationCommand` gönderir. AJP takılması/çıkarılması alt paneli yeniden giriş gerektirmeden açar/kapatır; konfigürasyon donanımı veritabanından okunur.
- Başlangıç ve donanım yenilemesi, varsa AJP için özgün `0|A|JCPU|I|...` hedef listesini üretir. Modern `JumpCPUUpdateCommand` modülü bu istemcide tüketilmediğinden onun yerine gerçekten kayıtlı Legacy işleyicisi kullanılır.
- Alt sayaç `resource_jumpvoucher` gerçek stokundan `0|A|JV|n` olarak beslenir. Kupon varken seçilebilir normal hedef için ücret sıfırdır ve başarılı atlamada tek kupon eksilir. Kupon yoksa mevcut açıkça yerel Uridium tarifesi kullanılır: portal grafiği adımı başına 100 U. Bu tarife özgün canlı sunucu bedeli olarak sunulmaz.
- Kaynakta bulunan düğmelerin paketleri korunur: liste `JCPU|GET`, harita seçimi `JCPU|S|mapId`, atlama `JCPU|J`; yanıtlar `I`, `C`, `S` dallarıdır. Seçim reddedilirse önceki hedef silinir ve native düğmeye başarısız seçim geri bildirimi verilir.
- Kupon/bakiye ve ortak bekleme süresi tek SQLite işleminde kaydolur. Hazırlık sırasında kaybolan ücretsiz kuponun yerine habersiz Uridium alınmaz. Başarısız veya iptal edilen atlama ödeme yapmaz. Yeni kazanılan kuponlar mevcut hedefin kullanılabilirliğini de günceller; stok kontrolü saniyede bir yapılır.
- JP ana üs dönüşü kendi fiziksel şarjını kullanır; AJP kuponuna dokunmaz. Portal harita seviye kuralları, mevcut 20 saniye çatışmasızlık, 10 saniye hazırlık ve 90 saniye ortak bekleme kuralları korunur. Galaksi kapısı ve korsan haritalarında AJP harita görünümü native sert kilitle korunur; bu haritalardan AJP atlaması yapılamaz.

Kaynak yolları `decompiled/main/scripts/net/bigpoint/darkorbit/` altındadır:

- `mvc/gui/itemsControlMenu/controller/CpuInitializationCommand.as` AJP donanım bayrağını `SpaceMapWindowProxy`'ye taşır.
- `mvc/gui/windows/spacemap/view/SpaceMapWindowMediator.as:updateCpuEquippedStatus` bu bayrakla pencere yüksekliğini 525 / 610 seçer ve paneli gizler/gösterir. Aynı sınıfın `mapItemClicked` / `jumpBtnClicked` metodları gerçek Legacy paketlerini gönderir.
- `mvc/gui/windows/spacemap/view/ui/SpaceMapView.as:updateJumpVoucherLabel` sayıyı kupon olarak gösterir ve kupon varken ücretsiz etiketi seçer. `updateJumpValues` hedef ve düğme kullanılabilirliğini günceller.
- `net/SetAttributeAssembly.as` `JV` ve `JCPU` dallarını gerçek model tüketicilerine bağlar. `SpaceMapWindowProxy.updateAdvanceWindow` eksik liste verisinde sert kilit uygular.

`tests/jump-cpu-native-ui.test.js` 7 test içerir: gerçek `World.current()` dünyasında envanter tak/çıkar → kodlanmış native panel bayrağı; gerçek Legacy hedef seçimi/düğme → kalıcı harita geçişi; kuponun tek tüketimi; şarj/kupon ayrımı; seviye ve çatışma engelleri; kaybolan kupon ve SQLite geri alma; ödül sonrası canlı sayaç yenilemesi. Bunlar gerçek paket kodlayıcıyla yapılan süreç içi entegrasyon testleridir; Flash ekranının görsel kontrolü değildir.
