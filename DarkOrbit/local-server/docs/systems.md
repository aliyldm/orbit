# Ayarlar, görevler ve Galaxy Gates

18 Ekim 2026. `game/handlers/systems.js`, `game/galaxy-gates.js`, migration 004 ve 006.

## Doğrudan gözlenen sözleşmeler

Kaynak `logs/session-6182-2.json` içindeki kayıtlı oyun trafiği; paketler mevcut istemciden çıkarılmış `game/codec/schema.json` ile çözüldü. `session-6182-1.json` boş bir dizidir. Bu çalışma canlı sunucuya yeni bağlantı kurmadı; mevcut JPEXS çıktıları okundu, SWF yeniden decompile edilmedi.

SHA-256:

- `session-6182-2.json`: `AEC5B26998661D8C07007739E40B50794F15EC2D33875CC83FB3E2BC774B0BF4`
- `schema.json`: `EC70F6ED91A8F12562015B407BDE04F0B7E4E07B9DFA17E29184FC7CF712D3DC`

`tools/export-systems-evidence.js` kayıtların salt okunur çözümünden `game/handlers/systems-evidence.json` üretir. Çıktı ayar varsayılanlarını, altı görev tanımını ve builder sözleşmesini içerir. Kaydedilmiş oyuncunun tamamladığı görevler, enerjisi, parası ve kapı parçaları yeni hesaba kopyalanmaz.

İlgili decompile kaynakları `decompiled/main/scripts/net/bigpoint/darkorbit/` altında:

- `com/module/*SettingsRequest.as`, `UserSettingsCommand.as`, `UIWindowUpdateRequest.as`, `UserKeyBindingsUpdate.as`: alanlar ve veri türleri.
- `gui/KeyboardSendComponent.as`: atama silme işlemi `keyCodes=[-1]` gönderebilir; atamalar eylem ve parametre temelinde birleştirilir.
- `mvc/gui/controller/SaveBarsSettingsCommand.as`: pencere/çubuk konum isteklerinin anlamı.
- `com/module/QuestAcceptabilityStatusModule.as`: durumlar 0 uygun değil, 1 başlamamış, 2 sürüyor, 3 tamamlandı, 4 devre dışı.
- `com/module/QuestConditionModule.as`: NPC öldürme=6, kargo kutusu=51, cevher satışı=52, görev verici ziyareti=62, loot toplama=67.
- `mvc/galaxygatebuilder/model/GalaxyGateBuilderModel.as`: parça sayıları, toplam dalga sayıları, ödül alt türleri, kapı kurma cevabının parçaları sıfırlaması. Batarya `item_id=2`, MCB-25 anlamındadır; kayıttaki ilk üretim 280 MCB-25 verir.
- `com/module/GalaxyGateBuilder*Command.as`: gerçek hata kodları kullanılır. Kurma başarısızlığı=1, üretimde para yetmemesi=1/genel hata=2, can alımında para yetmemesi=1/genel hata=2.

Harita kimlikleri `client/spacemap/graphics/maps-config.xml` içinden doğrulandı: Alpha 51, Beta 52, Gamma 53, Delta 55, Epsilon 70, Zeta 73, Kappa 74, Lambda 75, Hades 203, Kuiper 300. Harita görsel kaynakları bu mevcut kimliklerle yüklenir.

## Uygulanan davranış

Ayarlar oyuncu kimliğine göre `settings` tablosunda saklanır. Ses, görüntü, oyun, kalite, görev filtreleri, minimap ölçeği, çubuk konumları, ayrı pencere konumları/boyutları/açık durumları, tuş atamaları ve sıfırlama desteklenir. `WindowSettingsRequest.minimapScale`, yanıtta gerçek istemci alanı olan `WindowSettingsModule.minmapScale` biçimine çevrilir. `UIWindowUpdateRequest` verileri açılıştaki iç içe `WindowItemCommand` nesnelerine uygulanır. Şemada `UIPanelUpdateRequest` adlı komut yoktur; böyle bir paket uydurulmadı.

