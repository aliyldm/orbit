# Yalnız kurulum hazırlığı — 25 Ekim 2026

**Güncel yetki değişti:** kullanıcı daha sonraki mesajında çok oyunculu .NET/PostgreSQL/Redis mimarisine başlanmasını açıkça onayladı. [Yeni proje ve doğrulanan ilk aşama](../../multiplayer-server/README.md). Aşağıdaki “yalnız indirme, taşıma yok” ifadeleri önceki hazırlık görevinin tarihçesidir. Mevcut oyun henüz yeni sunucuya geçirilmedi; ilk altyapı ayrı geliştirme ortamında doğrulandı.

## Güncel doğrulanmış durum — temel hazırlık tamam

WSL3.0.3.0 kurulu ve varsayılan2. DockerDesktop CLI start --detach ile açıldı; Linux motor29.9.2/overlayfs hazır. **redis:8 resmî imajı indirildi**, linux/amd64,210698033byte; digest sha256:97ec88159e6d7cfb5ddef9015386087d58a912de80112f06ebdfa78fa5989901. Redis container oluşturulmadı, servis/port açılmadı. .NETSDK10.0.402 ve PostgreSQL18.6/5432 yeniden kontrol edildi. Kanıt setup-installers/prerequisites-status.json; indirme logu setup-installers/redis8-pull.log. Bu yalnız hazırlıktır; oyun kodu/verisi .NET/Postgresetaşınmadı. Prometheus/Grafana/k6sonrakiisteğebağlıhazırlıkadımı,henüzindirilmedi. Aşağıdaki WSL/Dockerbaşlatılamıyordurumu tarihçedir.


## WSL MSI indirildi ve doğrulandı

Kullanıcı son ekranla PowerShell indirmesinin sunucu bağlantısı sıfırlandığından%5/%9da kaldığını netleştirdi. Microsoft resmî GitHub stable3.0.3 x64 MSI doğrudan yeniden denemeli indirildi. Dosya: workspace/setup-installers/wsl.3.0.3.0.x64.msi,367575040byte. SHA256 ae977286974255bd26bf925f00f40f5692c6b2084155cbc0563c09aea091f211 resmî assetdigest ile aynı; Authenticode Valid/MicrosoftCorporation. Kanıt setup-installers/wsl-verified.json. Kullanıcının dosyayı çalıştırıp Windows yönetici onayıyla kurulumu tamamlaması bekleniyor; MSI otomatik çalıştırılmadı. Redis henüz indirilmedi; WSL/Docker engine hazır değil. Sonra WSLversion/dockerinfo doğrulanıp Redis8imajı yalnız pull edilecek.


## Son kontrol — Docker kuruldu, WSL bekliyor

Docker CLI29.9.2 kurulu: C:\Program Files\Docker\Docker\resources\bin\docker.exe. Linux motor pipe/dockerDesktopLinuxEngine yok; docker info sunucuya bağlanamadı. wsl --status, WSL yüklü değil diyor. wsl --install --no-distribution denemesi exit1 verdi; Get-WindowsOptionalFeature ayrıca yükseltme gerekiyor hatası verdi (araç izni Windows yönetici tokenı sağlamıyor). Kullanıcıya yönetici PowerShell ile aynı resmî WSL kurulum komutu verilmeli; Windows yeniden başlatma gerekebilir. Otomatik UAC onayı/reboot yapılmadı. Redis imajı henüz indirilemedi, container başlatılmadı. Oyun/.NET/PostgreSQL veri taşıması yok.

Kaynak: https://learn.microsoft.com/en-us/windows/wsl/basic-commands ; https://docs.docker.com/desktop/features/wsl/


Kullanıcı açıkça: **Henüz sunucuyu .NET/PostgreSQL'e taşımayacağız. Yalnız gerekli araçları indiriyoruz; gelecekte500–1000eşzamanlı oyuncu hedeflenecek.** Yeni backend projesi, veri taşıma, port değiştirme veya Redis bağımlılığı bu kapsamda eklenmedi. Mevcut oyun Node/SQLite olarak çalışıyor; envanter hata düzeltmeleri kendi kapsamındadır.

