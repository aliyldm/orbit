# Doğrulama — 20 Ekim 2026

- `node --test --test-reporter=tap tests/*.test.js`: 248 test, 248 başarılı, 0 başarısız.
- `node tools/check-source.js`: 132 JavaScript dosyası, 0 sözdizimi hatası.
- `node tools/check-client.js`: iki orijinal dosya kimliği ve tam beklenen yama farkları doğru; preloader/main SWF mevcut.
- `node tools/test-network.js`: ayrı bellek DB'si ve geçici portlarda gerçek HTTP/TCP akışı başarılı. Diminisher'ın gerçek MenuActionRequest → AbilityStart/Legacy efekt/cooldown akışı dahil 674 komut çözüldü. Üretim hesabı veya veritabanı kullanılmadı.
- `node tools/audit-capabilities.js`: 82 kayıtlı komut, kayıtta 50 istemci komut türü; sekiz gözlenen tür uygulanmamış. Ayrıntı `capability-audit.json`. Kayıt sayısı özellik tamamlanmışlığı değildir.
- REA kontrollü tarayıcı senaryosu: Edge/Chromium155, headless, ayrı bellek DB'sinde local-ui-qa hesabı; giriş ve ana sayfadaki geliştirme bağlantısının görünmesi başarılı. Eski bülten/HELIX pencereleri görünmüyor; 0 page-error. Kanıt `ev_d34b524aa0d5a62f5825d1a00b88088eaa4fdb2bb5caeb7e9c286059557b1aba`. Geçici test sunucusu kapatıldı. Bu kontrol Flash haritasını veya gemi yeteneklerinin görsellerini doğrulamaz.
- Güncel üretim sunucusu PID24748; HTTP8095/TCP8096. `/health`: status=ok, mode=solo. Yeniden başlatma sonrasında hata kaydı boş.
- Üretim DB'sinde salt okunur kontrol: oyuncu2/asd, iki diroit ve 67.343.656 Uridyum. Yabancı anahtar ihlali0. Onarım net19.000 Uridyum ve iki Iris için önceden açıkça onaylanmıştı; bu doğrulama yeni para/eşya değişikliği yapmadı.

Klasik yeteneklerin bazı süreleri ve beklemeleri yerel dengedir; `ship-abilities-local.md` kaynak davranışıyla yerel politikayı ayırır. Bütün DarkOrbit içeriği tamamlanmış veya Flash'ta baştan sona görsel test edilmiş değildir. Güncel kapsam README dosyasındadır.

## Lazer çıkışı güncellemesi

254/254 test ve135 JavaScript sözdizimi kontrolü başarılı. Gerçek HTTP/TCP testinde ikinci lazerin takılması ve Diminisher kademe3 paketi doğrulandı (694 çözülen komut). Aktif Spectrum hesabında15 gemi lazeri ve beklenen kademe3 salt okunur DB sorgusuyla doğrulandı. Hasar RNG ayarı±%15 olarak korundu. Güncel sunucu PID14080; /health ok, hata kaydı boş. Önceki PID ve test sayıları yukarıdaki tarihsel doğrulamanın değerleridir. Kaynaklar ve kapsam laser-visuals-local.md içinde.

## Kapı içeriği ve ArGe kalkanı güncellemesi

- 287/287 test başarılı; 143 JavaScript dosyası, sıfır sözdizimi hatası. Tam çıktı `logs/gate-final-suite.log`.
- On özgün içerik planının tamamı koşuldu; bütün NPC slotları, korumalı boss açılması, tam EP/şeref/kredi/Uridyum toplamları, tek seferlik bitirme ve ödül claim sayıları denetlendi. Ölüm/yeniden giriş/SQL hata geri alımı ayrıca test edildi.
- Gerçek HTTP/TCP'de 1.686 komut çözüldü: kalkan jeneratörü alım/takımı, ArGe kalkanı açma ve boşalma paketleri; Alpha kurma, gerçek geçiş isteği, 10 Streuner ve seçimde 800 HP/400 kalkan, çıkış doğrulandı. Geçici bellek DB'sindeki beceri fixture'ları gerçek hesaba verilmedi.
- SQLite online yedeği `backups/darkorbit-before-2026-10-20T06-35-07-549Z.db`; ayrı migration kopyasında 013 geçişi hesap/oyuncu/gemi kayıtlarını değiştirmedi. Launcher/Flash dosya kontrolü başarılı.
- Güvenli kayıt/kapanış sonrası güncel sunucu **PID24524**, HTTP8095/TCP8096. `/health`: status=ok, mode=solo; başlangıç hata kaydı boş. Gerçek DB migration013, integrity=ok, yabancı anahtar ihlali0.
- `asd` Uridyum67.343.656 olarak korundu; Kalkan enerjisi17=5 zaten öğrenilmiş, Kalkan sıklığı8 verilmedi. Mevcut kullanılmamış Alpha/Beta kapıları can3 ve dalga1 olarak korundu; ilk girişlerinde yeni içerik planını ek ücret/parça tüketimi olmadan benimserler.

