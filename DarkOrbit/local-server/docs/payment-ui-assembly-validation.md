# Payment, ArGe ve oyun arayüzü — 21 Ekim 2026

Bu çalışma tek oyunculu yerel sunucu içindir. Mevcut hesaplara test eşyası, para, yakıt veya ArGe puanı verilmez.

## Kullanıcıya görünen değişiklikler

- **ArGe:** Seprom gereksinimi kaldırıldı; görüntüleme/geliştirme Skylab çağırmaz. Dal açılması özgün önkoşullardan gelir. Geliştirme kredi ve bir boş ArGe puanı tüketir. Sabit 300.000 Uridyumluk temaya uygun sıfırlama butonu dağıtılmış puanları iade eder; kazanılmış toplamı korur. Aynı fiyat sonraki sıfırlamalarda da geçerlidir.
- **PET:** mevcut sahiplerin pencere düğmesi görünür; eksik ve başka işle dolu olmayan varsayılan E/R/D kısayolları tamamlanır, açıkça kaldırılmış veya değiştirilmiş tuşlar korunur. Yakıt **Dükkân → PET Modülleri → FUEL100** özgün ürün kutusundan, diğer modüller gibi alınır. Sonradan eklenen üç sabit bağlantı kaldırıldı. Bir yakıt 0,25 U.; stok gerçek PET deposudur ve kesirli bakiye korunur. 122 kozmetik görünüm iki konfigürasyonda takılır ve gerçek model kimliğiyle gösterilir.
- **Dükkân:** gemi açıklamasındaki `</script>` dış scripti kapatamaz; taşan metin düzeltilir. Iris/Flax listesi, seçili ürün ve önizlemesi gerçek sonraki fiyatı gösterir ve satın alımda güncellenir.
- **Diroit:** harita paketinde veritabanının 0–5 seviyesi istemcinin 1–6 model seviyesine çevrilir. Önceki 0 modelinde istemci hata ayıklama varlığı 120'yi (pişmiş hindi) seçiyordu. Flax/Iris/Apis/Zeus ve tasarımlar kaynak desenleriyle denetlendi. Satın alınmış dizilimler gerçek menüde görünür; kullanımda dört diroit koşulu korunur.
- **Galaksi kapıları:** on giriş kendi özgün varlığını kullanır; çıkış standart portalıdır. 2D/3D dosyalarının diskte bulunduğu denetlendi.
- **Birleştir:** native pencerenin kurulum paketi envanterden önce gönderilir; istemcinin Inventory/Discount proxy bağımlılığı karşılanır. Üretim, geliştirme ve söküm sunucuya ve gerçek envantere bağlıdır. Ek web atölyesi oyun içi pencerenin yerine geçmez.

## İçerik kapsamı ve sınırları

196 Payment teklifinin fiyatı 1.000.000 U.; **173 tam içerik manifestinden 162 teklif satın alınabilir**. 23 eksik içerikli ve 11 işlevsiz bileşen içeren paket gerekçeli kapalıdır. Tekrarlanabilir paketlerde özgün miktar seçicisi gerçek tüm içerik ve bedeli çoğaltır; benzersiz ürünler tek adet kalır. Beş Stellar2019 paketi hesap başına tek alım kuralını kullanır. İşlem hatasında para ve bütün teslimler birlikte geri alınır. 523 teklif/alias sınıflandırması, kısmen çalışan ürünler ve engellenen ürünler `shop-product-audit.md` raporundadır.

Modern lazerler, cannon/drive/lens/refraktör, AGS-X/RG-SL, SR-5/K-300M ve PLD/DCR için gerçek tüketiciler bağlandı. Özel lazer cephanelerinin hatalı ×1 çarpanları kaynak tablolara göre düzeltildi. 9 teknoloji stok, süre, bekleme ve savaş etkisiyle çalışır. 6 teknoloji ve henüz uygulanmamış modern gemi yetenekleri etkinmiş gibi gösterilmez.

Montajda 638 normal tarif, 15 geliştirme sınıfı ve 8 söküm sınıfı gerçek üretim/teslimle test edildi. **11 tarif** eksik katalog, çok oyunculu CBS veya desteklenmeyen çıktı nedeniyle kapalıdır. 519 zamanlanmış tarif yerel ayarla sürekli açıktır; plan sahipliği koşulları korunur. Her canlı etkinlik ve takvim yeniden yapılmış değildir.

Gold/Extra bileti açıkça yerel 90 seviyelik sezonu etkinleştirir. Trinity/Voyagers ödülleri resmî tablolardan alınır; ilerleme klasik GG üzerinden yerel uyarlamadır. Özgün etkinlik haritaları, girişleri ve bütün özel ayrıcalıkları tamamlanmış sayılmaz. Bazı modern savaş formülleri ve görselleri kaynakta olmadığı için belgeli yerel tercihler kullanır.

## Kanıt ve doğrulama

Alt sistem belgeleri: `skill-tree-unlock-fix.md`, `payment-cosmetics-boosters.md`, `portal-shop-fixes-2026-10-21.md`, `drone-menu-validation.md`, `modern-equipment-local.md`, `techs-local.md`, `payment-events-local.md`, `assembly-gate-portals-validation.md`, `payment-contents-evidence.md`.

Paketlerin codec ile doğrulanması, bütün Flash arayüzünün canlı olarak görüntülendiği anlamına gelmez; native kurulum sırası ayrıca istemci kaynak sözleşmesiyle sınanır.

## Son dağıtım

Bu bölüm önceki dağıtım kaydıdır. **Güncel kısayol/diroit/hangar/PET doğrulaması ve sunucu bilgisi:** `hotkeys-hangars-pet-validation.md`.

- **592/592 test geçti**, sıfır başarısız/atlanmış. `logs/payment-expanded-suite.log`.
- **213 JavaScript dosyası**, sözdizimi hatası 0.
- Gerçek HTTP/TCP testinde **15.135 komut** çözüldü. İlk native tarif paketinin ilk UserInventory paketinden önce geldiği; HTTP ve native üretim/teslim, gerçek eşya geliştirme, Payment/dizilim/modern silah/PET/bilet akışları doğrulandı. `logs/payment-expanded-network.log`.
- SQLite online yedeği: `backups/darkorbit-before-2026-10-21T04-56-49-829Z.db`. Ayrı yükseltme kopyasında iki hesap/oyuncu, altı gemi ve **38 sahiplik/ilerleme tablosunun bütün eski satırları** korundu. Kontrol aracı yeni sezon/ödeme/üretim defterlerini de otomatik kapsar.
- Sunucu **PID2792**, HTTP8095/TCP8096, solo, migration023; health/integrity ok, FK ihlali0. `logs/payment-expanded-production-check.json`. Test hesapları sadece bellek içi sunucudadır.
- Native Birleştir düzeltmesi için eski istemci oturumundan tamamen çıkıp yeniden giriş gerekir. Açık kalan pencere eski oluşturulmamış proxy durumunu koruyabilir.
