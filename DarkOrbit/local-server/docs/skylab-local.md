# Skylab ve rafineri — uygulama/evidence kaydı

18 Ekim 2026. Yeni kod: `game/skylab.js`, `game/handlers/lab.js`, `web/skylab-api.js`; migration `009-skylab.sql`.

## Kaynaktan doğrulanan sözleşmeler

`web/portal/pages/internalSkylab.html` gerçek kayıttan gelen modül adlarını, form alanlarını ve URL işlemlerini içerir:

Kaynak SHA-256: HTML `7B2C7F55EF9C5BAD4369FDCDA711FABF65BEF4C809EB1F574DC9A4DC8CCD21E7`; gömülü `game.xml` `0359DEECACA0A80466D3AE9829511C4BB89711F1F794A4034C67F1D080BC7263`.

- `action=internalSkylab`, `subaction=upgrade|instantUpgrade|setActive|setInactive`, `construction=baseModule|solarModule|storageModule|transportModule|xenoModule|prometiumCollector|enduriumCollector|terbiumCollector|prometidRefinery|duraniumRefinery|promeriumRefinery|sepromRefinery`.
- Transport formu POST `subaction=startTransport`, `construction=TRANSPORT_MODULE`, `mode=normal|fast`, `count_prometium`, `count_endurium`, `count_terbium`, `count_xenomit`, `count_prometid`, `count_duranium`, `count_promerium`, `count_seprom`.
- Normal/ani inşaat kredi, uridium, üç temel cevher maliyeti ve süreleri sayfadaki tablolardan çıkarıldı. `tools/export-skylab-evidence.js` bunları `game/skylab-evidence.json` olarak yeniden üretir. Örneğin temel modül 1→2: 16.352 kredi, her temel cevherden 707; ani işlem ek 1.487 uridium; normal süre 2:18.
- Kayıttaki başlangıç modülleri: temel/solar/depo/transport ve üç toplayıcı seviye 1; xeno ve rafineriler seviye 0. Kayıttaki 677 cevher veya hesap bakiyesi yeni hesaba aktarılmaz.
- Başlangıç depo kapasiteleri temel cevherler için 105.600, Prometid/Duranium 5.280, Xenomit/Promerium 528, Seprom 48; toplayıcı seviye 1 üretimi 2.200/saat; başlangıç enerji kullanımı/üretimi 96/170.
- Ani transport bedeli sayfada 1.250 uridium. Transport modülü sayfada seviye 1'de azami seviyededir.

Orijinal `client/js/skylab.js` yerel dosyalarda mevcut değildir. Bu dosyayı internetten yeniden indirmek yerine, sayfada çağrılan gerçek `Skylab.showModule`, `changeToTab`, `sendTransport` isimleri küçük yerel JavaScript ile uygulanmıştır. Asıl sayfanın modül kutuları, sekmeleri, stil sınıfları ve form sözleşmeleri kullanılır; stoklar ve işlem düğmeleri canlı DB verileriyle yeniden üretilir. Üretim robotlarının kayıtta görünen satın alma arayüzü bu sürümde uygulanmadığı için işlevsiz satın alma düğmeleri gösterilmez.

Rafineri tarifleri `decompiled/pet-patterns/game.xml` içindeki `<patterns><ores>` alanından doğrudan okunur; XML aynı SWF'nin karakter 187 gömülü oyun verisidir. `PatternManager.parseOrePatterns` ve `OrePattern.parseRefiners` virgüllü listedeki kaynak/miktar çiftlerinin anlamını doğrular:

| Çıktı | Kaynaklar (1 çıktı için) |
|---|---|
| Prometid (4) | 20 Prometium (0), 10 Endurium (1) |
| Duranium (5) | 10 Endurium (1), 20 Terbium (2) |
| Promerium (6) | 10 Prometid (4), 10 Duranium (5), 1 Xenomit (3) |

`LabRefinementRequest`, `LabUpdateRequest`, `LabUpdateItemRequest`, `LabUpdateItemCommand`, `UpdateItemModule` gerçek codec sınıflarıdır. `LabItemModule`: lazer 0, roket 1, motor 2, kalkan 3. `SourceRefinementModule.isValid` cevher/ekipman uyumluluğunu; `maxAmount*0.1` bir cevher başına on geliştirme birimini doğrular. `RefinementAssembly` yanıttaki sayacın istemciye nasıl yazıldığını gösterir.

Hasar/performans çarpanları Türkçe `client/spacemap/templates/tr/flashres.xml` açıklamalarındandır: Prometid hasar +%15; Duranium motor/kalkan +%10; Promerium hasar +%30, performans +%20; Seprom hasar +%60, kalkan +%40; Osmium hasar/kalkan +%50. Seprom ve Osmium motora, Duranium silahlara, Prometid jeneratörlere uygulanamaz.

## Kalıcılık ve doğruluk

Üretim son hesaplanan zaman damgası üzerinden süreç yeniden başladıktan sonra devam eder. Geçmişe giden saat kaynak üretmez. Kapasiteler ve girdi tüketimi uygulanır; uzun yokluklar dakika dilimlerinde bellekte hesaplanır, depolar kararlı duruma gelince kalan zaman atlanır. DB'ye yalnızca son stok yazılır. Modül inşaat bitişleri zaman çizgisinde ayrı sınırdır; geliştirilen üretici inşaat sırasında çalışmaz, tamamlandıktan sonraki sürede yeni seviye üretir.

