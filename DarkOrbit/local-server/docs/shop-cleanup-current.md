# Dükkân düzenleme — 23 Ekim 2026

## Tamamlandı

- Portal dükkânının mevcut dikey kategori şeridine **Özel Fırsatlar** eklendi: `internalDock&tpl=internalDockOffers`.
- Önceden Payment/kampanya olan **196 kanonik teklif** artık yalnızca bu kategoride. Gemi, silah, tasarım, kişiselleştirme ve Ekstralar listelerinden taşındı. SKU, paket manifesti ve satın alma sunucusu değiştirilmedi.
- 196 teklifin **162'si satın alınabilir**, 23'ünün tam manifesti yok, 11'inin desteklenmeyen bileşeni var. Son 34 ürün fiyatı ve açıklamasıyla görünür, satın alma kapalıdır; hiçbir ürün eksik içerikle teslim edilmez.
- Payment/Uridyum yönlendirmesi aynı Özel Fırsatlar ekranını açar. Ayrı kart ekranı veya yüzen bağlantı eklenmedi; kayıtlı dükkân ürün kutuları, önizleme, çoklu miktar seçimi, orijinal kaydırma ve satın alma işleyicileri korunur.
- Kredi ürünleri Uridyumdan **önce** gelir; her para biriminin içinde birim fiyat küçükten büyüğe sıralanır. Portal ilk render, canlı Iris/Flax fiyat güncellemesi ve yerel oyun içi mağaza aynı kuralı kullanır. Fiyatlar arasında kur varsayılmaz.
- Ürünler tam kutuları ile taşınır/çıkarılır; boş yer tutucu bırakılmaz. `numItems` ve açılış seçimi gerçek görüntülenen ürünlerden hesaplanır. Sabit 100px kutu + mevcut 5px aralık orijinal 105px kaydırma satırıyla eşleşir; değişken yüksekliğin float yerleşiminde boş hücre oluşturması önlenir.
- Günlük limit sayacı bulunan ürünlerde fiyat divi eskiden canlı fiyat sınıfını alamıyordu. Sayaç korunarak gerçek fiyat divi güncellenir.
- Seprom, Upgrade Module, Convert Module normal Ekstralar'da; P.E.T. yakıtı P.E.T. modüllerinde kaldı.

## Doğrulama

`logs/shop-cleanup-20261023.log`: **50 test geçti, 0 başarısız/atlanan**.

Yeni `tests/shop-campaign-category.test.js`: 196 SKU'nun tek kez ve orijinal dükkân veri/DOM eşleşmesiyle görünmesi, tüm sıradan sayfalarda kampanya kalmaması, bütün sayfa adetleri/açılış seçimleri, ürün görsellerinin yerel dosyada bulunması, derlenebilir sayfa yapılandırması ve Payment yönlendirmesi.

Mevcut anlamlı satın alma testleri de geçti: sabit 1 milyon bedel, çoklu paketin eksiksiz atomik teslimi, sahte/kapalı üründe kesinti yapılmaması, günlük/drone dinamik fiyat, canlı miktar seçimi, P.E.T. yakıtı ve Seprom.

Ek dosya kontrolünde bütün kayıtlı ürün ikonlarının PNG başlığı doğrulandı; eksik/boş ikon dosyası bulunmadı. Flash/Qt penceresinde görsel uçtan uca doğrulama yapılmadı. Boş kutu raporunun tüm olası çalışma zamanı nedenlerinin giderildiği iddia edilmez.

## Açık takip

- **24Ekim kaynak düzeltmesi:** bu Flash sürümünde SHOP/NEWSHOP, CommandCenterTriggerShopCommand üzerinden mevcut portalı açar. ShopItemListCommand signed-byte127sınırı ayrı protokol iskelesine aittir; mevcut mağaza için görünür eksik diye sayılmaz. MAIN patch/sayfalama gerekmez. LF4üstü lazerlerin kaldırılmasından sonra176korunan kampanya, gerçek portal Özel Fırsatlar kategorisinde tek kez görünür. Yukarıdaki196/162sayıları23Ekim tarihsel durumudur.
- Manifesti eksik 23 ve desteklenmeyen 11 kampanya için işlev/manifest tamamlanması ayrı açık iş olarak kalır.

İlgili dosyalar: `web/portal/shop-campaigns.js`, `web/portal/render.js`, `web/portal/shop-sort.js`, `client/css/local-shop.css`, `client/resources/js/shop.js`, `game/handlers/shop.js`.
