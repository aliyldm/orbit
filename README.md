# Orbit — ayrı istemci, sunucu ve veri servisleri

- `client`: Qt/Flash istemcisi, oyun görselleri/sesleri ve Localer bağlantı köprüsü. Oyuncu bilgisayarında PostgreSQL veya Redis çalıştırmaz.
- `server`: .NET10 oyun/HTTP sunucusunun kaynakları ve ayrı yayımlanan çalışma zamanı. Oyun durumu sunucu bilgisayarındadır.
- `db`: yalnız sunucuda çalışacak PostgreSQL/Redis servis tanımları. Veritabanı portları loopback'e bağlıdır; Localer oyuncularına açılmaz.
- `MIGRATION.md`: tamamlanan ve kalan geçiş işleri.

**Klasör ayrımı hazırdır; .NET oyun geçişi henüz tamamlanmış değildir.** `/ready`503 kalır. İstemci, eksik sunucuya girmek için bu kontrolü kapatmaz. Klan, açık artırma, sıralama ve bütün eski oyun mekaniklerinin portu doğrulanmadan ortak oynanabilir sürüm olarak sunulmaz.

## Oyuncu

Tam Windows paketi Qt/Flash/Node çalışma zamanını ve oyun varlıklarını içerir. Kaynak Git indirmesi bu büyük çalışma zamanı dosyalarını içermez; tam paket sürüm dosyası olarak paylaşılır. `client/connection.example.json` dosyasını `client/connection.json` adıyla kopyala; sunucu bilgisayarının güncel Localer IPv4 adresini ve portlarını yaz. Sonra `client/Oyunu Ac.cmd` dosyasını çalıştır.

Örnek IP gerçek sunucu adresi değildir. İki bilgisayar Localer üzerinden erişebilmeli; oda kurucusu otomatik oyun sunucusu değildir. İstemci köprüsü mevcut Qt'nin localhost8095/8096 adreslerini gerçek sunucuya taşır.

## Sunucu geliştirme

.NET10 SDK ve sunucu servis betikleri için PowerShell7 ile `server/Derle.ps1` sunucuyu yayımlar. `db/Servisleri Baslat.ps1` yalnız bu dağıtımın ayrı servislerini başlatır; mevcut PostgreSQL5432 ve eski geliştirme55432/56379 değiştirilmez. Bu paketin yeni portları55433/56380'dir.

Kaynak eski proje ve REA/decompiled analizleri bu pakete alınmadı. Gerektiğinde geliştiricinin mevcut `latestversion` klasörü referans olarak kullanılabilir; mutlak yerel yol ve özel hesap verileri Git'e gönderilmez. Canlı hesap aktarımı son, doğrulanmış geçişte yapılır; eski snapshot ile mevcut ilerleme ezilmez.

Kurulum dosyaları, analiz çıktıları, eski Node/SQLite oyun sunucusu, kişisel veritabanları, parola/oturum/capture dosyaları ve yedekler bu dağıtımın parçası değildir. Oyun içindeki gerekli SWF ve protokol/katalog JSON dosyaları çalışma zamanı bağımlılığıdır ve korunur. Qt lisansları istemciyle birlikte kalır.
