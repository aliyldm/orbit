# Hellstorm / HST yerel çalışma sözleşmesi

`game/hellstorm.js`; gerçek istemcinin `RocketLauncherAssembly.as`, `HellstormAttackHandler.as`, `AmmunitionTypeModule.as`, `SendMenuActionRequestCommand.as`, `ItemDataProvider.as` ve `resource_items.xml` kaynaklarına dayanır.

- **Takılı ekipman:** yalnız oyuncunun aktif gemisindeki aktif konfigürasyonun `heavy_gun` yuvalarındaki roketatarlar kullanılır. Depoda olması yetmez. HST-1, HST-2, Triskelion, Hydra, Neptune ve Ouroboros tanınır. Bütün takılı roketatarların kapasitesi toplanır; Citadel üzerinde iki HST-2 on roket yükler. Mermiler yuva sırasıyla, saniyede bir yüklenir; her mermi kendi roketatarının geliştirme bonusunu kullanır.
- **Gerçek menü isteği:** `MenuActionRequest.menuItemId` ekipman için `equipment_weapon_rocketlauncher_hst`, cephane için `ammunition_rocketlauncher_*` değeridir. Cephane seçimi yüklemeyi başlatır. Dolu roketatarı etkinleştirmek seçili hedefe ateşler; boş roketatarda etkinleştirme yükleme sonunda tek salvo bekletir. Normal tek roket isteği bu silahın isteği yerine kullanılmaz.
- **Eski istek uyumu:** `RL|L`, `RL|A|targetId`, `RL|SEL|type` gerçek ClientCommands sabitlerine göre core legacy yönlendiriciden işlenir. Oturum, hedef ve menzil kontrolü yine uygulanır.
- **İstemci durumu:** `0|RL|S|launcherTypes|visualRocketType|loadedCount` gönderilir. Tek tip değişmez; çoklu tip virgülle ayrılır (`2,2`), altılı Ouroboros tip3'tür. Native `RocketLauncherAssembly` yaması çoklu tip vektörünü ve altılı kapasiteyi yükleme sesine bağlar. Ayrıca gerçek `MenuItemStatusCommand`/timer komutları toplam kapasite/sayacı günceller; takılı roketatar yoksa devre dışıdır.
- **Atış görseli:** `HellstormAttackCommand {attackerId,targetId,hit,currentLoad,rocketType:AmmunitionTypeModule}` kullanılır. `HellstormAttackHandler` bunu gerçek çoklu roket efektine dönüştürür. `currentLoad` gerçekten tüketilen mermi sayısıdır.
- **Çarpma zamanı:** cephane ve bekleme atış anında işlenir; hasar, kalkan aktarımı, ölüm ve ödül son roketin kaynak kodundaki uçuş süresi bitince uygulanır. 2D'de 400 birim mesafedeki üçlü salvo 1.434ms bekler. Ayrıntı ve 3D hesabı `projectiles-local.md` dosyasındadır.
- **Cephane alanları:** menzil 650; ECO-10 hasar 2.000, HSTRM-01 4.000, UBR-100 7.500; SAR-01/SAR-02 kalkan aktarımı 1.000/4.000; CBR hasar/aktarım 3.000/3.000; BDR1212 hasar 4.000; PIR-100 hasar/aktarım 3.500/2.500; OBR-100 hasar 6.000. Bunlar istemci metadata'sındaki mermi başına değerlerdir. `AmmunitionTypeModule` ve `RocketPattern` görsel eşlemeleri aynen kullanılır.
- **Tüketim güvenliği:** yükleme sırasında mermiler yalnız önizleme olarak sayılır. Gerçek envanter mermileri atış anında tek transaction ile, gerekirse birden fazla stok satırından düşer. DB hatasında bütün düşümler geri alınır ve salvo gönderilmez. Kapatma/konfigürasyon değişimi yükleme önizlemesini temizler; gerçek mermiler kaybolmaz. İki mermisi kalan bir oyuncu iki mermilik gerçek bir salvo atabilir.
- **CPU:** gerçek aktif konfigürasyonda takılı `equipment_extra_cpu_rllb-x` menüden açıldığında, seçilen launcher cephanesini yükler ve oyuncunun lazer saldırısındaki hedefe hazır salvoları otomatik ateşler. CPU olmadan otomatik davranış verilmez.

