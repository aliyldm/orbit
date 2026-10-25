# Modern savunma, kamuflaj ve hedef düzeltmesi — 24 Ekim 2026

Yerel tamamlama çalışmasının devamı. Yeni yetenekler gerçek savaş hesaplarına ve native istemci paketlerine bağlıdır. Bu rapor bütün yerel eksiklerin bittiği anlamına gelmez; [kalanlar](remaining-work-current.md) ayrı tutulur. 5-x labirenti kapalı, LF4 tavanı ve solo kapsamı korunuyor.

## Yeni işlevler

| Gemi / işlev | Davranış |
|---|---|
| Berserker — Berserk | 30 saniye boyunca o an kaybedilen normal can oranı kadar ek lazer hasarı. Can değiştikçe hesap yeniden değişir. NanoHull kaybı aynı orana eklenmez. 60 saniye bekleme. |
| Berserker — Revenge | 6 saniye boyunca NPC saldırısının %100'ünü geri yansıtır; gemi yine %5 hasar alır. %5 hız kaybı; 180 saniye bekleme. Berserk ile birlikte kullanılabilir. |
| Orcus — Assimilate | NPC hasarının %20'si önce uygulanır; gemi yaşıyorsa %80'i normal can olarak iyileşir. Kalkan/NanoHull doldurulmaz. 20 saniye; kapanınca 540 saniye bekleme başlar. Ölümden geri döndürmez. |
| Orcus — Amplify | Birleşmiş gemi modülü bonus ve cezaları ×1,75. Eski ×2 değeri kullanılmaz. Bu katsayı gelecekte uyumlu modüllere de uygulanır; mevcut kararlı katalogda Orcus'a uyumlu modül yok, istikrarsız modüller hâlâ kapalı. |
| Ultimate Cloak | Spearhead/Veteran/Plus 30 saniye, Elite 45 saniye; Defcom/Raven 20 saniye. Kendi gövdesinin 360/240 saniye beklemesi. CPU cephanesi tüketmez. Hareket korunur; oyuncu saldırısı, toplaması veya harita değişimi bitirir. PET toplaması bitirmez. |
| Mimesis — Scramble | +%25 hız ve lazer hasarı; saniyede azami kalkanın %10'u tüketilir. Kalkan bitince, konfigürasyon değişince, harita/oturum değişiminde kapanır. Kalkan yenilenirse 30 saniyeyi aşabilir; 300 saniye bekleme başlangıçta kaydedilir. NPC silah atışlarına %65 kaçınma katkısı. Alan patlamalarına sahte isabet zarı eklenmez. |
| Citadel ailesi — Fortify | Seçilmiş eski hareket kuralında hız0; yeni hareket ve yetenek isteği engellenir. Önceden açılan etkiler ve ateş devam eder. Gelen hasar%50 azalır. Gövde süreleri10s/Elite8s;360s bekleme. Plus'ın Prismatic Endurance'ı önceden açıksa beraber sürer. |
| Doğrulanmış pasifler | Cyborg +%10 hasar; Mimesis +%10 kalkan / +%5 kalkan delme; Spearhead Plus +%5 kaçınma. |

Revenge'de 2022 resmî düzeltmesi kullanılır; eski tam dokunulmazlık uygulanmaz. Yansıyan hasar tekrar Berserk lazer çarpanından geçmez. Korunmuş NPC'ye hasar yazılmaz. Öldürme gerçek ödül/rütbe/kargo yoluna gider; ödül kaydı başarısızsa NPC can/kalkan/hedef durumu geri alınır ve oyuncuya yarım işlem hasarı yazılmaz. NPC kalkanına uygulanan emilim ve zırh/diğer azaltıcılarla tam sıralama seçilmiş yerel politikadır; kapalı sunucunun bütün ayrıntıları çözüldü denmez.

Assimilate hasar zarı/koruma kontrollerinden sonra devreye girer. Ölümcül %20 hasar iyileştirmeden önce öldürür. NanoHull ve PET HP Link normal gövde hasarı yolunda korunur. Barracuda kendini önceden emekliye ayırıp patladığında da NPC kökenli patlama olarak tanınır.

