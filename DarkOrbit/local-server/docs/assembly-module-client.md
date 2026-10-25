# Yerel modül ekonomisinin Flash uyumu

Sonradan gerçek Qt/Flash oturumunda bulunan asıl takılma nedeni: `resource_gold-pass` eşya tanımı `ItemTraits=null` taşıyor ve `AssemblyInventoryIndex.updateItem` bunu koşulsuz sorgularken TypeError #1009 oluşturuyordu. `tools/patch-assembly-null-traits.js` düzeltmesi kuruldu; güncel MAIN `3fb99f161dbf70f7a49f2b898f4d0cde16cb320f652bdeda40afbf1f071ce113`. Ayrıntı ve son görsel doğrulama sınırı [modül raporunda](module-economy-local.md). Aşağıdaki SHA, önceki maliyet yamasının ara çıktısıdır; güncel eser zinciri testlerde maliyet → tanılama → null-trait şeklinde denetlenir.

22 Ekim 2026. Kullanıcının istediği yerel ekonomi özgün tarif verilerinden ayrı tutulur. `game/module-policy.js` her iki tarafın tek maliyet kaynağıdır. `tools/patch-assembly-modules.js`, kurulu `main.swf` üzerinden dört sınıfı derler; `ItemDataProvider` içindeki 662 normal üretim/geliştirme tarifinin görünen malzemelerini aynı politikayla değiştirir. Özgün sonuçlar, hedef sınıfları, seviye sınırları, süreler ve söküm tarifleri korunur.

Yeni `resource_upgrade-module` ve `resource_convert-module` gerçek, ayrı yığınlanabilir eşya tanımlarıdır. Eski geliştirme kuponu veya mikrotransistör bakiyesi bu modüllere dönüştürülmez. `AssemblyModel` kurucusu, tarif oluşturulmadan ve envanter işlenmeden önce yeni tanımları ve maliyetleri kurar. Yerel adlar Türkçe eşya metin dosyasında, 30/100/ikon görselleri gerçek resim manifestinde bulunur. Mevcut nano-kondansatör ve mikrotransistör çizimleri yeniden kullanılır.

Aralıklı açılmama için statik kaynakta üç kırılgan nokta saptandı ve dar korumalar eklendi:

- `UserInventoryHandler`, `DiscountProxy` henüz yokken koşulsuz çağrı yapıyordu. Şimdi gerektiğinde özgün Assembly INIT bildirimi gönderilir ve envanter işlenmeden önce bağımlılık oluşturulur. Bu, sunucudaki mevcut tarif → envanter sırasına ek bir istemci korumasıdır.
- Asenkron sekme kurulumunda boş veya henüz eşlenmemiş seçim, `addChild(null)` çağrısına ilerleyebiliyordu. Artık seçilen içerik doğrulanmadan mevcut sekme gizlenmez.
- Normal Montaj sekmesi isteğe bağlı `EventProxy` bulunmadan kış etkinliğini sorguluyordu. Etkinlik sistemi henüz kurulmadığında normal sekme kurulumu devam eder.

Bunlar derlenmiş/decompile edilmiş istemci kaynak kanıtıdır; Flash ekranında görsel çalışma gözlemi yapılmış değildir. Yerel bütün aralıklı açılmama nedenlerinin tükendiği iddia edilmez.

Kanıt: `decompiled/assembly-module-patch/evidence.json`. Girdi SHA256 `a3d3e67288f6c4d9f4a1550eb46c91165a1a77e0f6d896ef00432bb7860d25e8`, çıktı `86192c4b7af5c21b0fc4d1ffd389b5c841b0a552135fb18e011f3b7bf82e216e`. Yalnız bir DoABC etiketi değişir; 256 diğer etiket aynıdır. Kurulu çıktıda M kısayolu `KeyboardMapper` ve diroit gösterimi `TopDisplay` yeniden dışa aktarılmış, önceki yama kaynaklarıyla birebir eşleştiği test edilmiştir.

`tests/assembly-module-client.test.js` dört kontrolü; eşya/maliyet kaydı, açılış korumaları, ad ve görsel kayıtlarını denetler. M ve ayar testleriyle 12/12 geçti. Testler Flash görsel E2E yerine gerçek derlenmiş sınıfların geri decompile edilmiş kaynakları, paylaşılan politika ve dosya kimliği üzerinde çalışır.
