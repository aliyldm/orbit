# CPU doğrulaması ve yerel uygulama — 23 Ekim 2026

**Son denetim:** [Görünmezlik ve 40 CPU sonucu](cloak-cpu-current.md). 33 işlevli ürün, diplomasi bayrağıyla sınırlı 1 ürün, desteklenmeyen 3 ürün ve sınırsız cephane nedeniyle etkisiz 3 eski kapasite ürünü. Son 7 ürünün satın alımı gerekçeli kapalıdır; sahip olunanlar silinmez. Aşağıdaki “çalışıyor” durumları kaynak/paket/izole yürütme kanıtıdır; bütün sürümlerde tam özgünlük veya canlı Flash görsel kontrolü iddiası değildir.

Kapsam: gömülü `docs/client-map.items.json` kataloğunda **34 gerçek CPUType** var. CPU adını taşıyan altı başka sınıf (üç cephanelik, kargo genişletici, tek kullanımlık gizlenme modülü ve PA-X) eklendiğinde denetlenen birleşim **40 farklı eşya kimliğidir**. Arayüzdeki `…_jp`, `…_aim`, `…_cl04k`, `…_dr` fiziksel eşya değil, bu ailelerin ortak menü kimlikleridir.

## Kanıt sınırı

`decompiled/main/scripts/net/bigpoint/darkorbit/net/SetAttributeAssembly.as:243`, `SpaceMapWindowProxy.as:105`, `AvailableJumpVO.as` ve `SpaceMapWindowMediator.as:284` gerçek eski istemcide `JCPU|GET`, `JCPU|S|map`, `JCPU|J` isteklerini ve `0|A|JCPU|I/C/S` yanıtlarını doğrular. Paket sınıfları CPUInfoHomeJump/Cloak/Aim/AutoRocket/TradeDrone, CPUInitialization ve ExtraInfo alanlarını doğrular. Cloak görseli MapEventsAssembly.as:461 içindeki `0|n|INV|user|0/1` yolunu kullanır. Bunlar statik istemci sözleşmeleridir; özgün sunucu yürütmesi gözlenmedi.