Başlangıç görevleri 20000–20004 kayıttaki tanımlar ve ödüllerle DB'ye alınır. Kabul, iptal, bilgi, liste, önkoşul, sıralı alt koşul, yeniden bağlanma ve bir kez verilen ödül uygulanır. Görev 2, Skylab alt sistemi eklendikten sonra gerçek Prometium toplayıcısı seviyesine bağlanmıştır; seviye 6 şartı ve gerçek eşya ödülü uygulanır. Ayrıntılar `docs/skylab-local.md` içindedir. Bilinmeyen görevler için tanım veya başarılı ilerleme üretilmez.

Görev olayları sunucudaki oyun eylemlerinden gelir. İstemcinin gönderdiği koşul sayacı kabul edilmez. `recordEvent(session,event)` için olaylar:

| Olay | Alanlar | Anlamı |
|---|---|---|
| `npcKill` | `npcType`, `amount` | Streuner görsel kimliği 84, görevdeki mantıksal kimlik 1'e çevrilir |
| `cargo` | `amount` | Toplanan NPC kargo kutusu adedi |
| `collectLoot` | `lootId`, `amount` | Gerçekte DB'ye eklenen cevher miktarı |
| `sellOre` | `match`, `amount` | Prometium için `match='1'` |
| `visitQuestGiver` | `match='HOME'`, `amount=1` | Kendi şirketinin ana haritasındaki gerçek istasyon yakınında doğrulanan ziyaret |

Görev ödülü, para/XP/seviye güncellemesi ve tamamlanma kaydı aynı SQLite savepoint içinde yazılır. Depolama hatasında ilerleme ve ödül geri alınır; başarı paketi gönderilmez. Tamamlanmış görev tekrar kabul edilerek ödül üretilemez.

Kapı üretimi oyuncu bazlı enerjiyi ve gerçek uridium bakiyesini atomik tüketir; parçalar, kopyalar, çarpan, seçilmiş üretim adedi ve gerçek cephane kalıcıdır. Tam parça seti kurulunca aktif `galaxy_gate_runs` satırı ve sahibinin ana haritasında gerçek portal oluşur; parçalar ancak kurma başarılıysa sıfırlanır. Haritaya giriş oyuncu sahipliği ve aktif can üzerinden denetlenir. Harita dışına çıkma, yeniden girme ve yeniden bağlanma kalan NPC'leri korur. Ölümler yalnızca mevcut dalgayı yeniden başlatır ve bir can tüketir; son can kaybolunca portal kaldırılır. Can satın alma para ve iki can sayacını birlikte günceller.

Her dalganın kalan NPC yuvaları DB'de tutulur. Dalga geçişi mevcut savaş çağrısı tamamlandıktan sonra planlanır. Son NPC öldüğünde kapı tamamlanması, ödüller ve kapı sayacı aynı işlemde yazılır; tekrar öldürme bildirimi ikinci ödül üretmez. Oyuncu ana haritasına döndürülür. NPC başına kaynaklı ödül kalıcı slot talebiyle bir kez ödenir; Combat'ın genel ödülü ikinci ödeme olmaması için sıfır aktarılır. Yeniden bağlanarak aynı slotun ödülü tekrar üretilemez.

## Açıkça yerel olan denge kararları

İstemci paket biçimlerini ve bazı sayaçları içerir; canlı sunucunun tüm RNG, NPC dalga içeriği, harita boyutu, ödül ve grup kuralları istemci içinde bulunmaz. Aşağıdaki değerler yerel, değiştirilebilir emülasyon politikasıdır:

