# Localer bağlantısı

Sunucu tek bir bilgisayarda çalışır. Arkadaşın kaynak kodu veya istemci paketini indirir; PostgreSQL/Redis'i kendi bilgisayarına kurmaz. Her oyuncunun kendi `localhost` adresi farklıdır.

- **Dinleme adresi:** sunucunun Localer sanal IPv4 adresi veya `0.0.0.0`.
- **İstemciye bildirilen adres:** sunucuya ulaşan Localer IP/DNS adı ve oyun portu. `0.0.0.0` bağlanılacak adres değildir.
- **Proxy seçilirse:** `portalUrl` ve `gameHost/gamePort` farklı hedeflere gidebilir. Oyun soketi ham TCP'dir; yalnız HTTP proxy/WebSocket tüneli yeterli değildir. Proxy TCP taşımasını da sağlamalıdır.
- **Mevcut Qt adresi:** exe değiştirilmez. İstemci köprüsü kendi bilgisayarındaki localhost8095/8096'yı `connection.json` içindeki uzak hedeflere yönlendirir. Uzak hedef arkadaşın kendi localhost'u olarak ayarlanmamalıdır.

Yeni .NET geliştirme hostu `DARKORBIT_NATIVE_SCHEMA` ile açıldığında varsayılan olarak dış arabirimleri dinler; erişilebilir `DARKORBIT_GAME_HOST` açıkça gereklidir. Test sınıfları varsayılan olarak loopback/rasgele port kullanır. Örneğin sunucuda:

```powershell
cd DarkOrbit/multiplayer-server
./tools/start-native-localer.ps1 -VirtualIP 10.42.0.1
```

Bu adres örnektir; Localer'in bu bilgisayara verdiği gerçek IP olmalıdır. Script IP'nin bilgisayarda bulunduğunu doğrular. `-BindAny` verilirse bind0.0.0.0 olur; istemciye bildirilen IP yine sanal IP'dir.

Güvenlik duvarı gerekiyorsa ayrı ve açık adım, yönetici PowerShell ile:

```powershell
./tools/start-native-localer.ps1 -VirtualIP 10.42.0.1 -ApplyFirewall -LocalerSubnet 10.42.0.0/24
```

Kural yalnız sanal yerel IP'ye, belirtilen uzak Localer aralığına ve geliştirme TCP18095/18096 portlarına izin verir. Global güvenlik duvarını kapatmaz; PostgreSQL5432/55432 ve Redis56379 açılmaz. Bu script bu geliştirme sırasında çalıştırılmadı; gerçek Localer IP/aralığı henüz verilmedi.

## Web güvenliği

Qt içindeki web sayfası ve API, bağlantı köprüsü üzerinden aynı origin'i kullanır; CORS için genel `*` izni eklenmedi. Gelecekte ayrı web frontend kullanılırsa yalnız tanımlı origin'lere izin ve cookie/SameSite/HTTPS uyumu birlikte uygulanacak. Şu an WebSocket oyun protokolü yoktur; özgün Flash TCP policy isteği oyun portunda cevaplanır ve testlidir.

`portalUrl` HTTPS olabilir: köprü sunucu sertifikasını normal biçimde doğrular, doğrulamayı kapatmaz. .NET sunucuya dış HTTPS sonlandırması eklenecekse sertifika ve proxy güven ayarları kontrollü yapılmalı; kendiliğinden imzasız bir sertifikaya genel güven yüklenmez. Localer ağının şifreleme/kimlik modeli henüz kesinleşmediği için internet üzerinden düz HTTP yayını yapılandırılmadı.

## Hazır olma durumu

Yeni geliştirme portları **18095/18096**, mevcut oyunun portları **8095/8096**. Yeni sunucunun `/ready` yanıtı hâlâ503; paylaşılmış NPC/savaş ve portal taşıması bitmeden uzak oyuna giriş yapılmaz. `requireMultiplayerReady` kontrolünü aşarak eksik sunucuyu arkadaşına açma. Son geçişte portlar/sertifika/adres manifesti birlikte güncellenecek.