Modül maliyetleri, cevher düşümü, para düşümü ve inşaat kaydı aynı savepoint içindedir. Başarısız maliyet/inşaat veri kaybı oluşturmaz. Her hesap için kalıcı rastgele `reloadToken` üretilir; başka hesabın veya yanlış anahtarın işlemi kabul edilmez.

Transport kaynakları gönderirken depodan ayrılır, ancak varış zamanı dolunca geminin `player_resources` kaydına eklenir. Tek bekleyen transport desteklenir. Başlangıçta geminin gerçek kargo kapasitesi kontrol edilir. Oyuncu arada kargosunu doldurursa teslimat bekler; cevher silinmez ve kapasite aşılmaz. Gemi kargosunda yer açılınca aynı teslimat bir kez yapılır. Kaynak yükleme hatasında taşıma bekleyen durumda kalır; tekrar denemek ikinci kargo üretmez. Canlı oyuna kargo ve bakiyeler bildirilir.

Skylab deposu `skylab_resources`, gemi kargosu `player_resources` tablosudur; aynı kaynak iki yerde birden sayılmaz. Pilot becerileri gibi başka işlemler `skylab.consume(db,playerId,oreType,amount)` yardımcısını kendi para işlemleriyle aynı SQLite transaction içinde kullanabilir. Yardımcı zaman ilerletmez veya ayrı commit yapmaz.

Silah cevheri yüklemesi gemi kargosunu düşürür; bir cevher on lazer salvosu veya on roket geliştirir. Her gerçek atış bir geliştirme hakkı tüketir. Motor/kalkan geliştirmeleri bitiş zamanı olarak saklanır; süresi dolunca sunucu istatistiği geri hesaplanır. Silah sayacı ve motor/kalkan süreleri `LabUpdateItemCommand` ile geri okunur. Güncel kaynak/ekipman kontrolü olmadan başarılı sonuç üretilmez.

Skylab'a bağlı gerçek görev 2 artık etkindir: kabulde oyuncunun seviye 6 şartı ve DB'deki Prometium toplayıcısı seviyesi kontrol edilir, gerçek `equipment_extra_hmd-07` ödülü bir kez verilir. Uydurma ilerleme sayacı kullanılmaz.

## Açık yerel denge kararları / kalanlar

Sayfa yalnızca kaydedilen seviyelerin fiyatlarını ve üretimini içerir; tüm canlı sunucu formülleri kurtarılmış değildir. Şunlar belgelenmiş yerel politikadır:

- Üst modül seviyesi 20; her üst seviye maliyet/süre artışı kaydedilen fiyatın `1.6^(mevcutSeviye-kaydedilenSeviye)` katı.
- Toplayıcı ve rafineri üretimi seviye karesiyle büyür. Yerel rafineri taban hızları 73 Prometid/saat, 73 Duranium/saat, 7 Promerium/saat, 1 Seprom/saat; xeno modülü 11 Xenomit/saat üretir. Seprom için 10 Promerium → 1 Seprom kullanılır; bu tarif kaynak XML'de bulunmadığından yerel tercihtir.
- Depo kapasitesi depo seviyesinin karesiyle, solar üretim seviye başına 170 enerjiyle artar. Modüller seviye başına 16 enerji kullanır; talep üretimi aşarsa üreticiler oransal yavaşlar. Gerçek Xeno sanal kaynak verimliliği modeli yerine taşınabilir Xenomit stoğu kullanılır.
- Normal transport süresi cevher başına 3,6 saniye. Yalnızca Skylab → gemi yönü uygulanmıştır; kayıttaki form da bu yönü göstermektedir.
- Motor/kalkan cevheri başına on dakika süre kullanılır. Üretim robotları, video hızlandırması ve canlı sunucuya özgü indirim/üyelik katsayıları uygulanmamıştır.

## Entegrasyon ve testler

- HTTP: `web/skylab-api.handle(playerId,params)` → `{ok,status,message,state}`; ardından mevcut portal HTML'i `render(player,html,{state,message})` ile doldurulur. Parent HTTP yönlendirmesi bunu bağlamıştır.
- Soket: `handlers/lab.register(onCmd,services)`; açılışa `lab.buildInit(player)` eklenir.
- Oyuncu istatistikleri: `lab.applyStats(playerId,stats)`; savaşta başarılı cephane tüketimi ardından `lab.consumeShot(player,0|1)` hasar çarpanı.
- Döngü: `skylab.tick(world)` zamanı dolan transportu teslim eder, `lab.refresh(world)` süresi dolan motor/kalkan geliştirmesini kaldırır.

`node --test tests/systems-skylab.test.js`: 19 test başarılı. Kaynak tarifleri, hesap izolasyonu, çevrimdışı üretim/sınırlar, inşaat/ücretler, kapasite/teslimat/yeniden deneme, SQL hata enjeksiyonu, gerçek sayfa form üretimi, codec paketleri, cevher geliştirmeleri ve görev 2 ödülü doğrulandı. Bunlar sunucu ve modül testleridir; Flash penceresinde görsel uçtan uca kontrol yapılmış sayılmaz.
