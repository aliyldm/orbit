# Küçük envanter, RSB dönüşü, Protegit saatleri ve 2D ölçek — 25 Ekim 2026

Dağıtıldı: PID20264, solo HTTP8095/TCP8096, health OK. Güncel kanıt: `logs/compact-rsb-production-check.json`. Eski PID28700 bu devam turunda zaten çalışmıyordu; zorla kapatma yapılmadı. İlk bağımsız ağ testi sohbet kesintisinde sonuca ulaşmadığı için tekrarlandı; son çalıştırma geçti.

## Küçük envanter / LF-5

Kullanıcı netleştirmesi: envanter tamamen boş değil, **Gemi** sekmesinde bazı ürünler eksik. Salt okunur gerçek hesap incelemesinde asd'de26, test'te37 tamamen boşta LF-5-MF vardı; miktarları1 ve API grup0/EB[SHIP,PET,DRONE] doğru. Bunların kaybolduğu veya başka gemiye takılı olduğu varsayılmadı; hiçbir eşya eklenmedi/silinmedi. Önceki uppercase EB düzeltmesi korundu.

Kurulu inventory SWF'den beş sınıf tekrar çıkarıldı. Kompakt filtre, ikonun eski `equippedInConfigs` işareti yerine mevcut ItemInstanceVO konfigürasyonunu kullanır. Önce gruba uyan tüm ikonları alır, sonra güncel takılılık, hangar ve SHIP/DRONE/PET uyumluluğunu kontrol eder. Kaydırma boyu, gizli öğeleri içeren tüm grid yüksekliğinden son görünür öğenin altına alındı; bağlam değişiminde konum sıfırlanır. Geniş kullanıcı filtresi ve diğer hangarda takılı eşya koruması devam eder. Gemiye takılamayan ham madde/cephane gibi ürünlerin Gemi kompakt bağlamında süzülmesi özgün davranıştır.

İki sınıf derlendi ve tekrar çıkarıldı; bütün kod dışı SWF etiketleri ve önceki diroit toplu sürükleme sınıfı aynı. Native Flash fare hareketi/görsel kabul yapılmadı; gerçek kullanıcı oturumundaki eski ikon durumunun kaydı yok. Bu nedenle üretimde gözlenen her eksik ürünün tek kök nedeninin kanıtlandığı iddia edilmez.

Yeni inventory SHA256: `3c4bfab12fbbaddd7a224ccfbf4526a362671139dbc910c0263d6b2920973853`; portal önbellek anahtarı `20261025compact`. Mevcut LF5'in gemi, diroit ve PET'e takılması iki konfigürasyonda testli; satın alma yasağı ekipmana taşınmadı. Gerçek HTTP taşımalarında da LF5 ve kapasite aşan kuyruk kullanıldı.

## RSB tek salvo / önceki lazere dönüş

Kullanıcının isteğiyle son RSB dışı lazer seçimi tutulur. Başarılı salvo tüketim/hasar/efekt işlemi tamamlandığında, isabetsiz atış dahil, önceki cephaneye döner ve normal saniyelik atış devam eder. Örnek: x4 → RSB → x4. Menüde seçili cephane de güncellenir. Önceki seçim yoksa LCB kullanılır; RSB bittiyse önceki cephaneye dönülür, onun da yetersizliğinde mevcut otomasyon tercihi uygulanır.

RSB'nin bağımsız3 saniye beklemesi korunur. Bekleme sırasında yeniden seçilmesi ek RSB atışı üretmez; normal lazer devam eder. İsabetsiz RSB de cephane/bekleme harcar. Bu kullanıcı talebiyle eklenen otomatik dönüş özelliğidir; özgün sunucunun varsayılan davranışı diye sunulmaz.

## Protegit bağımsız atış saatleri

Cubikon muhafızları ortak1 saniyelik NPC AI turunda ateşlemiyor. Çıkıştan sonra başlangıç fazları dağıtılmış bağımsız saatlerle, her biri en erken1 saniye arayla ateşler. AI hareket/güvenlik kontrolleri sürer. Hedef kaybı, jump, ölüm, menzil dışı, muhafız/anne ölümü ve sunucu harita temizliğiyle atışlar güvenli biçimde durur. Gecikmede kaçırılan salvolar toplu telafi edilmez; gecikmiş atıştan sonra1 saniyeden kısa atış engellenir.

Hasar, sayılar ve yörünge ayarları değiştirilmedi. Başlangıçta rastgele faz dağılımı yerel bir politikadır; özgün RNG formülü doğrulanmadı. Dokuz muhafız testi geçti; yirmi muhafızın farklı fazları ve yinelenen AI turunda çift atış olmaması sahte saatle doğrulandı.

## 2D gemi görünümü

MapView2D'nin ilk zoom'u yerel `%70` sınırından native1× değerine alındı. Pencere boyutu değişince kullanıcının kendi zoom'u korunur. Yalnız bu başlangıç ataması değişti; stage60FPS, ShipClip yön çizimi, Ship2D ve MoveTrait native kaynakla aynı. Pusat Plus varlığının32 yön karesi dışa aktarılabildi; incelenen1/9/17 yönlerinde eksik görüntü görülmedi. SWF'nin24 başlık FPS'si, gotoAndStop ile yön seçen geminin sahne hareket hızının24FPS olduğu anlamına gelmez.

Yeni MAIN SHA256: `6839384bca951b7d7ece2081c4054cbac4748b1beb2e985da5e995e0afcc95e7`, gameclientHash `local-20261025-compact-rsb-2d`.256 kod dışı etiket aynı, bir ABC değişti. **Gerçek Qt frame-time/FPS kaydı yok; FPS artışı veya tüm görüntü şikâyetinin çözüldüğü iddia edilmez.** Kullanıcı gerçek oyunda değerlendirmeli.

## Doğrulama ve veriler

- 1052/1052 test,379 JavaScript dosyası/0 sözdizimi hatası.
- Gerçek bağımsız HTTP/TCP:24159 çözümlenen komut; native hedef seçimi + x4 + RSB actionType1 + otomatik x4 efekt/menü doğrulandı.
- Yedek: `backups/darkorbit-before-2026-10-25T07-31-39-339Z.db` (SQLite online backup, WAL dahil).
- Üretim açılışından sonra60 tablonun bütün şema/satırları bu taze yedekle aynı:3 hesap,3 oyuncu,14 gemi, integrity OK/FK0.
- `logs/compact-rsb-full-tests.log`, `logs/compact-rsb-source.log`, `logs/compact-rsb-network-final.out.log`, `logs/compact-rsb-database.log`.

Oyunu tamamen kapatıp aç ve hangarı yeniden yükle. Hiçbir cüzdan/ödül/envanter hediyesi tekrarlanmadı. Önceki lazer ses/animasyon zinciri, footer düzeni ve LF4 sonrası yalnız satın alma kilidi korunur.
