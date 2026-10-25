# Korsan NPC özel saldırıları

20 Ekim 2026. `game/npc-special-attacks.js`, normal haritalardaki **temel** Saboteur, Barracuda ve Annihilator'a uygulanır. Üçünün normal nüfusu/istatistikleri mevcut katalogdan gelir. Kapı varyantları ve Uber türler bu çalışmada aile adına bakılarak aynı yetenekleri devralmaz. Çok oyunculu/PET hedefli özel saldırı sistemi değildir.

## Kaynakla doğrulanan davranış

[Resmî İspanyolca NPC FAQ](https://board-es.darkorbit.com/threads/faqs-aliens.135697/), Saboteur vuruşunun hızı düşürdüğünü ve EMP'nin bunu temizlediğini; Barracuda'nın düşük canda yaklaşık10 saniye sonra veya gemiye yaklaşınca patladığını ve yaklaşık%20 hasar verdiğini; Annihilator'ın Hellstorm kullandığını açıklar. Kaydedilmiş metin: `decompiled/gate-source-evidence/npc-es.txt:1006–1052`. Bu sayfa kesin yavaşlama katsayısı/süresi, patlama eşiği/yarıçapı/hasar tabanı ve Hellstorm adet/döngü formülünü vermez.

Mevcut decompile kanıtı yeniden kullanıldı; yeni SWF yaması yapılmadı:

| İşlev | Gerçek istemci sözleşmesi |
|---|---|
| Yavaşlatma görseli | `0\|n\|fx\|start\|SABOTEUR_DEBUFF\|oyuncuId`; kaldırma `end`. `MapEventsAssembly.as:273–328`, `SlowDownEffect.as:11–13`. |
| Hareket hızı | `AttributeShipSpeedUpdateCommand {newSpeed,displaySpeed}`. Handler gerçek MoveTrait hızını ve bilgi panelini günceller. `AttributeShipSpeedUpdateHandler.as:18–22`, `SetAttributeAssembly.as:440–445`. |
| Patlama hazırlığı | `0\|n\|fx\|start\|KAM\|npcId`: kamikaze **sesi**; geri sayım animasyonu değildir. `MapEventsAssembly.as:315–317`. |
| Patlama | Önce `0\|n\|BOOOM\|npcId`, sonra `ShipDestroyedCommand` ve kaldırma. `MapEventsAssembly.as:204–215`; tür6=`explosion0`+shockwave2 (`game.xml:10273–10274`). ShipAssembly ölüm paketinin tür alanını yok saydığı için BOOOM gereklidir. |
| Hellstorm | `HellstormAttackCommand {attackerId:npcId,targetId:oyuncuId,hit,currentLoad:5,rocketType:{typeValue:21}}`. `HellstormAttackHandler.as:16–23`, `RocketLauncherAssembly.as:61,81–100`: her iki kimlik genel harita varlığıdır; ammo21 görsel7 olur. |

AS yolları `decompiled/main/scripts/net/bigpoint/darkorbit/` altındadır; `game.xml`, `decompiled/pet-patterns/` altındadır. Bunlar statik istemci kanıtlarıdır; özgün sunucu AI algoritmasının decompile'ı değildir.

## Açık yerel ayarlar

`config.json` içinde isteğe bağlı `normalNpcs` nesnesiyle değiştirilebilir:

| Ayar | Varsayılan ve anlam |
|---|---|
| `saboteur.speedMultiplier` / `durationMs` | Hız×0.3,5000ms. İsabet eden lazer süreyi yeniler; katsayı üst üste katlanmaz. Miss/instashield etkisinde yavaşlatma uygulanmaz. |
| `barracuda.triggerHullFraction` / `fuseMs` | Can≤%10 olduğunda10000ms fitil. |
| `barracuda.contactRadius` / `blastRadius` |150 mesafede erken patlama,500 mesafede hasar. Fitil bitince uzakta da yok olur; menzil dışındaki gemiye hasar vermez. |
| `barracuda.damageHullFraction` | Azami gemi canının%20'si taban hasar; mevcut kalkan emilimi ve savunma becerileri uygulanır. Kaynaktaki yaklaşık%20'nin hangi tabana/kalkana göre olduğu açık olmadığından bu formül yereldir. |
| `annihilator.rounds` / `cooldownMs` |5 roket,5000ms salvo aralığı. Katalogdaki damageMin/Max **tüm salvo için bir kez** çekilir; roket başına çarpılmaz, ek lazer hasarı üretilmez. Bu sıklık kaynakla doğrulanmış özgün DPS değildir. |

Hellstorm hasarı aynı `projectiles.flightMs` hesabıyla son roketin varışında çözülür. 2D/3D minimumları ve salvo gecikmeleri korunur. İsabet bir kez çekilir; çarpma anındaki instashield dikkate alınır. Ölüm, atlama, çıkış, harita/oyuncu/nesil nesnesi değişimi eski vuruşu iptal eder. NPC kendi cephanesini kullanır; oyuncunun stoğundan düşmez. İstasyon barış alanında saldırmaz.

`player-speed.js`, yavaşlatma ve Lightning çarpanlarını temel ekipman hızına uygular. Konfigürasyon/cevher/destek güncellemesi etkileri silmez veya katlamaz. Mevcut hareketin kalan süresi gerçek sunucu konumundan hesaplanır. EMP ancak başarılı stok/bekleme kaydından sonra temizler. Süre bitişi, ölüm ve harita/oturum temizliği özgün hızı geri getirir; düşük hız kalıcı gemi istatistiği olarak kaydedilmez.

## Kalıcılık ve ödül

015 migration'ı `normal_spawn_state.self_destruct_at` alanını ekler. Fitil uyarıdan önce kaydedilir; harita/oturum dönüşünde aynı son tarih yüklenir. Çevrimdışında patlama simülasyonu çalışmaz; geçmiş son tarih ilk etkin AI adımında çözülür. Yeni nüfus neslinde fitil sıfırlanır.

Kendi kendine patlama, nüfus neslini normal yeniden doğma beklemesine geçirir. **Yerel ödül politikası:** para, XP, diroit/PET deneyimi, görev öldürmesi veya kargo vermez. Fitil bitmeden oyuncunun gerçek öldürmesi normal tek ödülü verir. Emeklilik kaydı başarısız olursa patlama/hasar/yeniden doğma duyurulmaz; aynı neslin tekrar patlama hasarı vermesi engellenir. Hesaplara test eşyası/seviye/beceri verilmez.

## Doğrulama ve kalanlar

`tests/npc-special-attacks.test.js`, gerçek codec ile hız/hareket, süre, EMP stok hatası, Lightning/stat yenileme, ölüm/temizlik, salvo uçuşu/bekleme/isabet/koruma, eski hedef/atlama, patlama yarıçapı/ödül/tek nesil/kalıcılık ve SQL geri alımını doğrular. `tools/test-network-pirates.js`, bellek DB'sindeki gerçek HTTP/TCP akışına bağlıdır: lazer→yavaşlatma, gerçek EMP menü isteği→temizleme, gecikmeli NPC Hellstorm vuruşu ve doğru BOOOM→ölüm sırası.

Uber ve gate özel saldırıları, PET hedefli özel salvo/yavaşlatma, diğer klasik/modern NPC becerileri ve özgün sayısal AI dengesi tamamlanmış sayılmaz. Flash üzerinde görsel oynanış doğrulaması yapılmadı; paketlerin çözülebilmesi görsel uçtan uca test yerine geçmez.
