# Toplu geliştirme, bonus ve donma düzeltmeleri

23 Ekim 2026. Oyun içindeki **Birleştir → Geliştirme** sekmesinde temaya ait düğmelerle **Tüm silahlar**, **Tüm kalkanlar**, **Yenile** ve **Maksimuma başlat** bulunur. İki grup birlikte seçilebilir. Sunucu eşya sayısını, toplam Upgrade Module maliyetini ve mevcut modülleri işlemden önce hesaplar. Takılı, depoda, diroitte ve P.E.T.'te bulunan uygun silah/kalkanlar dahildir. Her eşya kendi kaynak tarifinin azami seviyesine gider; hepsine keyfî 16 veya 20 sınırı zorlanmaz.

Geliştirme anında seviyeyi ücretsiz değiştirmez: bütün işler aynı anda başlar, her biri kaynak süreleri sonunda teslim alınır. Bir işlemde 2.000 hedef desteklenir. Azami seviyede veya başka geliştirmede olanlar çıkarılır. Sunucunun oyuncuya bağlı 120 saniyelik teklifi; hedef kimliği, türü, seviyesi ve kalan maliyetle tekrar doğrulanır. Bir eşya değişirse veya modül yetmezse bütün işlem geri alınır. Makbuzlu token tekrar kullanımı aynı sonucu verir ve ikinci ücret kesmez. Kaybolan canlı bağlantı tamamlanmış DB işlemini başarısız satın alma gibi göstermez; girişte işler yeniden gelir.

Native istemci aynı origin oturum çereziyle form POST yapar: `/ajax/upgrade-bulk.php`. GET 405, oturumsuz 401, yabancı Origin 403. Yetkili iş kuralı hataları Flash URLLoader'ın mesajı okuyabilmesi için HTTP200 + `ok:false` döner. Diğer hesaba ait kimlik gönderilemez; oyuncu oturumdan alınır.

## Donma kaynağı ve sonuç

1.000 eşyayla bellek içi ölçüm, gerçek paket kodlayıcısı dahil; gerçek hesap değiştirilmez. Önceki ve sonraki raporlar `logs/assembly-benchmark-before.json` / `logs/assembly-benchmark-after.json`:

| İşlem | Önce | Sonra |
|---|---|---|
| Başlangıç SQL | 5.307 | 75 |
| Filtre | 5.307 SQL, 205 KB | 1 SQL, 0 paket |
| Hatalı üretim | Tüm katalog | Tek açıklama mesajı |
| 10 üretimi toplama | 76.762 SQL, 1.600 komut, 4.299.473 bayt, 1.192 ms | 451 SQL, 13 komut, 68.202 bayt, 65 ms |

Süreler aynı makinedeki örnek ölçümdür; Flash render veya ağ süresi ölçümü değildir. Tam katalog her eşya için yeniden gönderilmez. Görev/üretim durumları topluca okunur; tek envanter, değişen tarif durumları ve yalnız değişen cephane menüsü gönderilir. Toplu teslimde P.E.T./destek pencereleri her eşya için tekrar kurulmaz. Filtrede iç modülün sabit 0 değeri yerine gerçek üst `filterType` kullanılır.

Native tarafta `UpgradeProxy`, yanlışlıkla recipeAdded'a bağlı handleRecipeRemoved dinleyicisi yerine gerçek recipeRemoved'a bağlandı. `AssemblyModel` tarif listesini her satırda değil paket bittiğinde bir kez sıralar. Kurulu MAIN SHA256 `d0d20e63a29e3182a33a7839b2f27e356b94841f90bcbcb1659d4ae2aa38403c`; önceki M/diroit/Gold Pass yamaları korunur. Kaynak/kanıt `decompiled/upgrade-bulk-patch`; araçlar `tools/patch-upgrade-bulk-ui.js` ve `tools/install-upgrade-bulk-ui.js`. Native değişiklikler derlenmiş ve tekrar decompile edilmiş, ama bu son bar kullanıcı Escape ile ekran kontrolünü durdurduktan sonra görsel olarak oynanmamıştır.

## Bonuslar ve hesap teslimleri

[Bonus raporu](upgrade-effects-validation.md): lazer, kalkan, diroit ve P.E.T. geliştirmesi gerçek build→collect ve savaş değerleriyle sınandı. Eksik HST geliştirme çarpanı ECO hasarına ve SAR kalkan emilimine eklendi. Diroit savaş seviyesi1–6 ile modül geliştirmesi ayrıdır: 6. seviye +%10 takılı lazer/+%20 takılı kalkan; bu istemcinin 6. büyüme seviyesindeki Iris'inde modül seviyesi16 ayrıca +%6/+%15 verir. İstemcinin diroit lazer oranıyla güncel 2026 resmî tablo arasındaki sürüm farkı ayrı raporda açıkça kaydedilmiştir. Tasarım tam set bonusları bu geliştirme doğrulamasının dışında kalır.

`asd` hesabına talep edilen **50.000.000.000 U.** eklenmiştir; teslim öncesi 5.110, teslim sonrası **50.000.005.110 U.**. `admin_wallet_user-20261022-fifty-billion-01` makbuzu tekrarı engeller. Havoc, Hercules, Spartan ve Demon Epic'ten **10'ar** gerçek eşya eklenmiştir; `admin_designs_user-20261022-drone-designs-01` makbuzu korunur. Sunucu kapalıyken çevrimdışı atomik işlemlerle uygulanmıştır. Önceki otomatik onay bağlantı hatası yüzünden çalışmayan canlı teslim tekrar sayılmamıştır.

Kompakt AttributeCreditsUpdate yalnız int32 taşır. Büyük bakiyeler aynı istemcinin Number kullanan özgün `0|A|C|credits|uridium` güncellemesine çevrilir. İlk gemi ve envanter paketleri double'dır; DB/portal/harcama bakiyesi korunur. Küçük bakiyeler eski ikili formatı kullanmaya devam eder. Sahte sarmalanmış/negatif bakiye veya Jackpot ödül mesajı gönderilmez.

## Doğrulama

- `logs/bulk-final-suite.log`: **778/778**, hata/atlama0.
- `logs/bulk-final-syntax.log`: **276 JS**, sözdizimi hatası0.
- `logs/bulk-network.log`: gerçek HTTP/TCP **16.181 çözülen komut**, PASS; oturum/Origin kontrolü, gerçek modül alımı, teklif/toplu başlat/tekrar/tek teslim ve 50 milyar bakiye sonrası yeniden giriş dahil.
- `logs/bulk-final-client.log`: launcher/Flash/preloader/MAIN doğrulandı.
- `logs/bulk-final-db.log`: 2 hesap/oyuncu, 7 gemi, 41 sahiplik/ilerleme tablosu korundu; SQLite integrity ve FK doğru. Son yedek `backups/darkorbit-before-2026-10-23T05-17-13-162Z.db`.

Sunucu `8095/8096`, solo. Yeni MAIN için istemci tamamen kapatılıp açılmalıdır. Çok oyunculu sistem eklenmemiştir.
