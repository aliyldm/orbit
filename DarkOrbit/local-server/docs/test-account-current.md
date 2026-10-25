# Test hesabı — 23 Ekim 2026

**Son ek: TP/şeref artırımı.** Kullanıcının devam talebiyle yalnız test/ID3 toplam TP10.000.000.000,şeref1.000.000.000 yapıldı; seviye formülüyle21. Rütbe puanı10.112.274,General/badge20;günlük kayıt da eşlendi. Önceki oluşturma anındaki18.seviye/1.018.494puan aşağıda tarihseldir. Makbuz settings/admin.progression_test-20261023-tp10b-hon1b ve logs/test-progression-created.json. Aynı artırımı tekrar uygulamayın. Rütbe mekanizması zaten game/ranks.js'de vardır; bu işlem oyun kodunu değiştirmedi.

**Güncel PID4496**,solo8095/8096. PID7164 kaydederek kapatıldı. Artırım öncesi yedek darkorbit-before-2026-10-23T14-07-05-041Z.db. logs/test-progression-rank-tests.log5/5, logs/test-progression-live-verification.log gerçekHTTPgiriş/HOF/General,10milyarTP'nin native double codec ile tam aktarımı ve60tabloda yalnız istenen değişiklikler PASS;asd/diğerhesaplar korundu. Console/error test-progression-server-console.log / test-progression-server-error.log.858tamtest/310JS0hata önceki kodla geçerlidir.

Kullanıcının açık talebiyle `test` hesabı oluşturuldu; kimlik bilgileri kullanıcıya son yanıtta verildi. Şifre bu raporda/araçta saklanmaz; mevcut scrypt doğrulaması kullanılır. Oyuncu ID3, kaynak `asd`/ID2. Gerçek HTTP girişi, oyun sayfasındaki userID3 ve Şeref Salonu General rozeti doğrulandı.

Kaynak hesabın bütün sahiplik/ilerleme alt tabloları kopyalandı:6gemi,283envanter kaydı,10diroit,18öğrenilmiş beceri, P.E.T./17ekipman ataması, iki konfigürasyon/40ikinci konfigürasyon ataması,36diroit ekipman ataması,6devam eden geliştirme,CPUşarjları,ayarlar,kaynaklar,destekler,hangar,görev/ödül/etkinlik defterleri ve kayıtlı dünya durumu. Yeni gemi/eşya/diroit/kapı kimlikleri atanır; devam eden geliştirme hedefleri, kayıtlı ekipman düzenleri ve JSON referansları yeniden eşlenir. Global tekil eski işlem/kutu kimlikleri yeni oyuncuya özel adlandırılır. Kaynak ve hedef aynı fiziksel eşyaları paylaşmaz.

Kopyalama sonrasında mevcut11GGtürünün her birinde tamamlanmış geçmiş kaydı var: Alpha,Beta,Gamma,Delta,Epsilon,Zeta,Kappa,Lambda,Kronos,Hades,Kuiper(streuner). Devralınan aktif kapılar testhesabında kazanılmış olarak kapatıldı. Native halka/taç maskesi127. Bunlar açıkça yönetici tamamlama kayıtlarıdır; kopyalanan paraya ikinci kez kapı ödülü eklenmedi. Hades'in solo runtime'ı değiştirilmedi.

Rütbe puanı **1.018.494,4632**, **General/badge20**; mevcut bütün diğer oyunculardan yüksek. Bunu kalıcı rozet hilesiyle değil mevcut hesaplayıcıyla sağlamak için yalnız yeni testhesabının şerefi99.994.737 yapıldı ve hesap tarihi29günlük testkaydı olacak şekilde ayarlandı (yerel4hafta uygunluk koşulu). Seviye18/TP ve para/envanter kaynakla aynı kaldı. Rütbe mevcut formülle ileride yeniden hesaplanır; gelecekte başka hesabın geçmesi zorla engellenmez.

`tools/clone-test-account.js` yalnız çevrimdışı CLI aracıdır; web/API yönetici yolu eklemez. Hedef hesap zaten varsa durur, üstüne yazmaz. İşlem atomiktir. `settings` içinde `admin.clone-test-account` makbuzu tam kimlik eşlemelerini ve sayıları tutar; aynı kayıt `logs/test-account-created.json` içindedir. **Hesabı veya önceki kaynak hediyelerini tekrar oluşturmayın.**

## Doğrulama ve dağıtım

- `logs/test-account-clone-tests.log`:3/3; tam ilişki/JSON eşleme, ertesi gün General kalıcılığı,11kapı/127maske,aynıhedef tekrarı reddi,geçhata atomik geri alma.
- `logs/test-account-full-tests.log`: **858/858**,0hata. `logs/test-account-source-check.log`: **310 JS/0 sözdizimi hatası**.
- GerçekDB'nin ayrı yedek kopyasında prova: `logs/test-account-rehearsal.log` / `test-account-rehearsal-report.json`. Sonra asılDB tek işlemde değiştirildi.
- `logs/test-account-created.log`: oluşturma sonrası **60 orijinal tablodaki her eski satır aynen korundu**. `logs/test-account-live-verification.log`: gerçek giriş/2Dtercihi/General/HOF,11tamamlanmışkapı,en yüksek puan,integrityOK/FK0;60orijinal tablo yeniden karşılaştırıldı.
- Oluşturma öncesi yedek `backups/darkorbit-before-2026-10-23T14-01-25-983Z.db`; oluşturma sonrası yedek `backups/darkorbit-before-2026-10-23T14-02-41-552Z.db`. İkisinin migration-check kopyaları da geçti. Artık3hesap/3oyuncu/13gemi var.
- **Güncel PID7164**,soloHTTP8095/TCP8096. Önceki PID9940 kimlik doğrulamasıyla kaydederek kapatıldı. `logs/test-account-server-console.log` / `test-account-server-error.log`. MAIN/cache aynı; bu tur oyun runtime'ına yama eklenmedi.

[Önceki2Ddağıtımı](classic-2d-current.md), [kalkan incelemesi](2d-shield-current.md), [ana açık işler](second-completion-work.md) geçerlidir. Native ekran girdisine önceki Escape kısıtı sürer; çok oyunculu/mimari geçişi yapılmaz.