[Resmî Extras FAQ](https://board-de.darkorbit.com/threads/faq-extras.118005/) klasik şarj sayıları, SLE yuvaları, turbolar, otomatik alım eşikleri ve AIM maliyetine dayanak olur. Özet: JP 10/20, gizlenme 10/50, diroit tamir 8/32; cephane/roket/yakıt alımı 10.000/500/10.000; eşikler 1.000/100/1.000. AIM her lazer salvosunda 10 Xenomit kullanır ve MISS oranını %25/%50 azaltır. Bu, doğrudan isabete 25/50 puan eklemek değildir. Robotların tam gövde tamir süreleri 165/120/105/90 saniyedir. HM7 yüz ticaret işlemi sunar.

[Resmî Jump Chip FAQ](https://board-en.darkorbit.com/threads/jump-chip-faq.834/) gelişmiş atlama sırasında hareket yasağını, savaş sonrasında 20 saniye beklemeyi, rastgele varış konumunu ve özel harita yasağını doğrular. Fiyat grafiklerinin makine okunabilir özgün tablosu elde edilmedi. **Yerel tarife portal grafiğinde en kısa mesafe başına 100 U.**; kesin özgün fiyat değildir. [Resmî ES ekipman FAQ](https://board-es.darkorbit.com/threads/faqs-objetos-de-equipamiento-armas-generadores-y-extras.147201/) gelişmiş CPU için 10 saniye hazırlık ve 90 saniye bekleme bildirir. Bu sürümde JP ailesi de aynı 90 saniyelik kalıcı beklemeyi kullanır; JP için ortak bekleme ve hareket engeli ayrıca yerel politikadır. AJP mevcut atlayış kuponunu önce kullanır; yoksa Uridyum düşer. Kupon/para yalnız başarılı tamamlamada atomik tüketilir.

## Tam katalog matrisi

Kimliklerde aksi yazılmadıkça `equipment_extra_cpu_` öneki bulunur.

| Eşya | Durum ve sınır | Doğrulama |
|---|---|---|
| jp-01 | Çalışıyor; X-1 dönüş, alt X-1..4, 4-X/5-X/özel harita yasak, 10 şarj | CPU testleri: izin/ret, gerçek geçiş, şarj, kalıcı bekleme |
| jp-02 | Çalışıyor; normal 1..4-X haritalarından X-1 dönüş, 20 şarj; korsan/özel harita yasak | Aynı yol; ekipman ve aile şarj testi |
| ajp-01 | Çalışıyor; yerel fiyat, 10 sn hazırlık, 90 sn bekleme; özgün harita seviye koşulları | Legacy I/C/S, hareket iptali, atomik ödeme, SQL geri alma |
| cl04k-m | Çalışıyor; 10 şarj, saldırı/ölüm gizlenmeyi kaldırır; harita değişimi yeniden şarj tüketmez | INV paketi, giriş/harita/geri dönüş/yeniden giriş ve 2D/3D hazır onayı |
| cl04k-xl | Aynı aile, 50 şarj | Kapasite tablosu/ortak tüketici |
| cl04k-xs | ModuleType; tek kullanımlık; canlı alımda etkinleşir, tüketilen fiziksel modül silinir | Alım tüketicisi ve yeniden alım engelinin kalkması |
| arol-x | Çalışıyor; açıkken kendi lazer saldırısında seçilmiş roketi normal savaş yolundan atar | Saldırı/kapalı konfigürasyon testi |
| rllb-x | Çalışıyor; gerçek HST yükleme/atış; aç/kapa tercihi bağlantı ve konfigürasyon arasında kalıcı | 8 HST testi + yeniden oluşturma testi |
| alb-x | Çalışıyor; açıldığında seçilmiş lazer <1000 ise 10000 alır; dükkân fiyatı ve bakiye uygulanır | Stok, fiyat, tekrar almama |
| rb-x | Çalışıyor; seçilmiş roket <100 ise 500 alır | Tüketim, yetersiz bakiye, fiyat |
| fb-x | Çalışıyor; PET yakıtı <1000 ise 10000 alır; bakiye zorunlu | Alım ve yetersiz bakiye |
| nc-rrb-x | Çalışıyor; takılı robotu dururken ve 10 sn savaş dışında başlatır | Robotsuz ret, REP4 ve tamir oranı |
| nc-awb-x | Çalışıyor; lazer/roket için laboratuvarda seçilmiş cevheri bitince yeniler; seçim yoksa en iyi uygun cevher yerel varsayımı | Her iki buff/maden atomik; yetersiz seçilmiş cevherde başka madeni harcamaz |
| nc-awr-x | Aynı tüketici, yalnız roket | Filtre tablosu/ortak yol |
| nc-awl-x | Aynı tüketici, yalnız lazer | Cevher düşümü ve mevcut buffı koruma testi |
| nc-agb-x | Hız/kalkan; süresi dolmuş buffı en iyi uygun cevherle yeniler | Ayrı hız/kalkan filtresi; aktif süre ve atomik lab işlemi |
| rok-t01 | Çalışıyor; tekli roket bekleme x0.5, HST etkilenmez | Aktif konfigürasyon ve çarpan |
| min-t01 | Çalışıyor; mayın/SMB bekleme x0.75 | En iyi CPU çarpanı ve utility testleri |
| min-t02 | Çalışıyor; mayın/SMB bekleme x0.5; turbolar toplanmaz | Aynı test, pasif konfigürasyon |
| sle-01 | Çalışıyor; +2 extra yuva | inventory kapasite yolu |
| sle-02 | Çalışıyor; +4 extra yuva | Aynı yol |
| sle-03 | Çalışıyor; +6 extra yuva | Aynı yol |
| sle-04 | Çalışıyor; +10 extra yuva; yalnız en büyük genişletici | inventory testleri |
| dr-01 | Çalışıyor; ölümden önce >%70 hasarlı diroitlere ücretli tamir, 8 işlem | Sağlıklı ret, para/şarj/hasar SQL geri alma |
| dr-02 | Çalışıyor; sıradaki ölüm aşınması diroiti yok edecekse ücretli tamir, 32 işlem | Iris aşınma, seviye/XP, şarj ve ücret |
| aim-01 | Çalışıyor; isteğe bağlı, MISS x0.75, salvo başına 10 Xenomit | Ortak atomik kaynak/miss yolu |
| aim-02 | Çalışıyor; isteğe bağlı, MISS x0.5, salvo başına 10 Xenomit | %80→%90, yetersiz kaynak ve tüketim |
| smb-01 | Çalışıyor; özgün kaynak maliyeti/kalıcı bekleme; solo NPC alan etkisi yerel uzantı | combat-utilities.test.js |
| ish-01 | Çalışıyor; 3 sn koruma ve maliyet | combat-utilities.test.js |
| rd-x | Donanım bayrağı çalışıyor; diplomasi/klan sistemi olmadığından diplomasi görüntüsü doğrulanamaz | CPUInitialization kodlama testi |
| equipment_extra_hmd-07 | CPUType; çalışıyor; uzaktan maden satışı, 100 şarj | Native OreTradeInfo type2; para/cevher/şarj atomik geri alma |
| g3x-crgo-x | UpgradeType; aktif konfigürasyonda kargo x2 | players.computeStats yolu |
| g3x-amry-s | UpgradeType; **etkisiz**: tarihî cephane kapasite sınırlaması uygulanmıyor; yeni alım kapalı | Mevcut sınırsız mühimmat modelinde ek kapasite tüketicisi yok; para düşümü reddedilir |
| g3x-amry-m | Aynı sınır | Aynı |
| g3x-amry-l | Aynı sınır | Aynı |
| rg-sl | Çalışıyor; açıkken kendi lazer hedefinde takılı modern topu seçilmiş slug ile normal beklemesinde ateşler | Gerçek cephane tüketimi/atış paketi, bekleme ve pasif konfigürasyon |
| ags-x | Çalışıyor; açıkken kendi lazer hedefinde takılı sürüş silahını seçilmiş spool ile ateşler | Gerçek cephane tüketimi/efekt, bekleme ve pasif konfigürasyon |
| anti-z1 | **Desteklenmiyor**: bulaşıcı hastalık modeli yok, sahte iyileştirme üretilmez | Menü açıkça devre dışı |
| anti-z1-xl | Aynı sınır, katalogda 10 kullanım | Aynı |
| pa-x | ItemType; **desteklenmiyor**: efekt uygulayıcı olay sözleşmesi yok | Menü açıkça devre dışı |

Eski açıklamalardaki ticaret çarpanlarının tüm sürüm farkları, klan diplomasisi ve cephanelik kapasiteleri tam özgün eşitlik iddiası kapsamına alınmadı. Enfeksiyon/PvP sistemleri yoktur. ALB/RB bu yerel sürümde mevcut savaş cephanesini izler; özgün hangardaki bağımsız CPU cephane tercihi henüz yoktur. Modern top/sürüş işlevleri uygulanmıştır; bütün yayımlanmamış savaş formüllerinin özgünlüğü iddia edilmez.

## Kayıt ve güvenlik

`020-cpus.sql` fiziksel `item_id` için şarj tablosu ekler. İki konfigürasyonda aynı eşya aynı şarjı kullanır; bitmiş şarj açılışta yeniden dolmaz. Beklemeler ve tercihler oyuncunun settings kaydındadır. Sahiplik, aktif konfigürasyon, ölüm ve harita/seviye koşulları eylem sırasında tekrar kontrol edilir. AJP yalnız başarılı son aşamada ödeme yapar. Eski istemci kayıtlarının CPUInfo/ExtraInfo ve menü durumları gerçek donanımdan üretilir.

Son tam süit **850/850** başarılı; **307 JS/0 sözdizimi hatası**, **22.041 gerçek HTTP/TCP komutu PASS**. Yeni `cloak-map-state.test.js` ve `cpu-audit-current.test.js` harita/yeniden giriş/ready durumlarını, dört lab CPU'sunu, AIM iki varyantını, ALB/RB eşiklerini, RG/AGS gerçek silah yollarını ve 7 kapalı ürünün ödeme reddini ekler. Önceki CPU/HST/çoklu launcher/utility/envanter testleri bütün ailelerin ortak tüketicilerini kapsar. Şarj varyantları aynı uygulamayı paylaşır; 40 ayrı Flash görsel senaryosu uygulanmış değildir. Testler izole bellek DB'si kullanır; gerçek hesaba para/eşya verilmez. Günlükler son denetim raporundadır.
