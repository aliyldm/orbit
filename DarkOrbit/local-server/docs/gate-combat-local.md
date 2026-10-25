# Galaksi kapısı savaş entegrasyonu

`combat.js`, `hellstorm.js`, `pet.js`, `combat-utilities.js` ve `ship-abilities.js` artık NPC tanımındaki `shieldAbsorb`, `aggressive`, `speed` ve koruma durumunu ortak kullanır. NPC temel değerleri `npc-catalog.js`, dalgalar/koruma bağımlılıkları `galaxy-gates.js` tarafından sağlanır; bu savaş modülleri kendiliğinden NPC gücü veya dalga üretmez.

## Kalkan dağılımı ve silah yolları

2016 tarihli resmi forumda Board Administrator'ın [NPC hasar dağılımı açıklaması](https://board-de.darkorbit.com/threads/schadensverteilung-von-npcs.107632/) kapılardaki 50/50 dağılımı ve normal haritalardaki 80/20 dağılımı ayırır. Bu tarihsel temel, katalogdan gelen `def.shieldAbsorb=.5` ile uygulanır. Katalog dışındaki normal harita NPC'lerinde mevcut `config.combat.npcShieldAbsorb` (varsayılan .8) korunur. Doğrulanmamış güncel NPC istisnaları uydurulmaz.

`Combat.npcAbsorb(npc)` bu değeri belirler. Kahraman lazerleri, standart roketler, Hellstorm, PET lazerleri ve normal patlama aynı dağılımı kullanır. Lazer kalkan delme etkisi bu tabandan çıkarılır. Örneğin yeterli kalkanı olan hedefe 1000 normal hasar: kapıda 500 kalkan/500 can; normal harita varsayılanında 800 kalkan/200 can.

SAB ve SAR cephanesi mevcut sözleşmesine uygun biçimde yalnız gerçek mevcut kalkanı emer, kendi kapasitesine kadar aktarır; sırf 50/50 oranı nedeniyle gövde hasarına dönüştürülmez. Doğrudan can mayını/Venom ile kalkan yüzdesi mayını kendi açık etkilerini korur. Kalkanı olmayan SAB/SAR hedefinde sahte sıfır hasarlı `AttackHitCommand` gönderilmez; uygun miss cevabı kullanılır.

## Koruma ve hedef yaşam döngüsü

`Combat.npcProtected(npc)`, `npc.def.invulnerable` ve varsa `galaxy-gates.isProtected(world,npc)` sonucunu denetler. Kapı modülü kendi kalıcı muhafız/escort bağımlılıklarını değerlendirir. `galaxy-gates.refreshProtection(world,combat,now)` varsa her savaş tick'inde çağrılır; görsel koruma yenilemesi kapı modülüne aittir.

Ortak hasar fonksiyonları ile doğrudan kalkan/can yazan tüm yollar koruma kontrolünden geçer: lazer/SAB, roket, Hellstorm/SAR, PET, normal/kalkan/doğrudan mayın, SMB ve Venom. Korumalı NPC gerçek hasar veya aktarım almaz; sahte hasar/ölüm/ödül üretilmez. Atış başlamadan korumalı olduğu bilinen roket/HST ve lazer/PET hedefinde cephane tüketilmez. Çoktan yola çıkmış roketin hedefi sonradan korunursa çarpmada miss oluşur; ateşlenmiş cephane iade edilmez. Aktif Venom korunurken vuruş biriktirip koruma sonrasında toplu hasar vermez.

Sıfır canla kalmış veya kaldırılmış hedefe yeni saldırı başlatılmaz; artık bulunmayan otomatik lazer hedefi bir kez iptal edilir. Kaynak yeniden doğma/oturum/harita nesne kimliği korumaları mevcut gecikmeli roket sisteminde korunur. Kapı modülü bir ölümün ödülünün önceden alındığını `gateKillRewardClaimed=false` ile bildirirse NPC kaldırılabilir fakat ikinci kargo, görev olayı veya diroit XP'si üretilmez.

## Takip ve sabit taretler

`def.aggressive=true` NPC doğarken mevcut gerçek oyuncuyu hedefler. Kilidi boşaldığında geçerli, canlı ve atlamayan oyuncuyu tekrar bulur. Bu NPC'ler yalnız mesafe 2500'ü geçti diye takibi bırakmaz; normal harita NPC'lerinin eski takip sınırı korunur. `speed=0` NPC hareket komutu üretmez; gezinme veya takip çağrısı taret konumunu değiştiremez.

Takip kararlarının saniyelik tick'i, rastgele yaklaşma ofseti, ateş mesafesi ve yeniden hedefleme sıklığı mevcut yerel AI politikasıdır; resmi sunucu AI'sının bütünü kurtarıldı diye sunulmaz. Doğrulanmamış 300.000 hasarlı boss burst zamanlayıcıları veya bilinmeyen özel saldırı değerleri eklenmedi.

`node --test tests/gate-combat.test.js`: 11 test; silahlar arasında karşılaştırmalı 50/50, gerçek gecikmeli roket/HST çarpması, sonradan gelen koruma, kalkan aktarımı, cephane güvenliği, PET, doğrudan/kalkan mayını, Venom, geçersiz hedef, saldırgan takip, sabit taret, kapı koruma adaptörü ve yinelenmiş gate-slot ölümünde kargo/görev/diroit tekrarının engellenmesi doğrulanır. Komutlar gerçek codec'ten geçirilir. Flash görsel uçtan uca doğrulaması ayrıca gerekir.
