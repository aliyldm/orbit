# NPC kargoları ve 5-x labirentinin kaldırılması — 24 Ekim 2026

Kullanıcının son kararı labirenti iptal etmek. 5-1/5-3 duvar POI'leri, oyuncu/NPC/PET hareket kırpması ve giriş/ganimet konumu taşıması çalışma yollarından kaldırıldı. Sis, Palladium ve kamuflaj bozma aynı. İzleme görselleri/veri ve kullanılmayan geometri araçları arşivdir; oyun bunları çağırmaz. Önceki labirent ekleme isteği artık geçerli değildir.

## Kargo tabloları

`node tools/audit-npc-cargo.js` üretim DB'sini açmadan [tam raporu](npc-cargo-audit.json) üretir. 80 katalog türü ve 28 Kronos türü olmak üzere108 tanım tarandı:103 kaynaklı; bunların7'sinde kaynak açıkça cevher yok der. Önceki45 normal/Boss/Uber/korsan tablosunda sayısal fark yok.

Yeni:28 Kronos cevher tablosu, resmî İspanyolca her NPC bloğundan ayrı alınarak `game/data/kronos-cargo.json` üzerinden gerçek ölüm/kargo yoluna bağlandı. Revenge'de Promerium yok; Evil'in Terbium'u300, Prometium/Endurium'u400. Aynı görünümlü normal geminin veya NPC'nin cevheri kopyalanmaz. Ayrıca genel Kucurbium/Boss Kucurbium için DE invasion x-1 tablosu eklendi; ayrı Kappa varyantları korunur.

