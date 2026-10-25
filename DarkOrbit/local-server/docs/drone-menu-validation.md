# Iris görseli ve bütün eylem çubuğu sekmeleri

21 Ekim 2026. Oyuncu eşyaları, diroit deneyimi veya tasarımları değiştirilmedi.

## Pişmiş hindi görselinin kesin nedeni

Veritabanındaki diroit seviyesi `0..5`; hangar yuvaları da bu indeksi kullanır. Haritadaki `0|n|d` paketi ise bu indeksi doğrudan gönderiyordu. İstemci `Drone.uberAssetDescriptorId` ile örneğin `2_standard_0` arar. Gömülü drone kütüphanesinde **yalnız `2_standard_1` … `2_standard_6` vardır**; aynı kural Flax/Apis/Zeus için de geçerlidir.

Tanım bulunmayınca `Drone.uberAssetDescriptor` → `UberAssetsLib.getDebugDescription()` → **`lib_ships:120`**, yani yorumunda `Turkey` yazan pişmiş hindi modeli kullanılır. Dolayısıyla sebep satın alım veya hesaba yanlış tasarım verilmesi değildir.

Düzeltme yalnız harita paketinde `d.level + 1` gönderir. Veritabanı ve hangar seviyeleri korunur; stat/kozmetik tasarım alanlarının sırası korunur. Altı seviye × dört tip, toplam24 tanım testte gömülü XML ile eşleştirilir.

Kanıt dosyaları:

- `decompiled/main/scripts/net/bigpoint/darkorbit/net/MapEventsAssembly.as:476`: dört alanın yorumlanması.
- `decompiled/main/scripts/net/bigpoint/darkorbit/map/model/ship/drones/Drone.as:85`: tanım öncelikleri ve debug geri dönüşü.
- `decompiled/main/scripts/net/bigpoint/darkorbit/mvc/common/model/assets/UberAssetsLib.as:133`: debug gemi120.
- `decompiled/drone-asset-evidence/lib_drones.xml`, `debug-ship-120.xml`, `evidence.json`: eldeki SWF içindeki177/189 numaralı XML blokları ve SHA256 kimlikleri.
- Yeniden çıkarım: `node tools/extract-drone-evidence.js`. Bu araç SWF’yi çalıştırmaz/değiştirmez.

## Satın alınan dizilimin görünmemesi

İstemcinin `DroneFormationAvailableFormationsHandler.run` gövdesi **boş**. Sunucunun yalnız bu paketi göndermesi, menüde gizli kaydedilmiş dizilim satırlarını açmıyordu. Menü artık her sahip olunan dizilim için `visible/available`, seçili durum ve gerçekten en az dört diroit varsa `activatable` üretir. Satın alma ve seçimden sonra gerçek `MenuInitializationCommand` güncellenir.

Dört diroitten önce sahiplik ve görünürlük korunur. Erken etkinleştirme denemesinde Türkçe asgari dört diroit mesajı gösterilir. Ücretsiz diroit verilmez. Gerçek HTTP satın alma → menüde görünürlük → TCP `MenuActionRequest` → `DroneFormationChangeCommand` zinciri ağ yardımcısında doğrulanır.

## 13 sekme / 286 satır kapsamı

Tam kimlik listesi ve bağlı gerçek sunucu işleyicileri `action-menu-audit.json` içindedir. `node tools/audit-action-menu.js` dosyayı yeniden üretir. Sayılar bu incelemenin anlık kod durumunu gösterir; gelecekte işleyici eklenince rapor yenilenir.

| Sekme | Çalışan | Kısmi | Henüz işlevi yok |
|---|---:|---:|---:|
| Lazer |23|1|0|
| Roket |9|0|5|
| Roketatar |10|0|0|
| Parçacık topu |12|0|0|
| Sürücü |4|0|0|
| Özel öğeler |3|0|65|
| Mayın |5|0|2|
| CPU |13|0|17|
| Hızlı alım |8|0|0|
| Teknoloji |9|0|6|
| Gemi yetenekleri |6|0|59|
| Diroit dizilimleri |21|0|0|
| PET kısayolları |1|0|7|

**124 çalışan /1 kısmi /161 uygulanmamış satır.** Bu sayı bütün oyunun tamamlanma yüzdesi değildir:65 özel satır havai fişek/emote/sprey **kozmetik kullanımıdır**; savaş işlevi eksikliği olarak sayılmamalıdır. PET kısayol sekmesindeki modern7 yetenek ayrı; mevcut9 klasik PET donanımı kendi PET penceresinden çalışır. CPU tablosu yalnız tıklanabilir kayıtlı menü satırlarıdır; pasif34 CPU türünün katalog denetimi ayrı rapordadır.

Çalışmayan sahip olunan bir öğe artık etkinmiş gibi görünmez; stok korunarak gri satır ve Türkçe açıklama gösterilir. Sahip olunmayan desteklenmeyen kayıtlı satırlar gizlenir. Desteklenen stok/CPU/dizilim/PET durumları gerçek hesap ve aktif konfigürasyondan gelir. Hızlı alım kısayolları artık gerçek bakiyeden **bir birim** satın alır; bu miktar mevcut yerel seçimdir.

PIB-100 temel ×4 hasar verir; enfeksiyon alt sistemi eksik olduğu için kısmi işaretlidir.59 modern gemi yeteneği, ek portal/uzaylı CPU’ları, bazı özel roket/mayınlar ve modern PET donanımları bu incelemede çalışıyor diye sunulmaz.

## Ek bulunan ve düzeltilen hasar sorunu

Özel lazer cephanelerinin sayısal olmayan `typeValue` değerleri katalog aktarımında ×1’e düşüyordu. Artık runtime seçimi `laser-ammo.js` üzerinden eldeki TR `resource_items.xml` açıklamalarını uygular: RSB6, SAB2, CBO3+1kalkan transferi, JOB3,5, RCB7, CC gruplarının ayrı PvE değerleri, A-BL/SBL/EMAA/VB’nin belirli NPC bonusları. IDB’nin atlanan `General` tanımı seçilebilir; başarılı vuruşlarda1,25 artar, en çok6 olur, üç saniye ara verince sıfırlanır. Başarısız vuruş artış sağlamaz.

PLD/DCR gerçek stok,525 menzil, kaynak roket görseli5/10 ve uçuş sonrası beş saniye etki kullanır: PLD lazer doğruluğunu40 puan düşürür; DCR hızı%30 azaltır. Kaynak cephane açıklamaları bu etkileri belirler. Bekleme/isabet özel sunucu formülü açıklanmadığından yerelde30 saniye ve yapılandırılabilir isabet seçilir; özgünlük iddiası yoktur. Bu etkiyi NPC’lere uygulamak solo sürüm kapsamıdır.

`tests/modern-equipment.test.js`: **24/24**; gerçek paket codec’i, stok/işlem geri alma, tip/seviye/tasarım ayrımı, görünürlük ve kaynak cephane kuralları dahil. Son toplu test/ağ sayıları ana doğrulama raporundadır.
