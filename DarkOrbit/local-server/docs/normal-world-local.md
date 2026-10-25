# Klasik normal dünya entegrasyonu

## Çalışan kapsam

Üç şirketin x-1–x-8 haritaları, 4-1–4-5 savaş haritaları ve 5-1–5-3 korsan haritaları bağlandı: 32 harita, 96 yönlü geçit, altı şirket üssü ve tarafsız korsan ticaret üssü. 4-1–4-4 klasik kalıcı NPC içermez; diğer 28 haritada 45 kaynaklı NPC anahtarı kullanılır. 23 Ekim 2026 nüfus ayarıyla profil toplamı 951 kalıcı nüfus yuvasıdır; solo sunucu yalnız etkin haritayı simüle eder. Sayılar, doğma koordinatları ve süreler özgün sunucu nüfus tablosu diye sunulmaz.

Kaynakların ayrıntılı ayrımı: [harita topolojisi](normal-map-layout.md), [NPC üyeliği ve kargo](normal-map-spawns.md), [AI](normal-npc-ai.md), [sayısal katalog](npc-catalog-local.md). Native `spacemap-config.xml` içindeki mantıksal NPC kimlikleri, `game.xml` içindeki görsel gemi kimliğiyle karıştırılmaz. Kalıcı klasik nüfustan etkinlik Curcubitor'u çıkarılmıştır.

Normal harita tanımı `normal-map-content.definition` ile adlandırılmış katalog kaydından gelir. Gate `get()` metodundaki .5 emilim ve sınırsız saldırganlık normal haritalara taşınmaz; varsayılan normal emilim .8'dir. Pasifler saldırılana kadar hedef almaz; saldırgan türler yakın temasla hedef alır. Klasik ailelerde opt-in %10 kaçış eşiği, 900 edinme/2500 takip/600 ateş mesafesi yerel politikadır. Barracuda430 ve Annihilator350 hızları İspanyolca kaynakla normal sürüme bağlanır; Interceptor hızı tek oyunculu hedefin hızı−20 kuralıyla güncellenir. Genel kapı katalog sürümleri bu normal hız uyarlamasını devralmaz.

## Anne NPC ve muhafızlar

Cubikon kendi başına sıfır hasar verir; sahte lazer üretmez ve saldıranı kovalayan bir normal NPC gibi davranmaz. Gerçek can/kalkan hasarı alınca Protegit muhafızları çıkar. Sadece hedef seçmek muhafız üretmez. Yerel ayarlar: anne başına20 muhafız, 2500 tutma mesafesi, 5 saniye eksik muhafız doldurma, 20 saniye ilgisizlik sınırı. Anne öldüğünde kendi muhafızları ödülsüz kaldırılır; başka anneye ait veya bağımsız Protegit silinmez. Muhafızın gerçek öldürülmesi normal NPC ödülü verir, bağımsız yeniden doğma zamanlayıcısı üretmez. Bu muhafız sayıları/süreleri kaynakta kurtarılmış kesin algoritma değildir.

Battleray ve Uber Battleray ilgili Interceptor türlerinden10 muhafızla çalışır. Standart Battleray'da koruma, muhafızların yarısı öldürüldüğünde açılır; hayatta kalan muhafızlar 10 saniyede %10 can yeniler. **Koruma ve iyileştirme mekanizması** [İspanyolca NPC FAQ](https://board-es.darkorbit.com/threads/faqs-aliens.135697/) içindedir; 10/5 eşikleri, süre/yüzde ve ilk grubun sonlu kalması yerel ayarlardır. Sonlu grup koruma açılır açılmaz kapanan kilitlenmeyi önler. Uber Battleray'a kaynakta doğrulanmayan aynı koruma otomatik eklenmez. Koruma `npcProtected` üzerinden bütün silah yollarında denetlenir; gerçek `0|n|ISH|id` görseli yenilenir.

## Üsler, Palladium ve kargo

x-8 üsleri eski ana üs sprite'ı yerine gerçek outpost AssetType değerlerini kullanır: HQ47, hangar49, cevher51, tamir54 ve taret56/58. Ana respawn hâlâ x-1'dir. 5-2 üssünde gerçek `station_6` korsan modeli ve tarafsız görünmez cevher satıcısı52 kullanılır; boş `station_0` gönderilmez.

Bu eşleme `decompiled/main/scripts/net/bigpoint/darkorbit/mvc/common/model/assets/UberAssetsLib_LIB_DEFAULT_XML.as` içinde gösterilen DefineBinaryData184 kaynağından doğrulandı. Ham XML `decompiled/normal-map-evidence/lib-assets.xml`, SHA-256 `8c5b0867df368b8f0dcf2d1f8414afe51b73a57881317abba0ddceced6396199` olarak saklandı. Kaynakta `refinery_outpost_*`, `refinery_invisible_0` ve `station_6` vardır.