- [DE NPC SSS](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/) ve [ikinci sayfa](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2).
- [ES NPC SSS — Kronos ve özel NPC'ler](https://board-es.darkorbit.com/threads/faqs-aliens.135697/).
- [Zeta](https://board-en.darkorbit.com/threads/zeta-gate-faq.852/), [Epsilon](https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/), [kendi x-1 Streuner seviye tablosu](https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/).

**Açık kaynak boşlukları:** Kuiper Soldier/Specialist/Turret/Emperor/Rocketeer için beş taban kargo kaydı;23 farklı büyütülmüş klasik kapı NPC varyantı. Beta/Gamma/Delta combat ve para çarpanları tek başına cevher miktarının kanıtı sayılmadı. [Beta SSS](https://board-en.darkorbit.com/threads/beta-gate-faq.792/) / [Gamma SSS](https://board-en.darkorbit.com/threads/gamma-gate-faq.841/) tekrar incelendi fakat ayrı cevher listesi yok. Bu varyantlar raporda bilinmiyor, tüm kargolar birebir tamamlandı denmemeli. Koşullu craft malzemesi olasılıkları ve çok oyunculu kutu sahipliği ayrıca doğrulanmış değildir. Eski başlamış gate snapshot'ları kendi eski içeriklerini korur.

## Toplama düzeltmeleri

1. Native `EventManager.queueMoveRequest` hareketi200ms'ye kadar geciktirir. Yakın kutuda `handleMoveComplete` collect isteği daha önce gelebilir. Önceden her MoveRequest koşulsuz beam iptaliydi. Aynı konuma varış veya kutunun son yaklaşma paketi artık beam'i bozmaz; başka hedefe gerçek hareket hâlâ iptal eder. Sunucu istemci konumunu kabul edip ışınlamaz; hedef hareketi normal hızla hesaplar.
2. Ambar tamamen doluysa anlamsız beam başlatılmaz. Native `0|f` komutu gönderilir; `ConnectionManager` bunu `loadfull` çevirisiyle gösterir. Beam sırasında ambar dolması da aynı nedeni verir. Xenomit kapasite dışındadır ve kalan kutuda Xenomit yoksa eski içerikten varmış gibi kabul edilmez.
3. PET, oyuncunun beam açtığı aynı kutuyu seçmez ve doğrudan collect yolu da bu rezervasyonu uygular. Kutunun aradan kaybolup oyuncuya iptal dönmesi engellendi.
4. Kısmen sığan kargo artık tamamen silinmez. Başarıyla verilen miktar düşülür, kalan içerik aynı hash/son kullanma süresiyle durur. İlk toplamadaki bonuslu kalan miktar sabitlenir; tekrar toplama beceri/PET bonusunu yeniden çarpmaz, Xenomit tekrarlanmaz. Kutu bitmeden RemoveCollectable gönderilmez. Kargo görevi bir kutuyu tekrar tekrar saymaz. [Resmî forumda ekipçe kayda alınan kısmi kargo sorunu](https://board-en.darkorbit.com/threads/tei-agatus-cargo-box-poofs-if-not-completely-collected.127523/) beklenen kalan-kargo davranışını destekler.

Mesafe180, hareketle iptal, ölüm/atlama ve mevcut120s kargo ömrü ayrıca değişmedi. Her bildirilen iptalin kök nedeninin aynı olduğu canlı Qt oturumunda kanıtlanmış değildir; yukarıdaki somut kod yolları yeniden üretildi ve düzeltildi.

## Lazerler ve önceki tur

Lazerler bu tur geri eklenmedi. LF4 üstü/özel17 türün runtime filtresi aktiftir. Metadata, asset ve eski formüller korunur. Önceki silmenin67Mortifer satırı ve4upgrade işi `logs/retired-lasers-removal.json` içinde; yedek `backups/darkorbit-before-2026-10-24T10-17-46-378Z.db`. İleride kullanıcı isterse filtre/satış/ödül ve seçili envanter satırları birlikte geri eklenebilir. Bütün eski veritabanını geri almak yeni ilerlemeyi ezer; yapılmamalı.

31 kararlı gemi modülünün mağaza/gerçek istatistik/uyumlu gemi listesi/sınıf slotu/native hangarSUS-SUM/HUD simgesi ve Cubikon'un özgün spawnChildren open/close animasyonu önceki turda tamamlandı. İstikrarsız modül üretimi tamamlandı sayılmaz. Bu tur MAIN/SWF veya ses değiştirilmedi.

## Doğrulama

`logs/cargo-maze-focused.log`:41 test; kaynak metinlerinden45normal+28Kronos+özel varyant cevherleri, gerçek combat ölüm yolu, gecikmiş hareket, tam/kısmi ambar, PET yarışı, maze'siz hareket/POI/ganimet testleri. Tam test ve dağıtım sonuçları son kayıtla aşağıda güncellenir. Ayrı geçici DB ile gerçek HTTP/TCP testi kullanılır; kullanıcının açık Qt penceresine girdi verilmedi.

**Dağıtıldı: PID16180**, solo HTTP8095/TCP8096, healthOK.919/919 test (`logs/cargo-maze-full-tests.log`);342JS/0sözdizimi hatası (`logs/cargo-maze-source.log`);22.762 gerçek HTTP/TCP komutu (`logs/cargo-maze-network.log`). Ağ senaryosu native CollectBoxRequest + gecikmiş MoveRequest, native ambar-dolu mesajı, kısmi kargoyu iki kez toplama ve Kronos kutusu içeriğini doğruladı. Son mesaj iyileştirmesi (kısmi toplama sonrası ambar dolu bildirimi) tam birim testlerinden tekrar geçirildi.

PID3680 kayıt işleyicisiyle kapatıldı. Son kayıt sonrası SQLite online yedek: `backups/darkorbit-before-2026-10-24T10-53-31-160Z.db`. Yeniden başlatma ardından60tablonun bütün kolon/satırları aynı; değişen tablo yok.3hesap/3oyuncu/14gemi, integrityOK/FK0. Aktif harita spawnlarında katalog anahtarsız özel NPC yok. Yeni migration/hediye/iade yok. Kanıt `logs/cargo-maze-production-check.json`. MAIN SHA256 `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824` ve cache aynı. Yeni harita init'ini almak için oyun yeniden açılmalı.
