# Montaj ve galaksi kapısı görselleri

## Native pencerenin sürekli yüklenmesi: açılış sırası düzeltmesi

Oyun içindeki Montaj/Geliştirme penceresinin dişlide kalması, üretim motoru veya web sayfası ile çözülmüş sayılmaz. Kaynakta gerçek hazır olma koşulu bulundu: `CraftingOverviewWindowMediator` yalnız `InventoryModel.isInitialized` true olunca yükleme katmanını kaldırır. `UserInventoryHandler` envanteri işlemeden önce `DiscountProxy.updateFromServer` çağırır. Bu proxy'yi yalnız `AssemblyRecipeContentHandler` tarafından tetiklenen `InitAssemblyWindowProxyCommand` oluşturur.

Önceki sunucu sırası **UserInventory → RecipeContent** idi. Temiz istemcide ilk envanter işleyicisi henüz bulunmayan DiscountProxy üzerinde hata veriyor, ardından pencere ve boş modeller kurulsa bile envanter hazır sinyali gelmiyordu. Sıra **RecipeContent → UserInventory → filtreler** olarak düzeltildi. İlk macro komutu proxy'leri senkron kurar; XML pencereleri daha sonra yüklense de hazır envanter bayrağı korunur.

`tests/assembly-native-bootstrap.test.js` saklanan AS kaynaklarının bu koşullarını kontrol eder; gerçek kodlanmış açılış paketlerini istemci başlangıç durum makinesinden geçirerek eski sıranın sürekli yüklenmeyi ürettiğini, yeni ve tekrarlanan sıranın hazır duruma ulaştığını doğrular. Bu sınırlı durum makinesi gerçek Flash render çalıştırması değildir. Ağ testi ayrıca ilk gerçek TCP oturumunda RecipeContent'in UserInventory'den önce geldiğini denetler. Canlı HTTP kayıtlarında ilgili altı native UI/XML dosyası 200 döndüğü için eksik pencere dosyası kanıtı bulunmadı.

## Kapı görünüşleri

Önceden bütün yerleştirilen GG girişleri `designId:1` gönderiyordu; bu normal harita portalıdır. Artık her kapı gerçek istemci varlık kimliğini kullanır.

| Kapı | Builder ID | Görsel ID |
|---|---:|---:|
| Alpha | 1 | 2 |
| Beta | 2 | 3 |
| Gamma | 3 | 4 |
| Delta | 4 | 5 |
| Epsilon | 5 | 53 |
| Zeta | 6 | 54 |
| Kappa | 7 | 70 |
| Lambda | 8 | 71 |
| Hades | 13 | 74 |
| Kuiper/Streuner | 19 | 82 |

Kapının içinden eve dönüş normal portal, görsel ID 1 olarak kalır.

Kaynak: `UberAssetsLib_LIB_PORTALS_XML.as` gömülü karakter 176'yı işaret eder. `tools/extract-portal-assets.js`, aynı `client/spacemap/main.swf` dosyasının DefineBinaryData etiketinden `decompiled/portal-patterns/portals.xml` çıkarır. Kimlikler bu XML'in asset kayıtlarından gelir. Kaynak ve çıktı SHA256 değerleri `docs/portal-assets-evidence.json` içindedir. `Portal.as` ve `JumpgateCreateHandlerCommand.as` gelen designId'yi doğrudan bu varlık kitaplığına yönlendirir.

Test, on girişin farklı kimliğini, XML kaydını, gerçek yerel 2D atlas ve 3D mesh dosyalarının varlığını, native paket kodlamasını ve standart dönüş portalını doğrular. Bu statik dosya/protokol doğrulamasıdır; Flash ekranında görsel karşılaştırma yapıldığı iddia edilmez.

## Montajın kullanılabilir arayüzü

Portalın sağ altındaki **Montaj Atölyesi** düğmesi veya `/indexInternal.es?action=internalAssembly`. Geliştirme **Eşya Geliştirme** sayfasında, üretim ve kaynak geri kazanımı Montaj Atölyesi'ndedir. Native oyun içi Montaj/Geliştirme/Söküm paketleri de aynı sunucu motorunu kullanır; özgün `DisassemblyRequest` artık kayıtlıdır.

Skylab ön koşulu yoktur. Tarif doğrudan oyuncunun depodaki eşyasını, kargosundaki madeni, gerçek PET yakıtını, GG ekstra enerjisini ve bakiyesini kullanır. Sonuçta destekler gerçek zamanlayıcıya, maden gerçek kargoya, enerji GG hesabına, PET yakıtı gerçek depoya gider. Aktif istemciye yeni bakiye, kargo, cephane ve envanter gönderilir.

