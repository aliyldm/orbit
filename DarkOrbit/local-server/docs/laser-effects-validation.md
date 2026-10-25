# Lazer özel etkileri ve atış ritmi

21 Ekim 2026. Bir milyon Uridyumluk kampanyalardan lazer veren **24 teklifin** özgün dükkân açıklaması taban hasarı ve özel etkiyi gösterir; paket içeriği satırı korunur. Fiyat değiştirmek özel özellik eklemekle eş tutulmaz. Normal lazer dağılımı, özel lazer dağılımı ve set kapsamı ayrı doğrulanır.

- **Kararsız LF-4:** gönderilen Türkçe `resource_items.xml` açık128–220 taban aralığı verir. Artık genel `%75–100` hesabıyla ayrıca daraltılmaz. Karışık salvo ve P.E.T. aynı özel hesabı kullanır. Bağımsız lazer başına düzgün RNG seçimi yerel politikadır; özgün RNG kaynağı bilinmez.
- **Odysseus:** [resmî FAQ](https://board-en.darkorbit.com/threads/faq-new-laser-odysseus-laser.129128/) kritik oranını ve gemi kapsamını belirler. Gerçek kritik hasarın yanında native `AttackHitCommand.strike` bayrağı gönderilir; her sıradan vuruşta yeniden kapanır.
- **Mortifer:** [Trial of Terrors FAQ](https://board-en.darkorbit.com/threads/faq-trial-of-terrors.129920/) tablosu, gemideki adet ve yalnız kendi hasarı için kullanılır. Diroit/P.E.T. taban hasarı set sayısını artırmaz.
- **Asmodeus:** [resmî Hitac FAQ](https://board-es.darkorbit.com/threads/faqs-asalto-hitac-agosto-2023.147994/) imha başına artışları kümülatif uygular; beş yığın ve süre/harita/ölüm temizliği sınanır. Diğer lazerlerin hasarına taşınmaz.
- **Anchorlock:** [resmî LF-5 FAQ](https://board-en.darkorbit.com/threads/faq-new-lasers-lf-5-and-lf-5-anchorlock.129854/) tablosundaki PvP hasarı NPC hasarına eklenmez. Başarılı gemi atışlarında3/10/15 eşikleriyle `%10/20/25` yavaşlatma şansı, `%15/20/55` hız düşüşü,1/2/2saniye uygulanır. FAQ yavaşlatmayı hedeflere tanımlar; NPC'yi ayrıca dışlamadığı için solo hedeflere uygulanması açık yerel yorumdur. Tam PvP sistemi eklenmez.
- Prometheus Black Light çarpanı/5saniye ek hasarı, Hyperplasmoid can bonusu ve LF-4 tür farkları mevcut özel hesap ve kaynak sürümüyle korunur. Güncel istemci tabanı eski2017 tabanlarıyla değiştirilmez.

İlk lazer görüntüsü daha önce `attack()` içinde hasarsız gönderilip sonraki1saniyelik timer turunda yeniden oynatılıyordu. Artık ilk gerçek salvo anında görüntü/ses/cephane/isabet aynı işlemdedir. Sonraki atışlar en az1000ms aralıklıdır; RSB75 ayrı3000ms bekler. Araya giren timer turu veya tekrar tuşu ek ses/atış üretmez. Hareket etmek saldırıyı durdurmaz. Menzil, cephane, ölüm/atlama ve iptal denetlenir.

`AttackLaserRunHandler` her pakette bir kerelik native efekt yaratır; istemcideki özgün ses ve salvo dosyaları değiştirilmez. Klasik1saniyelik süre [resmî LF-4 özellikleri](https://board-en.darkorbit.com/threads/permafrost-fissure-faq.117725/) ile uyumludur. Bütün modern setlerin ayrı ışık animasyonları bulunmuş/yeniden yapılmış değildir; gerçek hasar ve native kritik bilgisiyle aynı şey değildir.

`tests/laser-specials.test.js`, `tests/laser-cadence.test.js`, mevcut modern ekipman ve ArGe testleri: gerçek kampanya alımı/takma, imha yığını, özel RNG uçları, karışık/cephaneli hasar, yavaşlatma/bitme, tekrar tuşu ve codec ile kritik bayrağı. Ağ testi gerçek HTTP/TCP yolunu kullanır; Flash görsel uçtan uca gözlemi diye sunulmaz.
