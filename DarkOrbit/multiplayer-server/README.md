# DarkOrbit çok oyunculu sunucu geçişi

## Güncel — Aşama 5a: canlı ekipman ve bonus hesaplaması

26 Ekim 2026: kahramanın gemisi, iki konfigürasyonu, takılı eşyaları, diroitleri/tasarımları, gemi modülleri, mevcut arge dağılımı, süreli zenginleştirme ve booster etkileri artık PostgreSQL kayıtlarından hesaplanıyor. **91 gövde / 364 eski oyun senaryosu / 48.778 alan karşılaştırması** geçti. Modern lazerlerin temel ekipman istatistikleri bu hesaplamaya dahil; modern proc/ateş davranışı henüz ayrı bir port bekliyor.

Gemi/diroit/P.E.T. takma-çıkarma, kapasite kadar toplu yerleştirme, çoklu diroit planı, satış, konfigürasyon değiştirme, düzen kaydetme/yükleme, favori, çevrimdışı gemi/tasarım seçimi ve konfigürasyon aktarımı için canlı depolar eklendi. **12 Flash mutation işlemi** orijinal base64 zarfından, uygun native yazma istekleri de aynı depodan geçer. Bu, hangarın bütün okuma ekranlarının tamamlandığı anlamına gelmez: liste/detay/uyumlu gemi projeksiyonları, başlık hangarları ve P.E.T. çalışma zamanı sonraki alt adımlardır. [Ayrıntı ve devam noktası](docs/EQUIPMENT-PORT.md).

Canlı yenileme sunucu rotasını durdurur; yeni hız/bonus/diroit tanımı gönderilir. Süreli bonus sona erince can/kalkan üst sınırları daralır ve kayıt korunur; yeniden hesaplama iyileştirme vermez. Konfigürasyonların kalkan havuzları ayrıdır. Kayıtlı düzen satılan eşyayı çoğaltmaz; bulunamayan satırı atlayıp eksik sonuç döndürür. EP/şeref modüllerinin seviye sınırı gerçek ödül işlemi içinde kontrol edilir.

Geliştirme şeması **3** gerektirir. Eski geliştirme şemasının üstüne migration uygulanmaz; gerekirse `tools/bootstrap-native-development.ps1` yeni şema oluşturur. Kaynak Node/SQLite oyununa yazılmadı ve canlı hesapların üstüne eski snapshot konmadı. Yeni sunucu hâlâ `/ready`503, portal başlangıcı501 verir; ortak oynanabilir paket yayımlanmış değildir.

```powershell
node tools/export-equipment-content.js
node tools/generate-equipment-contract.js
dotnet build DarkOrbit.Multiplayer.slnx -m:1
dotnet run --project tools/DarkOrbit.Verify --no-build -- equipment
./tools/verify-native.ps1 -Mode equipment-storage
./tools/verify-native.ps1 -Mode combat
./tools/verify-native.ps1 -Mode native
node tools/audit-legacy-parity.js --check
```

Aşağıdaki aşamalar önceki kilometre taşlarının tarihçesidir; güncel kapsam yukarıdadır.

## Önceki — Aşama 4: atomik klasik ateş ve kalıcı normal dünya

Klasik MP-1/LF-1..4 ve LCB/MCB/UCB/RSB için native ateş, eski hasar formülleriyle yeni harita aktörüne bağlandı. **75 eski formül senaryosu / 302 kontrol**, **9 TCP istemcisi / 64 kontrol** geçti. İki oyuncu aynı lazer/hasar/imha paketini görür; RSB bir salvodan sonra önceki normal cephaneye döner. Cephane miktarı PostgreSQL'den gelir. Bu kapsam modern lazer/proc, SAB/drain, roket/launcher, NPC karşı ateşi veya canlı ekipman bonuslarının tamamı değildir; desteklenmeyen yükler klasik hasara sessizce düşürülmez.

