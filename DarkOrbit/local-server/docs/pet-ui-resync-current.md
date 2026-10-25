# P.E.T. modül menüsü ve durum eşitlemesi — 25 Ekim 2026

Paket çalışan yerel sunucuya uygulandı. P.E.T. geri çağrıldıktan sonra tekrar açıldığında boş kalan modül menüsü ve reddedilen modül seçiminde yanlış kalan başlık düzeltildi.

## Neden ve değişiklik

Kurulu MAIN içindeki `PetWindowAssembly.petDeactivation`, `resetPetWindowValues` üzerinden modül listesini ve seçili metni temizliyor. Sunucunun gerçek yeniden açılışı yalnız aktivasyon, durum ve seçim gönderdiği için temizlenmiş menü tekrar oluşturulmuyordu. Her açılış artık mevcut `sync/buildInit` akışını kullanarak önce kullanılabilir modülleri, ardından gerçek seçimi ve aktif P.E.T. durumunu gönderiyor. HP, yakıt ve bekleme süreleri korunuyor; yinelenen açma isteği ikinci P.E.T. oluşturmuyor.

İstemci modül simgesini/metnini sunucu yanıtından önce değiştiriyor. Donanım eksikliği, bekleme süresi veya ticaretin sürmesi nedeniyle reddedilen seçim artık gerçek menü ve moda geri eşitleniyor. İstek işleyicisindeki veritabanı hatasında da durum yeniden gönderiliyor. Başarısız işlem başarılı gösterilmiyor; mevcut modül kuralları korunuyor.

Değişen kaynaklar: `game/pet.js`, `game/handlers/pet.js`; regresyonlar `tests/pet-native-state.test.js` ve `tools/test-network.js`. İstemci SWF dosyaları/cache kimlikleri değiştirilmedi. Kurulu istemciden çıkarılmış beş sınıf ve hash kanıtı `decompiled/pet-ui-resync-audit/evidence.json` içinde.

## Gerçek hesaplarda konfigürasyon farkı

Salt okunur incelemede **asd ve test konfigürasyon 2'de**, özel P.E.T. modülleri ise yalnız **konfigürasyon 1'de** takılıydı. Bu nedenle 2'de özel modüllerin listelenmemesi beklenen davranış. 2'de kullanılacak modüller hangardaki P.E.T. yuvalarına bu konfigürasyonda da takılmalı. Oyuncuların donanımı taşınmadı veya çoğaltılmadı. Temel modların da kaybolması ise yukarıdaki menü hatasıydı.

## Doğrulama ve dağıtım

- Düzeltmeden önce üç regresyon yeniden üretildi: boş yeniden açılış listesi, bekleme süresinde yanlış mod başlığı, ticaret sırasında yanlış mod başlığı. `logs/pet-ui-resync-repro.log`.
- Odaklı P.E.T. denetimleri **56/56**, bütün testler **1073/1073**, **383 JavaScript dosyası / 0 sözdizimi hatası**. Kapat/aç döngüleri, konfigürasyon değişimi, reddedilen seçim, depolama hatası, kamikaze/onarım/ticaret ve harita/oturum durumları kapsandı.
- İzole gerçek HTTP/TCP testi **24557 çözümlenmiş komutla PASS**. Üç kapat/aç döngüsünde modül ekleme/sıralama ve geçersiz modülden gerçek seçime dönüş doğrulandı. İlk eklenen testte yerel değişkene bildiriminden önce erişim vardı; test değişkeni düzeltildi ve tekrar geçti. Bu bir oyun hatası değildi.
- Dağıtım sırasında eski sunucu PID13108 zaten çalışmıyordu; zorla kapatma yapılmadı. Güncel PID **24528**, solo HTTP8095/TCP8096 ve health OK.
- SQLite online yedeği: `backups/darkorbit-before-2026-10-25T12-47-57-397Z.db`. Başlatma sonrası **60 tablonun tüm şemaları ve satırları aynı**; 3 hesap, 3 oyuncu, 14 gemi; integrity OK / FK ihlali 0.
- Servisten indirilen MAIN SHA256 `6839384bca951b7d7ece2081c4054cbac4748b1beb2e985da5e995e0afcc95e7`, inventory `1721614e40928882542eb84f2158e2309def9b02f5806a0b11e29fa7caf8336a`; önceki paketle aynı.

Üretim kanıtı: `logs/pet-ui-resync-production-check.json`. Oyuna yeniden giriş yeterli. Gerçek Qt/Flash fare-klavye oynatımı veya görsel kabul yapılmadı; durum modeli ve ağ komutları doğrulandı. HEAT ve önceki raporlardaki özgün mekanik eksikleri bu paketle tamamlanmış sayılmaz. .NET/PostgreSQL geçişi yapılmadı.
