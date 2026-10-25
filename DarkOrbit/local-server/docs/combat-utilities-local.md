# Mayınlar ve savaş araçları

`game/combat-utilities.js`, gerçek `MenuActionRequest` menü kimlikleriyle ACM, EMPM, SABM, DDM, SLM mayınlarını; SMB akıllı bombayı, EMP ve ISH insta kalkanı çalıştırır. Kaynakta mayın açıklamaları PvP kullanımı anlatır. Bu solo sunucuda NPC tetikleme ve NPC alan etkileri açık bir yerel uzantıdır; canlı PvP eşdeğerliği iddia edilmez.

İstemci sözleşmesi `ConnectionManager.as`, `ClientCommands.as`, `BoxCollectResponseAssembly.as`, `ItemDataProvider.as`, `map/model/env/mine/Mine.as` ve gömülü `decompiled/pet-patterns/lib-assets.xml` üzerinden doğrulanır. ISH/SMB/EMP efektleri gerçek eski protokol `0|n|ISH/SMB/EMP|oyuncuId` ile gönderilir. Mayın `AddMineCommand` ile eklenir; patlama `0|LM|ST|MIN|hash`, süre bitimi `RemoveMineCommand` ile kaldırılır. Görsel türleri normal=1, EMP=2, kalkan=3, doğrudan=4, yavaş=7'dir. Kullanılmayan typed MapEvent komutlarına sahte başarı bağlanmaz.

- Mayın döşeme gerçek bir ilgili cephane tüketir. Normal mayın temel canın %20'sini normal kalkan emilimiyle; doğrudan mayın %20'sini doğrudan gövdeden; kalkan mayını mevcut kalkanın %50'sini götürür. Yavaş mayın hareket hızını 5 saniye yarıya indirir. EMP mayını hedef kilidini kaldırır. ArGe ve diroit mayın etkileri uygulanır.
- SMB, satın alınmış SMB cephanesinden bir adet tüketir. Yoksa aktif konfigürasyonda gerçek SMB CPU takılı olmalıdır; 10 ACM ve 100 Xenomit tek transaction ile tüketilir. Etki yakındaki NPC temel canının %20'sidir; sahibine hasar vermez.
- ISH için aktif konfigürasyonda gerçek ISH CPU şarttır; 10 ACM ve 100 Xenomit tüketir, kaynak açıklamasındaki 3 saniyelik korumayı NPC ateşine uygular.
- EMP bir gerçek EMP cephanesi tüketir, oyuncunun lazerini/hedef seçimini ve yakın NPC kilitlerini kaldırır; gövdeye hasar vermez. Sonradan tekrar saldırılan NPC yeniden hedef alabilir.

Miktarlar ve kalıcı bekleme durumu aynı SQLite transaction'ında yazılır. Eksik kaynakta cephane düşümü ve bekleme geri alınır. Bekleme `settings.game.utilityCooldowns` içinde saklanır ve yeniden girişle sıfırlanmaz. Aktif konfigürasyon/ölüm/oturum/istasyon kontrolleri sunucudadır; salt menü seçimi kaynak tüketmez.

Yerel politika: mayın 1 saniye sonra kurulur, 120 saniye yaşar, aynı anda en fazla 20 tanedir. Mayın yarıçapı 250, SMB 500, EMP 1000 birimdir. Mayın/SMB/ISH beklemesi 30 saniye, EMP 40 saniyedir. Bunlar `config.combat.utilities` üzerinden ayarlanır ve canlı sunucudan doğrulanmış zaman/yarıçap değerleri diye sunulmaz. Çıkış/harita değişimi aktif mayınları temizler. Yalnız kalıcı bekleme tutulur.

`node --test tests/combat-utilities.test.js`: 8 test; kurulum/tetikleme, farklı mayın etkileri, gerçek codec/görsel sözleşme, aktif CPU, atomik eksik kaynak geri alma, EMP, ISH, SMB, kalıcı bekleme ve oturum temizliği doğrulanır. Flash üzerinde görsel uçtan uca doğrulama ayrıca gerekir.