Yükleme süresi mermi başına 1.000ms; klasik HST atışı sonrasında yeniden yüklemeden önce 3.000ms beklenir. Bunlar [resmî Hellstorm FAQ](https://board-en.darkorbit.com/threads/hellstorm-rocket-launchers-faq.893/) ile doğrulandı. `config.combat.launcherReloadRoundMs` ve `launcherCooldownMs` açık yerel override olarak kalır. Formasyon/tasarım launcher cooldown çarpanları korunur. Tek roket cevher güçlendirmesi Hellstorm'a uygulanmaz ve cevher atışı harcanmaz. Menzil dışı hedefte gerçek `AttackRangeExceededCommand` tip2 gönderilir; cephane düşmez. Yayımlanmış cephane oranı olmayanlarda mevcut yerel isabet varsayılanı1'dir; `launcherHitChance` ve ArGe roket isabet etkisiyle değişebilir. OBR-100 için resmî oran0,9 kullanılır.

Özel PIR enfeksiyonu, etkinlik bonusları ve UBR'nin canlı NPC ek hasar formülü bu modülde doğrulanmış değildir; ilave hayali etkinlik etkisi uygulanmaz. Temel metadata hasarı ve kalkan transferi işler. Flash üzerinde görsel uçtan uca test yapılmadı.

`node --test tests/hellstorm.test.js`: 8 test; aktif konfigürasyon/HST kapasitesi, gerçek codec/status/atış, yükleme kuyruğu, menzil, çoklu stok/transaction geri alma, SAR kalkan transferi, gerçek CPU ile otomatik ateşleme, yetkisiz/ölü/cephanesiz istekler ve çıkış/konfigürasyon temizliği doğrulanır.

## 23 Ekim 2026 otomatik roket düzeltmeleri

Gerçek sorunlar: her lazer/tek roket cephane bildirimi kayıtlı şablondaki launcher cephane seçimini geri yazıyordu; tam menü yenilenmesi RLLB seçimini bozuyordu. Seçimler artık gerçek sunucu durumundan üretilir. Aynı fiziksel roketatar iki konfigürasyona da takıldığında eski imza konfigürasyonu içermediği için yük korunuyordu; artık değişimde boşalır, cooldown korunur. CPU yalnız lazer saldırısı sırasında yeniden yüklediği için konfigürasyon/ammo değişiminden sonra hazır beklemiyordu; artık açık CPU boşta da doldurur, yalnız aktif lazer hedefi varsa ateşler. Yükleme atış cooldown'u sırasında başlatılamaz. Jump sırasında menüden CPU/yükleme isteği kabul edilmez.

| Roketatar | Salvo kapasitesi | Atış sonrası yükleme kilidi | Geliştirme kademesi başına hasar | Sabit özellik |
| --- | ---: | ---: | ---: | --- |
| HST-1 | 3 | 3sn | %0,5 | — |
| HST-2 | 5 | 3sn | %0,5 | — |
| Triskelion | 3 | 4sn | %2,5 | Gemi yeteneği bekleme oranından25 puan düşer |
| Hydra | 5 | 4sn | %0,5 | %30HP, %25kalkan |
| Neptune | 5 | 4sn | %1,5 | %5lazer/roket hasarı |
| Ouroboros | 6 | 3sn | %3,5 | %5roketatar hasarı |

Geliştirme kademesi `upgrade_level` alanıdır; seviye1→kademe0. Triskelion/Hydra/Neptune sayıları [resmî Dispatch FAQ](https://board-en.darkorbit.com/threads/faq-retriever-gate-dispatch.127317/) ve yakalanmış ItemDataProvider ile; Ouroboros [resmî Eylül2026 FAQ](https://board-en.darkorbit.com/threads/galactic-strife-faq-09-2026.130406/) ile karşılaştırıldı. Ouroboros'un yakalanmış metadata'sı genel DAMAGE kullanmasına rağmen resmî açıklama roketatar hasarı dediği için %5 yalnız launcher çarpanına eklenir. Hydra/Neptune pasifleri gerçek `loadPlayer` istatistiklerine, Triskelion azaltması gerçek yetenek deadline hesabına bağlandı. Diroit formasyonu daha önce gelen roket çarpanını siliyordu; artık çarparak korur. Çoklu roketatar pasifleri toplanır; birden fazlasının orijinal bonus istifleme ayrıntıları ayrıca doğrulanmalı.

AROL-X'in seçili tek roketi yalnız lazer saldırısında, ROK-T01 ile2sn aralıkta atması gerçek Combat.tick ve native MenuAction codec üzerinden doğrulandı; lazer durunca veya CPU'suz konfigürasyona geçince durur. RLLB ayrı roketatar CPU'sudur; AROL-X onun yerine geçmez. ROK-T01 Hellstorm'a uygulanmaz.

`tests/rocket-cpu-integration.test.js`8 yeni test; ilgili6 dosya toplam81/81PASS. Kayıt: `logs/rocket-cpu-validation.log`. Testler native isteği kodlayıp çözerek gerçek menü dispatcher/DB/Combat.tick/çarpma ve yetenek akışını çalıştırır; gerçek Flash görsel testi veya bu dosyada socket testi yapılmadı.

Bu bölümün ilk doğrulamasından sonra çoklu roketatar ve kesirli zamanlama tamamlandı; aşağıdaki ek güncel davranışı açıklar. Görsel kontrol yapılmadı.

## 23 Ekim 2026 çoklu launcher ve zamanlama eki

- İki HST-2 aynı gerçek `HellstormAttackCommand.currentLoad=10` ile on mermi tüketir. Karışık3+5 yuvalar toplam8 yükler. Manuel erken ateşleme gerçekten dolmuş mermileri kullanır; yüksek seviyeli bir roketatarın bonusu ötekinin mermilerine yayılmaz. Çoklu stok düşümü tek transaction'dır; ortada DB hatası olursa hiçbir mermi düşmez, yük korunur.
- `World.schedule` üzerinde tek yeniden kullanılabilir launcher deadline'ı vardır. Formasyonun0,75sn/1,33sn yüklemeleri NPC'nin1sn tick'ine yuvarlanmaz. Cephane değişimi, konfigürasyon değişimi, jump/çıkış/stop eski deadline'ı iptal eder. Global NPC tick'i değiştirilmedi.
- İki farklı cooldown'lı roketatarın ortak atışından sonra en uzun kilit kullanılır; bu güvenli **yerel kompozisyon kararıdır**, resmî özel sunucu algoritması diye sunulmaz. Aynı tip klasik HST2+HST2 üç saniye bekler ve on saniyede on mermi yükler.
- [Resmî Ship Plus FAQ](https://board-en.darkorbit.com/threads/faq-ship-plus-update-upgrade-your-ships.127618/) Citadel Plus için2 launcher yuvasını doğrular; yakalanmış `ItemDataProvider` klasik Citadel'de de2 yuva gösterir. Native `RocketLauncherAssembly.setRocketLauncherStatus` zaten vektör üzerinde kapasite topluyordu; girişindeki tek tip kısıtı dar bir istemci yamasıyla açıldı.
- [Resmî Eylül2026 Galactic Strife FAQ](https://board-en.darkorbit.com/threads/galactic-strife-faq-09-2026.130406/) OBR-100 için6.000PvE hasar/650menzil/%90isabet verir; bunlar uygulandı.9.000PvP hasarı solo sunucuda oyuncuya vurma özelliği eklendi anlamına gelmez.
- UBR-100 için [Hellstorm FAQ](https://board-en.darkorbit.com/threads/hellstorm-rocket-launchers-faq.893/)7.500 değerini ve geleneksel HSTRM'a göre en az%80NPC etkinliği anlatır. Mevcut7.500'e ayrıca×1,8 eklemek aynı açıklamayı iki kere kullanır; yapılmadı. PIR-100'ün PlagueNPC'ye ek700 hasarı etkinlik NPC'leri uygulanmadığı için açık kalır; oyuncuya enfeksiyon solo kapsamı dışındadır.
- Cevherin normal roket/Hellstorm ayrımı [2016 resmî forum tartışmasıyla](https://board-en.darkorbit.com/threads/gi-ammo-upgrades.115331/) uyumludur; bu konu FAQ'daki sayısal tablo kadar güçlü birinci taraf teknik kanıt değildir. Ayrım yakalanmış istemcinin `ROCKET`/`HELLSTORM_LAUNCHER` silah türleriyle de tutarlıdır; yerel uygulama kararı açıkça kaydedilir.

`tests/multi-launcher.test.js`7 yeni test: onlu salvo, karışık upgrade/erken atış, kesin kesirli deadline, auto tekrar, eski timer iptali, atomik stok/geri alma, OBR isabet/override, cevher ayrımı. İlgili7 dosya toplam79/79PASS: `logs/combat-launchers-round2-tests.log`. Native görsel/ses testi yapılmadı. İstemci yamasının ayrı artefakt kaydı/testi native UI çalışmasında tutulur.