Kaynak sürüm farkları ve yerel hız/zamanlama sınırları `npc-catalog-local.md`, `gate-content.md`, `gate-combat-local.md` içinde; gerçek efekt kodu `shield-visuals-local.md` içindedir. Hades grup/polarite sistemi, Kuiper özel AI/ayrı haritaları ve bütün boss saldırı algoritmaları tamamlanmış değildir. Flash üzerinde görsel uçtan uca test iddiası yoktur.

## ArGe roket görselleri güncellemesi

294/294 test ve 145 JavaScript sözdizimi kontrolü geçti. Yedi yeni roket testi; gerçek beceri yükseltme/sıfırlama, mor iz/kurtarılmış isabet ışığı, tek RNG ve mevcut hasar/uçuş davranışını doğrular. HTTP/TCP testinde 1.718 komut çözüldü; gerçek `AttackRocketRequest` karşılığında `0|v|…|H|1|1|1` doğrulandı. Test becerileri ve düşük temel isabet fixture'ı yalnız bellek DB'sindedir.

Üç smoke SWF'sinin iç sprite kareleri JPEXS ile incelendi; smoke1 mor/mavi, smoke2 kırmızı. Kaynak sınırları `rocket-visuals-local.md` içindedir. Varsayılan %100 temel isabet değiştirilmediğinden üretimde kurtarılmış isabet ışığı oluşmaz; max Fusion mor izi bağımsızdır. Üretim hesabında6/20 becerileri bulunmuyor, ücretsiz seviye eklenmedi.

Güncel sunucu **PID19928**, HTTP8095/TCP8096; sağlık durumu ok/solo ve hata kaydı boş. SQLite bütünlüğü ok, FK ihlali0; asd hesabında kredi1.000.118.400 ve Uridyum67.343.656 korundu. Bu güncelleme migration veya oyuncu para/beceri değişikliği gerektirmedi.

## Klasik normal dünya güncellemesi

- 342/342 test geçti (`logs/normal-world-suite.log`), 156 JavaScript dosyasında sıfır sözdizimi hatası. On harita topolojisi, sekiz profil, dört kargo, on bir AI, dokuz dünya entegrasyonu ve altı kalıcı normal NPC testi yeni kapsamı doğrular.
- Gerçek HTTP/TCP: 9.033 komut çözüldü (`logs/normal-world-network.log`). Native geçitlerle üst harita/Cubikon/Kristallon, 4-5/Uber Kristallon, tek yönlü korsan güzergâhı/Battleray, uzaktan ticaret reddi, tarafsız ticaret tipi5, gerçek `XCP|30` ile iki ekstra enerji ve dönüşte hasarlı NPC seçimi (321 HP) doğrulandı. Bunlar bellek DB'sindeki QA hesabındadır; üretim hesabına test seviyesi/cevher verilmedi.
- `backups/darkorbit-before-2026-10-20T07-27-36-651Z.db` SQLite online yedeği; ayrı migration kopyasında iki hesap, iki oyuncu, altı gemi ve 12 sahiplik/ilerleme tablosu aynen korundu. 014 geçişi integrity/FK denetimlerinden geçti.
- Eski sunucu PID19928 kayıt işleyicisiyle kapatıldı. **Güncel sunucu PID21824**, HTTP8095/TCP8096; `/health` ok/solo, başlangıç hata kaydı boş. Gerçek DB migration014 ve normal-world-v1 içerik sürümünü taşıyor; integrity=ok, FK ihlali0. 32 normal+10GG haritası, 96 normal portal ve 939 yerel kalıcı nüfus yuvası var. Solo çalışma yalnız etkin haritayı simüle eder.
- Üretimde `asd`: kredi1.000.118.400, Uridyum67.343.656, iki Iris ve Alpha/Beta can3/dalga1 korunuyor. Oyuncu seviyesi1 korunmuştur; üst harita ve düşman şirket geçişleri artık gerçek kaynaklı seviye şartıyla denetlenir.

Üyelik/topoloji kanıtı, kaynak sürümü farkları ve yerel koordinat/nüfus/süre sınırları `normal-world-local.md`, `normal-map-layout.md`, `normal-map-spawns.md`, `normal-npc-ai.md` içinde açıklanır. Saboteur/Barracuda/Annihilator'ın bütün özel saldırıları ve modern/koşullu bütün NPC'ler tamamlanmış sayılmaz. Flash görsel uçtan uca doğrulama iddiası yoktur.

## Temel korsan özel saldırıları güncellemesi

