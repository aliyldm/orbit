# Payment kaplamaları ve destek işlevleri — 21 Ekim 2026

PET kaplamaları artık satın alma sonrası hangardaki **görsel** yuvasına takılır. Her konfigürasyonda bir kaplama bulunabilir; aynı fiziksel eşyanın sahiplik/konfigürasyon kuralları diğer ekipmanlarla aynıdır. `023-pet-appearance.sql`, mevcut bütün PET ekipman satırlarını koruyarak görsel yuvasını açar.

`tools/export-pet-appearances.js`, gönderilmiş `decompiled/pet-patterns/game.xml` dosyasındaki sayısal PET model kimliklerini katalogla eşleştirir. Yorum satırları çıkarılır, belirsiz eşleşmeler üretimi durdurur. Dosya özeti ve 122 kaplamanın eşleştirmesi `game/data/pet-appearances.json` içinde tutulur. Bunlar adlardan tahmin edilmiş yeni model numaraları değildir. Eski Frozen/Red/Green ve Phoenix iç içe modelleri de kaynakta vardır. Normal Goliath-X, kaynaktaki 185 numaralı PET modeline açıkça eşleştirilir.

`PetHeroActivationHandler.as`, `shipType` alanını doğrudan `createPet` model anahtarı olarak kullanır. Bu yüzden aktivasyon, yeniden bağlanma ve seviye artışında takılı model gönderilir. Canlı kaplama değişikliği modelin yeniden oluşturulmasını sağlar; yakıt, HP, XP doldurulmaz. Görsel kaplamaya kaynakta bulunmayan hasar/kalkan bonusu eklenmez. Native hangarın gemi ayrıntı paketi de sahip olunan tasarımları ve etkin tasarımı gösterir.

Desteklerde, `ItemDataProvider` kaynaklı yeni tüketiciler:

- DMG-H01: %2 hasar, lazer ve roket isabetine 8 yüzde puan. Lazer, normal roket ve Hellstorm için gerçek isabet hesabına bağlanır. Kaynak faktörleri doğrulanmıştır; farklı isabet katkılarının toplanması yerel birleşim kuralıdır.
- CD-B01/B02/DLB: kaynak %20/%30/%5 bekleme süresi indirimi, yeni etkinleştirilen klasik gemi yeteneğinin gerçek kalıcı süresine uygulanır. Önceden başlayan süre yeniden yazılmaz. Aynı anda farklı destek yüzdeleri toplanır; bu yerel birleşim kuralıdır.
- PET EP-B01: gerçek PET TP kazanımına %5 katkı, sahip oyuncunun TP'sini ayrıca artırmaz.
- Paket içeriğindeki saatler tam korunur: örneğin Powerup2025 SHD-B02 **5 saat**. `boosterHours` sadece sunucudaki doğrulanmış paketten okunur; HTTP isteğinden süre kabul edilmez.

PvP ve kaynak düşme şansına bağlı etkinlik destekleri hâlâ ayrı kapsamdır. Çok oyunculu sistem eklenmez. B02 alan paylaşımı yerine tek oyuncunun kaynak kişisel etkisi kullanılır.

Doğrulama: `tests/pet-appearance.test.js`, `tests/systems-boosters.test.js`, `tests/ship-abilities.test.js`; gerçek codec, sahiplik, iki konfigürasyon, kayıtlı düzen, model değişikliği, TP, saat ve süre sonu kontrolleri. Sadece bellek içi hesaplar kullanılır.
