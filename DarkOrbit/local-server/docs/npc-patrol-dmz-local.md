# Normal NPC nüfusu, devriye ve portal koruması

21 Ekim 2026. Kullanıcı isteğiyle üç şirketin x-3 haritalarında **12 Devolarium**, x-4 haritalarında **12 Sibelon** vardır. Her iki harita grubunda Lordakia 16→6, Saimon 12→6, Mordon 10→8; büyük NPC 3→12 değişti. Boss adetleri korunur. Bunlar yerel nüfus ayarlarıdır; özgün sunucunun yayımlanmış adetleri diye sunulmaz.

`normal-population-2026-10-21-v2` yalnız ilgili profil sayısını aynı `map_spawns.id` üzerinde günceller. Eski dünya kurulumunu yeniden çalıştırıp NPC hasarı, ölüm nesli ve yeniden doğma beklemesini silmez. Azaltılan eski slot kayıtları silinmez; çalıştırılmaz.

Migration024, NPC'nin devriye dönüş noktasını son takip konumundan ayrı tutar. Harita/oturum ayrılışında hedef saklanmaz, başlamış geri dönüş saklanır. Dönüşte NPC kendi hızında geçen süre kadar ilerletilir; dönüş bitene kadar eski oyuncuyu tekrar edinmez. Aktif haritada menzil/portal koruması yüzünden bırakılan takip de devriye noktasına döner. Can, kalkan ve gerçek ölüm beklemesi bu işlemle sıfırlanmaz. Kapı dalgalarının ayrı takip davranışı korunur.

Özgün `BeaconHandler.setDemilitarizedZone`, `BeaconCommand.inPeaceArea` ile `GuiManager.displayNAZ` çağırır; yerel Türkçe metin `Saldırıya-Korumalı-Bölge`dir. Kendi şirketinin portal alanında bu alan artık gönderilir; atlama hazır olma bayrağı ayrı kalır. Yarıçap750 yerel seçimdir. Normal solo savaş yolları aynı alanı kullanır; portal içinde lazer/roket/Hellstorm/PET/özel silahlar korumayı aşmaz.

Kapsam sınırı: orijinal PvP'deki daha önce başlamış saldırının SKB'ye taşınması ve4-5'e girişte15saniye şirketler arası PvP koruması uygulanmış değildir. `resource_faq.xml` bu özgün kuralları açıklar; mevcut solo portal koruması bunların bütününü tamamladığını iddia etmez.

`tests/npc-patrol-dmz.test.js`: bütün şirketlerde gerçek nüfus, sürümün tek uygulanması, kalıcı hasarın korunması, kısa/uzun harita dönüşü, devriye takibi ve codec ile özgün Beacon/cephane engeli. `tests/respawn.test.js` üsse dönüşün önce eski harita snapshotını kaydettiğini de sınar.
