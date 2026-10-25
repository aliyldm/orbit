# Özgün ölüm ekranı ve yeniden doğma

İstemcinin kendi `KillScreenPostCommand` / `KillScreenOptionModule` kartları kullanılır. Yeni pencere veya HTML katmanı eklenmez. Güncel normal haritadaki aynı oturumun imhasında üç seçenek vardır:

| Native seçenek | Bedel | Sonuç |
|---|---:|---|
| 1 — ana istasyon | Ücretsiz | Şirketin başlangıç haritası; mevcut yerel tam can/kalkan davranışı korunur |
| 2 — en yakın atlama kapısı | 500 Uridium | İmha olunan haritadaki en yakın gerçek ve şirkete görünür portal; başka haritaya atlatmaz |
| 3 — imha noktası | 2.000 Uridium | Aynı koordinat; gemi türünün temel canının %10'u, kalkan sıfır; 10 saniye saldırı koruması |

500 / 2.000 bedelleri kullanıcı isteğidir. Ücretsiz ve kapıda tamirin tam can/kalkan miktarı mevcut yerel kuraldır; eldeki istemci bu ikisinin sayısal can oranını doğrulamaz. İmha noktasındaki %10 temel can ve 10 saniye koruma ise gönderilen Türkçe `flashres.xml:ttip_killscreen_repair_location` metninde açıkça bulunur. Koruma oyuncu saldırınca sona erer. Ücretli seçenekler çıkış/yeniden giriş ve gemi değişimi sonrasında geçersiz olur; bu da aynı dosyadaki `ttip_killscreen_logout_1/2` davranışıdır. Koruma NanoHull oluşturmaz.

Galaksi kapılarında ücretli seçenekler gönderilmez ve sahte seçimler sunucuda reddedilir. Ücretsiz ana üs dönüşü korunur; bu modül kapı canı, dalga, ödül veya NPC kaydı değiştirmez. İmha akışı zaten `galaxy-gates.onPlayerDeath` üzerinden kaybettiği canı ve dalga yeniden başlatmasını kaydeder. Kapının içindeki konuma ücretli tamirle dönülerek bu muhasebe atlanamaz.

İstemci kanıtları `decompiled/main/scripts/net/bigpoint/darkorbit/` altındadır:

- `com/module/KillScreenOptionTypeModule.as`: BASIC=1, JUMPGATE=2, DEATHLOCATION=3.
- `com/module/PriceModule.as`: Uridium para birimi 1.
- `net/netty/handlers/KillScreenPostHandler.as` ve `KillScreenOptionHandler.as`: native kart kurma, fiyat ve yerelleştirilmiş `%COUNT%` yer değiştirmesi.
- `gui/windows/components/Killscreen.as`: seçimin gerçek `KillScreenRepairRequest` gönderimine bağlanması. Yetersiz Uridium kartı kırmızıdır; aynı sınıf yalnız kredi kartlarını kesin devre dışı bırakabildiğinden, desteklenmeyen harita/oturum seçenekleri hiç gönderilmez.
- `net/netty/handlers/VisualModifierHandler.as`: 33 numaralı INVINCIBILITY için kalıcı native aç/kapat efekti. Sunucu 10 saniyelik korumaya aynı efekti bağlar; tek seferlik üç saniyelik ISH animasyonunu taklit etmez.

`respawn.js` imha kaydını oyuncu nesnesi, gemi, harita ve o anda bağlı oturumlarla ilişkilendirir. Paket içindeki kullanıcı kimliği, canlı oturum sahipliği, gerçek aktif gemi ve veritabanındaki sıfır can durumu kontrol edilir. Bakiye, can ve hedef konum tek SQLite işleminde kalıcılaşır. İşlem başarısız olursa oyuncu belleği ve ödeme değişmez. Aynı tamir paketinin tekrarında veritabanındaki canlı gemi tekrar ücretlendirmeyi engeller. Başarılı kalıcı geçişin ardından native harita kurulumu gönderilir; bağlantı gönderimi başarısız olsa dahi yeniden girişte kaydedilmiş canlı gemi gelir. Ağ gönderimi veritabanı işlemi içinde yapılmaz.

Ek bir tamir bekleme süresi eklenmemiştir: bu sürüm için doğrulanmış bir sunucu bekleme sayısı bulunmamaktadır. Koruma süresi çalışma anına aittir ve yeniden girişte devam etmez. Yalnız yerel tek oyunculu/NPC savaşı kapsamındadır.

`tests/respawn.test.js` gerçek paket kodlayıcı ve bellekte SQLite ile native fiyatları, doğru konumu, yetkisiz/tekrar/eksik bakiye isteklerini, ücret+can+konum geri almasını, oturum değişimini ve galaksi kapısı engelini denetler. Görsel Flash oturumu doğrulaması ayrıca yapılmalıdır.