### Tarif kapsamı

İstemciden çıkarılmış katalogda **672 tarif** bulunur:

- **638 normal üretim:** Her biri izole hesapta tam malzemeleri verilerek başlatıldı, gerçek süresinin sonunda sonucu teslim alındı.
- **15 geliştirme sınıfı:** Her sınıfın gerçek hedef ekipman/diroiti, kaynaktaki son seviyeye kadar bütün ara maliyetler toplanarak geliştirildi. Modern eşyalar kaynak tablosu varsa 20, klasik bazı eşyalar/diroitler 16 seviyeye kadar çıkar; veritabanı/protokol seviyeleri sıfır tabanlıdır.
- **8 söküm sınıfı:** Kaynağın yalnız mevcut seviye satırındaki pozitif maliyet tahsil edilir, negatif malzemeler kaynak iadesidir. Eşya tüketilir; aynı fiziksel eşya başka işte kilitliyse veya herhangi bir konfigürasyon/PET/diroite takılıysa sökülemez. Tüketilmiş satır miktar 0 olarak tutulur; eski fiziksel kimliğin iade eşyasında hemen tekrar kullanılmasını önler.
- **11 kapalı tarif:** 2 klan savaş istasyonu geliştirmesi, istemci kataloğunda sonuç SKU'su bulunmayan 7 tarif, aynı eksik malzemeyi isteyen 1 dahili test tarifi ve etkisi desteklenmeyen RM-B00 destek tarifi. Atölye bu nedenleri gösterir; bunlardan malzeme çekmez veya teslim edemeyeceği bir üretim başlatmaz.

519 zamanlanmış tarif `config.assembly.enableAllScheduled:true` ile yerelde kalıcı açılmıştır. Bu **yerel sunucu politikasıdır**, özgün etkinlik takviminin yeniden oluşturulduğu anlamına gelmez. Plan sahipliği isteyen tarifler oyuncunun gerçek planını ister. Kullanım sınırları kaynaktaki `maxUses` ve `usingStrategy` ile korunur; kalıcı yerel takvimde kullanım sınırının her etkinlik dönüşünde yenilenmesi henüz bulunmaz.

### Düzeltilen tutarlılık

- `costScalingFactor` 1.1 olan tariflerde mevcut kullanım sayısından başlayan geometrik toplam ve istemcideki yuvarlama uygulanır. Adetle düz çarpım yapılmaz. Üretim süresi adetle çarpılır; fiyatın geometrik artması süreyi geometrik artırmaz.
- Aynı fiziksel hedefte farklı yükseltme/söküm tarifleri eşzamanlı başlatılamaz.
- Malzeme ve iş kaydı aynı işlemde yazılır. Sonuç teslimi hata verirse iş tamamlanmış olarak güvenli tekrar için kalır. Toplama ikinci kez ödül vermez.
- Takılı malzemeler üretim girdisi olarak harcanamaz. Gövde dönüşümü aktif gemiyi harcamaz ve canlı oyun sırasında gemi dönüşümü yapmaz.
- Gerçek maden, yakıt ve enerji assembly envanterinde de sayılır; sıfır miktarlı tüketilmiş satırlar gösterilmez.

Kaynak davranışlar: `mvc/crafting/assembly/model/AssemblyRecipeModel.as` geometrik maliyet ve yuvarlama; `TargetItemRecipeModel.as` ara geliştirme seviyelerinin maliyet/süre toplamı; `mvc/crafting/disassembly/model/DisassemblyRecipeModel.as` mevcut seviye negatif kaynak iadesi; `mvc/crafting/disassembly/view/DisassemblyMediator.as` native söküm isteği. Tarifler `docs/client-map.items.json` içinde `Recipe` kayıtlarıdır.

## Doğrulama

`node --test tests/assembly.test.js tests/assembly-expanded.test.js tests/galaxy-gate-portals.test.js`

18 test: temel 10, genişletilmiş 7 ve görsel varlık testi 1. Genişletilmiş testler 638 tarifi ayrı hesapta gerçekten üretir; 15 geliştirme ve 8 söküm sınıfını tamamlar. Ayrıca maliyet artışı, hedef kilidi, native söküm akışı ve kullanılabilir web üretim/teslim ekranını doğrular. Testler gerçek oyunculara eşya veya para eklemez.