- Üretim maliyeti kayıtta görülen 85 uridium. Yeni hesaba ücretsiz enerji verilmez.
- Üretim kategorileri %13 parça, %12 Xenomit, %3 tamir kuponu, %1 logfile ve %71 cephanedir. Kayıttaki ilk dört kategori oranı korunur; henüz kalıcı savaş hasarına bağlanmamış nanohull kategorisinin %4 payı cephaneye aktarılır. Arayüze bu gerçek yerel oranlar gönderilir. Tamamlanmış kapıda parça sonucu cephaneye dönüşür. Alpha/Beta/Gamma parça havuzları bu sürümde ayrıdır.
- Her cephane/kaynak/kupon/logfile kategorisi içinde %85 normal, %13 nadir ve %2 çok nadir ödül seçilir. Normal cephaneler 280 MCB-25, 100 MCB-50, 50 UCB-100, 100 SAB-50, 40 PLT-2021 veya 3 ACM-01'dir. Nadir cephane paketleri iki, çok nadir cephane paketleri üç farklı gerçek cephane yığını verir. Kategori içindeki altı cephane paketi eşit ağırlıktadır. Xenomit miktarları 10/60/300, tamir kuponları 1/3/10, logfile 1/5/20'dir. Böylece toplam 27 farklı paket/sonuç vardır. 280 MCB-25 kayıttan; diğer miktarlar, paketler ve nadirlik oranları kullanıcının çeşitlilik isteği için yerel politikadır. Xenomit gerçek `player_resources` cevher 3 bakiyesine yazılır; kapı ödülü mevcut kargo dolu olsa da kaybolmaz ve boş alan sıfır olur. Kupon/logfile gerçek stacklenebilir inventory bakiyesine yazılır; arayüz sonucu ile DB ödülü aynıdır.
- Kopya parça bankası protokolde 0–5, görünür çarpan olarak x2–x6'dır. `useMultiplier=true` yalnız ilk enerjide bankayı bir kez tüketir; kapalı kutucuk bankayı üst sınırda da korur. Kullanılan ödülün `multiplier_used` alanı bankanın kodu değil gerçek x2–x6 değeridir. Çoklu üretimin kalan enerjileri normal devam eder. Çarpanla üretilen parçalardan yeni kopyalar çıkarsa yeni banka oluşturabilir.
- Kapı üç canla başlar. Ek can 10.000 uridium, üst sınır 10.
- Varsayılan savaş içeriği artık on kapının resmî FAQ düşmanlarından ve miktarlarından gelir; Alpha/Beta/Gamma 446 NPC, gerçek Boss/Uber/Pirate/Emperor türleri ve farklı can/kalkan/hasar çarpanları kullanır. Üç NPC'lik eski içerik yalnız başlamış eski kayıtlar veya açık QA azaltması için korunur. Kaynak sürümleri, alt faz zamanlaması ve özel boss sınırları `docs/gate-content.md` içindedir.
- Yeni kapıların tamamlama ödülleri kapıya özgü resmî garantili temel ödüllerdir. NPC parası da kalıcı slot talebiyle bir kez ödenir. Hades bu yerel sürümde tek oyunculu çalışır; gerçek grup kapısı kuralları ve bazı özel Emperor mekanikleri henüz uygulanmaz.
- `config.galaxyGates.waveCount`, `npcsPerWave`, `waveDelayMs`, `completionReward` ile yerel içerik ve tempo değiştirilebilir. Başlatılmış kapı dalga sayısı ve ödülü kurulduğu anda DB'ye kaydedilir; süreç yeniden başlayınca değişmez.

Paket listeleri ve gerçek wire eşleştirmeleri `game/gate-builder-rewards.js` içindedir. Normal/nadir/çok nadir ağırlıklar isteğe bağlı `config.galaxyGates.builderRewardTierWeights={"normal":85,"rare":13,"veryRare":2}` ile değiştirilebilir; toplamın 100 olması gerekmez. Her ağırlık 0–1000000 arasında tam sayı olmalı ve en az biri pozitif olmalıdır. Geçersiz yapılandırma ödeme/ödülü geri alır.

