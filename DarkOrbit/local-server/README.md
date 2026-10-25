# DarkOrbit Local

Güncelleme: 23 Ekim 2026. Mevcut Flash istemcisine bağlanan, SQLite kullanan tek oyunculu yerel sunucu. Canlı oyunun bütün içerikleri henüz uygulanmış değildir. [Son değişiklikler,855 test ve 2D/kalite denetimi](docs/classic-2d-current.md); [önceki ana kapsam ve kalan işler](docs/second-completion-work.md).

## Başlatma

Node.js 26 veya üstü gerekir; ayrıca npm paketi kurmak gerekmez.

1. Proje kökündeki **Sunucuyu Baslat.lnk** veya **Sunucuyu Baslat.cmd** dosyasını açın.
2. `DarkOrbit/DarkOrbit.exe` dosyasını açın. Portal: `http://127.0.0.1:8095`.
3. Kullanıcı adı ve şifreyle giriş yapın. Hesap yoksa oluşturulur; ilk girişte şirket seçilir.
4. Portalın **BAŞLA** düğmesi oyunu açar.

Terminalden bu klasörde `node server.js` de kullanılabilir. HTTP 8095, oyun TCP 8096 portundadır. Aynı yerel sunucu zaten açıksa ikinci başlatma bunu bildirir. Konsolda Ctrl+C, oyuncuyu kaydedip sunucuyu kapatır. Canlıya bağlanan `DarkOrbit_live.exe`, yerel istemci değildir.

## Kullanım

