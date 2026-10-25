# Görünmezlik ve Ekstralar CPU denetimi — 23 Ekim 2026

En son kullanıcı isteği: görünmezliğin harita geçişinde kaybolan görüntüsünü düzeltmek ve Ekstralar CPU'larının tamamını kontrol etmek. Solo kapsam korundu; çok oyunculu sistem eklenmedi.

## Sonuç

Görünmezliğin sunucudaki kaydı doğruydu. `game/templates/init.json` içindeki eski hesaptan yakalanmış `0|n|INV|173637251|0`, açılışta güncel oyuncuya uyarlanıp doğru `ShipInitializationCommand.cloaked` alanının ardından gönderiliyor ve istemcide görünmezliği kaldırıyordu. `game/init.js` artık bu yakalanmış INV durumunu filtreler; harita sahnesinin sonunda gerçek oyuncudan tek doğru INV komutu üretir. `game/handlers/core.js` 2D/3D map-ready onayında da aynı durumu tekrar gönderir. Hazır onayı, normal geçiş, AJP/JP ve yeniden giriş ilave görünmezlik şarjı tüketmez. Kendi saldırısından sonra yeniden görünmez yapmaz.

İstemci sözleşmesi: `decompiled/main/scripts/net/bigpoint/darkorbit/net/MapEventsAssembly.as` INV bayrağını geminin `cloaked.value` alanına bağlar. ShipAssembly ilk değeri kurar; Ship2D/Ship3D değişimi dinler. İstemci SWF'sini değiştirmek gerekmedi.

## Bütün CPU ürünleri

40 fiziksel kimliğin tamamı [ayrıntılı matriste](cpu-local.md) listelenmiştir; katalog `game/cpu-catalog.js` ile birebir karşılaştırılır. Arayüzdeki ortak JP/AIM/cloak/DR kısayolları ayrıca fiziksel ürün sayılmaz.

| Sonuç | Adet | Ürünler |
|---|---:|---|
| Yerel işlevi var, tüketici ve aile testleri mevcut | 33 | JP-01/02, AJP, CL04K-M/XL/XS; AROL/RLLB/ALB/RB/FB; NC-RRB/AWB/AWR/AWL/AGB; ROK-T01/MIN-T01/02; SLE-01..04; DR-01/02; AIM-01/02; SMB/ISH; G3X-CRGO; RG-SL/AGS-X; HM7 |
| Yalnız donanım bayrağı; diplomasi yok | 1 | RD-X |
| Gerekli enfeksiyon/PvP sistemi yok | 3 | Anti-Z1, Anti-Z1-XL, PA-X |
| Sınırsız cephane modelinde ek kapasite sağlamaz | 3 | G3X-AMRY-S/M/L |

Son 7 ürün satın alınamaz; para düşmez. Eski sahiplik kayıtları korunur. Özellik varmış gibi sahte etki uygulanmaz. Modern RG-SL/AGS-X artık çalışmaktadır; 20 Ekim tarihli eski denetim bu iki ürün hakkında güncel değildi ve düzeltildi.

Laboratuvar otomasyonu bu tur düzeltildi: silah CPU'su laboratuvarda seçilmiş cevheri korur; daha güçlü cevheri habersiz harcamaz. Jeneratör CPU'su en iyi uygun cevheri seçer. Harcama ve bütün ilgili buff güncellemeleri tek işlemde yapılır; ikinci güncelleme başarısız olursa birincinin harcadığı maden de geri alınır. Seçim kaydı olmayan yeni hesapta silah için en iyi cevher varsayımı yerel politikadır. Davranış dayanağı [resmî Extras FAQ](https://board-de.darkorbit.com/threads/faq-extras.118005/).

AROL ve RLLB'nin gerçek tekli/beşli roket akışları önceki entegrasyon testleriyle tekrar geçti. Aç/kapa, aktif konfigürasyon, stok, yükleme, bekleme ve saldırı iptali denetlenir. Laboratuvar otomasyonu için maden stoku, AIM için Xenomit; otomatik satın alım için para ve ilgili CPU'nun aktif konfigürasyonda takılı olması gerekir. ALB/RB'nin bağımsız hangar cephane seçimi henüz yoktur; mevcut savaş cephanesini izler. AJP'nin mesafe başına 100 U. tarifesi ve JP ortak beklemesi yerel karardır. Tam özgün sunucu formülleri veya bütün Flash pencerelerinin görüntülü denenmesi iddia edilmez.

## Doğrulama

- `logs/cloak-cpu-full-tests.log`: **850/850**, 0 hata. Yeni 15 test; kalan testler de yeniden geçti.
- `logs/cloak-cpu-source-check.log`: **307 JavaScript / 0 sözdizimi hatası**.
- `logs/cloak-cpu-network-check.log`: **22.041 çözülen gerçek HTTP/TCP komutu PASS**. Gerçek 10 saniyelik AJP ve JP dönüşünde hem hero cloak bayrağı hem INV1 korunur; INV0 gönderilmez, görünmezlik şarjı 9'da kalır. Bellek DB'si kullanılır.
- `logs/cloak-cpu-deploy-database.log`: 2 hesap, 2 oyuncu, 7 gemi ve 46 sahiplik/ilerleme tablosu yükseltme kopyasında korundu.
- `logs/cloak-cpu-live-verification.log`: solo/ok; sunulan MAIN aynı; gerçek DB'de hesap/oyuncu dahil **48 tablo** kapanış yedeğiyle tam aynı, integrity OK / FK0.

Native ekran girdisi önceki Escape durdurması nedeniyle kullanılmadı. Bu sonuç kaynak, codec, yürütme ve gerçek soket kanıtıdır; gerçek Qt ekranında görüntülü son deneme kullanıcıya kalır.

## Dağıtım ve devam

Güncel sunucu **PID22308**, solo HTTP8095/TCP8096. Önceki PID3628 kimlik doğrulamasıyla kaydederek kapatıldı. Console/error: `logs/cloak-cpu-server-console.log` / `logs/cloak-cpu-server-error.log`. Kapanış yedeği: `backups/darkorbit-before-2026-10-23T11-40-30-447Z.db`; migration kontrol kopyası aynı damgayla kaydedildi.

MAIN SHA256 `e672b127d1f7898e1d558e4bb7f03f4dfd5372f56f8ac6ecb3a063facc3b6a8d`; cache `local-20261023-launcher-native-rewards`. Bu tur istemci dosyası veya DB şeması değişmedi. Oyundan çıkıp yeniden giriş yeni init durumunu alır. Gerçek hesaba bu tur para/eşya verilmedi; geçmiş hediyeleri tekrar teslim etmeyin.

Önceki ana kapsam ve kalan işler: [ikinci tamamlama kaydı](second-completion-work.md), özellikle görsel kontrol, yayımlanmamış savaş formülleri, özgün görevlerin kalanı, modern etkinlik/PET/Payment içeriği ve asset denetimi. Hades değiştirilmeyecek; çok oyunculu/mimari geçişine başlanmayacak. Yeni CPU açığı olarak bağımsız hangar CPU cephane seçimini ve yukarıdaki 7 işlevsiz ürünü açık tutun.
