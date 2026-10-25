# Özgün envanterde çoklu diroit sürükleme

21 Ekim 2026. Özgün Flash envanter arayüzü korunur. Yeni ekran/düğme eklenmez.

Normal bırakma yolu `DragComponent.rearrangeItem` ile bir diroide `ITEMS_MOVED_TO_DRONE_EQUIPMENT` gönderiyordu. Bu paketin hedefinde tek diroit vardır. Sunucunun bu isteği sessizce başka diroitlere yayması, Flash’ın yerel modelinin yalnız tek diroide güncelleme yapmasına ve yeniden girişe kadar farklı görünmesine yol açar.

İstemcide zaten tam bir dağıtım yolu bulunur: `handleMultiSectionQuickMove`, bütün diroitlerdeki boş yuvaları inceler; her diroit için ayrılmış gerçek eşya kimliklerini `from.droneItems` haritasına yazar. `ConnectionProxy.equipItemsToNDronesRequest` da `itemsToMove` listesini üretip native yanıt işleyicisiyle eşleşen diroit/eşya modellerini günceller.

Bu yol çoklu sürüklemeye bağlandı. Küçük koruma yalnız şu üç koşulda devreye girer: kaynak envanterdir, hedef diroit görünümüdür, sürüklenen simge birden çok eşyadan oluşan mevcut seçimin içindedir. Bu durumda mevcut native `handleMultiSectionQuickMove` çağrılır. Tek eşya bırakma, gemi/PET bırakma, envantere geri taşıma ve arayüz yerleşimi değişmez. Dağıtımın sırası özgün istemcinin diroit listesidir; kapasiteyi aşan seçim envanterde kalır.

Kanıt:

- `decompiled/swf_global/inventory/scripts/net/bigpoint/darkorbit/equipment/view/components/items/DragComponent.as`: özgün tek hedef sürükleme ve native çoklu dağıtım.
- `ConnectionProxy.as:1263`: çoklu model/yanıt yolu.
- `decompiled/drone-bulk-patch/inventory-before.swf`: yedek.
- `decompiled/drone-bulk-patch/source/DragComponent.as`: küçük korumalı kaynak.
- `decompiled/drone-bulk-patch/actual-after/.../DragComponent.as`: derlenen artifact yeniden decompile edilerek doğrulandı.
- `decompiled/drone-bulk-patch/evidence.json`: kaynak/çıktı SHA256 ve tag karşılaştırması.100 grafik/yerleşim/diğer tag aynıdır; yalnız bir DoABC tag değişir. Yeniden çıkarılan kaynak, amaçlanan koruma dışında yalnız eşdeğer `NaN → Number(NaN)` yazımıyla farklıdır.

Tekrarlanabilir derleme: `node tools/patch-inventory-drone-bulk.js`. Mevcut JDK21 ve `D:\swfde\ffdec.jar` JPEXS26.3 kullanılır; çalışma zamanı Flash çalıştırılmaz. Derlenen ve doğrulanan SWF `client/swf_global/inventory/inventory.swf` dosyasına konmuştur; native embed `local=20261021bulk` ile önbellek yeniler.

`tests/inventory-client-bulk-patch.test.js` gerçek sunulan SWF özeti ve yeniden decompile edilen kontrol akışını denetler. Sunucu tarafı gerçek `droneEquip` haritası/kapasite/işlem testleri ayrı envanter testlerindedir. Bu statik doğrulama canlı Flash fare hareketinin görsel olarak denendiği anlamına gelmez.