- **2D:** Ayarlardan 2D'yi seçip çıkış sayacının bitmesini bekleyin. Kaydedilen mod değişmişse oyun sayfası yeniden yüklenir. En düşük gemi kalitesinde istemci düz yedek görsel kullanır; açılı sprite için gemi kalitesini yükseltin. [Kaynak kanıtı](docs/classic-2d-evidence.md).
- **Ekipman:** Hangardaki iki konfigürasyon, gemi/diroit/PET ekipmanı ve sürükle-bırak gerçek sahiplik kayıtlarıyla çalışır. Oyun içindeki alt kısayol çubukları da oyuncuya özel kaydedilir.
- **Geliştirme:** Oyun içi **Birleştir → Geliştirme** sekmesi gerçek uygun eşyaları gösterir; satın alma sonrası liste yenilenir. Azami seviye eşyanın tarifine bağlıdır; klasik ekipman 1–16'dır. **Dağıtma**, uygun yükseltilmiş ve takılı olmayan eşyaları kullanır. Stabilize/Hiper Ocak henüz uygulanmamıştır. [Sekme kapsamı](docs/assembly-native-tabs.md).
- **Kısayollar:** C iki konfigürasyonu değiştirir. M başka eyleme atanmamışsa Yıldız Sistemi'ni açıp kapatır.
- **Seprom:** Dükkân → Ekstralar, 1 U./adet. Cevher stokuna teslim edilir; zenginleştirme için Skylab gerekmez. ArGe sıfırlama 300.000 U.; ArGe'de Seprom tüketilmez.
- **Hangar genişletme:** Üstteki hangar oku → `+`; her ek boş hangar 250.000 U. Mevcut gemi atamak/değiştirmek için önce oyundan çıkılır.
- **Diroit:** Flax/Iris fiyatı sahip olunan aynı türün sayısıyla artar; normal toplam sınır sekizdir. Altı deneyim seviyesi, deneyimden ayrı ücretli geliştirme ve ölüm hasarı bulunur.
- **Kalın lazer:** ArGe'de ilgili iki becerinin seviyeleri kontrol edilir; yalnız toplam puanın 23 olması koşulu kullanılmaz. [Envanter ve ArGe](docs/inventory-local.md).
- **Lazer çıkışları:** Gemide iki veya daha fazla lazer takılıysa geminin kendi çok namlulu deseni seçilir; ekipman/konfigürasyon değişiminde anında güncellenir. [Gemiye özel çıkışlar ve mevcut hasar RNG'si](docs/laser-visuals-local.md).
- **ArGe kalkan görselleri:** Kalkan enerjisi 5/5 baloncuk, Kalkan sıklığı 5/5 özel vuruş efekti açar. Kalkan boşalınca kapanır; yeniden dolunca geri gelir. [İstemci kaynakları ve kapsam](docs/shield-visuals-local.md).
- **ArGe roket görselleri:** Roket uzmanı 5/5 mor iz açar. Isı arayıcısı, becerinin kurtardığı isabette kırmızı ışık açar; temel isabet %100 ise böyle bir atış oluşmaz. [Koşullar ve istemci kaynakları](docs/rocket-visuals-local.md).
- **Galaksi kapıları:** Rastgele üretim, kopya parça çarpanı ve seçildiğinde bir sonraki enerjide çarpanı harcama uygulanır. 27 ödül paketi, istemcinin tanıdığı dokuz gerçek türü içerir; bunlar 27 ayrı eşya türü değildir.
- **Görev/PET:** Görev merkezinde 53 solo görev (33 kaynaklı NYX yeniden kurulumu dahil); PET modül/protokolleri dükkanın kendi sekmelerinden alınıp hangardaki P.E.T. bölümüne takılır. Kademe 2 için PET 4, kademe 3 için PET 8 gerekir. [Görev kapsamı](docs/quests-local.md), [PET kullanımı](docs/pet-local.md).
- **CPU:** JP ile ana üs dönüşü; AJP ile uzay haritasından hedef seçimi ve 10 saniyelik atlama; otomatik cephane/yakıt/roket/HST, AIM, gizlenme, robot/lab/diroit tamiri ve HM7 uzaktan satış. Şarj/tercih/bekleme kalıcıdır. [40 eşyalık tam durum matrisi ve sınırlar](docs/cpu-local.md).
- **NanoHull:** GG üreticisinden kazanılır; gemiye kalıcı bağlı ayrı havuz, kalkan payından sonra normal canın önünde tüketilir. Tamir/HP bonusları havuzu doldurmaz. [Kaynak ve yerel miktarlar](docs/nano-hull-local.md).
- **Payment:** 196 teklifin fiyatı **1.000.000 Uridyum**. 162 teklif satın alınabilir; 23 eksik manifest ve 11 işlevsiz bileşenli teklif gerekçeli kapalıdır. Uygun paketler çoklu alınabilir. [Teklif durumu](docs/payment-local.md).

## Uygulanan kapsam

| Sistem | Yerel davranış ve ayrıntı |
|---|---|
| Hesap/DB | Şifreli hesap doğrulama, süreli web/oyun oturumu, oyuncu sahipliği, SQLite migration ve transaction'ları |
| Dükkan/hangar | Gerçek ürün kimlikleri, kredi/Uridyum alışverişi, stok/bakiye, iki konfigürasyon, gemi/diroit ekipmanı; [envanter](docs/inventory-local.md) |
| Harita/savaş | Hareket, hedef, lazer/SAB/RSB, roket, NPC ödülü, kargo/cevher, satış, kapı geçişi, ölüm/tamir; [oyun döngüsü](docs/gameplay-local.md) |
| Klasik dünya | 32 harita/96 portal, 45 NPC tür anahtarı, haritaya özel normal/Boss/Uber/korsan nüfusu, Cubikon/Battleray muhafızları, üst üsler, Palladium takası; [kapsam ve kaynaklar](docs/normal-world-local.md) |
| Kargo/kutu ödülleri | Kaynaklı normal/özel kapı NPC kargoları, Xenomit kapasite istisnası, normal bonus çeşitleri/4-x miktarları; dört renk anahtarlı korsan kutusu, atomik teslim; [doğrulama ve yerel RNG sınırları](docs/loot-reward-audit.md) |
| Korsan özel saldırıları | Temel Saboteur yavaşlatması ve EMP temizliği, kalıcı fitilli Barracuda patlaması, gecikmeli Annihilator Hellstorm; [kaynaklar ve yerel denge](docs/npc-special-attacks-local.md) |
| Roketatar/araçlar | HST, otomatik CPU, uçuşta bekleyen roket hasarı, mayın/EMP/akıllı bomba/insta kalkan; [HST](docs/hellstorm-local.md), [uçuş](docs/projectiles-local.md), [araçlar](docs/combat-utilities-local.md) |
| Gemi yetenekleri | Altı klasik geminin yeteneği, gerçek efekt/menü, sahiplik ve kalıcı bekleme; [yetenekler](docs/ship-abilities-local.md) |
| CPU / savaş dengesi | 34 CPU ve6 ilişkili eşya denetimi; klasik CPU tüketicileri, atomik para/şarj, kalıcı tercihler. Lazer%75–100 aralığı, LF4 kaynaklı%80 salvo tabanı ve doğrulanmış altı yetenek süresi; [savaş kaynakları ve bilinmeyenler](docs/combat-balance-audit.md) |
| NanoHull / Payment | Gemide kalıcı NanoHull ve GG kategori4%; Payment196teklif sabit1mUridyum;145teslim/51gerekçeli kapalı |
| ArGe/diroit | Beceri önkoşulları/maliyeti/sıfırlama, savaş etkileri, deneyim, formasyon, tasarım, tamir |
| PET | Kademe fiyatı/sahiplik, iki ekipman konfigürasyonu, 10 protokol, dakika yakıtı/XP, toplama, koruma, bulucular, ticaret, tamir ve kamikaze; [yerel politika sınırları](docs/pet-local.md) |
| Görev/kapı | 20 görev, mantıksal NPC/harita/sıra koşulları, sabitlenmiş kabul ve tekil atomik ödül; [görevler](docs/quests-local.md). Kapı üretimi/parça/çarpan; on kapıda kaynak FAQ dalga içerikleri, kalıcı can/ilerleme ve koşu anlık kaydı; [kapı içeriği](docs/gate-content.md) |
| Skylab/Montaj | Çevrimdışı üretim, modül geliştirme, taşıma, cevher güçlendirmesi, gerçek tarifler ve süreli geliştirme işleri; [Skylab](docs/skylab-local.md) |
| Destek | Süreli destek satın alımı, gerçek stat/ödül etkileri ve bitişi; [destekler](docs/boosters-local.md) |

## Açık kalan işler

- Çalışma modeli **solo**: tek aktif oyuncu oturumu. Çok oyunculu/PvP, yerel sohbet, tam klan ve açık artırma ekonomisi yoktur. Kaydedilmiş portal sayfasının bulunması o sistemin sunucusunun uygulandığı anlamına gelmez.
- Klasik normal dünya bağlantıları ve NPC üyeliği kaynaklara bağlandı; nüfus adetleri/süreleri ve yakalanmamış dünya koordinatları yerel ayardır. Bütün modern NPC'ler ve özel saldırı AI'ları, Kronos ve Hades grup kuralları tamamlanmamıştır. [Normal dünya sınırları](docs/normal-world-local.md).
- Bütün özgün görev kataloğu ve gelişmiş grup/zamanlı/PvP koşulları yoktur; 12 ek görev açıkça yerel etiketlidir. PET ısı/tasarım, modern özel modüller, seviye 16–20 ve ücretli slot takvimi yoktur. Kamikaze düşüş eğrisi ve kombo kalkan takvimi yerel yaklaşımdır. Güncel etkinlikler, sefer, Trinity/Voyagers, etkinlik sıralaması ve mini istemci ödülü uygulanmamıştır.
- Canlı sunucuya ait olup istemciden çıkarılamayan denge, RNG ve süreler ilgili belgelerde **yerel politika** olarak işaretlenir.
- Modern top/sürüş/veba/PA-X CPU tüketicileri, tarihî cephanelik kapasite sınırı, diplomasi/klan ve AJP kupon ödemesi yoktur. AJP tarife ve JP ailesinin ortak90sn beklemesi yerel politikadır. Genel NPC/roket/HST temel isabetleri kaynakla kesinleşmedi; ayarlanabilir yerel varsayımlar korunur. NanoHull2000dolum ve dolu-havuz cephane fallback'i yereldir.
- Eski korsan kutularının tam ödül oranları/çeşitleri, Hades/Kuiper kesin şansları ve bazı ölçekli kapı NPC kargoları doğrulanmamıştır. Renkli kutu etkinlikleri yerelde sürekli açıktır; eski snapshot'ı bulunan kapıların ödülleri değiştirilmez. Apis/Zeus parçasından diroit üretimi, otomatik yeşil anahtar alımı ve Kronos'un kurulup oynanması açık eksiktir. [Ayrıntılı ödül denetimi](docs/loot-reward-audit.md).
- Otomatik paket/DB/HTTP/TCP kontrolleri, Flash arayüzünün her özelliğini görsel olarak oynayıp doğrulamakla eşdeğer değildir.

## Dosyalar ve bakım

- `server.js`, `config.json`: başlatma, portlar ve yerel ayarlar.
- `game/`: oyun mantığı, istemciden çıkarılmış codec, katalog ve migration'lar.
- `web/`: giriş/portal, hangar/dükkan/geliştirme API'leri.
- `data/darkorbit.db`: hesaplar ve ilerleme. Çalışan DB'yi sıradan dosya kopyasıyla yedeklemek WAL'daki son yazıları atlayabilir.
- `client/`: yerel SWF/görsel/ses önbelleği. Dört manifestteki 17.299 dolu kaynak yereldedir; bir boş girdi ayrı raporlanır. Bu sayı bütün olası portal/dinamik CDN dosyalarının eksiksiz olduğu anlamına gelmez.
- `decompiled/`, `docs/`, `logs/`: kaynak çıktıları, kanıtlar ve kayıtlar. Eski analizler tarihsel olarak korunur; güncel kapsam bu dosya ve alt sistem belgeleridir.

| Komut | Kontrol |
|---|---|
| `npm test` | Bellek DB'sinde birim/entegrasyon testleri |
| `npm run test:e2e` | Geçici portlarda ve bellek DB'sinde gerçek HTTP/TCP akışı |
| `npm run check` | JavaScript sözdizimi |
| `npm run check:client` | Launcher/Flash yamalarının beklenen dosya ve baytlarla karşılaştırılması |
| `npm run check:db` | SQLite yedeği; ayrı kopyada migration, bütünlük ve sahiplik kontrolü |
| `npm run audit` | Kayıtlı komutlar ile gözlenen istemci isteklerinin kapsam farkı |
| `npm run audit:assets` | Manifest kaynaklarının önbellek denetimi |

`tools/grant.js` ve `tools/delete-account.js` gerçek kullanıcı verisini değiştirir. `tools/repair-drone-purchases.js` yalnız kanıtlanmış eski Iris hatası için tek seferlik onarımdır; varsayılanı değişiklik yapmadan önizlemedir. Yeniden çalıştırılması iki Iris'i tekrar vermez.

Launcher yama adresleri ve orijinal dosya kimlikleri [REA analizinde](docs/rea-analysis.md) bulunur. Orijinaller `DarkOrbit.exe.orig` ve `HCSFP32.dll.orig` olarak korunur.

21 Ekim 2026 güncellemesi: ArGe Seprom gereksinimi kaldırıldı, Skylab bağımlılığı yok. PET yakıtı Dükkân → PET Modülleri veya PET Yakıtı bağlantısında; E aç/kapat. Diroit model seviyeleri/dizilimler, ürün metinleri/fiyatları, on GG görseli ve Montaj Atölyesi düzeltildi. Payment173/196 teklif açık;23 içerik doğrulanamadığından kapalı. Güncel kapsam ve sınırlar: [toplu doğrulama](docs/payment-ui-assembly-validation.md).
