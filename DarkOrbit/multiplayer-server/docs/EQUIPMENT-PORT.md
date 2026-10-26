# Canlı ekipman aktarımı — devam noktası

26 Ekim 2026. Kullanıcının kabul ettiği sıranın **1. maddesindeyiz**. Çekirdek hesaplama ve yazma işlemleri aktarıldı; bütün hangar arayüzünün bittiği söylenmez. Kaynak oyun/veritabanı korunur, `/ready`503 kalır.

## Doğrulanan kapsam

- Gemi türü ve eşya türü değerleri arşivin kendi SQL satırlarından okunur; özel katalog değerleri yeni tohumla ezilmez.
- Canlı stat sırası: diroite takılı eşyanın diroit seviyesi/tasarımı/upgrade ağırlığı, eşyanın kendi upgrade'i, gövde/modül, diroit seti/formasyon, arge, süreli maden, booster. 91 gövde ve iki konfigürasyonda 364 eski JS senaryosu, 48.778 alan karşılaştırması.
- Aynı fiziksel eşya aynı geminin iki konfigürasyonunda kullanılabilir; farklı gemiye veya aynı konfigürasyondaki başka hedefe kopyalanamaz. Toplu yerleştirmede sığanlar takılır, kalan kimlikler geri döner. Geçersiz son satır tüm işlemi geri alır.
- Gemi, diroit ve P.E.T. yuva/uyumluluk/seviye doğrulaması. Modül sınıfı ve gövde beyaz listesi; parçacık topu türü tekilliği. P.E.T. modül/protokol satışında kendi seviye fiyatı.
- Satış ve kredi tek PG işleminde; iki konfigürasyondaki bağlantılar birlikte silinir. İşlemdeki upgrade hedefi satılamaz. SLE çıkarılması/satılması genişletilmiş yuvada eşya bırakamaz.
- İki konfigürasyonun ayrı kalkan havuzu; C tuşunun `S|CFG|1/2` ve `ConfigChangeRequest` yolları aynı depoda. Canlı native hız/can/kalkan/modül/diroit/formasyon güncellemesi ve rota emekliliği.
- Süreli bonus sona ermesi, kaydedilen canın üst sınıra daralması ve yeniden hesaplamanın bedava iyileştirme vermemesi. Bağlantı sahibi/nesli vitals kaydını sınırlar.
- Kaydet/yükle: gemi/diroit/P.E.T. yuvaları iki konfigürasyonda korunur; satılan eşyalar yeniden oluşturulmaz, eksik düzen açıkça bildirilir. Favori/kaydet işlemleri rota veya stat revizyonu değiştirmez.
- Çevrimdışı aktif gemi/tasarım seçimi ve kapasite/modül doğrulamalı iki konfigürasyon aktarımı. Kaynak çevrimdışı kuralı korunur; gelecekteki harita içi ship-warp ayrı işlem olacak.
- Sahip olunan formasyon seçimi ve sayısal etkiler; gerekli dört diroit ve sahiplik kontrolü. Süreli drain/regen davranışı savaş katmanıyla tamamlanacak.
- Gövde ve EP/şeref modülü bonusu, modülün gerçek oyuncu seviye sınırı ve booster yuvarlama sırası aynı ödül işlemi içinde.

## Taşınan uçlar

`/flashAPI/inventory.php`: `move`, `droneEquip`, `moveDroneDesign`, `clearConfig`, `sell`, `sellMultiple`, `setFavourite`, `activateShip`, `changeShipModel`, `saveConfig`, `loadConfig`, `importConfig`. Orijinal base64 JSON zarfı ve satış `update` alanı korunur. Dosid/hesap/sunucu doğrulanır; kuyruktaki işlem kilidi aldıktan sonra oturum yeniden doğrulanır. Sunucu fiyatı/kapasitesi kullanılır.

Native: konfigürasyon, item move, clear, favourite, save, load, change-model ve import istekleri. Çevrimdışı gerektiren native işlemler orijinaldeki gibi bağlı oturumdayken başarı uydurmaz. Hangar liste/detay cevapları henüz canlı üreticiye bağlı değildir.

## İlk maddede kalanlar

1. Native `HangarListRequest`, `HangarShipEquipmentRequest`, `HangarShipDetailRequest` ile açılıştaki envanter paketlerini canlı kayıtlarla üret. P.E.T. görünümünün hesaplamasını da kaynakla karşılaştır; arşivdeki envanteri tekrar oynatma.
2. Flash `getHangarList`, `getHangar`, `getShipDetails`, `getCompatibleShips` okuma projeksiyonları. Küçük/geniş envanter ve satış/takma sonrası yeniden yükleme aynı canlı eşya kümesini göstermeli.
3. Diroit tamir/satış uçları, başlıktaki ücretli hangar yuvaları ve konfigürasyon kopyalama arayüzünün tam döngüsü. P.E.T. slot unlock/protokol çalışma zamanı ve CPU cephane ayarı kendi mekanik sıralarında tamamlanacak.
4. Gerçek Qt/Flash görsel kabulü kullanıcı tarafından yeniden yetkilendirildiğinde yapılacak. Şu anki native testler başsız gerçek TCP istemcileri; pencere tıklanmadı.

Bunlardan sonra kabul edilen sıranın 2. maddesi: NPC karşı ateşi, oyuncu can/kalkan kaydı, ölüm ve ücretli doğuş. Modern proc/roket/CPU/P.E.T. davranışları ve tam portal sonraki maddelerde devam eder.

## Testler ve sınırlar

- Saf JS/C# hesaplama: 364 senaryo / 48.778 karşılaştırma.
- PG envanter: 43 kontrol; arşivdeki 3 gerçek profil kopyasının temel istatistikleri dahil.
- Gerçek TCP/HTTP canlı ekipman: 16 kontrol; süreli bonus bitişi, C konfigürasyonu, native save/clear/load/favourite, Flash satış/taşıma, yeniden bağlantı ve yetkisiz istek.
- Hangar/P.E.T./çoklu diroit/depo düzeni: 17 kontrol; eşzamanlı aynı eşyayı satışın bir kere ödenmesi dahil.
- Atomik savaş kayıtları: 27 kontrol; modül seviye sınırı ve gerçek gövde seçimi dahil.
- Eski dokuz TCP istemcili giriş/portal/RSB/ödül testleri ayrıca çalıştırılır.

Testler yalnız `127.0.0.1:55432/darkorbit_development` altında rastgele kendi `mp_*` şemalarını kurar ve temizler. Hesaplara hediye eklenmez. Bunlar 500/1000 oyuncu savaş yükü veya fiziksel iki bilgisayar testi değildir.
