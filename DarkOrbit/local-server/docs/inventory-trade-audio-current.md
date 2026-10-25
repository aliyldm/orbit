# Envanter, toplu takma, hammadde satışı ve lazer sesi — 25 Ekim 2026

**Dağıtıldı:** PID30260/solo8095–8096/healthOK, önceki17180 kayıtla kapandı.22-53-06-161Z yedekle60tablonun tüm satır/şeması aynı;3hesap/3oyuncu/14gemi/integrityOK/FK0. Aşağıdaki220ms tercihi, kullanıcının sonraki **bütün lazer ses/animasyonu özgün olsun** talebiyle200ms'ye döndürüldü; [son lazer paketi](native-lasers-current.md) geçerlidir. Ticaret/envanter düzeltmeleri bu sonraki pakette de korunur.

Doğrulama: **1.034/1.034 test**, **374 JavaScript / 0 sözdizimi hatası**, ayrı bellek veritabanında **24.009 gerçek HTTP/TCP komutu PASS**. Üretim dağıtım durumu `logs/inventory-trade-audio-production-check.json` ve kök DEVAM_NOTLARI.md içinde tutulur.

## Dar envanter

Önceki EB düzeltmesi yanlıştı. ActionIdentifiers küçük harf olsa da kurulu InventoryViewMediator FILTER_INVENTORY_BY_CONTEXT yolunda `toUpperCase()` çağırır; GridComponent bu **büyük harfli** bağlamı EB ile karşılaştırır. EB artık metadata'daki SHIP/DRONE/PET biçimiyle aktarılıyor. Tam mediator→grid zinciri testte işletiliyor; önceki lowercase verisi hatayı yeniden üretir. Geniş görünümün çalışması farklı kullanıcı filtresini kullanmasından kaynaklanır. Eşyalar silinmedi veya yeniden verilmedi. Kurulu SWF'den beş sınıf `decompiled/inventory-compact-capacity/before` altına çıkarıldı; inventory SWF değişmedi.

## Toplu takma

Gemi lazer/kalkanları, diroitler ve P.E.T. boş yuva kadar eşya kabul eder. Fazla eşya depoda kalır. İki konfigürasyon ayrı kalır; tüm seçimin sahiplik, tür ve başka yuvada takılı olma kontrolü önce yapılır. Geçersiz kuyruk öğesi bile tüm işlemi geri alır. Normal move ve droneEquip yanıtındaki diziler **kabul edilmeyen eşya kimlikleri**dir; çoklu diroit istemcisinin returnFilteredOutNotAcceptedItems işlemi de bu kimlikleri çıkarır. Diroitler arası dağıtım istemcinin açık slot planını kullanır.

moveDroneDesign ayrı Boolean yanıt sözleşmesidir; kısmi işlemi tam başarı diye bildirmez. Boş tasarım yuvası yoksa hareket olmaz. Tasarım çıkarma korunur. `tests/inventory-capacity.test.js` kısmi, sıfır kapasite, konfigürasyon, sahte kuyruk, geç grup rollback ve native yanıt yönünü denetler. HTTP/TCP testi gerçek FlashAPI kısmi taşıma→hangar yenileme→çıkarma akışını her iki konfigürasyonda yürütür.

## Ticaret ve Seprom

Üst menüye özgün **ore_trade** simgesi ve `title_trade` (Ham madde ticareti) eklendi; başlangıçta kapalıdır. GuiManager mevcut yerel ticaret penceresini kurar, kullanıcı büyüttüğünde TradeRequest gönderir. İstasyon yakınında hiçbir modül gerekmez. Uzaktan HM7 mevcut ve şarjlı olmalı. Açmak şarj tüketmez; satış tüketir. Menzil, aktif oturum, ölüm ve atlama kontrol edilir; uzakta modülsüz girişte yerel bilgi mesajı gösterilir. 5-2 Palladium takası korunur.

Seprom fiyatı0 olduğu için native OreTradeModule.setOreCount, `orePrice > 0` koşulunu geçemiyor ve sayacı doldurmuyordu. Taban fiyat **750 kredi** oldu; aynı fiyat tablosunu istasyon/HM7/P.E.T. kullanır. Açılışta miktarlar DB'den tekrar gönderilir.90.000+ stokla miktar, seçilen miktarın düşülmesi, kredi, depolama hatasında rollback test edildi. Kullanıcının cevheri otomatik satılmaz/silinmez.

Kaynaklar: [resmî kaynak FAQ'sı](https://board-de.darkorbit.com/threads/faq-rohstoffe-erze.2750/) tüm cevherlerin Xenomit dışında satılabileceğini belirtir; [2019 resmî forum satış açıklaması](https://board-es.darkorbit.com/threads/como-puedo-vender-las-materias-primas-mas-eficiente-mente.141195/) Seprom750 ve modülsüz istasyon satışını açıklar. Eski2016–2018 İngilizce forum yanıtları Seprom satılamaz diyordu; bunlar bu modern istemcinin fiyat alanını kapatmak için kullanılmadı. Bu çalışma genel şeref/firma/istasyon satış çarpanlarının tamamını birebir doğruladığı iddiası değildir. P.E.T. mevcut toplamdan bonus hesaplaması korunur; istemcinin tam sayı birim fiyat yuvarlamasıyla toplam farkları ayrıca doğrulanmalı.

## Lazer sesi

Özel bir saniyelik LAST_SOUNDS/soundAllowed kapısı kaldırıldı. Yakalanmış istemcinin özgün ses koşulları ve ses örnekleri kullanılır: 2D'de saldırı başlatma yolu, 3D'de namlu grubu salvosu. RSB de aynı özgün ses yolunu korur. Önceki kullanıcının tercih ettiği **normal görsel alt salvo220ms / RSB200ms** korunur; bu sefer görsel hız değiştirilmedi. Sunucu hasar ve cephane ritmi aynı.

Yama: `tools/patch-native-laser-sound.js`, kanıt `decompiled/native-laser-sound-patch/evidence.json`. MAIN47a0…→ffd878…;256kod dışı etiketin tümü aynı. Derlenmiş SWF tekrar çıkarıldı; iki renderer'ın ses koşulları ve gövdeleri (eşdeğer decompiler NaN/Boolean gösterimleri normalize edilerek) eski istemciyle karşılaştırıldı. Tarif/yükseltme/roketatar sınıfları korunur. Yeni gameclientHash `local-20261025-native-laser-sound`; resourcesXmlHash önceki footer anahtarında kalır.

Gerçek Qt arayüzüne girdi verilmedi veya ses kaydı alınmadı. Kaynak, paket ve dosya doğrulaması; canlı orijinal sunucuda bütün cephane/ses zamanlarının birebir ölçüldüğü anlamına gelmez. Kullanıcı oyunu tamamen yeniden açmalı; hangarı da yeniden yüklemeli.
