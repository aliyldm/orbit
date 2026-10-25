# ArGe roket izi ve ışığı

## Kaynakla doğrulanan koşullar

[Resmî Pilot BIO FAQ](https://board-en.darkorbit.com/threads/pilot-bio-skill-tree-faq.1224/) Rocket Fusion efektini azami seviyeye, Heat Seeking efektini ise beceri olmasa ıskalayacak olan bir roketin isabete dönüşmesine bağlar. Heat Seeking azami seviye gerektirmez; bonuslar 1/2/4/6/10 yüzde puandır. [İkinci resmî FAQ](https://board-en.darkorbit.com/threads/skill-tree-pilot-bio-faq.1017/) Rocket Fusion için 5/5 koşulunu ayrıca doğrular.

Bu istemcinin Türkçe beceri adları `skill-tree-data.json` içindedir: **Roket uzmanı** ID6 ve **Isı arayıcısı** ID20. Toplam dağıtılmış puan bu efektlerin koşulu değildir. Gerçek öğrenilmiş seviyeler her atışta okunur; yükseltme/sıfırlama sonrası tekrar giriş gerekmez.

## İstemci kanıtı ve seçilen alanlar

Kaynak kökü `decompiled/main/scripts/net/bigpoint/darkorbit/`:

- `net/ConnectionManager.as:571–595`, `0|v|attacker|target|H/M|rocketType|smokeId|heatSeeking` paketini çözer. Son iki alan `RocketEffect` constructor'ına aktarılır. Önceki sunucu ikisini daima 0 gönderiyordu.
- `map/model/effects/impl/combat/RocketEffect.as`, smoke ID ve heat seeking bayrağını ayrı saklar. `RocketEffect2D/3D` bunları gerçek çiziciye geçirir.
- `map/view2D/effects/combat/rocket/Rocket2D.as`, smoke pattern parçacıklarını üretir. Heat seeking açıkken `minePulse` klibini yükler, 16711680 yani kırmızıya boyar ve roket üzerinde nabız animasyonu oynatır; kavisli hareket dalı da aynı bayrağı kullanır.
- `map/view3D/effects/combat/rocket/Rocket3D.as`, smoke pattern'ın fx3D kaynağını ve heat seeking için kırmızı küreyi kullanır. Normal roketin 3D ışığı da vardır; her ışık ArGe'den gelmez. Parçacıklar istemcinin efekt kalite ayarına bağlıdır.
- `decompiled/pet-patterns/game.xml:10439–10448`: smoke0→rocketSmoke0/rocket_trail_1.zip; smoke1→rocketSmoke1/rocket_trail_2.zip; smoke2→rocketSmoke2/rocket_trail_3.zip. JPEXS26.3.0 ile üç SWF'nin iç `mc` sprite'ları çıkarılıp incelendi: sekizinci karede smoke0 gri, smoke1 mor/mavi, smoke2 kırmızıdır. Bu nedenle max Fusion için **smoke1** seçilir; sadece dosya numarasına bakarak smoke2 seçilmez.

Çıktılar `decompiled/rocket-visual-evidence/smoke{0,1,2}/DefineSprite_43_mc/` ve export günlüklerindedir. Smoke2 kök `1.png` sadece düz sahne arka planıdır, efekt kanıtı sayılmaz; iç sprite kareleri kullanılmıştır. `rocketSmoke1.swf` SHA-256: `09de9dc9b90ce6f68b7465ccd934bc5f8afa3eccff0d54cc18d3b34325feacef`. Kaydedilmiş `full-dump.json` paketleri kapalı0/0 örnekleridir; aktif1/1 paketi geçmiş canlı kayıtta gözlemlendiği iddia edilmez.

## Sunucu davranışı ve sınırlar

`game/rocket-visuals.js`, ID6=5 ise smoke1, aksi halde0 seçer. Tek rastgele örnek temel isabet sınırı ile ArGe eklenmiş sınır arasında kalırsa hem isabet hem heatSeeking=true olur. Normal isabet ışık yakmaz; gerçek ıskalama da yakmaz. Böylece becerinin toplam isabet bonusu korunur ve efekt için ikinci bir bağımsız RNG yapılmaz. Var olan roket hasar çarpanı tekrar eklenmez; hasar/ölüm/ödül mevcut uçuş sonunda çözülür.

**Mevcut temel yerel roket isabeti %100'dür** (`config.combat.rocketHitChance` verilmediğindeki varsayılan1). Bu ayarda becerinin kurtaracağı ıskalama yoktur, dolayısıyla kırmızı ArGe ışığı oluşmaz; sırf görsel için sahte kurtarılmış isabet üretilmez. Temel oran 1'in altında yapılandırıldığında ışık uygun atışlarda çalışır. Bu değişiklikte kanıtlanmamış mühimmat bazlı isabet oranları eklenmedi ve mevcut savaş dengesi değiştirilmedi. Mor iz bu sınırlamadan bağımsızdır.

Hellstorm'ın mevcut `HellstormAttackCommand`/`RocketLauncherAssembly` yolu smoke/heat seeking alanı taşımaz; tekli roket alanları bu pakete uydurularak eklenmez. Bu çalışma tekli gemi roketlerine uygulanır. Üretim hesabına beceri puanı, eşya veya ücretsiz seviye verilmez.

## Doğrulama

`tests/rocket-visuals.test.js`: 7 test; 4/5–5/5 sınırı, 1/5 ısı arayıcısı, normal/kurtarılan/ıskalanan atış ayrımı, deterministik isabet dağılımı, gerçek codec paketi, tek mühimmat tüketimi, %15 hasar bonusu ve gecikmeli çarpma, gerçek beceri yükseltme/sıfırlama, yerel 2D/3D kaynak eşleşmesi. Gerçek HTTP/TCP testinde ayrı bellek DB'sinde deterministic kurtarılan atış ve `...|H|1|1|1` paketi doğrulandı. Flash üzerinde canlı görsel oynanış testi yapılmadı.
