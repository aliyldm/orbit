# Diroit ana görünürlük anahtarı

22 Ekim 2026. Yerel istemcide genel “Diroitleri göster” seçeneği bütün diroitler için ana anahtar olarak kullanılır. Önceki sunucu düzeltmesi genel anahtar kapanınca kendi diroitlerini de kapatıyordu; tekrar açılırken `displayMyDrones=false` kalabiliyordu. Bu durumda genel kutu işaretli olmasına rağmen oyuncunun diroitleri görünmüyordu.

Native `SettingsWindowFUIProxy.handleCheckBoxValueChangedInWindow` içindeki `SHOW_DRONES` dalı düzeltildi. Genel kutunun değeri değiştiğinde hem `model.showMyDrones` hem `Settings.showMyDrones.value` aynı değeri alır. Böylece modeller hemen değişir, pencere kendi diroitleri kutusunu günceller ve Kaydet isteği doğru iki alanı birlikte taşır. Genel anahtarın değeri değişmediyse ayrı “Kendi diroitlerimi göster” tercihi korunur. Kendi kutusu tek başına yalnız kendi diroitlerini etkiler.

Bu davranış kullanıcı tarafından istenen yerel ana anahtar davranışıdır; özgün istemcideki iki bağımsız alanın aynısı olduğu iddia edilmez. Anahtar açıkken fiziksel 2D/3D modeller, kapalıyken önceki F/I/A/Z ve Havoc/Hercules renkli özet satırı kullanılır. Önceki `TopDisplay`, M kısayolu ve Montaj düzeltmeleri değişmemiştir.

Araç: `tools/patch-drone-master-toggle.js`. Kanıt: `decompiled/drone-master-toggle-patch/evidence.json`. Girdi SHA256 `3fb99f161dbf70f7a49f2b898f4d0cde16cb320f652bdeda40afbf1f071ce113`, kurulu çıktı `e445a0d6a05f56d5ec0de9766b29278b564c1ebb731ac4d074a3aa36179e3eb3`. Yalnız bir DoABC etiketi değişmiştir; 256 diğer etiket aynıdır.

`tests/drone-master-toggle.test.js` eski dalın kapalı kalan kendi diroitlerini, yeni derlenmiş dalın kapat/aç döngüsünü, bağımsız kendi kutusunu ve önceki yamaların korunmasını denetler. Diğer native Montaj/M artifact testleriyle 12/12 geçti. Kullanıcı Computer Use’u durdurduğu için bu değişiklikte bilgisayar arayüzü kullanılmadı; görsel test yapıldığı iddia edilmez.
