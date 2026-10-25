# Kalıcı oyuncu boosterları

`game/boosters.js` ve migration `012-boosters.sql`, ödenen oyuncu boosterlarını `player_boosters(player_id,loot_id,expires_at)` defterinde saklar. Yeni hesaba kayıttaki günlük giriş boosterı veya ücretsiz süre aktarılmaz.

## Kaynak ve protokol

Saat ve kişisel etki yüzdeleri, mevcut istemci kataloğundan çıkarılmış `docs/client-map.items.json` içindeki `kind=Booster`, `hours`, `boostList.type/factor` alanlarından okunur. Örneğin DMG-B01 10 saat ve %10 hasar, SHD-B01 %25 kalkan, EP-50 24 saattir. Sabit oran uydurulmaz. Kaynak sınıfları `decompiled/main/scripts/net/bigpoint/darkorbit/` altında:

- `items/item/attributes/BoosterAttributes.as`, `Boost.as`: süre, kişisel factor ve ayrı areaFactor.
- `com/module/AttributeBoosterUpdateCommand.as`, `BoosterUpdateModule.as`, `BoosterPlayerDetailModule.as`: güncel toplam yüzde, sahip olunan lootId ve kalan saniye.
- `net/netty/handlers/AttributeBoosterUpdateHandler.as`, `mvc/booster/model/BoosterModel.as`: ayrıntı anahtarı modül sınıfı ve lootId birleşimidir. Süresi biten kişisel booster aynı `BoosterPlayerDetailModule` sınıfıyla kaldırılır; sahte grup ayrıntısı gönderilmez.

Desteklenen kişisel özellikler EXPERIENCE_POINTS, HONOUR_POINTS, DAMAGE, DAMAGE_NPC, HITPOINTS, SHIELD, REPAIR, SHIELD_REGENERATION, COLLECT_RESOURCES, COLLECT_RESOURCES_NEWBIE, LASER_HIT_CHANCE, ROCKET_HIT_CHANCE, ABILITY_COOLDOWN_TIME ve PET_EXP_BOOSTER'dır. PvP ve rastgele etkinlik düşürme etkili desteklerin aktivasyonu reddedilir. B02 kişisel faktörü uygulanır; grup alanındaki `areaFactor` ve başka oyunculara paylaşım bu tek oyunculu uygulamada üretilmez.

## İşlem ve uygulama

Shop ödeme işleminin içinde `addOwned(db,id,lootId,amount)` çağrılır. Süre aynı tür için mevcut aktif bitişe eklenir; türün yüzdesi tekrar satın alınca çoğalmaz. Ödeme commit edildikten sonra `purchased(world)` canlı istatistiği ve gerçek protokol ayrıntılarını yeniler. Hatalı miktar, aşırı uzun süre veya SQL hatası işlemi geri alır.

Oyuncu yüklenirken drone, skill ve cevher istatistiklerinin üzerine kişisel booster etkileri bir kez uygulanır. NPC hasarı iki silaha, genel hasar lazer/rokete; HP/kalkan azami değerlere; tamir/yenilenme mevcut kaynak formüllerine çarpan olarak bağlanır. XP/onur NPC/kutu, görev ve kapı ödüllerinde bir kez artırılır. COLLECT_RESOURCES cevher/kargo ve bonus kutuya; COLLECT_RESOURCES_NEWBIE yalnız bonus kutuya uygulanır. Başlangıçtaki boş booster durumu gereksiz hareket durdurma/istatistik yenilemesi yapmaz.

Yerel süre politikası duvar saatidir: çevrimdışıyken süre işler ve yeniden başlatma süreyi sıfırlamaz. Katalog saatleri doğrulanmıştır; canlı sunucunun çevrimdışı zaman sayma kuralı bu kayıttan doğrulanmamıştır. Farklı lootların aynı özellik yüzdeleri toplanır; ayrı kategorilerin çarpanları çarpılır. Bunlar açık yerel birleşim politikalarıdır.

Önceki sürümlerde ödenmiş ama zaman damgası olmayan loose inventory boosterları otomatik aktifleştirilmez. `adoptInventory(db,id)` yalnız açık bakım işlemiyle, dış transaction içinde çağrılır; eski satırları silerek aynı ürünü iki kez aktarmayı önler. Başlangıç zamanı bakım anıdır.

## Doğrulama

`tests/systems-boosters.test.js`: kaynak süre/yüzdeler, sahiplik, süre uzatma, çevrimdışı sona erme, etki birleşimi, gerçek codec gidiş/dönüş, desteklenmeyen etki reddi, ödeme/ledger rollback, canlı güncelleme ve bitişte kaldırma, eski ücretli stokun bir kez aktarımı, ilk tick hareketinin korunması. Görev ve kapı testleri gerçek tamamlama sırasında XP/onur artışının bir kez uygulandığını da denetler.

21 Ekim ekleri: isabet/klasik yetenek cooldown/PET TP tüketicileri ve tam saatli paketler için `payment-cosmetics-boosters.md`.
