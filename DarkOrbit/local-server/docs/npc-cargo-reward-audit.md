# NPC kargo denetimi — 20 Ekim 2026

**24 Ekim güncellemesi:** Aşağıdaki önceki kapsam103kaynaklı/108tabantüre genişletildi.28Kronos ve2genelKucurbium tablosu eklendi; toplamada hareket/PET/kapasite/kısmi kutu düzeltmeleri yapıldı. [Güncel rapor](cargo-maze-current.md), [tam katalog](npc-cargo-audit.json). Beş Kuiper ve23çarpanlıkapıvaryantı hâlâ veri açığıdır.

45 normal/Boss/Uber/korsan cevher tablosu saklanan resmî Almanca kayıtla
yeniden karşılaştırıldı: sayısal fark bulunmadı. Bu, seçilmiş kaynak sürümüne
uyumdur; bütün DarkOrbit dönemlerinin aynı olduğunu kanıtlamaz.
[DE NPC SSS](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/),
[ikinci sayfa](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2).

`game/npc-cargo.js` yeni çözümleyicidir. `resolve(def,{player,mapId,scale?})`
bağımsız cevher satırları döndürür. `[]` kaynakta açıkça cevher yok anlamına,
`null` bu sürüm için doğrulanmış veri yok anlamına gelir. Görsel kimlikten,
HP oranından veya adı benzer başka varyanttan cevher üretilmez.

Bulunan gerçek farklar:

- Kendi şirketinin x-1 haritasındaki Streuner, seviye arttıkça daha az kargo
  vermeli. 7/8/9 seviyelerinde her iki temel cevher 5/2/1; 10 ve sonrasında
  sıfırdır. `rewardOverride` aynı tablodaki ayrı EP/kredi/şeref/Uridyum
  tabanlarını döndürür; oyuncu bonusları bundan sonra uygulanır. Başka şirketin
  x-1'i, x-2, Boss ve gate NPC'si bu kurala girmez.
  [EN standart NPC SSS](https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/).
- Önceki kapı kargo yolu bütün türler için yerel 10+10 fallback kullanıyordu.
  Dört Zeta ve yedi Epsilon türünün açık cevher tabloları eklendi; Seprom
  korunur. Epsilon'un `epsilon-*` sürümleri, Almanca genel/LoW türlerinden
  farklıdır. Genel Vagrant/Marauder/Outcast/Corsair/Hooligan/Ravager/Convict
  için seçilen Almanca kaynak açıkça sıfır cevher belirtir.
  [Zeta SSS](https://board-en.darkorbit.com/threads/zeta-gate-faq.852/),
  [Epsilon SSS](https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/).
- Kappa'nın dört özel varyantı ve Hades'in üç imparatoru kendi İspanyolca
  satırlarından alınır. Genel DemaNeR ile Kappa DemaNeR'in Xenomit farkı
  kaynak farkı olarak korunur. Kuiper özel Streuner türlerinde cevher satırı
  bulunmaması açık sıfır ispatı sayılmaz; sonuç bilinmiyor olur.
  [ES NPC SSS](https://board-es.darkorbit.com/threads/faqs-aliens.135697/).

Unscaled klasik kapı NPC'leri aynı adlandırılmış temel cevher tablosunu
kullanır. Beta/Gamma ve Delta'nın büyütülmüş klasik NPC'lerinde HP, hasar ve
para çarpanı cevher miktarını da kanıtlamaz. Sayısal cevher çarpanı doğrulanana
kadar bu türlerin `resolve` sonucu `null` olur. Eski 10+10 fallback özgün
ödül gibi sürdürülmez. Bu bilinçli veri açığıdır; kapı parası/EP ödülünü
silmez. İleride doğru değer bulunursa yalnız kargo çözümleyicisi genişletilir.

Diğer sınırlar: Aurus/bifenon gibi koşullu kaynakların olasılıkları, kargo
kutusunun sahiplik süresi ve çok oyunculu ganimet paylaşımı bu sayısal cevher
denetimiyle doğrulanmadı. Kargo kapasitesi ve oyuncu becerileri toplanan
miktarı etkileyebilir; burada denetlenen değer kutunun taban içeriğidir.

Kapasite denetiminde ayrı bir fark da bulundu: Xenomit kargo alanı kullanmaz.
Bu cevherin sayısı kapasite toplamından çıkarılmalı ve kargo doluyken de
alınabilmelidir. Çözümleyici yalnız içerik döndürür; kapasite uygulaması
`collectables`/oyuncu durumunu hesaplayan katmanda yapılır.
[EN kaynak SSS](https://board-en.darkorbit.com/threads/resources-faq.903/).

Kanıtlar `decompiled/gate-source-evidence/` altında URL, tarih ve HTML SHA-256
metadatasıyla saklanır. Normal JSON değiştirilmedi. Ek 7 test, normal 45
satırın çözülmesini, bütün şirketlerde x-1 seviye sınırlarını, EN gate
tablolarının kaynak ayrıştırmasını, boş LoW varyantlarını, ES varyantlarını
ve bilinmeyen verinin uydurulmamasını doğrular.

Çalıştırma: `node --test tests/npc-cargo-audit.test.js tests/normal-npc-cargo.test.js`
— 11 test başarılı. Bu, gerçek Flash oturumunda görsel doğrulama değildir.
