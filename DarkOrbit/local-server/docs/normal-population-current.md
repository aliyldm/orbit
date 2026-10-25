# Normal harita nüfusu — 23 Ekim 2026

Kullanıcının büyük NPC azlığı bildirimine göre yerel nüfus dengesi değiştirildi. Türlerin özgün harita üyeliği korunur; bu sayılar orijinal sunucu nüfus değerleri olarak sunulmaz. Üç şirketin karşılık gelen haritaları aynı profili kullanır.

| Harita | Değişen tür | Önce → sonra |
|---|---|---:|
| x-3 | Devolarium | 12 → 16 |
| x-4 | Sibelon | 12 → 16 |
| x-5 | Lordakium | 5 → 12 |
| x-5 | Lordakia / Sibelonit | 12 / 18 → 8 / 12 |
| x-6 | Kristallon | 3 → 12 |
| x-7 | Kristallon | 5 → 18 |
| x-7 | Kristallin | 20 → 12 |
| 5-1, 5-2, 5-3 | Annihilator | 3 → 6 |

Diğer normal/Boss/Uber tür adetleri, yeniden doğma süreleri, katalog savaş değerleri, kargolar ve saldırganlık değişmedi. 4-1…4-4'e veya kapı/etkinlik/BL haritalarına varsayımsal kalıcı tür eklenmedi. Bütün profillerin bağımsız kalıcı slot toplamı 951; Cubikon/Battleray muhafızları bu toplama dahil değildir. Solo sunucu yalnız etkin haritayı çalıştırır.

## Kalıcı verilerin korunması

`normal-population-2026-10-23-v3` içerik işaretiyle işlem bir kez uygulanır. Önceki nüfus satırları `normal_world_versions.previous_content_json` içine kaydedilir. Güncelleme artık sadece x-3/x-4'ü değil, profil tablosundaki bütün normal haritaları kapsar.

Mevcut `map_spawns.id` satırında yalnız `count` güncellenir. NPC'nin oyuncuya özgü can/kalkanı, konumu, nesli, gerçek respawn beklemesi `normal_spawn_state` içinde aynı anahtarla kalır. Sayısı azalan eski slotlar silinmez; runtime yeni sayı aralığının dışındakileri çalıştırmaz. Katalog dışı özel spawn satırları korunur. İkinci açılış sonraki özel nüfus ayarlarını geri yazmaz.

Eksik katalog satırı eklenirken ilk dünya kurulumuyla ortak `spawnBehavior` kullanılır. Bu, yeni Cubikon satırına hasarda çıkan Protegit ve Battleray satırına sürekli Interceptor/protection/heal davranışının eksik eklenmesini önler. Muhafızlar bağımsız kalıcı satır olarak eklenmez. Savepoint, önceki adet güncellemeleri ve sürüm kaydını birlikte geri alır.

## Testler

`logs/normal-population-current-tests.log`: **27/27 PASS** (`normal-map-spawns`, `normal-population-update`, `normal-world`, `normal-map-runtime`). 4 yeni test bütün şirketlerde hedef adetleri ve tür üyeliğini; önceki sürümden bir kez güncelleme ve NPC hasar/respawn/nesil/oyuncu/gemi/eşya korunmasını; eksik Cubikon/Battleray davranışını; başarısız geçiş rollback'ini doğrular. Mevcut runtime testleri harita değişimi/DB yeniden açma sonrasında gerçek nüfusun çoğalmamasını ve beklemelerin korunmasını denetler. Testler bellek/geçici DB kullanır; bu alt çalışma canlı DB'yi veya sunucuyu değiştirmedi.