NPC checkpoint'i, çoklu yığın cephane düşümü ve ölüm nesli/ödülü aynı PG işleminde yazılır. Son adım hata verirse hasar/cephane/ödül birlikte geri alınır. Sonucu belirsiz kayıt hatasında harita yazmaya devam etmez. NPC nesli/can/kalkan/respawn ve rota kaydı yeniden yüklenir; eski saldırı hedefi yeni bağlantıya taşınmaz. Kalıcı 1s lazer/3s RSB saatleri yeniden girişle aşılamaz. Farklı işlem kimliği aynı ölümü ikinci kez ödeyemez. **25 gerçek PG kontrolü PASS**: kesirli/büyük bakiye, tekrar, eşzamanlı öldürme, geç hata, yeniden açma ve bağlantı/dünya sahipliği.

Ödülün skill/formasyon aşaması uyumluluk profilinden; gövde ve süresi geçmemiş EP/şeref booster aşamaları PG'deki sahiplik/süre kayıtlarından hesaplanır. EP/şeref veren gemi modülleri tam politika portu beklediğinden bu profiller ilk klasik ateş kapsamının dışında tutulur. Envanter snapshot'ının tüm satırları saklanır; şu an yalnız cephane işlemleri canlıdır. `NativePilot.Profile` hâlâ türetilmiş stat projeksiyonudur. Diğer envanter, rütbe, PET, arge veya görev verileri canlı port edildi diye sunulmaz.

Geliştirme runtime şeması **2**. Eski `mp_*` geliştirme şemasının üstüne yazılmaz: `tools/bootstrap-native-development.ps1` yeni rastgele şema oluşturur. Kaynak SQLite kullanılmaya devam eder; eski snapshot canlı oyuncu verisinin üstüne konmaz. Bir sunucu kimliği için PG süreli sahiplik/nesli aynı anda ikinci hostu engeller. Harita başına dağıtım ve tam oyun yük testi henüz yoktur.

Kapsam denetimi: [LEGACY-PARITY.md](LEGACY-PARITY.md), [adlarıyla komut/tablo/API listesi](legacy-parity-report.json). Eski **1.073 test PASS**, 196 kaynak/ayar/istemci checksum'ı aynı. Eski sunucunun 106 native komutunun yalnız2'si tam,8'i kısmi kapsamdadır;96'sı port bekler. Tablo arşivi ve kaynak dosyasının mevcut olması çalışan .NET özelliği değildir. `/ready`503 ve web portalı501 kalır; ortak oynanabilir paket henüz yayımlanmadı.

```powershell
node tools/generate-classic-combat-contract.js
node tools/export-world-content.js
dotnet build DarkOrbit.Multiplayer.slnx -m:1
dotnet run --project tools/DarkOrbit.Verify --no-build -- laser
./tools/verify-native.ps1 -Mode combat
./tools/verify-native.ps1
node tools/audit-legacy-parity.js --check
```

Aşağıdaki aşamalar önceki kilometre taşlarının tarihçesidir.

## Güncel — Aşama 3: ortak normal dünya ve portal geçişi

32 normal harita, 96 portal ve 951 NPC yuvası eski oyunun **yalnız bellekte açılan** veritabanından üretilir; hesap verisi katalogda yoktur. `tools/export-world-content.js`, C#'a gömülen `World/world-content.json` ile 405 farklı harita/şirket/konum için eski paket sözleşmesini üretir. **5.648 dünya kontrolü PASS**: portal paket sırası, şirket erişimi, istasyon/barış alanı, NPC'nin ortak can/kalkanı, tek ölüm nesli, yeniden doğuş ve ayrılan hedefin devriyesine dönüşü. NPC simülasyonu harita aktörünün tek yazıcı kuyruğunda çalışır. Normal NPC durumu şimdilik bellektedir; sunucu yeniden başlayınca korunması ve özel NPC/eskort mekanikleri henüz port edilmedi.

Gerçek HTTP/TCP testinde **7 istemci / 56 kontrol PASS**: iki oyuncu aynı NPC kimliklerini görür, seçimi ortak durumdan gelir; 1-4 → 4-1 geçişi eski portalın varış konumuyla yapılır. Geçiş boyunca hareket/tekrarlı atlama engellenir; çıkış bekleyen atlamayı iptal eder. PostgreSQL konum kaydı bağlantı sahibi/nesli koşuluyla korunur. Varışın kaydı başarısızsa diğer oyunculara yayın yapılmadan üyelik geri alınır. NPC ateşi/ödülü ve native lazer istekleri henüz bağlanmadı; testteki sunucu hasar API'si istemciden hasar kabul etmez.

