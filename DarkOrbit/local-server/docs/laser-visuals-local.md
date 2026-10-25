# Lazer çıkışları ve hasar RNG'si

20 Ekim 2026. Kullanıcı tek namlu görseli ve rastgele hasar aralığını bildirdi.

## Hata ve düzeltme

`players.loadPlayer` görsel kademeyi 0 olarak dolduruyor, `init.js` ise bu alanı özellikle atarak kaydedilmiş başlangıç gemisinin `expansionStage=1` değerini koruyordu. Ekipman/stat güncellemesi de `ShipExtensionsCommand` göndermiyordu. Böylece çok sayıda takılı lazer olsa da gemi tek namlulu başlangıç deseninde kalıyordu.

Artık aktif konfigürasyondaki **geminin kendi lazerleri** sayılır. Diroit lazerleri toplam savaş hasarı ve cephane tüketimine katılmaya devam eder; fiziksel gemi lazeri sayılmaz. Gemiye takılı 0/1 lazerde kademe1; iki veya daha fazla lazerde, o geminin kaynak tanımındaki ilk eşzamanlı çok namlulu salvo içeren kademe seçilir. Bu sayısal ekipman eşiği kullanıcının istediği yerel davranıştır; orijinal sunucunun kurtarılmış kademe formülü olduğu iddia edilmez.

Kademe, ilk `ShipInitializationCommand` paketinde verilir. Ekipman veya konfigürasyon değiştiğinde kademe değişmişse gerçek `ShipExtensionsCommand {userId,extensionStage}` gönderilir. Harita/Flash yeniden yüklenmesine gerek yoktur; değişmeyen kademeler tekrar gönderilmez. Kalın lazerin ArGe `skilledLaser` bayrağı ayrı kalır.

| Gemi | Tek lazer kademesi | Çok namlulu ilk kademe | Yerel istemcinin özgün noktaları |
|---|---|---|---|
| Liberator | 1 | 2 | `leftFrontOuter,rightFrontOuter` |
| Goliath | 1 | 2 | Arka/iç ve ön/iç çiftler, arada merkez salvolar |
| Diminisher | 1 | 3 | Arka/iç ve ön/dış çiftler, arada merkez salvolar |
| Spectrum | 1 | 3 | Arka/dış ve ön/dış çiftler, arada merkez salvolar |

Diminisher/Spectrum kademe2, merkez ön ve merkez arka **iki ayrı tekli** salvodur; her gemiye sabit kademe2 vermek bu bildirimi çözmezdi. Çok namlulu özgün desenlerde de araya tek merkez atışları girer: tüm gemilere aynı iki nokta veya her salvoya zorla iki ışın eklenmez. Phoenix gibi yalnız tek kademe tanımlayan gemiler ve özel modeller kendi istemci desenlerini korur. Expansion tanımı bulunmayan modellerin basit/model üzerindeki marker sistemi değiştirilmez.

## İstemci kaynağı

- `decompiled/pet-patterns/game.xml`: mevcut `main.swf` içindeki DefineBinaryData187; SHA256 `0359deecaca0a80466d3ae9829511c4bb89711f1f794a4034c67f1d080bc7263`. Çalışılan `main.swf` içindeki XML ile hash eşitliği doğrulandı.
- `PatternManager.parseExpansionPatterns`: sınıf, stage, salvo ve açıya bağlı `positionsList` koordinatları.
- `Lasers2D`: geminin `expansionClassID` ve `laserExpansionStage` değerleriyle desen; dönüş açısıyla doğru namlu koordinatı.
- `Lasers3D`: aynı kademe/desen, gerçek modelde `getLaserSlot` ile namlu konumu.
- `ShipAssembly`: ilk kademe. `ShipExtensionsHandler`: oyun sırasında kademeyi değiştirme.

`node tools/export-laser-patterns.js`, mevcut XML'den `game/laser-patterns.json` üretir: 911 görünümün (kozmetik tasarımların kalıtımı dahil) sınıf eşlemesi ve 166 çıkış deseni. Runtime yalnız kademe seçer; nokta/koordinatlar özgün Flash kaynaklarında kalır. SWF veya gemi görselleri değiştirilmedi.

## Mevcut RNG'nin anlamı

20 Ekim 2026 savaş denetiminde önceki simetrik ±%15 varsayımı kaldırıldı. Üretim ayarı `laserDamageMin=.75,laserDamageMax=1` ile toplam maksimum lazer hasarının %75–100 aralığını kullanır; 1000 için750–1000. Aralık içinde uniform tek salvo örneklemesi hâlâ açık yerel politikadır. `damageSpread` ancak açık özel sunucu/test override'ı olarak kullanılabilir. İsabet/ıskalama ve görsel çıkış desenleri ayrı kalır. [Güncel kaynaklar ve sınırlar](combat-balance-audit.md).

Klasik orijinal oyunun [resmî Laser Damage Charts FAQ'sı](https://board-en.darkorbit.com/threads/laser-damage-charts.888/) LF3/LF4 çizelgeleri için listelenen maksimum değerin %75–100'ünü belirtir. Bu, maksimumun üstüne ±%20/±%15 ekleyen simetrik bir aralık değildir. Modern özel lazerlerin farklı kuralları ve gizli sunucu dağılımı bu belgeyle doğrulanmış sayılmaz.

## Doğrulama

Altı yeni test: gemiye/tasarıma özel kademeler, diroitlerin ayrılması, gerçek codec ile ilk giriş, ikinci lazer takma/çıkarma ve gereksiz paket engeli, konfigürasyon2/yeniden giriş, mevcut RNG uçları. Toplam254 test başarılı;135 JavaScript dosyasında sözdizimi hatası yok. Gerçek HTTP/TCP testi ikinci LF1'in dükkandan alınmasını, takılmasını ve Diminisher için `ShipExtensionsCommand.extensionStage=3` alınmasını doğrular. Flash ekranında bütün gemilerin namlu görselleri tek tek oynanarak doğrulanmadı.