- 363/363 test geçti (`logs/pirate-special-suite.log`); 21 yeni özel saldırı testi. 160 JavaScript dosyasında sıfır sözdizimi hatası; son ağ testi dosyası düzenlemesi ayrıca `node --check` ile doğrulandı.
- Gerçek HTTP/TCP'de9.221 komut çözüldü (`logs/pirate-special-network.log`). Normal haritada gerçek Saboteur vuruşu hız/efekt paketlerini üretti; TCP `MenuActionRequest` EMP temizliğini yaptı. Annihilator NPC→oyuncu beşli Hellstorm paketi gönderdi, hasar uçuş sonunda oluştu. Barracuda BOOOM→ölüm sırası ve ödülsüz kalıcı emeklilik doğrulandı. Önceki harita/kapı/dükkan/ArGe/PET akışları da geçti.
- Ağ testi gerçek uçuşu beklediğinden aktif PET artık yakıt tüketebilir. Sabit100 beklentisi yerine kalan yakıtın aralıkta olduğu ve DB kaydının istemciye son bildirilen değerle aynı olduğu doğrulanır.
- `backups/darkorbit-before-2026-10-20T11-47-34-076Z.db` SQLite online yedeği alındı. Ayrı upgrade kopyasında015 migration'ı iki hesap/iki oyuncu/altı gemi ve13 sahiplik/ilerleme tablosunun önceki tüm alanlarını korudu. Eklenen fitil alanı varsayılan0; bütünlük ok/FK0.
- Eski PID21824 doğrulanmış kayıt işleyicisiyle kapatıldı. Güncel **PID24244**, HTTP8095/TCP8096. `/health` ok/solo; gerçek DB migration015, integrity=ok, FK0; başlangıç hata kaydı boş.
- Üretim hesaplarının bakiyeleri/seviyeleri korunuyor: asd kredi1.000.118.400/Uridyum67.343.656/seviye1; iki Iris, Alpha/Beta dalga1/can3. Test eşyası, becerisi veya seviyesi üretim hesabına verilmedi.

Statik istemci kanıtı, kaynak ve yerel ayarlar `npc-special-attacks-local.md` içindedir. Bu güncelleme yalnız temel üç korsanı kapsar; Uber/gate/PET hedefli özel saldırılar ve diğer bütün NPC becerileri tamamlanmış değildir. Flash üzerinde görsel oynanış testi iddiası yoktur. Çok oyunculu/.NET/PostgreSQL/Redis geçişi başlatılmadı.

## Kargo, kutu ve kapı ödülü denetimi

-401/401 test başarılı (`logs/loot-audit-suite.log`),169 JavaScript dosyası sözdizimi kontrolünden geçti. Son kapasite sınırı/çıktı düzenlemesinde değişen dört dosya ayrıca `node --check` ile kontrol edildi.17 kutu/kargo entegrasyon testi,7 yeni NPC kargo kaynak testi ve14 kapı bitirme ödülü testi eklendi.
- Gerçek HTTP/TCP:12.146 komut çözüldü (`logs/loot-audit-network.log`). Dört renk için gerçek HTTP anahtar satın alma→TCP CollectBoxRequest→özgün açma efekti→anahtar düşümü/ödül/makbuz; Epsilon bütün dalgalar→ilk LF-4+5 yeşil anahtar→tek bitirme makbuzu doğrulandı. Trusted konum/ödül/öldürme fixture'ları yalnız bellek DB'sindedir; istemciye keyfi ödül verme yolu açılmadı. Önceki harita/savaş/hangar/ArGe/Alpha/PET akışları da geçti.
- Kaynak karşılaştırması45 normal NPC tablosunda sayı hatası bulmadı. Ortak kapı10+10 kargosu, x-1 seviye azaltımı ve Xenomit kargo kapasitesi hataları düzeltildi. Bonus miktarları/4-x artışı EN FAQ ile eşleştirildi; korsan kutusunun tam özgün RNG'si doğrulanamadı.
- Güvenli kapanış sonrası yedek `backups/darkorbit-before-2026-10-20T12-07-36-994Z.db`. Ayrı kopyada016/017 geçişleri iki hesap/iki oyuncu/altı gemi/13 sahiplik-ilerleme tablosunu korudu. Gerçek sunucu yükseltmesi sonrasında accounts/players/ships ve bu13 tablonun bütün satırları yedeğin eski sütunlarıyla salt okunur karşılaştırıldı:16/16 aynı.
- Eski PID24244 kayıt işleyicisiyle kapatıldı. Güncel **PID5576**, HTTP8095/TCP8096; `/health` ok/solo, migration017, SQLite integrity=ok, FK0, başlangıç hata kaydı boş. Gerçek DB'de kutu/kapı test makbuzu yok; üretime test ödülü verilmedi.
- asd kredi1.000.118.400/Uridyum67.343.656/seviye1, iki Iris, Alpha/Beta dalga1/can3 korunuyor. Snapshot'ı bulunan eski koşular yeni nadir ödül politikasıyla sessizce yeniden yazılmadı.

Toplu sonuç `loot-reward-audit.md`; kaynak/sürüm ayrımı `box-reward-evidence.md`, `npc-cargo-reward-audit.md`, `gate-completion-rewards-audit.md`. Bütün modern etkinlik, orijinal RNG veya Flash görsel oynanış eşitliği iddia edilmez.