Ultimate Cloak için önceki normal CPU kamuflajı ayrı tutulur; süre bitince varsa normal kamuflaj görünümü geri kurulur. Normal CPU'yu etkinleştirmek üstün kamuflajı bitirir ve tek yük tüketir. Native103 başlangıcı zaten görsel/sesi başlattığından ikinci bir aktivasyon paketi gönderilmez. Korsan sisi üstün kamuflajı bozmaz. NPC hedef bağı aktivasyonda kesilir; yeni agresif hedefleme ve gecikmiş NPC hasarı engellenir. **20 saniyelik çatışma kilidi tarihsel taktik rehberinden seçilmiş kuraldır; güncel özel sunucu sabiti olarak doğrulanmış değildir.** PvP hedef kilidi/grup etkileşimleri sonraki mimari fazına kalır.

[Resmî Spearhead rehberindeki](https://board-de.darkorbit.com/threads/faq-spearhead-faehigkeiten.2733/) geçici sıfır kalkan da uygulanır. Gerçek kalkan havuzu ayrı tutulur; kamuflaj sırasında yenilenmez, bitince geri döner. Kayıt, tekrar giriş ve konfigürasyon değiştirmek geçici0değerini gerçek kalkan diye kaydetmez. Aynı konfigürasyonun tekrar istenmesi de ayrılmış havuzu silmez. Henüz PvP minimap görünürlüğünün çok oyunculu kabulü yapılmadı.

Fortify'ın hareket/yetenek kilidi [resmî Citadel rehberinden](https://board-de.darkorbit.com/threads/faq-citadel-faehigkeiten.2977/);%50azaltma [ön üretim dengeleme metninin eski değer sütunundan](https://board-en.darkorbit.com/threads/pre-production-balance-patch-the-emerging-light.120312/) alınmıştır. Aynı metindeki önerilen200hız/%80azaltma, dağıtılan10s/Elite8s süreli eski davranışla karıştırılmaz. Bu sürüm seçimi bütün2026sunucu ayrıntıları birebir çözüldü iddiası değildir. Genel hız katmanı0hızı güvenle destekler, sonsuz hareket süresi üretmez ve yeni stat/konfigürasyon hesaplaması hareketsizliği bozamaz.

Scramble'da resmî SSS'nin kalkan bitene kadar süren davranışı, yakalanmış istemcinin30s görüntü süresinden üstün tutulur. Kaçınma eski SSS'deki%80 yerine Aralık2018 resmî yamadaki%65'tir. Ocak2018 ön üretim teklifindeki%30hasar/%8tüketim değerleri canlı kural diye kullanılmaz. Hasar/kaçınma bonuslarının diğer kaynaklarla birleşimi mevcut yerel savaş politikasıyla yapılır. Phase Out hâlâ eksik; Mimesis'in bütün yetenekleri tamamlandı denmez.

Mimesis pasifini eklerken diroit formasyonu katmanının önceki kalkan delme bonusunu sildiği de düzeltildi. Gövde ve formasyon katkıları toplanıp0–1aralığında sınırlandırılır. Yeni bir pasif eklenen fakat aktif yetenekleri eksik gövdeler dükkân denetiminde yanlışlıkla tam işlevli olarak işaretlenmez.

## Gecikmiş roketten sonra hedef kaybı

Gerçek ağ testinde eski hedefe giden roketin başka bir NPC'yi öldürmesi, yeni seçilmiş hedefi bırakıyordu. `Combat.kill` seçimi ve lazeri koşulsuz temizliyordu. Artık yalnız öldürülen NPC seçiliyse seçim temizlenir; yalnız ona ateş ediliyorsa lazer durur. Yeni hedefe sürdürülen lazer zamanlayıcısı ve kilit korunur. Test, gerçek roket uçuş zamanlayıcısı sırasında yeni hedefe geçip ateş etmeyi kapsar.

## Kaynaklar

- [Vortex of Terror — Berserker](https://board-en.darkorbit.com/threads/vortex-of-terror-faq.119463/)
- [Nisan2022 — Revenge%5hasar/%100yansıtma düzeltmesi](https://board-en.darkorbit.com/threads/april-sync.127863/)
- [Eternal Blacklight — Orcus ve Amplify1,75 güncellemesi](https://board-en.darkorbit.com/threads/eternal-blacklight-faq.126632/)
- [Yeni gemiler — Mimesis/Cyborg](https://board-en.darkorbit.com/threads/new-ships-faq.118482/)
- [6Aralık2018 — Scramble%65](https://board-en.darkorbit.com/threads/sync-notes-for-december-6-2018.123297/)
- [Spearhead Plus pasifi](https://board-en.darkorbit.com/threads/faq-ship-plus-update-spearhead-plus.128201/)
- [Ultimate Cloak'ı bitiren işlemler — resmî destek yanıtı](https://board-en.darkorbit.com/threads/spearhead-ultimate-cloak-not-working.101247/)
- [Tarihsel taktik rehberi —20s çatışma kilidi](https://board-en.darkorbit.com/threads/tactical-ship-guide.102122/)
- Gövde süreleri: `game/data/ship-abilities.json`, kaynak `ItemDataProvider.as`. Native efektler: `VisualModifierAssembly.as`, `AbilityStartHandler.as`, `AbilityStopHandler.as`, `AbilityEffectActivationAssembly.as`.

## Önceki listede hatalı eksik sayılan P.E.T. davranışları

Kaynak toplayıcı bütün uygun cevheri toplar. Ayrı cevher seçme alt menüsü kaynak **bulucuya** aittir. [Resmî destek, eski SSS hatasını düzeltiyor](https://board-en.darkorbit.com/threads/gi-p-e-t-10-auto-resource-gear.100802/). Orijinal dışı seçim menüsü eklenmeyecek; kaynak bulucunun mevcut native seçim sözleşmesi çalışıyor.

Ticaret penceresinde her cevherin kendi satış düğmesi vardır. `OreTradeModule.handleSellButtonClick`, tek `TradeSellOreRequest.toSell` gönderir; toplu sepet alanı yoktur. [Resmî P.E.T. SSS](https://board-en.darkorbit.com/threads/pet-10-faq.1228/) de seçilen cevherin satılmasını ve ardından PET'in geçici yokluğunu anlatır. Mevcut tek cevher isteği doğru sözleşmedir. Ödemenin mutlaka dönüşe ertelenmesi gerektiği kanıtlanmadığından özgün eksik diye geliştirme planına konmaz. Anlık ödemenin bütün özel sunucu ayrıntıları birebir doğrulandı iddiası da yapılmaz.

## Doğrulama

983/983 test; 356JS/0sözdizimihatası.34yeni regresyon testi. `tests/berserker-orcus.test.js` ve `tests/ultimate-cloak.test.js`; bütün testler `logs/modern-defense-full-tests.log`.

Gerçek izole HTTP/TCP senaryosu23.471paketle PASS. `tools/test-network-modern-defense.js`: beş gövde satın alma, native yetenek istekleri, yansıma/iyileşme, kamuflaj kalkanını sıfırlayıp toplayarak bitirince geri verme, gerçek SG3N-B02 satın alma/FlashAPI ile takma, Scramble tüketimi ve Fortify sırasında TCP hareket isteğinin reddi. İlk ağ denemesi yukarıdaki gerçek hedef kaybını yakaladı; ayrı hata kaydı `logs/modern-defense-network-first-diagnostic.log`, düzeltmeden sonra baştan geçen kayıt `logs/modern-defense-network.log`.

Ana kaynak manifestleri17.301girdi:17.300indirilebilir dosya yerelde; eksik0; tek boş-MD5 placeholder ayrı. Native2D/3Defekt dosyaları da mevcut: `logs/modern-defense-effect-assets.json`. Bu yalnız varlık kontrolüdür; dinamik bütünURL'lerin çevrimdışı kabulü, dosya içeriklerinin tamamının hash doğrulaması ve gerçek Qt görüntü kabulü değildir. Qt penceresine girdi verilmedi. MAINdeğişmedi. Üretim dağıtımı ve veri korunumu aşağıya kaydedilir.

**Dağıtıldı: PID2744**, soloHTTP8095/TCP8096, healthOK. Son kayıt sonrası WALuyumlu yedek `backups/darkorbit-before-2026-10-24T16-59-46-168Z.db`. Yeniden başlatmada60tablonun bütün kolon/satırları yedekle aynı; değişen tablo yok.3hesap/3oyuncu/14gemi,integrityOK/FK0. Kanıt `logs/modern-defense-production-check.json`. MAIN SHA256 `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824`; cache aynı. Yeni migration/hediye/iade yok. Aynı turdaki ilkPID21280kalkan/Fortify eklerinden önceydi; sonPID2744o ekleri de içerir. ÖncekiPID16172ve21280kayıt işleyicileriyle kapatıldı. Yeni native menüler için oyun yeniden açılmalı.
