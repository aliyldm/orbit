# Native montaj sekmelerinin durumu

Yükseltme ve Söküm'deki boş listenin nedeni eşyanın kaybolması değildi. `UpgradeProxy.handleRecipeAdded`, genel tarif durumunu yalnız `targetItemId=0` için `UpgradeTypeModel.recipes` listesine ekler. Aynı modelin `filterEmpty` metodu hem bu listenin dolu olmasını hem sahip olunan hedefleri ister. Sunucu yalnız sahip olunan eşyanın kimliğiyle tarif gönderdiğinden genel liste boş kalıyordu. `DisassemblyProxy` aynı modeli kullanır. Artık genel tarif durumu ve gerçek eşya durumları birlikte gönderilir; native arayüz değiştirilmez.

| Sekme | Bu yerel sürümde durum |
|---|---|
| Montaj | Mevcut kaynak tarifleri ve üretim/teslim akışı |
| Yükseltme | 15 kaynak tarif sınıfı; sahip olunan uygun silah, kalkan ve diroit hedefleri |
| Söküm | 8 kaynak tarif sınıfı; yükseltilmiş, hiçbir yerde takılı olmayan uygun eşyalar |
| Stabilize | Henüz uygulanmadı; aşağıdaki ayrı rastgele modül sistemi gerekli |
| Hyperforge | Henüz uygulanmadı; aşağıdaki ayrı kuantum çekirdeği sistemi gerekli |

Takılı yükseltilebilir eşyalar da Yükseltme'de görünür. CPU, maden ve cephaneye rastgele yükseltme tarifi eklenmez. Klasik 16 seviye kaynak tariflerinde DB seviyesi 0–15, görünen seviye 1–16'dır. Bu istemcinin bazı ileri ekipman tarifleri 20 seviyeye kadar tanımlıdır; kaynak sınırları korunur. Üretim maliyetleri ve süreleri `ItemDataProvider` tariflerinden alınır.

Söküm için ayrıca eşyanın native `hangarId` alanı düzeltildi. `ItemVO.isEquipped`, bu alanın sıfır olmamasına bakar. Artık ikinci konfigürasyon, diroit ve P.E.T. bağlantıları da gerçek hangar kimliğini taşır. Native arayüz bu eşyaları söküm hedefinden çıkarır; sunucudaki mevcut kontrol de sahte istekleri reddeder. Yükseltme sırasında kimlik ve bağlantı korunur; teslim alındığında gerçek savaş istatistiği yeniden hesaplanır.

`assembly.refreshInventory(world, sendCmd)` satın alma veya ekipman değişiminden sonra canlı istemciye tarif/yeni eşya bilgisini göndermek içindir. Önce yalnız Yükseltme/Söküm tarifleri, sonra `UserInventoryModule` gönderilir. Yüzlerce normal üretim tarifi tekrar gönderilmez. Genel başlangıçtaki tarif → envanter sırası, native `DiscountProxy` bağımlılığından dolayı korunur.

Stabilize, normal lazer geliştirme sistemi değildir. Resmî FAQ, kararsız modülün seçilmiş gemilerini koruyup bonuslarını yeniden üretmesini, takılı modüllerde de çalışmasını açıklar. Bazı başlangıç değerleri bilinir: XT10 için 30 parça geri dönüşüm, 150 parça yeniden dengeleme, iki kullanım sınırı. Yerel DB'de eşya başına rastgele bonus/gemi/kullanım kaydı ve sunucunun özgün dağılımı henüz yoktur. Bu yüzden bu işlem gerçekmiş gibi para veya eşya tüketmez. [Resmî Stabilize FAQ](https://board-en.darkorbit.com/threads/faq-unstable-modules-restabilize-system.127074/)

2022 genişlemesi eski/yeni bonusu seçme ve eskiyi koruma bedelini ayrıca tanımlar. Bu bekleyen sonuç/tercih kaydı da uygulanmış değildir. [Resmî Salvage genişlemesi](https://board-en.darkorbit.com/threads/new-unstable-modules-salvage-expansion.128093/)

Hyperforge için resmî Deep Space Echoes FAQ, özelliği Unity istemcisine ait olarak belirtir. Kuantum çekirdeği rastgele gemi ve nitelik alır; 5/10 seviyelerinde yeni nitelik açar, azami seviye 12'dir ve Luminaflux Alloy kullanır. Kaynak Flash'ta sekme/protokol sınıflarının bulunması, sunucudaki çekirdek üretim ve rastgele geliştirme tablolarını sağlamaz. Yerel eşya kataloğundaki AX/DF kodları bu değerlerin yerini tutmaz. [Resmî Hyperforge/DSE FAQ](https://board-en.darkorbit.com/threads/faq-deep-space-echoes-2025.129742/)

Stabilize/Hyperforge istekleri artık sessizce işlenmeyen paket olmak yerine native standart mesajla hangi sistemin henüz olmadığı açıklanarak reddedilir. `assembly.capabilities()` aynı durumu programatik olarak verir; işlem başarı yanıtı veya sahte sonuç gönderilmez. Bu iki sekmenin tamamlandığı iddia edilmemelidir.

Kaynak kanıtı: `mvc/crafting/upgrade/model/{UpgradeProxy,UpgradeTypeModel,UpgradeRecipeItemPair}.as`, `mvc/crafting/disassembly/model/{DisassemblyProxy,DisassemblyTypeModel}.as`, `delete_in_eic/{ItemVO,ItemsDataUtility}.as`, `mvc/crafting/assembly/model/{AssemblyModel,TargetItemRecipeModel}.as`, `mvc/crafting/{reroll,hyperforge}/model/*.as`.

`tests/assembly-native-tabs.test.js` altı testte eksik genel tarifin boş liste üretmesini, ekipman bağlantılarını, gerçek satın alma → native yükseltme → teslim → artan lazer hasarını, kaynak söküm iadesini ve desteklenmeyen işlemlerin hiçbir şey tüketmemesini denetler. Gerçek paket kodlayıcısı ve SQLite kullanılır. Native görünürlük koşullarının dar kaynak izdüşümü kullanılır; Flash ekranının görsel testi değildir.
