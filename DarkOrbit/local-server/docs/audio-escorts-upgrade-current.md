# Lazer sesi, Cubikon refakatçileri ve geliştirme yerleşimi

23 Ekim 2026. **Dağıtıldı: PID26136**, solo HTTP8095/TCP8096, healthOK. Önceki PID24408 kayıtlarını kaydederek kapatıldı.

## Lazer sesi

Kullanıcı tekrar eden lazer sesini daha seyrek istedi. Normal lazer sesleri artık **gemi başına en az2s aralıkla** çalınır; ilk ses hemen duyulur.2D/3D aynı weak-key Dictionary tabanlı `LaserEmissionSchedule.soundAllowed` kullanır. Normal salvoların birden çok namlu grubu ayrı ayrı ses patlaması üretmez. **RSB renk/type6 bu kapıdan muaftır**, bütün önceki ses noktaları korunur.

Hasar/cephane/1s normal tur/3s RSB beklemesi ve namlu gruplarının200ms görsel aralıkları değişmedi. Ses örnekleri değiştirilmedi. Bu2s kullanıcının istediği yerel ses tercihidir; özgün sunucu sabiti diye sunulmaz.

`tools/patch-laser-sound-cadence.js`, mevcut MAIN'den3 sınıfı JPEXS ile dışa aktarıp değiştirir ve tekrar derler. Girdi SHA256 `e672b127d1f7898e1d558e4bb7f03f4dfd5372f56f8ac6ecb3a063facc3b6a8d`; çıktı `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824`. Yalnız1ABC tag değişti;256diğer tag/medya aynıdır. Önceki upgrade/drone/assembly/launcher sınıflarının tekrar decompile kaynakları aynıdır. JPEXS'in NaN opsiyonel değer derleyememesi nedeniyle iki dummy `getLaserCannonLocalPosition` metodunun **hiç okunmayan üçüncü argümanı** varsayılanıNaN→0 normalize edildi; metot gövdesi ve ürettiği0,0,0 konumu aynı. Bu teknik fark evidence.json'da açık kayıtlıdır.

`tools/install-laser-sound-patch.js` hash zincirini denetler. `gameclientHash` ve `resourcesXmlHash`: `local-20261023-audio-escorts-upgrade`. Yeni ses için oyunu kapatıp yeniden açmak gerekir. Açık Qt/Flash üzerinde ses dinleme veya UI girdisi yapılmadı; doğrulama derlenmiş kaynağa/codec/ağ akışına dayanır.

## Cubikon / Protegit

Önceki davranış20refakatçiyi hazır220yarıçaplı çembere yerleştiriyor, ardından bütün normal NPC'ler gibi oyuncunun±150çevresindeki aynı küçük kümeye sürüklüyordu. Yeni davranışta Protegitler **Cubikon gövdesi çevresinden** doğar ve gerçek MoveCommand ile dışarı dağılır. Annenin geçerli saldırganı varsa onu hedefler. Her refakatçi kendi kalıcı slot/açı/yarıçapına sahiptir; saldırganın etrafında ayrı orbit hedefleri kullanır, hareketli hedefin güncel konumunu izler. Aynı tickte hareket tekrar başlatılmaz. Ölen refakatçinin boş slotu doldurulur; kalan19'un slotu değişmez.

20adet sınırı, yalnız gerçek hasardan sonra oluşma, öldürme ödülü, anne ölünce/map değişince temizlik, mevcut yeniden dolma/mesafe/ilgisizlik sınırları korunur. Battleray/Uber refakatçi kuralları bu yeni harekete alınmaz. Yeni timer veya çok oyunculu özellik yok.

[Resmî NPC FAQ](https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/) Protegit'i Cubikon'un hızlı refakatçisi, Cubikon'u saldırılana kadar pasif anne olarak tanımlar. [İspanyolca NPC FAQ](https://board-es.darkorbit.com/threads/faqs-aliens.135697/) normal hız/istatistiklerini verir. **Özgün sunucunun doğma koordinatı/orbit algoritması açık değildir.** Gövdede35–71başlangıç yarıçapı,260açılma noktaları,1s açılma ve300/335/370/405orbit yarıçapları yerel uyarlamadır. Birebir orijinal koordinat diye sunulmaz.20sayısı ve eski5s dolma da önceki yerel politikadır; Crazy Cubikon gibi sınırsız üretim etkinliği eklenmez.

## Geliştirme penceresi

`upgradeWindowUI.xml` içindeki `itemGridContainer` yüksekliği yoktu. FUI Coreponent'te autoSizeHeight varsayılanfalse olduğu için dikey yerleşim ızgaraya yeterli yer ayırmıyor, sonraki geliştirme bilgisi dolu silah satırlarına biniyordu. Kapsayıcıya146px sabit yükseklik verildi; ızgara120px sabit/maskeli, autoSizeHeight=false. Uzun envanter mevcut scrollbar ile kendi içinde kalır.25+120≤146; alt panel36px boşlukla devam eder; bütün içerik418px içinde450px pencereye sığar.

Kaynak XML MD5 `259c9633b0fa3d0fbfbfd5a443b430db`; `resources.xml` içindeki upgradeWindowUI hash'i güncellendi. Geliştirme bonus/formülleri ve toplu fiyat/başlatma/teslim akışı değiştirilmedi. Gerçek Flash ekranı görsel denemesi yapılmadı.

## Taç sorusu

Taç **Kronos'u tamamlayınca** gelir; `gate-rings.js` native64bitini gerçek kazanılmış/ödülü alınmış koşudan üretir. Alpha/Beta/Gamma/Delta/Epsilon/Zeta altı ayrı yüzüğü verir. [Resmî moderatör cevabı](https://board-tr.darkorbit.com/threads/tac.146032/), [yüzükler ve Kronos](https://board-tr.darkorbit.com/threads/ruetbenin-uestuendeki-6-nokta.59421/). Kullanıcıya Kronos'u açan normal21parça dizisi de açıklandı: Alpha4/Beta3/Gamma1/Delta1/Epsilon4/Zeta1/Kappa2/Lambda5. Bu tur hiçbir hesaba taç/kapı tamamlama eklenmedi.

## Doğrulama ve korunumu

**898/898test**,331JS/0hata; launcher/FlashDLL kimlik kontrolü PASS. Derlenmiş ses kapısı testleri ilk ses/2s/grup çağrıları/RSB/ayrı gemiler/saat sıfırlamasını, sabit atış testi hasar/ammo ritmini denetler.4Cubikon testi gerçek world/SQLite/codec ile doğuş/dağılım, hareketli hedef, boş slot doldurma, diğer refakatçilerin ayrımı ve gerçek combat.tick'i denetler. XML yerleşim testi kapsayıcının bütün ızgaraya alan ayırdığını doğrular.

Gerçek HTTP/TCP **22.653komut PASS**: yeni MAIN hash'i ve XML sunumu; Cubikon20doğuş/açılma ve20orbit hareket paketi alındı. `logs/audio-escorts-upgrade-tests.log`, `audio-escorts-upgrade-network.log`, `audio-escorts-upgrade-production-check.json`.

Yedek `backups/darkorbit-before-2026-10-23T18-06-48-090Z.db`. Üretimde **60tablonun bütün verisi yedekle aynı**;3hesap/3oyuncu/14gemi korunur, integrityOK/FK0. Yeni migration, hediye veya hesap satın alımı yok. HTTP üzerinden yeni MAIN ve upgrade XML manifest hash'i doğrulandı.
