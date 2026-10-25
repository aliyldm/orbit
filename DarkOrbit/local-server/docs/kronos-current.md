# Kronos solo kapısı — 23 Ekim 2026

[Özgün Kronos FAQ](https://board-en.darkorbit.com/threads/kronos-gate-faq.838/), [resmî NPC değerleri](https://board-es.darkorbit.com/threads/faqs-aliens.135697/) ve gönderilmiş istemci kullanıldı. NPC bölümünün yerel kanıtı `docs/evidence/kronos-official-npc.txt`. Map76 `maps-config.xml` içinden, portal72 gömülü portallar XML'inden doğrulanır. Hades'in dalgaları/solo uyarlaması değiştirilmedi.

Kronos enerjiyle çevrilmez: Alpha4, Beta3, Gamma1, Delta1, Epsilon4, Zeta1, Kappa2, Lambda5 parçaları gerekir. Builder'ın8 kaynak sayacı gerçek envanteri gösterir. Kurulum21 parçayı tek işlemde tüketir, üç canlık sahibi belli koşu oluşturur; ikinci kurulum tüketemez. SQL hatası parçaları geri alır. Yalnız `parts_json` alanını doldurmak bedava kapı oluşturmaz. Eski kapı tamamlama ödülleri zaten sınırlı Kronos parçaları veriyordu; bu defter korunur.

`game/kronos.js`: **13 ana dalga,50 sıralı alt grup,377 NPC**. Her NPC'nin HP/kalkan/alt-üst hasar/hız/ödülü resmî ES tablosundan; sıralama EN FAQ'dan. Saturn gemileri gerçek gemi görsellerini kullanır. Evil You kabul anındaki gövdeyi; Evil Iris gönderilmiş istemcideki108 desenini kullanır. Son iki türün hızı kaynakta `-` olduğundan oyuncunun kurulum anındaki hızıyla sabitlenir; bu değer **yerel** ve açık bir seçimdir.

Ana dalga sonunda devam/üs portalları, alt gruplarda otomatik devam, çıkış/yeniden girişte korunmuş ilerleme vardır. Ölüm mevcut ana dalganın başına döndürür. Önceden öldürülen slotun ödül kaydı korunur; tekrar denemede aynı slot ikinci kez ödeme yapmaz (mevcut kapıların yerel tekil ödeme politikası).

Bitiş:25.000 U.,25.000 UCB,250 ekstra enerji,500 UBR,5.000 RSB,15 günlük dosyası,10 yeşil anahtar,12 milyon TP,450.000 şeref; gerçek destek bonusları genel ödül katmanından uygulanır. Bitiş kaydı native64 maskesiyle taç verir. Saturn gövdesinin mevcut %20 HP pasifi kullanılır; zaten sahipken ikinci gövde yaratılmaz. **Saturn düşme ihtimali yayımlanmamıştır:** yerel varsayılan%10, `galaxyGates.kronosSaturnChance` ile değiştirilebilir; özgün oran diye sunulmaz.

`tests/kronos.test.js`: bütün koşunun bitmesi/377 tekil NPC ödemesi,12 checkpoint, kaynak kanıtıyla28 NPC'nin karşılaştırılması, kurulum/geri alma, sahte parça/enerji isteği reddi, ölümden dönüş, enerji/taç/ödül tekilliği ve Saturn dalı testlidir. Görsel Flash kontrolü ayrıca gerekir.
