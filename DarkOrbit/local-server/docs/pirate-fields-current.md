# 5-x Palladium ve sis — 23 Ekim 2026

**24 Ekim güncel karar:** Labirent denemesi kullanıcı isteğiyle kaldırıldı; tekrar ekleme eksik iş sayılmamalı. Sis/Palladium korunur. [Güncel durum](cargo-maze-current.md). Aşağıdaki dağıtım numaraları tarihsel kayıttır.

Önceki durumda 5-1 ve 5-3 aynı40 Palladium noktasını geniş bir alanda üretiyordu; sis POI'si ve kamuflaj bozma yoktu. Yeni `game/pirate-fields.js` bu alanların sunucu/istemci ortak tanımıdır.

## Uygulanan

- 5-1 merkezinde60, 5-3 alt bölümünde480 adet1 Palladium.5-2'de doğal Palladium yok.
- Noktalar sis alanına dağıtılır; ilk üretim boş kümeleri azaltan hücre dağılımı kullanır. Toplanınca15s sonra aynı alanda yeni konum/hash ile doğar.
- Yerel alan sınırları:5-1 `(18000,11000)–(24000,15500)`;5-3 `(9000,19500)–(33000,24500)`. **Sayılar, sınırlar ve15s yerel ayardır; orijinal sunucu sabiti değildir.** Konum tercihi resmî haritalar/SSS'deki merkez ve alt bölge düzenine dayanır.
- Native `MapAddPOICommand`, rectangle2, generic0, nebula design5 ve mevcut2D/3D assetleri kullanılır. POIReady'den önce gönderilir. SWF değiştirilmedi. Qt/Flash ekranı otomasyonla denenmedi; codec ve gerçek TCP ile doğrulandı.
- Sise girişte CPU kamuflajı kalıcı olarak kalkar. İki konum güncellemesi arasında sisin tamamından geçmek de algılanır. Yeniden giriş/harita init sırasında sis içindeki kayıtlı kamuflaj temizlenir; çıkınca geri gelmez. Sis içindeyken yeni kamuflaj aktivasyonu reddedilir; satın alınan tek kullanımlık ürün envanterde korunur, harcanmaz.
- Auto-loot ve auto-resource P.E.T. modülleri Palladium toplar. Auto-loot sıradan ham cevherleri toplamaz. Mevcut kargo sınırı ve15Palladium→1GGenerji/5-2 üssünde işlem korundu.

## Kanıt ve sınırlar

[Resmî TR korsan SSS](https://board-tr.darkorbit.com/threads/s-s-s-korsan-haritalari-ve-korsanlar.2508/):5-1 az,5-3 bol Palladium; Palladium sis içinde;5-1 merkez labirent/sis; Saboteur yavaşlatır. Bu eski sayfadaki kalkan aşınması ve Palladium ölüm kaybı açıklamaları daha sonraki sürümlerle çelişir, otomatik uygulanmadı.

[Daha yeni TR SSS](https://board-tr.darkorbit.com/threads/s-s-s-korsan-haritalari-ve-korsanlar.122381/): ölümde Palladium kaybı yok. [EN SSS](https://board-en.darkorbit.com/threads/pirate-map-faq.1013/): iki PET toplama modülü, sis kamuflaj bozma,15:1 takas. [DE SSS](https://board-de.darkorbit.com/threads/faq-piratenmaps.2789/): kamuflaj sis sonrası geri gelmez.

Resmî harita görselleri `docs/evidence/pirate-5-1.jpg` ve `pirate-5-3.jpg`: EN SSS ekleri5088/5090. Bunlar kesin dünya koordinatları sağlamaz.

Native istemci kanıtı: `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/{MapAddPOICommand,POITypeModule,POIDesignModule}.as`; `map/model/poizones/rectangle/RectangleZone.as` iki köşeden sınır hesaplar. Tasarım5nebula, tür0generic; hız etkisi istemciden varsayılmaz.

**Tam5-x birebirliği tamamlanmadı:** labirentin özgün engel poligonları, mayın tarlalarının konum/hasar/yeniden doğma kuralları hâlâ yok. Sis için doğrulanmış sabit hız azaltma oranı bulunmadı; rastgele %50 yavaşlatma eklenmedi. Saboteur yavaşlatma/EMP mevcut; süresi ve oranı `npc-special-attacks-local.md` içindeki yerel ayardır. NPC adetleri/kapalı sunucu formülleri özgün kayıt değildir. Bu çalışmada nüfus/kapılar/ödüller değiştirilmedi.

## Doğrulama

884/884 birim/entegrasyon testi geçti;320JS/0sözdizimi hatası. `tests/pirate-fields.test.js` gerçekSQLite+world+codec ile üretim/alan/yeniden doğma/kamuflaj geçişi/reconnect/ücret tüketmeme durumlarını; `tests/pet.test.js` iki PET toplama modülünü doğrular. Tam ağ testi sis POI'sini ve480ore komutunu TCP'de, gerçek MoveRequest sonrası INV0 ve kalıcı kamuflaj temizliğini denetler. Son dağıtım sonucu aşağıya eklenir.

Dağıtım öncesi yedek: `backups/darkorbit-before-2026-10-23T16-36-41-743Z.db`. Yeni migration/hesap hediyesi yok.3hesap/3oyuncu/13gemi ve46ilerleme tablosunun yükseltme kopyasında korunumu PASS.

**Dağıtıldı: PID18004**, soloHTTP8095/TCP8096,healthOK. Gerçek HTTP/TCP22.562komut PASS (`logs/pirate-fields-network.log`).884/884test (`logs/pirate-fields-tests.log`);320JS/0hata. `logs/pirate-fields-production-check.json`: yedeğin60tablosu bütün kolon/satırlarıyla birebir aynı; değişen tablo yok,integrityOK/FK0. Ekranı yeniden açarak yeni POI/maden listesini alabilirsiniz. Çalışan Qt penceresine girdi verilmedi.
