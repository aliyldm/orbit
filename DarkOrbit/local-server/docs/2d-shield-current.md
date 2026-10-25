# 2D kapsamı ve ArGe kalkan çarpması — 23 Ekim 2026

Kullanıcı 2D uyumunun gemi dışındaki diroit/NPC/lazer/ArGe efektlerini de kapsayıp kapsamadığını ve dış kalkan çarpmasını sordu. Bu tur çalışma kodu/SWF/hesap/dağıtım değiştirilmedi. Bir önceki2Ddağıtımı PID9940,855test olarak geçerlidir.

## ArGe'de hatırlanan iki ayrı görsel

[Resmî Pilot BIO FAQ](https://board-en.darkorbit.com/threads/pilot-bio-skill-tree-faq.1224/) ve [ikinci resmî açıklama](https://board-en.darkorbit.com/threads/skill-tree-pilot-bio-faq.1017/): Shield Engineering5/5 baloncuk; Shield Mechanics5/5 beyaz kalkan koruması. İstemcinin Türkçe adları Kalkan enerjisi (ID17) ve Kalkan sıklığı (ID8). Mevcut `game/shield-visuals.js` ikisini bağımsız kontrol eder. Beyaz çarpma için atışın HEDEFİNİN ID8'i5olmalı, hedef canlı ve kalkanı pozitif olmalıdır; ateş edenin kalın lazer becerisinden alınmaz.

`asd` oyuncu2'nin mevcut seviyeleri salt okunur denetlendi: ID17=5, ID8=4,22a=2,22b=3. Dolayısıyla baloncuk ve kalın lazer koşulu var; beyaz çarpma için ID8henüz eksik. Kullanıcı puan harcama/bedelsiz beceri verme istemediği için beceri değiştirilmedi.

Kurulu MAIN'den yeniden dışa aktarılan `LaserSalvo2D` (decompiled/2d-shield-audit/current): `showShieldDamage` bayrağı düşük gemi kalitesinde kapatılır. Diğer kalitelerde lazer varışında gerçek `shieldDamage.mc` hedef yarıçapına göre ölçeklenip atış yönüne yerleştirilir. `framesLoaded / 30` süreyle oynatılır. Yerel `client/spacemap/graphics/shields/shieldDamage.swf` mevcut;9karelik mcJPEXSile dışa aktarıldı. Bir kare: `decompiled/2d-shield-audit/shieldDamage/DefineSprite_19_mc/4.png`. Bu resim oyun ekranı değil, doğrudan asset karesidir. Tam kalkan baloncuğu `ShieldEffect2D` tarafından ayrı oynatılır/soldurulur.

## 2D kapsamındaki kanıt

| Yol | Denetlenen davranış / sınır |
|---|---|
| NPC/gemi | Aynı Ship2D/ShipClip descriptor çizim yolu ve kaliteye bağlı gerçek/yedek asset. NPC sayısı, yapay zekâ ve tüm modern türlerin görsel eşitliği bu kaynak yolundan kanıtlanmış sayılmaz. |
| Diroit/tasarım | Drone2D yüksek gemi kalitesinde descriptor assetini; diğerlerinde replacementShips'i seçer. Gerçek drone/design descriptorları kullanılır. Görünürlük ve kompakt renkli satır mevcut testlerle doğrulanır. |
| Lazer/ArGe | Native LaserSalvo2D, geminin namlu grupları, skilledLaser'dan skillResKey; kaliteye göre shieldDamage ayrımı. Özgün sunucunun tüm kademe/equip eşiği formülleri değil, mevcut kaynak ve yerel açıklanmış kademe seçimi doğrulanmıştır. |
| Roket | Rocket2D, uygun smoke/heat bayrakları ve gerçek2Dflight süresi; önceki renderer düzeltmesi korunur. |
| Kalkan | ID17baloncuk ve ID8çarpma ayrı, hedef odaklı. Kalkan boş/ölüyken kapalı. Düşük kalite çarpma ayrıntısını gizler. |

Yeni exportlar: LaserSalvo2D,ShieldEffect2D,Drone2D,DronesFormation2D,Rocket2D; `logs/2d-shield-export.log`. `logs/2d-shield-asset-export.log`9assetkaresi. `logs/2d-shield-recheck.log` **32/32ilgili test**: kalkan görselleri,2Dmod/kalite,ayarlar,namlu/kalın lazer ve roket görselleri yeniden geçti. Mevcut kalkan testleri gerçekNPC→kahraman AttackLaserRun bayrağını,5.seviyeye öğrenmeyi/sıfırlamayı,boşalma/yenilenmeyi ve NPC/PETbeceriayrımını içerir.

Gerçek Qt ekranına/sesine girdi verilmedi. Bu denetim bütün modellerin/kalite seviyelerinin ekranda birebir oynatıldığı iddiasını desteklemez. Genel “her şey orijinalle birebir” onayı vermeyin. [Önceki2Ddağıtımı](classic-2d-current.md) ve [ana açık işler](second-completion-work.md) korunur.
