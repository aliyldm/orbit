# DarkOrbit çok oyunculu sunucu geçişi

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
2. **Sıradaki:** mevcut web/oyun oturum sözleşmesi, parola doğrulaması ve oyuncu yükleme; gerçek native TCP giriş yaşam döngüsü; iki istemcinin ortak haritada birbirini oluşturma/hareket/kaybolma komutları. Şu anda native oyun login'i veya tam açılış paketleri .NET'te çalışmıyor.
3. Ortak harita NPC/kargo/portal yaşam döngüsü, otoriter savaş/hasar/hedef ve çok oyuncu etkileşimleri; özel kapılar için oyuncu/grup örnekleri. Eski tek oyunculu `World.player` varsayımları tek tek kaldırılacak.
4. Envanter/konfigürasyon/diroit/P.E.T./arge/üretim/geliştirme/dükkan/ödüller/görev/rütbe dahil bütün kalıcı depolar; işlem, tekrar istek ve ödülün tek kez verilmesi. SQLite SQL'lerini metin değiştirmeyle PostgreSQL'e aktarma.
5. Eski 1.073 testin senaryo karşılıkları ve gerçek ağ akışları, aynı hesap kopyalarıyla eski/yeni sonuç karşılaştırması; Qt/Flash görsel kabul; 500 ve 1.000 gerçek protokol oturumu yük ve kopma testleri. Mevcut oyun özellikleri bu aşamaya kadar eski sürümde kalır.
6. Son yedek, oturumların güvenli kapatılması, son veri eşitlemesi ve geri dönüş planıyla giriş noktasını yeni sunucuya çevirme. Hazır olmadan eski sunucuyu kapatma veya hesapları sıfırlama.

İlgili kaynaklar: [.NET bounded channels](https://learn.microsoft.com/en-us/dotnet/core/extensions/channels), [Npgsql data source/pooling](https://www.npgsql.org/doc/basic-usage.html), [binary COPY ve tamamlama/geri alma](https://www.npgsql.org/doc/copy.html), [Redis .NET istemcisi](https://redis.io/docs/latest/develop/clients/dotnet/), [PostgreSQL tablo/kısıt tanımları](https://www.postgresql.org/docs/18/sql-createtable.html).
