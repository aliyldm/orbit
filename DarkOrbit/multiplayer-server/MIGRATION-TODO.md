# Ortak sunucuya geçiş — 25 Ekim 2026

Hedef: aynı Qt/Flash istemcisi, aynı oyun kuralları ve hesap ilerlemesiyle tek .NET/PostgreSQL/Redis sunucusuna Localer üzerinden bağlanmak. Yerel önizleme bu hedefin tamamlanmış sürümü değildir. `/ready`503 kontrolünü kapatmak çözüm değildir.

## Doğrulananlar

- Özgün native codec: 1.352 sınıf / 4.053 JS-C# sözleşmesi; çekirdek 8.148 kontrol.
- Eski parola biçimi; web/native giriş; Redis oturumu ve bağlantı sahipliği; PostgreSQL oyuncu projeksiyonu/konum kaydı.
- Ortak haritada gemi oluşturma/hareket/kaybolma; kendi hesabına yeniden giriş; başka harita ve özel örnek izolasyonu.
- 32 normal harita / 96 portal / 951 normal NPC yuvası. Tek ortak NPC durumu; seçme, hareket/devriye, hedef ayrılınca dönüş; sunucu hasar API'sinde can/kalkan, tek ölüm nesli ve süreli yeniden doğuş.
- Normal portal yakınlığı/şirket/seviye kontrolü, 2 saniyelik geçiş, doğru varış koordinatları, tekrarlı atlama/move engeli, çıkış iptali ve PG konum kaydı.
- Dünya: 405 eski harita senaryosu / 5.648 kontrol. HTTP/TCP: 7 sentetik istemci / 56 kontrol. Bunlar fiziksel iki bilgisayar veya tam savaş yük testi değildir.
- Kaynak eski oyun için 196 dosya checksum kontrolü aynı. Katalog üretimi/testler canlı SQLite'ı yazmaz.

## Ortak oyun açılmadan bitmesi gerekenler

1. **Canlı ekipman/stat depoları.** Şimdiki `NativePilot.Profile/Commands` dondurulmuş başlangıç projeksiyonudur. Gemi/iki konfigürasyon/diroit/PET/modül/arge/boost/zenginleştirme/modern lazer bonusları PG kayıtlarından aynı kurallarla hesaplanmalı. Eski proje testleri yeni motorla karşılaştırılmalı.
2. **Atomik savaş ve ekonomi.** Native lazer/RSB/roket/launcher istekleri, otomasyon, cephane düşümü, isabet/kalkan/HP, özel NPC/PET/yetenekler, oyuncu ölümü ve respawn. Hasar değerini istemci belirlemez. Ödül/cephane/loot tek işlem ve tekrar kimliğiyle kaydedilmeli; yeni map owner/yeniden başlatma çift ödül vermemeli.
3. **Kalıcı ortak dünya.** `SharedNpcs` durumu şu an bellekte. PG NPC nesli/can/respawn, kargo/ham madde/kutu toplama ve kalan ambar, Cubikon/Protegit/Battleray gibi özel kurallar, harita sahibi fencing ve servis kesintisi kurtarması eksik. Şu an 951 sayısı bağımlı eskortları içermez.
4. **Web portalı ve özellikler.** Hangar/envanter/takma/satma, dükkan, arge/üretim/geliştirme, görev/rütbe/ödüller, günlük giriş ve özgün SWF HTTP/API rotaları. Yeni hesap ve şirket seçimi de canlı PG üzerinden tamamlanmalı. `/indexInternal.es` şu an501.
5. **Galaxy Gate koşulları/dalgaları.** Kişisel/grup örnekleri, kapı açma şartları, giriş/bitiş/ödüller. Normal harita NPC kataloğu özel örneğe otomatik eklenmez; özel örneğin içeriği henüz bu motorda üretilmez.
6. **Dağıtım ve kabul.** Başlatıcının açık sunucu/istemci rolü ve güncel sanal IP ayarı, iki fiziksel bilgisayarda Localer oyun testi, pencere/Qt görsel kabulü, savaş dahil 500/1000 yük, kopma/kurtarma. Son yedek/fresh snapshot ve kontrollü geçişten sonra ready200 ve yeni ortak oyun paketi.

## Buradan devam

Önce 1 ve2: `NativePlayerRepository` canlı özellik depolarıyla genişletilecek; `MapActor.DamageNpc` native ateşe bağlanmadan önce cephane/ödül işlemleri ve özel korumalar tamamlanacak. Başlangıç paketindeki bir sayıyı değiştirerek envanter güncellenmiş sayılmaz. .NET'e geçene kadar çalışan eski Node/SQLite oyununa yazma/migration uygulanmaz. Eski snapshot canlı hesapların üstüne geri konmaz.

5-x labirenti kullanıcı isteğiyle kapalı kalır. Denge/fiyat/envanter hediyesi bu geçişin kapsamında değiştirilmez.
