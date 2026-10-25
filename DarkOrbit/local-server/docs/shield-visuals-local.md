# Azami kalkan becerilerinin görselleri

Bu istemcinin Türkçe ağacındaki **Kalkan enerjisi** (kaydedilmiş beceri ID17; İngilizce Shield Engineering) ve **Kalkan sıklığı** (ID8; Shield Mechanics) iki ayrı görsel açar. Her biri kendi becerisinin 5/5 olmasını gerektirir; diğerinin azami olması koşul değildir. Bu ayrım resmi [Pilot BIO Skill Tree FAQ](https://board-en.darkorbit.com/threads/pilot-bio-skill-tree-faq.1224/) ve [Skill Tree/Pilot Bio FAQ](https://board-en.darkorbit.com/threads/skill-tree-pilot-bio-faq.1017/) ile doğrulandı: mühendislik baloncuk, mekanik beyaz kalkan korumasıdır. Kalın lazerin ArGe koşulu bu iki kalkan görselinin yerine kullanılmaz.

`game/shield-visuals.js` gerçek öğrenilmiş seviyeyi DB'den okur. Kalkanı sıfır olan veya ölü gemide görseli etkinleştirmez. NPC ve PET hedefleri oyuncunun becerilerini devralmaz. Var olan sayısal kalkan gücü/emilim bonusları `skills.applyStats` içinde kalır; yeni görsel bayrakları hasara fazladan çarpan eklemez.

## Kaynak ve protokol kanıtı

Kaynaklar `decompiled/main/scripts/net/bigpoint/darkorbit/` altındadır:

- `net/netty/handlers/attribute/AttributeSkillShieldUpdateHandler.as`: `shieldSkillId` alanını boolean yapar ve min/max twinkle alanlarıyla `SetAttributeAssembly.assembleShieldSkillUpdate` çağırır.
- `net/SetAttributeAssembly.as:315`: true olduğunda kahramana kalıcı `ShieldEffect` ekler; false olduğunda aynı efekti kaldırır. Sunucu `AttributeSkillShieldUpdateCommand {shieldSkillId:1|0,minSkinShieldTwinkle:10,maxSkinShieldTwinkle:100}` gönderir. Aktif değer1, istemcinin açık boolean dönüşümüne dayanır; aktif canlı paket kaydı kurtarılmış değildir.
- `map/view2D/effects/impl/ShieldEffect2D.as`: baloncuğu oynatıp soldurur, kalıcı efekti yeniden gösterir. `map/view3D/effects/impl/ShieldEffect3D.as`: `shield_infinity.zip` kullanır. Böylece kaynakta bulunan baloncuk kullanılır; yeni boyut veya sahte sürekli kabuk üretilmez.
- `net/netty/handlers/ShipSelectionHandler.as`: hedefin `ShipSelectionCommand.shieldSkill` bayrağıyla geçici `ShieldEffect` oynatır. Yardımcı modül bu bayrağın sahip olunan gerçek hedefte ID17'ye göre hesaplanmasını sağlar. Mevcut solo seçim yolu NPC seçer ve NPC için false gönderir; başka gerçek oyuncu seçimi/multiplayer eklenmiş değildir.
- `net/netty/handlers/combat/AttackLaserRunHandler.as`: `AttackLaserRunCommand.isDiminishedBySkillShield` alanını `LaserEffect.showShieldDamage` olarak kullanır. Bu alan **vurulan hedefin** ID8 seviyesinden hesaplanır; ateş edenin becerisinden alınmaz.
- `map/view2D/effects/combat/laser/LaserSalvo2D.as:514`: bu bayrakla gerçek `shieldDamage` klibini hedef yarıçapına göre ölçekler ve atış yönüne yerleştirir. `map/view3D/effects/combat/laser/LaserSalvo3D.as:414` / `ShieldImpactEffect.as`: kaynak shield pattern'ın skilled etkisini seçer. `game.xml` varsayılan pattern'ı `impact_shield.zip` / `impact_shield_skill.zip` olarak tanımlar.

`logs/full-dump.json` içinde 17 adet `AttributeSkillShieldUpdateCommand` kaydı bulunur; hepsi kapalı0 ve min/max10/100 taşır (ilk örnek seq184). Zaman alanları bu kayıttan korunmuştur. İncelenen `ShieldEffect` constructor'ı max alanına da min parametresini yazar; istemcinin bu davranışı sunucuda uydurma başka bir formülle değiştirilmedi.

## Çalışan güncellemeler ve doğrulama

Başlangıç `skills.buildInit` üzerinden kahraman sahnesi oluşturulduktan sonra tek attribute komutu gönderir. Gerçek ArGe yükseltme ve sıfırlama zaten aynı akışa bağlıdır. `World.refreshStats` ekipman/konfigürasyon değişiminden sonra yeniden denetler. Combat tick'i kalkanın boşalma/dolma geçişlerini izler; değişmeyen baloncuk durumunu her saniye tekrar göndermez. Ölümde hemen kapatma, tamir/yeniden girişte sahip olunan durumun tekrar kurulması vardır. Mekanik yön efekti, her gerçek NPC→kahraman lazer paketinde güncel seviyeye göre hesaplanır. Lazer rengi, `skilledLaser` ve gemi expansionStage davranışı korunur.

`node --test tests/shield-visuals.test.js`: 7 test; bağımsız 4/5–5/5 koşulları, gerçek codec, kahramandan sonraki init sırası, gerçek son beceri yükseltmesi, canlı sıfırlama, NPC→kahraman savaş paketi, NPC/PET ayrımı, boşalma/yenilenme/ölüm ve ekipman değişimi doğrulanır. Flash üzerinde görsel uçtan uca doğrulama yapılmadı; kaynak istemci kendi kalite/efekt ayarlarına göre çizim yapar.
