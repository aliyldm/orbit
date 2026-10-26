# Ortak sunucuya geçiş — 26 Ekim 2026

Hedef: aynı Qt/Flash istemcisi, aynı oyun kuralları ve hesap ilerlemesiyle tek .NET/PostgreSQL/Redis sunucusuna Localer üzerinden bağlanmak. Yerel önizleme bu hedefin tamamlanmış sürümü değildir. `/ready`503 kontrolünü kapatmak çözüm değildir.

## Doğrulananlar

- Özgün native codec: 1.352 sınıf / 4.053 JS-C# sözleşmesi; çekirdek 8.148 kontrol.
- Eski parola biçimi; web/native giriş; Redis oturumu ve bağlantı sahipliği; PostgreSQL oyuncu projeksiyonu/konum kaydı.
- Ortak haritada gemi oluşturma/hareket/kaybolma; kendi hesabına yeniden giriş; başka harita ve özel örnek izolasyonu.
- 32 normal harita / 96 portal / 951 normal NPC yuvası. Tek ortak NPC durumu; seçme, hareket/devriye, hedef ayrılınca dönüş; sunucu hasar API'sinde can/kalkan, tek ölüm nesli ve süreli yeniden doğuş.
- Normal portal yakınlığı/şirket/seviye kontrolü, 2 saniyelik geçiş, doğru varış koordinatları, tekrarlı atlama/move engeli, çıkış iptali ve PG konum kaydı.
- Dünya: 405 eski harita senaryosu / 5.648 kontrol. HTTP/TCP: 9 sentetik istemci / 64 kontrol. Klasik formül:75 senaryo/302 kontrol. Atomik PG savaş/ödül/kurtarma:25 kontrol. Bunlar fiziksel iki bilgisayar veya tam savaş yük testi değildir.
- Kalıcı normal NPC checkpoint'i, cephane düşümü ve tek ölüm ödülü aynı PG işleminde; geç hata/replay/yeniden açma denetimi. Klasik outgoing ateş/RSB dönüşü native'e bağlı. Süreli sunucu sahibi ve bağlantı nesli eski yazarı reddeder. Gövde ve canlı EP/şeref booster ödülü çalışır.
- Kaynak eski oyun için 196 dosya checksum kontrolü aynı. Katalog üretimi/testler canlı SQLite'ı yazmaz.
- Canlı kahraman ekipman/bonus hesabı: 91 gövde / 364 eski JS senaryosu / 48.778 alan karşılaştırması. PG envanter43, TCP/HTTP ekipman16, hangar/P.E.T. ekipman17 ve savaş27 kontrol. Süreli bonusun bitişi, no-heal yenileme, konfigürasyon kalkan havuzları, satış, düzen kaydet/yükle ve offline aktarım kapsandı. [Detay ve kesin devam noktası](docs/EQUIPMENT-PORT.md).

## Ortak oyun açılmadan bitmesi gerekenler

1. **Canlı ekipman/stat depoları — sürüyor.** Kahraman hesabı ve 12 Flash mutation işlemi canlı PG'ye bağlı. Native/Flash liste-detay/uyumlu gemi projeksiyonları, gerçek küçük/geniş envanter yenilemesi, diroit tamir/satış ve başlık hangarları tamamlanmalı. Diğer özelliklere ait açılış mesajlarının bir kısmı hâlâ uyumluluk projeksiyonudur. P.E.T. ekipman yerleşimi canlı, çalışma zamanı bonusları/menüsü sonraki P.E.T. maddesinde.
2. **Savaşın kalan kapsamı.** İlk sıradaki ekipman okuma/arayüz döngüsünden sonra NPC karşı ateşi, oyuncu can/kalkan kaydı, ölüm ve ücretli doğuş. Klasik outgoing hasar/RSB canlı ekipman istatistiğini kullanır; modül EP/şeref seviye sınırı ödülde doğrulanır. Modern proc/SAB/drain/roket/launcher/otomasyon, tam CPU/yetenek etkileri ve PET eksik. Özgün ilk saldıran/claim/grup katkısı kuralları da tamamlanmalı.
3. **Ortak dünyanın kalan kapsamı.** PG normal NPC can/nesil/respawn/rota checkpoint'i ve sunucu bazında owner fencing vardır. Kargo/ham madde/kutu toplama, ambar, özel NPC/eskortlar, özgün drop sahipliği ve harita başına dağıtım eksik. Eski per-player `normal_spawn_state` kayıtları son geçişte tek ortak dünyayla uzlaştırılmalı. 951 sayısı bağımlı eskortları içermez.
4. **Web portalı ve özellikler.** Envanterin 12 yazma işlemi vardır; tam hangar okumaları, dükkan, arge/üretim/geliştirme, görev/rütbe/ödüller, günlük giriş ve özgün SWF HTTP/API rotaları port bekler. Yeni hesap ve şirket seçimi de canlı PG üzerinden tamamlanmalı. `/indexInternal.es` şu an501.
5. **Galaxy Gate koşulları/dalgaları.** Kişisel/grup örnekleri, kapı açma şartları, giriş/bitiş/ödüller. Normal harita NPC kataloğu özel örneğe otomatik eklenmez; özel örneğin içeriği henüz bu motorda üretilmez.
6. **Dağıtım ve kabul.** Başlatıcının açık sunucu/istemci rolü ve güncel sanal IP ayarı, iki fiziksel bilgisayarda Localer oyun testi, pencere/Qt görsel kabulü, savaş dahil 500/1000 yük, kopma/kurtarma. Son yedek/fresh snapshot ve kontrollü geçişten sonra ready200 ve yeni ortak oyun paketi.

## Buradan devam

Önce `docs/EQUIPMENT-PORT.md` içindeki kalan okuma/arayüz maddeleri; sonra NPC karşı ateşi/ölüm/respawn. `NativePlayerRepository` artık canlı ekipman deposunu kullanıyor. Klasik `MapActor.AttackNpc` atomik PG işleminden geçer; `DamageNpc` kalıcı haritalarda ödeme atlamasına izin vermez. Kaynak kapsamının tamamı [LEGACY-PARITY.md](LEGACY-PARITY.md) ve `legacy-parity-report.json` içinde izlenir. .NET'e geçene kadar çalışan eski Node/SQLite oyununa yazma/migration uygulanmaz. Eski snapshot canlı hesapların üstüne geri konmaz.

Kabul edilen ayrıntılı sıra: **envanter/bonus → NPC karşı ateşi/ölüm → portal/kayıt/başlangıç → kargo/maden/toplama/ticaret → lazer/roket/CPU → P.E.T. → yetenek/arge/teknoloji → dükkan/üretim/upgrade → Galaxy Gate → PvP/grup/claim → görev/rütbe/etkinlik/ayarlar → Localer kabul/yük/son geçiş**. İlk madde bitmeden sonraki madde tamamlanmış sayılmaz.

5-x labirenti kullanıcı isteğiyle kapalı kalır. Denge/fiyat/envanter hediyesi bu geçişin kapsamında değiştirilmez.
