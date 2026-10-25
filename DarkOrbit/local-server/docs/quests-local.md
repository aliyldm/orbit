# Son ek — 23 Ekim2026

Görev sayısı artık **53**: önceki20korundu,33kaynaklı solo NYX görevi en son eklendi. [Amaç/ödül/kimlik ve açılma koşulu sınırları](quests-original-current.md); [güncel doğrulama ve açık işler](second-completion-work.md). Aşağıdaki20görev belgesi önceki temel kapsamı anlatır.

# Görevler: çalışan kapsam ve kaynak sınırları

2026-10-20. Bu sürüm **20 görev** sunar: kayıtlardan gelen 5 başlangıç görevi (`20000..20004`), Skylab görevi (`2`), kaynaklardan yeniden kurulan iki başlangıç adımı (`20005/20006`) ve **12 açıkça yerel görev** (`900001..900012`). Bütün orijinal DarkOrbit görev kataloğunun tamamlandığı iddia edilmez.

## Kaynaklar

- `game/handlers/systems-evidence.json`: mevcut kayıtların görev tanımları, ödülleri ve paket yapıları. Önceki altı görevin tanımları değiştirilmedi.
- `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/QuestConditionModule.as`: NPC öldürme `6`, harita ziyareti `34`, kargo `51`, cevher satışı `52`, bonus kutusu `55`, görev merkezine dönüş `62`, eşya toplama `67`, slot yerleştirme `70`, Skylab `76`, kapı bitirme `79`.
- `QuestTypeModule.as`, `QuestRequirementModule.as`, `QuestLocalizationModule.as`, `questfm/conditions/*`: görev türleri, ön koşul/aktif görev limiti ve doğru istemci metin parametreleri.
- `decompiled/pet-patterns/game.xml`: gemi grafik türü ile görev `npcId` değerleri farklıdır. 174 pozitif NPC eşlemesi `game/quests-npc-ids.json` içine kaynak SHA-256 özetiyle çıkarıldı. Örneğin Lordakia `71 → 2`, Saimon `75 → 6`, Sibelon `74 → 5`, Kristallin `78 → 9`, Interceptor `111 → 58`. Normal, Boss ve Uber ayrı sayılır.
- `client/spacemap/templates/tr/resource_quest.xml`: `20005/20006` için mevcut özgün Türkçe başlık ve şirket açıklamaları kullanılır. Yerel görevlerin başlık/açıklamaları aynı kaynak dosyasına eklendi, başlıkları `[Yerel]` içerir. Bilinmeyen görev numarasının kendiliğinden çevrileceği varsayılmadı.
- [NYX MISSION FAQ, 2015](https://board-en.darkorbit.com/threads/nyx-mission-faq.102728/): `20005` için 3 bonus kutusu, ardından görev merkezi; 1 BO2 ve 1000 MCB-50. `20006` için standart bara MCB-50 yerleştirme, kendi x-2 haritasına gitme, 5 Lordakia, x-1 ve görev merkezi; 100 PLT-2021, G3N-3310, 100.000 kredi ve LF-3. **Bu, resmî forumdaki oyuncu raporudur; özgün sunucu paketi değildir.** Tanım, ödül ve sıra yeniden kurulmuştur; bilinmeyen eşik/ödül dağılımları bütün katalog için uydurulmamıştır.
- [NYX FAQ](https://board-en.darkorbit.com/threads/nyx-faq.847/) görev merkezinin görev kabulü, şart ve ödül arayüzünü açıklar. [Eski Quest Line](https://board-en.darkorbit.com/threads/quest-line.849/) farklı dönem ve görev limitleri içerir; mevcut kaydın beş görev sınırı yerine eski üç görev sınırı aktarılmadı.

## Yeni görevler

`20005` ve `20006` önceki başlangıç zincirini takip eder. `20005` tamamlanınca seviye 6 altındaki oyuncunun görev listesi yalnızca başlangıç görevlerine filtrelenmez; uygun yerel işler açılır. Şirket haritaları kabul sırasında oyuncunun şirketine göre çözümlenir ve kaydedilir.

| ID | Adı | En az seviye / ön koşul | Amaç | Ödül |
|---|---|---|---|---|
| 900001 | Maden tedariki | 1 / 20005 | 50 Prometium, 25 Endurium, 10 Terbium | 10.000 kredi, 2.000 TP, 10 U. |
| 900002 | Lordakia devriyesi | 2 / 20005 | Kendi x-2 haritasında 10 Lordakia, sonra ana görev merkezi | 16.000 kredi, 4.000 TP, 20 U. |
| 900003 | Enkaz kurtarma | 2 / 20005 | 10 dolu NPC kargo kutusu toplama | 12.000 kredi, 3.000 TP, 1 tamir kuponu |
| 900004 | Sektör keşfi | 3 / 20005 | Sırayla kendi x-2, x-3, x-4 haritaları, sonra görev merkezi | 20.000 kredi, 5.000 TP, 25 U. |
| 900005 | Saimon temizliği | 3 / 900002 | Kendi x-3 haritasında 20 Saimon | 32.000 kredi, 8.000 TP, 30 U. |
| 900006 | Lider avı | 3 / 900002 | Kendi x-2 haritasında Boss Streuner ve Boss Lordakia | 30.000 kredi, 6.000 TP, 1 günlük dosyası |
| 900007 | Ticaret sevkiyatı | 2 / 900001 | 100 Prometium satma | 15.000 kredi, 3.000 TP, 15 U.; satış geliri ayrıca |
| 900008 | Sibelon tehdidi | 5 / 900005 | Kendi x-4 haritasında 1 Sibelon | 50.000 kredi, 16.000 TP, 40 U. |
| 900009 | Kristallin nöbeti | 11 / 900008 | Kendi x-6/x-7 haritasında 10 Kristallin | 100.000 kredi, 32.000 TP, 80 U. |
| 900010 | Korsan yolu | 12 / 900008 | 5-1/5-3 haritasında 10 Interceptor | 125.000 kredi, 40.000 TP, 100 U. |
| 900011 | Alpha seferi | 6 / 20005 | Alpha kapısını bitirme | 100.000 kredi, 25.000 TP, 100 U.; kapı ödülü ayrıca |
| 900012 | Bonus arayıcısı | 2 / 20005 | 20 normal bonus kutusu | 15.000 kredi, 3.000 TP, 500 MCB-25 |

Bu 12 görevin şartları ve ödülleri **yerel tasarımdır**. Günlük/haftalık yenilenmez; tamamlandıktan sonra tekrar ödeme yapmaz. Kalıcı eşya ve cephane katalogdaki gerçek envantere, para ve TP oyuncu kaydına gider. Mevcut TP/şeref booster hesaplaması korunur.

## Kayıt, sıralama ve güvenlik

- `018-quests.sql` mevcut görev durumlarını, ilerlemelerini ve tarihlerini korur; kabul edilmiş tanım/ödülleri `snapshot_json` içine sabitler. Zaten tamamlanan görevler için ödeme kaydı oluşturur; tekrar ödül vermez.
- Kabul edilen yeni görevin amaçları, şirket haritaları, kısıtları ve ödülleri anlık görüntü olarak saklanır. Katalog daha sonra değişse bile devam eden görevin hedefi/ödülü değişmez. İptal sonrası yeniden kabul güncel tanımla sıfırdan başlar.
- İlerleme yalnızca sunucunun `recordEvent` çağrılarından gelir. İstemciden bir tamamlanma ya da sayaç güncellemesi kabul eden handler yoktur. Görev merkezine dönme isteği canlılık, atlama, kendi ana haritası, gerçek görev nesnesi ve 1800 birim mesafeyle doğrulanır.
- NPC eşlemesi öncelikle `npcId` (mantıksal kimlik), ardından katalog `npcKey`, son olarak eski `npcType` grafik değeriyle yapılır. Harita sınırlı görevde farklı şirket/kapı kopyaları sayılmaz.
- Tek bir eylem bir sonraki sıralı koşulu açtığında aynı eylem yeni koşula da yazılmaz. Yeni aktif koşul güncellemesi ve yeniden bağlanma durumu istemciye gönderilir.
- Kabul sınırı 5'tir. Eksik seviye, ön görev ve dolu görev limiti istemcinin gerçek `QuestRequirementModule` yapılarıyla açıklanır. Tamamlanan görevlerin ayrıntıları doğru sayaçlarla, etkin olmayan tamamlanmış koşullarla gösterilir.
- İlerleme, `quest_reward_claims` tekil ödeme kaydı, para/eşya teslimi ve tamamlandı durumu aynı SQLite savepoint içinde kaydedilir. Ödül yazımı başarısız olursa bütün bu işlemler geri alınır ve başarı paketi gönderilmez.
- Sunucu benzersiz `eventId` sağlarsa `quest_event_receipts` aynı olayı tekrar saymayı engeller. Anahtar oyuncu+olay türü+kimliğidir; sunucu kimliği gereklidir. Kimlik almayan eski çağrıların tekrarını bu tablo kendiliğinden tanımaz; gerçek toplama/öldürme sisteminin zaten tekil olay üretmesi gerekir.

Entegrasyon olayları: `mapVisit {mapId}`, `npcKill {npcKey,npcType,mapId}`, `slotItem {lootId,slotBarId}`, `gateComplete {gateId,mapId,eventId}`. Harita geçişi yalnızca gerçekleştiğinde, slot olayı doğrulanmış yerleştirmeden sonra, kapı olayı gerçek tekil bitirme işleminden sonra üretilmelidir. `collectLoot`/`cargo`/`sellOre`/`visitQuestGiver`/`skylabUpgrade` mevcut sunucu olayları korunur. MCB-50 zaten standart bardaysa `20006` kabulünde kayıtlı bar okunarak ilk amaç sağlanır.

## Doğrulama ve kalanlar

`node --test tests/quests-expanded.test.js tests/systems.test.js`: **39/39** geçti (15 yeni görev testi + 24 mevcut sistem testi). Yeni testler bütün 12 yerel görevin bitirilebilirliğini/ödül kataloğunu, iki başlangıç adımını, NPC mantıksal kimliklerini, şirket/harita ayrımını, sıralamayı, kayıt sabitlemeyi, codec turunu, limit/iptal/yeniden bağlanmayı, tekil olay ve ödeme geri almayı, eski DB göçünü sınar. Kaynak XML başlıkları statik olarak kontrol edilir; Flash ekranında bütün görevlerin görsel incelemesi ayrıca gerekir.

Henüz yok: orijinal tam görev kataloğu, günlük/haftalık sıfırlama, süreli görevler ve başarısızlık koşulları, PvP/grup görevleri, başlangıç özel Devolarium kapısı, klana katılma, hangar konumuna özel adımlar. Bunlar çalışmayan amaçlarla kabul edilebilir olarak listelenmez. Yerel görev eklemek bu özgün işlevlerin tamamlandığı anlamına gelmez.