5-1'de60,5-3'te480 Palladium noktası sis alanlarında doğar; sayılar/sınırlar/15s yeniden doğma yerel ayardır. Native nebula POI ve kalıcı kamuflaj bozma eklendi. İki PET toplama modülü de Palladium toplar. [Güncel alanlar, kaynaklar ve eksik labirent/mayın kuralları](pirate-fields-current.md). Gerçek ore ID8 ile gemi/PET toplama ve kargo sınırı çalışır. 5-2 tarafsız üssündeki ticaret, kaynak istemcinin `OreTradeModule.handleTradeButtonClick` yolundaki `XCP|miktar` komutuyla 15 Palladium→1 ekstra enerji çevirir. [Resmî korsan FAQ](https://board-en.darkorbit.com/threads/pirate-map-faq.1013/) bu oranı ve yeri doğrular. Harita, gerçek istasyon mesafesi, canlı oturum, pozitif/tam ve 15'e bölünen miktar denetlenir; cevher ve enerji tek transaction içinde değişir. Ticaret tipi5, şirket üssünde1'dir. Builder'ın tam init listesini tekrar göndererek sekme çoğaltılmaz; enerji kalıcıdır ve sonraki üretim cevabında güncellenir.

NPC kutuları artık herkese aynı10+10 cevher vermez.45 türün açık kaynak satırları `normal-npc-cargo.json` içinde korunur; Boss/Uber için varsayımsal otomatik çarpma yapılmaz. Sonraki denetim kapı özel kargolarını da `npc-cargo.js` üzerinden kaynak sürümüne bağladı; bilinmeyen tür/ölçek için sahte10+10 kaldırıldı. Kendi x-1 Streuner seviye azaltımı ve kargo tüketmeyen Xenomit düzeltildi. [Kaynaklar ve doğrulanamayan türler](npc-cargo-reward-audit.md). Kargo kapasitesi ve mevcut gerçek ArGe/booster yüzdeleri uygulanır.

## DB geçişi ve doğrulama

014 migration'ı `map_spawns.catalog_key/behavior_json`, sürüm kaydı ve kalıcı normal nüfus durumunu ekler. `normal-map-content.seed` dünya verisini **bir kez** uygular; önceki kapsam içi harita/portal/spawn kayıtlarını `normal_world_versions.previous_content_json` içinde saklar. Sonraki açılışlar bu içerik sürümünü yeniden yazmaz; yerel nüfus değişikliği korunur. Kapsam dışı haritalar, hesaplar, oyuncular, gemiler, envanter, diroit, ArGe ve kapı koşuları sıfırlanmaz.

Normal nüfusun can/kalkan/konum ve yeniden doğma zamanı `normal_spawn_state` içinde tutulur; haritadan çıkıp dönerek Boss beklemesi atlanmaz. Solo dünyalar oyuncuya özeldir. Ayrıntılar `normal-npc-ai.md` içindedir. Kalıcı slotun öldürme talebi ve para ödülü aynı işlemde korunur.

`normal-population-2026-10-23-v3`, bütün mevcut normal profil haritalarının adetlerini aynı spawn kimliği üzerinde bir kez günceller; dünya kurulumunu yeniden çalıştırmaz. Respawn ayarı, özel davranış, oyuncu durumu ve normal NPC bekleme kayıtları korunur. Eksik anne NPC satırı eklenirse Cubikon/Battleray muhafız davranışı da ilk kurulumdaki ortak üreticiden gelir. [Güncel sayılar ve doğrulama](normal-population-current.md).

`tests/normal-world.test.js`, 32 haritanın gerçek codec ile nüfusunu, gate emiliminden ayrımı, çoğalmamayı, Cubikon/Battleray muhafızlarını, üs türlerini, kargo kapasitesini, Palladium takası/rollback ve şirket/seviye atlama denetimini çalıştırır. Harita/AI/profil/kargo/runtime dosyaları ayrıca test edilir. Gerçek HTTP/TCP testi üst haritalar, 4-5, tek yönlü korsan güzergâhı, tarafsız ticaret ve XCP takasını tamamlar. Bu testler Flash görsel oynanışının bütünü değildir.

## Kalan sınırlar

Temel Saboteur yavaşlatması/EMP temizliği, Barracuda'nın kalıcı fitili/şok dalgalı patlaması ve Annihilator'ın uçuş sonunda hasar veren Hellstorm döngüsü eklendi. Süre/oran/yarıçaplar açık yerel ayardır; Uber/gate varyantlarına varsayımla taşınmaz. [Kaynaklar, sayısal ayarlar ve doğrulama](npc-special-attacks-local.md).

Klasik dünya içeriği bütün modern NPC/etkinlik evreni değildir. Recruit/Aider, PurposeXXI, Blighted türevler ve koşullu dolaşan Deadly Battleray bu kalıcı profillere katılmamıştır. Diğer eski/modern NPC ek yetenekleri, özgün sis/engel/mayın geometrisi, bütün özgün NPC yeniden doğma sayıları ve yakalanmamış dünya koordinatları birebir doğrulanmış değildir. Sis kamuflaj bozması mevcut; alan koordinatları yereldir. Çok oyunculu ödül paylaşımı solo modelin dışındadır.
