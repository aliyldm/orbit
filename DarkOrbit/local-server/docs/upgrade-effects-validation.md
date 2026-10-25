# Geliştirme bonusları: gerçek istatistik ve savaş doğrulaması

22 Ekim 2026. Üretim maliyetleri kullanıcının Upgrade Module/Convert Module kuralıdır; aşağıdaki bonuslar maliyetlerden bağımsızdır.

LF-3 ve diğer 16 seviyeli lazerler: her adım +%0,5; 1→16 toplam +%7,5. LF-4 ve 20 seviyeli lazerler: 1→20 toplam +%9,5. Kalkan jeneratörleri: her adım +%1, 16'da +%15, 20'de +%19. HST-1: 16'da +%7,5; HST-2: 20'de +%9,5. Bunlar yalnız geliştirilen eşyanın değerine uygulanır; tüm gemi hasarına eklenen genel bonus değildir.

Lazerlerin eski %0,4/%0,2 oranları kullanılmıyor: [2019 resmî sistem değişikliği](https://board-en.darkorbit.com/threads/new-assembly-upgrading-system-faq.124627/) tüm lazerler için adım başına %0,5 tanımlar. [2026 resmî geliştirme tabloları](https://board-de.darkorbit.com/threads/faq-montagewerk-stand-mai-2026.123239/) 16 ve 20 seviye sınırlarını ve kalkan oranlarını doğrular. Captured `UpgradableTrait`/`ItemDataProvider` verileri normal lazer, kalkan ve HST için bu oranlarla uyumludur.

HST bonusunun gerçek atışta kullanılmadığı hata düzeltildi: aktif konfigürasyonda seçilen roketatarın geliştirme çarpanı hasara ve SAR kalkan emilimine eklenir. Cephane adedi, 3/5 yük kapasitesi, bekleme ve gecikmeli çarpma akışı korunur. Normal tekli roketler bu HST bonusunu almaz.

Diroitlerin savaşla büyümesi (1–6) ile eşya geliştirmesi (1–16) ayrıdır. [Resmî diroit FAQ](https://board-de.darkorbit.com/threads/faq-drohnen.2892/) büyüme seviyesinde 6'ya ulaşınca takılı lazerlere +%10, takılı kalkanlara +%20 verir. Yerel uygulama bunları doğru uygular. Diroit geliştirmesi yalnız o diroit üzerindeki eşyalara eklenir; gemi ve P.E.T. yuvalarına taşmaz. Eşyanın kendi geliştirmesi bu güçlendirilmiş değer üzerinde ayrıca uygulanır.

Sürüm uyuşmazlığı: captured `ItemDataProvider` diroit büyüme seviyesi 1 için lazer adımını %0,5, büyüme 2–6 için Iris/Apis/Zeus'ta %0,4 ve Flax'ta %0,2 tanımlar. `game/data/drone-patterns.json` bu tier verisini aynen korur. Böylece büyüme6/geliştirme16 Iris mevcut istemciyle +%6 lazer/+%15 kalkan; Flax +%3 lazer/+%6 kalkan verir. Buna karşılık 2026 resmî tablo tüm büyüme seviyeleri için Iris ve Flax lazerine toplam +%7,5 gösterir. Bu fark sessizce orijinalle birebir diye sunulmaz.

P.E.T. üzerindeki lazer/kalkan geliştirmeleri P.E.T. istatistiklerine uygulanır; oyuncunun hasar/kalkanına eklenmez. İleri kanon/itki silahlarının mevcut geliştirme hesabı da shared `modern-lasers.upgraded` yolundan çalışır. Havoc/Hercules/Spartan tam set etkileri bu doğrulamanın dışında, ayrı eksiktir.

`tests/upgrade-effects.test.js` gerçek build→collect ile LF-3/LF-4, kalkan, diroit ve P.E.T. değerlerini kontrol eder. `tests/hellstorm.test.js` gerçek geliştirilmiş HST ile gecikmeli ECO hasarı ve SAR emilimini doğrular. Assembly ve modern ekipman kontrolleriyle genişletilen koşu 60/60 geçti: `logs/upgrade-effects-validation.log`.
