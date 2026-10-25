# Özgün lazer ses ve animasyon zinciri — 25 Ekim 2026

**Dağıtıldı: PID28700/solo8095–8096/healthOK.** Önceki30260 kayıtla kapandı.23-13-04-721ZSQLite/WALyedekle60tablonun tüm satır/şeması aynı;3hesap/3oyuncu/14gemi/integrityOK/FK0. Kanıt `logs/native-lasers-production-check.json`. Yeni migration, hediye veya iade yok.

Kullanıcı son olarak ses ve animasyonların tümünde özgün istemci davranışını istedi; önceki220ms görsel yavaşlatma tercihini geri çekti. Önceki [envanter/ticaret/Seprom paketi](inventory-trade-audio-current.md) korunur.

**1.039/1.039 test**, **376 JavaScript / 0 sözdizimi hatası**, ayrı bellek veritabanında **24.135 gerçek HTTP/TCP komutu PASS**. Loglar `logs/native-lasers-*`; üretim kanıtı `logs/native-lasers-production-check.json`.

## Son davranış

- Normal ve RSB namlu grupları özgün `sıra × 200ms` takviminde. Özel220ms yavaşlatma yok. İlk grup anında; geminin gerçek desenindeki sonraki gruplar200/400/600ms vb. Tek ağ/hasar turundaki grup sayısı DPS veya cephane tüketim sayısı değildir.
- Özel1s/2s ses susturma kapıları yok. 2D/3D özgün ses çağrılarını, ses örneklerini, konum/öncelik ve ses düzeyi kurallarını kullanır. Normal sunucu atış turu1s, RSB beklemesi3s korunur.
- Yakalanmış daha güncel AudioManager'daki durmuş/bitmiş kanal temizliği taşındı. Unique ve stacking listeleri kanalı bırakır; aynı kanalı arka arkaya iki kez kaydeden durumda da referans kalmaz. Null loop kaldırma güvenlidir. Ses sayısı/öncelik eşiği keyfî değiştirilmedi; Unity'ye ait5uzak ses sınırı Flash'a kopyalanmadı.
- Önceden kırmızı0'a düşen CBO8, JOB9, RB21410, PIB109, ABL110, RCB111, IDB112, VB113, SBL114 ve Spacecup32 tipleri native `<lasers>` türlerine bağlandı. Bunlar salvoID veya envanter cephane ID'siyle karıştırılmadı. CBO, native14+15 çift animasyonu kullanır. Her cephane için gerçek MenuActionRequest→AttackLaserRequest→AttackLaserRunCommand→AttackAbortLaserRequest ağ yoluyla doğrulandı; yalnız fixture bekleme süreleri sıfırlanır, üretim beklemeleri aynı.
- NPC0, NPC'nin kendi `laserClassID` üzerinden çözümlenir; bütün NPC'lere kırmızı kahraman efekti zorlanmaz. ArGe kalın lazer/kalkan bayrakları, gemiye özgü2D/3D çıkış noktaları, kaliteye bağlı sadeleşme, hedefi takip ve durdurulmuş atışı temizleme korunur.

## Karşılaştırma

Yama `tools/patch-native-laser-visuals.js`, kanıt `decompiled/native-laser-visuals-patch/evidence.json`. MAINffd878…→**8982264ff56b60223647ccf697881ad94b120633db5007d0481897de091aed97**; gameclientHash **local-20261025-native-lasers**.256kod dışı etiketin tamamı bu yama öncesiyle aynı. Önceki tarif/upgrade/roketatar ve envanter düzeltmeleri korunur.

Kurulu son SWF ile yakalanmış host MAIN1170d6ae… tekrar decompile edildi: LaserEmissionSchedule, LaserImpactGeometry, iki LaserSalvo, iki LaserEffect, LaserBullet3D, Lasers2D/3D, LaserCannon, AudioManager, LaserPattern, PatternManager ve AttackLaserRunHandler. **14/14 davranışsal kaynak eşleşmesi**,11tam metin eşleşmesi. Geri kalan3sınıfta decompiler'ın eşdeğer NaN, gereksiz Boolean/int dönüşümü ve gövdede kullanılmayan üçüncü dummy namlu parametresi varsayılanı0/NaN normalize edilir; bu dönüşümler kanıtta tek tek listelenir.

Embedded game.xml, her iki gerçek SWF'nin DefineBinaryData187 etiketinden çıkarılır. **laserDefinitions, laserDefinitionsAprilsFools, lasers, expansions** dört kesimi birebir aynıdır. Lazerlerin referans verdiği **15ses tanımının** tamamı aynı; ses bankaları/ses düzeyleri yeniden yaratılmadı. Bütün host MAIN'in kod dışı verisi eşit DEĞİL: önceki logo/metadata/asset farkları ve hosttaki daha yeni dünya bossu/kozmetik girdileri korunur; sırf lazer işi için tüm MAIN dosyası geri kopyalanmadı.

[14 Ekim2026 resmî geliştirici notları](https://board-en.darkorbit.com/threads/dev-notes-october-2026.130448/) Flash lazerlerinin atış/uçuş/çarpma ve hareketli hedef uyumunu iyileştirdiğini, bunların hasar/gerçek atış/cephane hızını artırmadığını açıklar.200ms Flash değeri bu açıklamanın Unity kısmından varsayılmadı; karşılaştırılan Flash LaserEmissionSchedule kodundan alındı.

## Kanıt sınırı ve kalanlar

Kaynak/binary/XML ve gerçek paket eşleşmesi, canlı orijinal sunucunun tüm gizli seçim kurallarını veya Qt'de duyulan/görülen her kareyi ölçmek değildir. Qt'ye girdi verilmedi ve ses kaydı alınmadı.

EMAA-20'nin bu XML'de adıyla ayrı efekt eşleşmesi yok; varsayılan0 davranışı korunur, yanlışlıkla SBL114 veya TODO119 diye tahmin edilmez. Scatter/Asmodeus/Odysseus gibi modern silahların karma ekipmanda özel görsel paket seçimi ve orijinal sunucunun lazer adedi→expansionStage eşikleri hâlâ kaynakla doğrulanmadı. Mevcut iki+gemi lazerinde ilk çift namlulu native kademeyi seçme, önceki kullanıcı isteğiyle eklenen yerel politikadır; gizli orijinal algoritma diye sunulmaz. Bu ayrıntılar tamamlanmadan **her lazer her koşulda yüzde100birebir** iddiası yapılmaz.

Oyun tamamen kapatılıp yeniden açılmalı. Müzik/efekt ses tercihleri ve grafik kalitesi değiştirilmedi.
