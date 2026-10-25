# Lazer iadesi, üretim, diroit ve Cubikon — 25 Ekim 2026

Dağıtıldı: **PID24464**, solo HTTP8095 / TCP8096, healthOK. Kaynak testi **1011/1011**, gerçek izole HTTP/TCP senaryosu **23838 çözümlenmiş komut**. Gerçek Qt penceresine girdi verilmedi; sesin kullanıcı tarafından dinlenmesi ve Flash görüntüsü kabulü ayrıca gerekir.

## İstenen düzeltmeler

- Bütün26 lazer tekrar satış/üretim/ödül yolunda açık. Önceki LF4 tavanı kararı iptal edilmiştir. Metadata ve modern-lasers özgün özel özellik yolları korunur; bütün kapalı sunucu RNG/bonus birleşim ayrıntıları çözüldü diye sunulmaz. Özel Fırsatlar196 ürüne döndü; diğer özelleştirilmiş Module/Convert fiyatlandırması korunur.
- Daha önce silinen67 Mortifer lazer, özgün yükseltme seviyeleriyle **boş envantere** seçici iade edildi: asd26, test41. Eski ekipman atamaları güncel konfigürasyonu ezmemek için yeniden takılmadı. asd'nin önceden ödenmiş4 geliştirme işi yeni item kimliklerine bağlanıp geri getirildi; tekrar ücret alınmadı. Makbuz `logs/lasers-restored.json`; tek-seferlik settings anahtarı `admin.restore-lasers-20261024`.
- Günlük girişte buton **BAŞLA**. TR yükleme XML MD5 manifesti yenilendi.
- LF4 agate dahil91 normal ekipman tarifi yeterli Convert ile tekrar ve çoklu üretilebilir. Eski kullanım sayacı silinmedi; normal ekipmanın tek kullanımlık istemci/sunucu sınırlaması kaldırıldı. Benzersiz gemi/diroit/tasarım sınırları korunur.
- Geliştirmede diroit için eksik XP-seviye özelliği düzeltildi. Native ItemVO.xpLevel1..6 yerine0 okuyunca ItemBuff drone−1 lookup ile −1% ve boş Error ikonunu üretiyordu. Artık UserInventoryModule her altı seviyeyi doğru gönderir; yüzdeyi görsel olarak örtme yok.
- Hangar native `moveDroneDesign` eylemi desteklenir. Havoc/Hercules/Spartan ve görsel tasarımlar çıkarılabilir; yalnız seçilen konfigürasyon değişir. Native `success/newEffects` dönüşü, yabancı sahip/yanlış yuva reddi ve öğe korunumu testlidir.
- Normal lazer sesi2s'den **1s** aralığa getirildi. Normal görsel alt salvo200ms'den **220ms** oldu; RSB200ms ve ses yolu korunur. Gerçek hasar/cephane turu1000ms olarak kalır. Ortak2D/3D zamanlayıcısı değişti; ses dosyaları değişmedi.
- Maden ticaret istasyonunda eksik MapAssetActionAvailableCommand eklendi; yakında aktif simge ve native maden satışı açılır. Sahip şirket/alive/jump/350mesafe kontrolüyle özgün OreTradeInfoCommand kullanılır. Bu, genel TradeRequest'ten bağımsız gerçek asset aktivasyonudur.

## Cubikon örneğinin gerçek nedeni

Üretim kayıtlarında hem asd hem test: **397000 Seprom**, diğer kapasite tutan madenlerle **397026 kullanılmış ambar birimi**. Bu gövdelerin kapasitesini fazlasıyla aşar. Xenomit yer kaplamadığından tek başına alınabilir. Seprom silinmedi, iade edilmedi, başka depoya taşınmadı veya kendiliğinden zenginleştirmeye harcanmadı.

Cubikon'un taban ölüm kargosu:

| Maden | Adet |
|---|---:|
| Prometium |1200|
| Endurium |1200|
| Terbium |1200|
| Xenomit |64|
| Prometid |512|
| Duranium |512|
| Promerium |64|

Kaynaklar: [resmî DE NPC tablosu](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/), [resmî ES Aliens tablosu](https://board-es.darkorbit.com/threads/faqs-aliens.135697/). Miktarlar toplama bonusu öncesidir. Önceden mevcut tablo bu sayıları zaten içeriyordu; sırf hata bildirildi diye doğru sayılar değiştirilmedi.

Yeni regresyon, gerçek Combat.kill → FROM_SHIP kutusu → native oreID → veritabanı/log zincirinde45 normal/Boss/Uber/korsan türünü doğrular. Cubikon için397000Seprom doluluğu yeniden üretildi:64Xenomit alınır, diğer6 maden kutuda kalır; ambar açılınca artanlar bir kez alınır, Xenomit/bonus tekrarlanmaz. Aynı durum gerçek TCP CollectBoxRequest ile de geçti. Kutu ömrü120s; kalıcı depo değildir. Boş ambarın bile tüm Cubikon kargosunu tek seferde alacak kadar büyük olması gerekmez.

**Tam özgünlük sınırı:**108 taban türün103'ü kaynaklıdır. Beş Kuiper türü ve23 çarpanlı kapı varyantının cevherleri önceki raporda belirsiz kalır. Kaynağın maden satırı yazmaması sıfır kanıtı değildir; nominal HP/ödül çarpanını cevhere otomatik uygulamak da kanıt değildir. Bu kayıtlar uydurularak kapatılmadı. Tam liste `npc-cargo-audit.json`. Bildirilen Cubikon sorunu bunlardan biri değildir.

## Dağıtım ve korunma kanıtı

- Önceki PID24352 kayıt işleyicisiyle kapatıldı. SQLite online/WAL yedeği: `backups/darkorbit-before-2026-10-24T18-18-27-978Z.db`.
- Seçici iade sonrası60 tablonun her eski satırı ve şeması korundu. Yalnız `items`+67, `assembly_jobs`+4, `settings`+2. Cüzdanlar, madenler, ekipman atamaları, görev/kapı ilerlemesi değişmedi.3hesap/3oyuncu/14gemi; integrityOK/FK0.
- İlk yeniden başlatma otomatik onay hizmeti kullanım sınırında çalıştırılmadı; kullanıcı devam isteğinden sonra portlar kapalı doğrulanıp PID24464 başlatıldı. Kanıt `logs/restoration-production-check.json`.
- MAIN: `47a0a55587987d5918ccb41e3e8fa9f3da2c13a8514b01e1e5be0f296894e585`; cache `local-20261024-lasers-crafting-rhythm`. Eski d732 artifact artık kurulu sürüm değildir.
- Repeatable-equipment → laser-rhythm derleme zinciri ve256 medya tagının değişmediği evidence.json dosyalarında. Önceki bütün MAIN testleri zincire bağlandı. İstemci değişiklikleri için oyunu tamamen kapatıp tekrar açmak gerekir.
- 5-x labirenti kapalı; çok oyunculu/.NET başlamadı. Bütün yerel eksikler tamamlandı değildir. Üretim Flash diagnostic logunda BattlePassDataAssigner.updateObjectiveProgress null hatası görüldü; ayrı takip gerekir, bu paket onu düzeltti demek değildir.