`/ready` **hâlâ503**, kaynak SQLite/oyun ayarları/istemci aynı. İki bilgisayarla ortak oyun henüz açılmaz. Önizleme ZIP'i bu değişikliklerle yeni bir çok oyunculu sürüm olarak yayımlanmadı. [Güncel kalanlar](MIGRATION-TODO.md). Önceki aşamaların aşağıdaki notları tarihçedir.

```powershell
node tools/export-world-content.js
dotnet build DarkOrbit.Multiplayer.slnx -m:1
dotnet run --project tools/DarkOrbit.Verify --no-build -- world
./tools/verify-native.ps1
```

Git paketindeki kök `/runtime/` dışlaması, Windows'ta C# `Runtime` kaynak klasörünü de yanlışlıkla gizliyordu; köke sabitlendi. `distribution/source-completeness.test.js` tüm C# kaynaklarını kontrol eder. `distribution/verify-source-build.ps1` Git arşivini ayrı klasöre çıkarıp özel dosyalar olmadan gerçek restore/build yapar.

## Güncel — Aşama 2: native giriş ve harita görünürlüğü doğrulandı

Node scrypt parola biçimi, mevcut `dosid` form/cookie akışı, Redis doğrulaması ve PostgreSQL oyuncu yükleme yeni .NET HTTP/TCP sunucusuna bağlandı. İki istemci aynı haritada birbirini gerçek `ShipCreateCommand`, `MoveCommand`, `ShipRemoveCommand` ile görür. Üçüncü harita ve iki özel kapı dahil **5 gerçek TCP istemcisi / 43 kontrol PASS**; hatalı kullanıcı/sunucu, yeniden bağlanma, çıkış ve pozisyon kaydı kapsandı. `NativeVerification` yalnız rastgele test şemasındaki sentetik hesapları kullanır ve şemasını temizler.

Özgün türetilmiş bonusları değiştirmemek için şimdilik kaynak SQLite'ın **online kopyasında** eski `loadPlayer/buildInit` çalıştırılarak uyumluluk projeksiyonu üretilir. Üç gerçek hesap kopyasının **1.422 açılış komutu** JS/.NET bayt eşleşmesinden geçti; parola hashleri aynıdır. Bu, stat/bonus/özellik depolarının C#'a canlı port edildiği anlamına gelmez. Geliştirme deposu sadece konum ve oturum sahibini günceller; eski hesap/SQLite ve PG arşivi değişmez. Kalıcı kayıtta Redis bağlantı nesli/owner koşulu, eski soketin yeni oturumu ezmesini engeller.

`tools/export-native-profiles.js`, `bootstrap-native-development.ps1`, `generate-password-contract.js`, `verify-native.ps1` bu aşamanın araçlarıdır. Son geliştirme şeması raporu `artifacts/native-bootstrap.json`, bağlantı testi `artifacts/native-verification.log`. Bunlar ve özel profil JSON'ları Git'e gönderilmez.

Giriş ekranı kullanıcının yeni isteğiyle yenilendi; eski launcher form/alan seçicileri ve `/login` davranışı korundu. Yeni .NET host aynı HTML ve yerel görselleri gömer. HTTP18095/TCP18096 yalnız ayrı geliştirme ortamıdır; eski oyun8095/8096 çalışır. Yeni sunucu hâlâ **ready503**. Yeni hesap oluşturma ve bütün portal rotaları da port bekler; şu an bu hostta mevcut hesapla geliştirme girişi vardır.

Sanal ağ/proxy bağımsızlığı: `DARKORBIT_WEB_BIND`, `DARKORBIT_GAME_BIND`, `DARKORBIT_GAME_HOST`, `DARKORBIT_GAME_PUBLIC_PORT`. Native host bind varsayılanı0.0.0.0; erişilebilir `DARKORBIT_GAME_HOST` zorunlu. `start-native-localer.ps1` sanal IP'yi doğrular ve varsayılan olarak yalnız o arabirime bağlar. Testler loopback veya rasgele test portları kullanır. Dağıtım başlatıcısının `connection.json` köprüsü ayrı portal ve TCP adresleri alır; Qt/Flash exe değişmez. [Localer/port/firewall/HTTPS notları](../../distribution/NETWORK.md). Sağlanan mimari belgesi Localer'in EasyTier/Wintun sanal IPv4 ağı olduğunu netleştirdi; özel SDK/API gerekmez. Oda adresleri dinamik, güncel sunucu IP'si kullanılacak. Hazır olma kontrolü atlanmaz. Depolama portlarını sanal ağa açma.