## Son durum — PostgreSQL doğrulandı, Docker kuruluyor

PostgreSQL18.6 servisi postgresql-x64-18 Running; pg_isready127.0.0.1:5432 accepting connections. Locale hatasından sonra kullanıcı kurulumunu tamamladı. Kimlik doğrulamalı SQL oturumu/oyun veri taşıması yapılmadı. .NETSDK10.0.402 mevcut. Kullanıcı Docker Desktop kurucusunun Configuration ekranında; Per-user installation, WSL2 açık, Windows Containers kapalı önerildi. Docker/Redis hazır olduğu henüz doğrulanmadı. Aşağıdaki ilk kurulum hatası tarihçedir.

## Bu bilgisayarda görülenler

- Windows x64, Git mevcut.
- .NET SDK **10.0.402** kuruldu: `C:\Program Files\dotnet\sdk`. [Resmî .NET10 SDK sayfası](https://dotnet.microsoft.com/en-us/download/dotnet/10.0).
- PostgreSQL **18.6** ikilileri kurulu: `C:\Program Files\PostgreSQL\18\bin`. [Resmî Windows kurucusu](https://www.postgresql.org/download/windows/) pgAdmin'i içerir.
- İlk PostgreSQL küme başlatması başarısız: salt okunur kurulum günlüğünde `initdb: locale name "Turkish_Türkiye.1254" contains non-ASCII characters`. Kontrol anında data klasörü boş, servis yok ve5432 `no response`. Şifre görüntülenmedi/istenmedi, veri klasörü değiştirilmedi. Kullanıcı sihirbazı tekrar çalıştırıyor; gösterdiği Advanced Options ekranında **Locale=C** seçmesi söylendi. EncodingUTF8 kalmalı. Varsayılan libc+C karakter kodlamasının SQL_ASCII olabileceği için UTF8 açıkça korunur. [Resmî initdb seçenekleri](https://www.postgresql.org/docs/18/app-initdb.html).
- İlk kontrol sırasında kullanıcı ekranında Locale DEFAULT idi; **bu eski durum sonraki başarılı servis/port kontrolüyle aşıldı.** Sonraki kontrol: pg_isready127.0.0.1:5432, servis ve gerekiyorsa kullanıcı tarafından sağlanan güvenli bağlantı. Postgres yönetici parolasını sohbet/loglara yazdırma.
- `wsl.exe` var; WSL2'nin kurulup etkin olduğu doğrulanmadı. `docker` komutu bulunmadı.

## Sonraki indirilecekler

1. [Docker Desktop Windows x64](https://docs.docker.com/desktop/setup/install/windows-install/), WSL2 arka ucu. Önce `wsl --version` ve gerekiyorsa WSL kurulumu/güncellemesi kontrol edilir. Yeniden başlatma isteyebilir; otomatik makine yeniden başlatma yapılmadı.
2. Redis8'i Docker imajı olarak hazırlama. Docker çalışınca `docker pull redis:8` yalnız imajı indirir; Redis servisi başlatmaz. [Resmî Redis kurulum yolu](https://redis.io/docs/latest/install/install-redis/install-redis-on-linux/). Container başlatma/port açma henüz yapılmadı.
3. İzleme için Prometheus/Grafana ve web API yük testleri için [k6](https://grafana.com/docs/k6/latest/set-up/install-k6/) sonraki hazırlık kalemleri. Bu araçlar bu turda indirilmedi/kurulmadı. Gerçek oyun TCP protokolü için ayrıca uygun bot/yük istemcisi gerekir; HTTP testi tek başına500–1000oyuncu kanıtı değildir.

RedisInsight isteğe bağlı yönetim aracı olabilir; çekirdek Redis'in yerine geçmez. Npgsql gibi kod bağımlılıkları yeni .NET projesi kapsamı açıldığında NuGet ile seçilir; şimdi sunucuya eklenmedi. Oyuncu kapasitesi ölçüm, NPC/harita yükü, dünya döngüsü, veritabanı yazımı ve makine kaynaklarıyla doğrulanacak; program indirmek kapasite garantisi değildir.
