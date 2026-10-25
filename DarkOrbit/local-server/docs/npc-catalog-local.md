# Kapı NPC kataloğu ve kaynak seçimi

`game/npc-catalog.js` grafik kimliğinden can/hasar türetmez. Kapı planı, adlandırılmış NPC tanımını bütün sayısal değerleriyle `plan_json` içine kaydeder. Yeni katalog mevcut koşunun dengesini değiştirmez. Normal haritadaki mevcut üç NPC ayarı ve spawn sayıları seed tarafından değiştirilmez. Aynı görsel kimliğinin Kappa ve grup/invasion sürümleri ayrı anahtarlardır; SQLite `npc_types` tek satırı kapı tanımının kaynağı değildir.

## Sayısal kaynaklar

- Normal/Boss/Uber HP, kalkan, hasar aralıkları: [Almanca resmî NPC tablosu](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/) ve [ikinci sayfası](https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2). Normal/Boss hızları [İngilizce normal NPC FAQ](https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/) ve [Boss FAQ](https://board-en.darkorbit.com/threads/boss-alien-faq.801/) ile tamamlanır.
- Alpha/Beta/Gamma için HP, kalkan, hasar ve NPC ödülü sırasıyla ×1/×2/×3 olur; hız çarpılmaz. Kapı NPC kalkanının %50 emilimi, Board Admin açıklamasında normal haritadaki %80/%20 dağılımından ayrılır: [Schadensverteilung von NPCs](https://board-de.darkorbit.com/threads/schadensverteilung-von-npcs.107632/). Bu oran SAB/SAR gibi yalnız kalkan emen mühimmatın sözleşmesini değiştirmez.
- Zeta'nın dört özel NPC'si için [İngilizce Zeta FAQ](https://board-en.darkorbit.com/threads/zeta-gate-faq.852/) seçilmiştir. Scorcher 15.000 EP/8 şeref, Melter 55.000 EP bu sürümün değerleridir; Almanca 16.000/9 ve 60.000 ile karıştırılmaz.
- Epsilon'un yedi korsanı [İngilizce Epsilon FAQ](https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/) sürümünden `epsilon-*` anahtarlarıyla ayrılır: Vagrant 60.000/40.000, son Convict 450.000/300.000 HP/kalkandır. Bu FAQ hız belirtmez; 300 yerel hız olarak işaretlidir. Kappa FAQ bireysel korsan sayıları vermez; Epsilon değerleri Kappa'ya kendiliğinden taşınmaz. Kappa'nın genel korsanları Almanca tablodaki sürümde kalır.
- Hades imparatorları, Kuiper ve açık `kappa-*` varyantları: [İspanyolca resmî NPC FAQ](https://board-es.darkorbit.com/threads/faqs-aliens.135697/). Kappa Boss Kucurbium 640.000 HP/480.000 kalkan; Century Falcon 800.000/600.000 olarak ayrılır. Kappa Kucurbium 320.000/1.200.000 ve DemaNeR 512.000/256.000 aynı kaynak sürümünden alınır. Almanca Kucurbium 1.600.000 HP ve genel DemaNeR 400.000/300.000 farklı sürüm değerleridir; bu anahtarların kapıda yanlışlıkla kullanılmaması gerekir.

## Kaynak uyuşmazlıkları ve sınırlar

- Üst harita StreuneR ve Uber StreuneR ödülleri İngilizce normal/Uber FAQ sürümünde tutulur (3.200 EP/16 şeref/6.400 kredi/8 U. ve bunun ×8'i); Almanca tabloda 6.000/30/12.000/15 vardır. Hasar aralıkları Almanca tablodandır. Uber Streuner ödülü 8 U. olarak Almanca kaynak seçilir; İngilizce Uber tablosundaki 4 U. ile uyuşmazlık açıktır.
- Uber Devolarium ve Uber Kristallin şerefi 256'dır. Almanca iki satırdaki 246, İngilizce Uber tablosu ve normal NPC'nin ×8 ödülü ile uyuşmaz; burada İngilizce 256 tercih edilir.
- `localSpeed:true` işaretli düşmanlarda güvenilir sayısal hız bulunmadı; 300 yerel hareket politikasıdır, orijinal hız iddiası değildir. Kappa'nın dört özel varyantı, normal/Boss tabloları, Icy 475 ve sabit Kuiper taretinin 0 hızı bu işareti taşımaz.
- Hades'in 35.000/45.000 hasarı kaynakta **yaklaşık** olarak verilmiştir. Emperor Kristallon'ın özel 300.000 saldırısının zamanlaması, Seeker sayısal değerleri ve Kuiper yön bozma/füze üretme davranışının tam algoritması geri kazanılmadı. Bunlara uydurma zamanlayıcı veya hasar sayısı eklenmedi. Rocketeer 200 füze hasarı kaynak tablosundandır; tam Seeker alt varlığı modellenmez.
- Aralık içi hasar sunucuda rastgele seçilir. Bu kaynaklar her NPC'nin dağılım fonksiyonunu ve atış zamanlamasını ispatlamaz; mevcut bir saniyelik combat tick'i korunur. Dalga çıkarma düzeninin kaynakla doğrulanan ve yerel kalan bölümleri `docs/gate-content.md` içinde ayrılır.

## Tekrarlanabilir kanıt

Normal dünya güncellemesinde Cubikon80 (1.600.000 HP/1.200.000 kalkan, sıfır hasar, hız30) ve Battleray115/Uber korsan türleri254–258 eklendi. Battleray ve Uber korsanların sayısal sürümü Almanca ikinci sayfaya sabitlenmiştir; Uber Barracuda'nın 1.400.000 HP ve Uber Annihilator'ın 100.000 kredi değerleri başka dildeki 1.440.000/1.000.000 ile uyuşmaz, burada sessizce harmanlanmaz. Normal dünya üyeliği ve kaynak sınırlamaları `normal-map-spawns.md`, genel entegrasyon `normal-world-local.md` içindedir. Normal dünyadaki Interceptor hedef hızı−20, Barracuda430 ve Annihilator350 uyarlamaları normal tanım katmanındadır; eski gate sürümü değiştirilmez.

`tools/fetch-gate-sources.js` herkese açık, oturumsuz FAQ sayfalarını `decompiled/gate-source-evidence/` içine HTML, okunabilir metin ve URL/tarih/SHA-256 metadatasıyla kaydeder. Sayfalar güncellenebilir; çalışma sayıları bu kayıt sürümüne dayanır. Zeta görsel kimlikleri ayrıca `InGameCatalog.as` ve istemci `game.xml` eşleştirmesiyle test edilir; modül enum'u gemi tipi sanılmaz.

Katalog testleri sayısal varyantları, çarpanları, gerçek istemci görsellerini, kopyaların bağımsızlığını ve normal harita seed verilerinin korunmasını denetler. Flash üzerinde görsel uçtan uca doğrulama ayrıca yapılmalıdır.