Paketler 27 farklı loot türü anlamına gelmez. Değiştirilmemiş Flash builder yalnız 6 cephane adını/ikonunu, Xenomit, tamir kuponu ve logfile'ı tanır. `GalaxyGateBuilderLootItemModule` yalnız sayısal byte `item_id` taşır; lootId metni yoktur. Model bilinmeyen batarya kimliğini MCB-25 diye gösterir. Bu nedenle başka lazer/roket/anahtarların kimliğini uydurmak yanlış ürün gösterirdi. Bu sınıra uygun dokuz gerçek tür 27 sonuçta ve iki/üç bileşenli paketlerde çeşitlendirilmiştir. NanoHull savaş defteri ve ilave client UI protokolü uygulanmadan desteklenmiş gibi sunulmaz.

Bir paket içindeki bütün bileşenler aynı enerji işlemiyle verilir. Seçilen çarpan paketin her bileşenine bir kez uygulanır. Çoklu 100 üretimde aynı type/item_id/multiplier_used sonuçları toplulaştırılır; gerçek miktar ve kullanılan enerji sayısı korunur, byte boyutlu yanıt listesi taşmaz. İkinci/üçüncü bileşenin SQL hatası önceki bileşenleri, çarpanı, enerji ve maliyeti birlikte geri alır.

Kronos, Kuiper'in ayrı haritalarına geçiş, canlıya özgü bonus günleri/ödülleri ve bazı özel NPC yapay zekâları tam uygulanmış değildir. On mevcut kapının düşman listeleri kaynaklara bağlanmıştır; ayrıntılı durum `docs/gate-content.md` içindedir.

## Doğrulama ve entegrasyon

Sistem, kapı, kapı ödül paketleri, Skylab ve booster dosyaları birlikte 76 test geçirir. Testler iki farklı oyuncu, ayarların geri yüklenmesi, görev önkoşulları/sıralaması, tüm beş başlangıç görevinin gerçek ödülleri, tekrar ödül engeli, hata enjeksiyonunda rollback, kapı parçaları/enerji/para/çarpan, tüm 27 paketin ödül dalları, kaynak dosyalardaki gerçek ad/ikon eşleştirmeleri, 100 üretimin taşmadan toplulaştırılması, portal sahipliği, dalga devamı, yeniden bağlanma, ölüm/can/yeniden kurma ve kapı tamamlanması içerir. Bir entegrasyon testi gerçek World, Gameplay ve Combat sınıflarıyla aynı yetkili oturumun portaldan girişini, NPC öldürmesini, kalıcı ödülünü ve ana haritaya dönüşünü çalıştırır; zamanlayıcılar test içinde elle ilerletilir. Gönderilen paketler gerçek codec ile yeniden çözülerek kalan bayt ve nesne eşitliği denetlenir. Bunlar otomatik sunucu/modül testleridir; Flash arayüzünde görsel uçtan uca doğrulama değildir.

Builder bilgisi hero/map açılışına eklenmez. İstemci `GalaxyGateBuilderModel.parseInitUserData`, statik `MODE_GATES`, `spinamounts` ve `MAX_GATES_COUNT` verilerini temizlemeden ekler. Açılışta InfoCommand yollamak ardından modelin normal InfoRequest cevabını yollamak bütün sekmeleri çoğaltıyordu. Artık açılış şablonundaki Info/GetParts da süzülür; aynı oturumun ilk gerçek InfoRequest'ine bir kez yanıt verilir. Sonraki parça/üretim/can/kurma cevapları modeli günceller. Eski istemcide birikmiş sekmelerin temizlenmesi için SWF'nin yeniden yüklenmesi gerekir.

Protokol kaydı: `systems.register(onCmd,services)`. Açılış komutlarına `systems.buildInit(player)` çıktısı eklenir ve mevcut `UserSettingsCommand`, `UserKeyBindingsUpdate`, `QuestListCommand` şablonlarının yerine geçer; son komut listesine `systems.applyInit(player,commands)` uygulanır. Gameplay/Combat, `galaxy-gates` modülünün `portals`, `portalRows`, `nearestPortal`, `canEnter`, `spawnWave`, `onNpcKilled`, `onPlayerDeath` işlevlerine bağlanır. `onNpcKilled` DB işlemi, NPC haritadan silinmeden önce çağrılır; depolama hatası durumunda öldürme tekrar denenebilir.
