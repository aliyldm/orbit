# Kapı NPC kanıtları — 20 Ekim 2026

Bu araştırmada uygulama, SWF ve üretim veritabanı değiştirilmedi. Değerler
resmî SSS kayıtlarıdır; sunucu tarafındaki mevcut canlı oyunun ölçümü değildir.

## Hades

[İspanyolca oyun SSS'si, gönderi 10](https://board-es.darkorbit.com/threads/faqs-aliens.135697/)
ile [Fransızca moderatör NPC rehberi, gönderi 21](https://board-fr.darkorbit.com/threads/lexique-2-0-npc.132411/page-2)
can/kalkan değerlerini aynı verir. Fransızca rehber M-Lexique2.0, S-Moderator
Team Darkorbit tarafından yayımlanmış, 27 Aralık 2022'de güncellenmiştir.

| NPC | Can | Kalkan | İspanyolca SSS hasarı | Hız |
|---|---:|---:|---|---|
| Emperor Sibelon | 6.400.000 | 6.400.000 | yaklaşık 35.000 | belirtilmiyor |
| Emperor Lordakium | 9.600.000 | 6.400.000 | yaklaşık 45.000 | belirtilmiyor |
| Emperor Kristallon | 14.080.000 | 11.100.000 | yaklaşık 45.000 + 300.000 özel saldırı | belirtilmiyor |

Fransızca moderatör rehberindeki ödüller:

| NPC | TP | Şeref | Kredi | Uridyum |
|---|---:|---:|---:|---:|
| Sibelon | 409.600 | 2.048 | 1.400.000 | 4.608 |
| Lordakium | 786.000 | 4.096 | 2.000.000 | 9.216 |
| Kristallon | 1.536.000 | 8.192 | 5.000.000 | 36.864 |

## Kuiper

[İspanyolca oyun SSS'si, gönderi 11](https://board-es.darkorbit.com/threads/faqs-aliens.135697/):

| NPC | Can | Kalkan | Hasar |
|---|---:|---:|---|
| Soldier | 150.000 | 150.000 | 2.000–5.000 |
| Specialist | 450.000 | 300.000 | 5.000–7.000 |
| Turret | 300.000 | 300.000 | 3.000–5.000 ve yön değiştiren misil |
| Emperor | 650.000 | 700.000 | 2.000–3.000 |
| Rocketeer | 20.000 | 10.000 | tabloda 200 (misil) |

Rocketeer girişinde ayrıca füzenin 10.000 canı olduğu yazıyor; Seeker'ın tam
istatistikleriyle eşitlemek için yeterli açıklama yoktur. SSS hızları boş bırakır.
[Fransızca resmî Kuiper SSS'si](https://board-fr.darkorbit.com/threads/faq-portail-intergalactique-kuiper.110503/)
Turret'ın sabit olduğunu ve Seeker'ın ödülsüz kamikaze çocuk NPC olduğunu doğrular.
Seeker hasar/hız/can/kalkanı sayısal olarak kesinleşmedi.

[Fransızca NPC rehberi, gönderi 17](https://board-fr.darkorbit.com/threads/lexique-2-0-npc.132411/)
bu beş NPC'nin can/kalkanını destekler; ayrıca ikinci bir Turret satırında
800.000 kalkan yazar ve Specialist ödülünü 20 uridyum gösterir. İspanyolca SSS
Specialist için 200 uridyum yazar. Çelişki korunmalıdır; sessizce harmanlanmamalıdır.

## Gönderilen istemcide görsel kimliği

`decompiled/pet-patterns/game.xml` ana SWF'nin gömülü oyun XML'idir. Can/hasar
tablosu olarak kullanılmaz. Doğrudan bildirdiği görsel `type` / `npcId`:

| NPC | type | npcId | XML satırı |
|---|---:|---:|---:|
| Emperor Sibelon | 124 | 113 | 3424 |
| Emperor Lordakium | 123 | 114 | 3413 |
| Emperor Kristallon | 122 | 115 | 3405 |
| Streuner Emperor | 147 | 147 | 3482 |
| Turret | 148 | 148 | 3488 |
| Specialist / Technician | 149 | 149 | 3495 |
| Soldier / Warrior | 150 | 150 | 3502 |
| Rocketeer | 158 | 158 | 3525 |
| Seeker Rocket | 159 | 159 | 3532 |

151, Seeker değildir: XML satır 3509'da Demon Drone olarak tanımlıdır.

Zeta görselleri için `InGameCatalog.as` satır 1630–1635, adlandırılmış
`SHIPICON_IFREET_*` sabitlerini doğrudan ikon kaynaklarına bağlar:

| NPC | İkon kaynağı | Görsel type |
|---|---|---:|
| Scorcher | iconShip99 | 99 |
| Infernal | iconShip100 | 100 |
| Melter | iconShip102 | 102 |
| Devourer | iconShip105 | 105 |

`ShipIconModule.as` satır 229–235'te enum değerleri sırasıyla Infernal109,
Scorcher110, Melter111, Devourer112'dir. Bunlar görsel type kimliği değildir.
`game.xml` satır 3189–3234 bu type değerlerini ship99/100/102/105 kaynaklarına
bağlar. Aynı dosyada eski genel adlar bulunması, bu açık ikon eşlemesini geçersiz
kılmaz. Gerekli kanıt mevcut olduğundan ek SWF decompile veya üretim çalıştırması
yapılmadı.

Araştırma sınırı: resmî EN/DE/ES/FR/CZ/PL forum sorguları, resmî SSS sayfaları,
mevcut gömülü XML ve decompile edilmiş InGameCatalog/ShipIconModule incelendi.
İstemcinin paketle bildirdiği veya sunucuda sakladığı bilinmeyen değerler
tahmin edilerek resmî değer gibi sunulmadı.