**Sıradaki:** paylaşımlı NPC/kargo/portal yaşam döngüsü, gerçek portal/HTTP API rotaları, canlı stat/ekipman depoları ve otoriter savaş. .NET'e geçiş tamamlandı veya arkadaşların ortak oyuna şimdiden girebilir deme. Aşağıdaki aşama1 kaydı temel bileşenlerin tarihçesidir.

25 Ekim 2026: kullanıcı .NET/PostgreSQL/Redis tabanlı çok oyunculu mimari çalışmasını onayladı. Önceki “yalnız programları indir” sınırı bu iş için kaldırıldı. Oyun kuralları, fiyatlar, hesap ilerlemesi, Qt/Flash penceresi ve mevcut istemci dosyaları korunacak.

**Aşama 1 tamam: doğrulanmış altyapı çekirdeği. Oyun henüz bu sunucuya geçirilmedi.** Mevcut `../local-server` Node/SQLite sürümü hâlâ oyunu çalıştırır. .NET kontrol sunucusu `/ready` için bilerek **503** verir; bir dosyanın derlenmesini tamamlanmış çok oyunculu oyun gibi göstermeyiz.

Eklenenler:

- Aynı istemciden çıkarılmış 1.352 sınıflık ortak paket şemasıyla .NET codec ve ilk istemci paketi 4 bayt / sonraki paketler 3 bayt çerçeve ayrıştırması. SWF değişmedi.
- Harita başına sınırlı kuyruk ve tek yazıcı; bağımsız oyuncu hareketleri, bağlantı yenileme güvenliği, sunucu/harita/özel kapı ayrımı. Şimdilik hareket/üyelik altyapısı; savaş ve NPC simülasyonu taşınmadı.
- Redis üzerinde süreli, oyuncu/sunucuya bağlı oturumlar ve atomik bağlantı sahipliği. Eski bağlantı yeni sahibin kaydını silemez veya uzatamaz. Henüz eski web girişine/native LoginRequest'e bağlanmadı.
- SQLite'tan tutarlı ve salt okunur dışa aktarım; PostgreSQL'e işlem içinde arşiv aktarımı ve bütün hücrelerin karşılaştırılması. Mevcut 60 tablo/4.584 satır eşleşti. Bu **prova şemasıdır**: kaynak DDL, indeks, default ve yabancı anahtar tanımları metadatada korunur; PostgreSQL oyun şemasına ait kısıtlar/depolar henüz taşınmadı. Kesir içeren `item_types.price_uridium`, bigint'e kırpılmak yerine numeric olarak saklanır.
- Ayrı, sabit imaj digest'li Docker geliştirme ortamı: PostgreSQL `127.0.0.1:55432`, Redis `127.0.0.1:56379`. Yerel kurulu PostgreSQL5432 ve oyun8095/8096 değişmedi. Ayrı kalıcı volume'lar, rastgele yerel parolalar; sırlar `.local` içinde, oyuncu dışa aktarımı `artifacts/private` içinde.

## Çalıştırma

Bu klasörde PowerShell7 ve .NET10 SDK ile:

```powershell
dotnet build DarkOrbit.Multiplayer.slnx
node tools/generate-contract-fixtures.js
dotnet run --project tools/DarkOrbit.Verify --no-build
./tools/start-development.ps1
./tools/verify-storage.ps1
dotnet run --project src/DarkOrbit.Host --no-build -- --verify
```

Kontrol sunucusunu kalıcı çalıştırmak için `dotnet run --project src/DarkOrbit.Host --no-build`; yalnız localhost18095. Bu oyun giriş noktası değildir. Geliştirme servislerini durdurmak için:

```powershell
docker compose --env-file .local/development.env -f infra/compose.yaml stop
```

`down -v` veri volume'larını siler; normal durdurma için kullanma. `.local` ve özel snapshot dosyalarını paylaşma. PostgreSQL yönetici şifresi veya mevcut hesapların parolaları bu araçlara gerekmez.

