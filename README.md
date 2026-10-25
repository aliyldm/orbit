# Orbit

Qt/Flash DarkOrbit istemcisi, çalışan yerel Node/SQLite oyun sunucusu ve .NET10/PostgreSQL/Redis çok oyunculu geçişi.

**Güncel durum:** yerel oyun çalışır. Yeni .NET sunucusunda gerçek HTTP giriş/parola doğrulaması, PostgreSQL oyuncu yükleme ve beş TCP istemcisiyle harita görünürlüğü/hareket/yeniden giriş/çıkış testleri çalışır. Savaş, NPC ve bütün portal özellikleri henüz .NET'e taşınmadığı için çok oyunculu sürümün `/ready` yanıtı **503**. Gerçek 500–1000 oyuncu kapasitesi henüz ölçülmedi.

## İndirip yerel oynamak

Depodaki **Releases** bölümünden `Orbit-Local-Preview-Windows.zip` paketini indir, normal bir klasöre çıkar ve **`Orbit Baslat.cmd`** dosyasını aç. Paket mevcut Qt/Flash istemcisini, oyun varlıklarını, Node çalışma zamanını ve sunucu kaynaklarını içerir. Node/.NET/Docker kurmak yerel önizleme için gerekmez. İlk girişte yeni hesap oluşur; bu pakette geliştiricinin hesapları, şifreleri veya ilerlemesi yoktur.

İstemci açılmıyorsa paketteki `DarkOrbit/dependencies/vc_redist.x86.exe` bileşenini kurmak gerekebilir. Paket Windows x64 içindir; Qt/Flash istemcisi x86 çalışır. Sunucu yerel oturumun ardından arka planda kalır; tekrar açılışta aynı sunucu kullanılır. **`Orbit Sunucuyu Kapat.cmd`** bu paketin sunucusunu kayıt alarak güvenli kapatır.

Bu paket **şimdilik kendi bilgisayarında çalışan yerel önizlemedir**. Ortak sunucuya bağlanma, aşağıdaki ağ ayarı ve tamamlanacak çok oyunculu sunucu içindir. Eksik yeni sunucuya kullanıcı sokmak için hazır olma kontrolü atlanmaz.

## Sanal ağ / proxy bağlantısı

`connection.json` ilk açılışta örnekten oluşturulur. Ortak sunucu hazır olduğunda:

```json
{
  "mode": "remote",
  "portalUrl": "http://10.113.47.2:8095",
  "gameHost": "10.113.47.2",
  "gamePort": 8096,
  "requireMultiplayerReady": true
}
```

Buradaki adres örnektir; Localer odasının sunucu bilgisayarına verdiği güncel adresle değiştirilir. Localer gerçek sanal IPv4 ağı sağlar; özel oyun SDK'sı gerekmez. Oda kurucusu otomatik oyun sunucusu değildir. Proxy kullanılıyorsa web ve TCP için farklı adres/port verilebilir. Bağlantı katmanı localhost8095/8096 üzerinden mevcut Qt istemcisini değiştirmeden yönlendirir. Parola/oturum veya oyun paketleri kaydedilmez. Sunucunun `/ready` yanıtı `200 {"ready":true}` olmadan uzak oyun açılmaz. PostgreSQL ve Redis oyuncuların bilgisayarında çalışmaz ve sanal ağa açılmaz. [Localer kurulum ve test yönergesi](distribution/NETWORK.md).

## Kaynak kodla geliştirme

- `DarkOrbit/local-server`: mevcut oyun; Node26+. `node server.js`.
- `DarkOrbit/multiplayer-server`: .NET10 çözümü ve gelişim kaydı. [Açıklama](DarkOrbit/multiplayer-server/README.md), [geçiş durumu](DarkOrbit/multiplayer-server/migration-state.json).
- `distribution`: paylaşım başlatıcısı, HTTP/TCP bağlantı köprüsü ve paketleme araçları.

Değiştirilen istemci SWF'leri, XML/JS/CSS tanımları ve kaynak kod Git'te tutulur. Büyük grafik/ses varlıkları ve yerel çalışma zamanları sürüm paketindedir. Kaynak ZIP/clone ile geliştirenler sürüm paketindeki `DarkOrbit/local-server/client` klasörünü aynı konuma kopyalamalıdır. .NET çözümünü derlemek için gerekli iki giriş görseli kaynakta ayrıca bulunur. Eski sunucunun tam istemci artefakt testleri sürüm paketindeki `decompiled` referanslarını da kullanır.

```powershell
cd DarkOrbit/multiplayer-server
dotnet build DarkOrbit.Multiplayer.slnx
node tools/generate-contract-fixtures.js
dotnet run --project tools/DarkOrbit.Verify --no-build
./tools/start-development.ps1
./tools/verify-storage.ps1
```

Yeni ağ katmanı testi: kök dizinde `node --test distribution/client-bridge.test.js`.

Depo özeldir; kaynak ve sürüm paketlerini indirecek kişiye depo erişimi verilmelidir. Mevcut Qt bileşenlerinin lisans dosyaları `DarkOrbit/Licenses` içinde korunur. Her sürüm paketinin SHA256 özeti yayınlanır.
