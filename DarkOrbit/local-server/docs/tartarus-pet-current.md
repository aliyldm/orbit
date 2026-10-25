# Tartarus ve P.E.T. düzeltmeleri — 24 Ekim 2026

Bu paket yerel eksikleri tamamlama çalışmasının devamıdır. 5-x labirenti kapalı, LF4 lazer tavanı korunuyor; çok oyunculu mimariye geçilmedi. Bütün yerel eksikler bitmiş değildir.

## Eklenen davranışlar

| İşlev | Uygulama |
|---|---|
| Tartarus Speed Boost | Hız ×1,30; yalnız lazer hasarı ×0,95. Açma ve kapatma arasında 10 saniye kilit. Süresiz anahtar. |
| Tartarus Plus Speed Boost | Hız ×1,45; yalnız lazer hasarı ×0,75. Aynı 10 saniyelik anahtar kilidi. |
| Rapid Fire | Üç saniye boyunca gerçek takılı roketatarların mevcut cephaneyle anında dolması ve salvolar arasında 1 saniye bekleme. Normal gemide 24 saniye, Plus'ta 72 saniye yetenek beklemesi. |
| Rapid Fire Plus hasarı | Etkin yetenek süresinde roketatar hasarı ×1,20. Tekli roket ve lazerlere aynı bonus uygulanmaz. |
| Tartarus Plus pasifi | Salvo başına %20 olasılıkla aynı türden bir ücretsiz ek roket. Son satın alınmış mermiyle de çıkabilir; boş depodan sınırsız salvo üretilmez. İki roketatar için tek salvo/tek şans uygulanır. |
| Hecate pasifi | %7 silah hasarı, %10 kalkan. Particle Beam resmî kurala göre NPC hedeflerine uygulanmaz; PvP aşamasına kalır. |
| P.E.T. G-REP1 | Çatışma sırasında kendi canını doldurmaz. Modül değiştirmek çatışma zamanını temizlemez. Mevcut yerel 10 saniyelik P.E.T. çatışma bekleme penceresi kullanılır; bu sayının özgün sunucudan çözüldüğü iddia edilmez. |

Hız anahtarı mevcut `settings` tablosunda `game.shipAbilityToggles` olarak saklanır; yeni migration yok. Harita yenilenmesi/oturumdan çıkış hız çarpanını kalıcı istatistiğe yazmaz. Aynı gövdede tekrar girişte seçili durum ve native görsel yeniden kurulur; ölüm veya başka gövdeye geçiş seçimi temizler. Konfigürasyon yenilemek çarpanı ikinci kez uygulamaz. Anahtar kilidi ve kayıt birlikte transaction içindedir; SQL hatası sahte hız veya bekleme üretmez.

Rapid Fire mevcut `hellstorm` döngüsünü kullanır. Cephane yalnız gerçek ateşte düşer; yükleme önizlemesi cephane üretmez veya tüketmez. Aktif CPU ve gerçek saldırı olmadan otomatik ateş başlamaz. Yetenek bitiş sınırında dördüncü hızlı salvo çıkmaz. Normal roket uçuş/çarpma zamanları korunur; Plus'ın bedelsiz roketi hasar ve `HellstormAttackCommand.currentLoad` içine birlikte dahil edilir. İki farklı roketatarın bonus roketinde ilk takılı roketatarın geliştirme çarpanı kullanılır; bu seçim kapalı sunucudan doğrulanmış ayrıntı değildir.

Native menüler: `ability_tartarus_speed-boost`, `ability_tartarus_rapid-fire`, `ability_tartarus-plus_speed-boost-plus`, `ability_tartarus-plus_rapid-fire-plus`. Native `VisualModifierCommand` 0/1, mevcut istemcinin 2D ve 3D efekt assembly'lerine bağlıdır. MAIN SWF değiştirilmedi. Önceki 14 menüye 4 eklenmiştir; toplam 18 işlevli solo yetenek menüsü vardır.

**Açık sınırlar:** Phantom/Chimera tam takımının özel görsel kenetlenmesi, JAM-X ve diğer PvP etkileşimleri uygulanmadı. Kullanıcının gerçek Qt penceresi kullanılmadı; native paket testi görsel kabul yerine geçmez. PET HEAT ve diğer gemilerin eksik yetenekleri sürüyor.

## Kanıt ve kaynaklar

- `game/data/ship-abilities.json`: dağıtılan `ItemDataProvider.as` süreleri ve hız/hasar parametreleri; kaynak SHA256 önceki çıkarma aracında doğrulanır.
- `decompiled/main/scripts/net/bigpoint/darkorbit/net/VisualModifierAssembly.as`: Speed Boost/Rapid Fire için gerçek model efektleri ve 2D/3D görünümler.
- [Resmî Tartarus SSS](https://board-en.darkorbit.com/threads/tartarus-ship.115771/), [2018 dengeleme duyurusu](https://board-en.darkorbit.com/threads/balance-patch.121942/): %30 hız, %5 hasar kaybı ve 24 saniye bekleme.
- [Resmî Tartarus Plus SSS](https://board-en.darkorbit.com/threads/faq-ship-plus-update-tartarus-plus.128400/): %45/%25, anında bütün roketatarların doldurulması, bir saniyelik salvo aralığı, %20 hasar ve ücretsiz ek roket.
- [Resmî Hecate SSS](https://board-en.darkorbit.com/threads/hecate-ship.124099/): pasifler ve Particle Beam'in NPC'lere uygulanmaması.
- [Resmî P.E.T. SSS](https://board-en.darkorbit.com/threads/pet-10-faq.1228/): tamir modülünün çatışmada tamir edememesi.

## Doğrulama

949/949 test geçti. On yeni test hız/konfigürasyon/harita/yeniden giriş/ölüm/SQL geri alma, üç salvo sınırı, iki roketatar, son cephane, %20 şans sınırı, gerçek hasar ve P.E.T. çatışma tamirini kapsar. `logs/tartarus-full-tests.log`; `tests/tartarus-abilities.test.js` ve `tests/pet-runtime-expanded.test.js`.

İzole bellek DB ve ayrı portlarla gerçek HTTP/TCP testi: 23.354 çözülen paket, PASS (`logs/tartarus-network.log`). İki Tartarus gövdesi dükkândan alınır; orijinal FlashAPI ile gerçek HST-2 yuvalarına taşınır; hız ve Rapid Fire native menü istekleri TCP üzerinden gelir; gerçek hedef seçimi, salvo, bir saniyelik bekleme ve tam cephane düşümü doğrulanır. Üretim hesabına test eşyası eklenmez. Son üretim dağıtımı ve veri korunumu ayrıca aşağıya kaydedilir.

**Dağıtıldı: PID16172**, solo HTTP8095/TCP8096, healthOK. Eski PID21516 yalnız kendi kayıt/kapanış işleyicisiyle durduruldu. Son kayıt sonrası yedek: `backups/darkorbit-before-2026-10-24T16-03-21-399Z.db`. Üretimde60tablonun bütün kolon/satırları yedekle aynı; değişen tablo yok,3hesap/3oyuncu/14gemi,integrityOK/FK0. Kanıt: `logs/tartarus-production-check.json`. MAIN SHA256 `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824`; cacheaynı.353JS/0sözdizimihatası. Yeni migration/hediye/iade yok. Yeni menüler için oyun tekrar açılmalı.