Yeni veri provası gerektiğinde:

```powershell
node tools/export-legacy-snapshot.js
./tools/import-development.ps1
```

Her prova yeni `legacy_<16 hex>` şeması oluşturur; var olan şemayı düşürmez veya üzerine yazmaz. Testler sadece rastgele oluşturdukları test şemalarını temizler. Kaynak SQLite'a migration/seed/yazma uygulanmaz. Snapshot canlı oyun oynanırken güncelliğini yitirebilir; son geçişte yazılar durdurulup son yedekten aktarılacak.

## Doğrulama

- `artifacts/verification.log`: 4.053 JS/.NET çift yönlü paket sözleşmesi; 8.148 kontrol; iki gerçek TCP istemcisi; 10 haritada 1.000 sentetik üyelik/hareket; eski socket, özel kapı, başka sunucu ve başarısız hedefe geçiş ayrımı.
- `artifacts/storage-verification.log`: 67 gerçek PostgreSQL/Redis kontrolü. 64bit kimlik, kesir, Unicode, blob/null, yinelenen aktarım engeli, son tablodaki hatada tüm işlemin geri alınması; oturum süresi/iptali/50 eşzamanlı sahiplik talebi.
- `artifacts/postgresql-rehearsal.json`: gerçek hesap verilerinin 60 tablo/4.584 satırlık prova sonucu. Kullanıcı değerleri rapora basılmaz.
- `artifacts/host-verification.log`: ayrı .NET HTTP host health200 / ready503; test sonunda kapanır.
- `artifacts/legacy-compatibility-baseline.json` ve `legacy-preservation.log`: 196 kaynak/ayar/istemci dosyası ve kaynak SQLite'ın bütün tablo/değerleri korunuyor.

**1.000 sentetik üyelik testi, 1.000 gerçek Flash oyuncusu kapasite kanıtı değildir.** Gerçek yük testinde NPC, savaş, P.E.T., kutular, portal geçişleri, veritabanı ve yavaş bağlantılar birlikte çalıştırılacak.

## Devam sırası

1. **Tamam:** ortak protokol, harita/oturum çekirdeği, ayrı PostgreSQL/Redis ortamı, veri provası ve koruma denetimleri.
2. **Tamamlanan:** mevcut parola ve web/native oturum doğrulaması, PostgreSQL oyuncu projeksiyonu, ortak görünürlük/hareket/kaybolma ve yeniden giriş. Canlı türetilmiş stat depoları bekliyor.
3. **Kısmen tamamlanan:** normal haritalarda ortak NPC yaşam döngüsü ve portal geçişi. Sırada kargo, kalıcı dünya durumu, otoriter savaş/hasar/ödül ve özel kapı/grup örnekleri var. Eski tek oyunculu `World.player` varsayımları tek tek kaldırılacak.
4. Envanter/konfigürasyon/diroit/P.E.T./arge/üretim/geliştirme/dükkan/ödüller/görev/rütbe dahil bütün kalıcı depolar; işlem, tekrar istek ve ödülün tek kez verilmesi. SQLite SQL'lerini metin değiştirmeyle PostgreSQL'e aktarma.
5. Eski 1.073 testin senaryo karşılıkları ve gerçek ağ akışları, aynı hesap kopyalarıyla eski/yeni sonuç karşılaştırması; Qt/Flash görsel kabul; 500 ve 1.000 gerçek protokol oturumu yük ve kopma testleri. Mevcut oyun özellikleri bu aşamaya kadar eski sürümde kalır.
6. Son yedek, oturumların güvenli kapatılması, son veri eşitlemesi ve geri dönüş planıyla giriş noktasını yeni sunucuya çevirme. Hazır olmadan eski sunucuyu kapatma veya hesapları sıfırlama.

İlgili kaynaklar: [.NET bounded channels](https://learn.microsoft.com/en-us/dotnet/core/extensions/channels), [Npgsql data source/pooling](https://www.npgsql.org/doc/basic-usage.html), [binary COPY ve tamamlama/geri alma](https://www.npgsql.org/doc/copy.html), [Redis .NET istemcisi](https://redis.io/docs/latest/develop/clients/dotnet/), [PostgreSQL tablo/kısıt tanımları](https://www.postgresql.org/docs/18/sql-createtable.html).
