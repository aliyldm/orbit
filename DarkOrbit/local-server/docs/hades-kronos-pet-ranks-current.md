# Hades, Kronos, P.E.T. ve NPC puanları — etkin çalışma

**Sonraki kullanıcı tercihi:** "hepsi orijinalle aynı olsun" ile Hades solo istisnası kaldırıldı. Aşağıdaki yanıtsız giriş sorusu artık tarihsel. [Orijinal mekaniklere geçiş güncel raporu](original-rules-current.md) üstündür; P.E.T. seviye20/bonus/TP/kademe4/tabanHP işleri de o raporda.

23 Ekim 2026. Kullanıcının son isteği Hades ve Kronos'un açılış/kapı içeriğini orijinale göre düzeltmek, P.E.T. modüllerini ve NPC rütbe puanlarını tamamlamak. Önceki "Hades'e dokunma" kapsamı bu istekle kaldırıldı. Çok oyunculu sisteme geçmeme kararı sürüyor. Stabilize, hiper ocak ve kapalı yedi CPU kapsam dışı.

Hades'in orijinal 4–8 oyunculu grup şartı solo sunucu tercihiyle çakışıyor. Kullanıcıya orijinal giriş engeli / geçici solo istisnası seçenekleri soruldu; henüz açık yanıt yok. İçerik çalışması bağımsız sürer, grup sistemi eklenmez.

Başlangıç: PID4496, 858 test, 310 JS. Son dağıtım: **PID20352**, solo HTTP8095/TCP8096. Gerçek Qt/Flash ekran girdisi için kullanıcıdan yeni açık izin gerekli; kaynak ve ağ doğrulaması görsel doğrulama değildir.

Kaynaklar:
- https://board-en.darkorbit.com/threads/hades-gate-faq.971/
- https://board-en.darkorbit.com/threads/kronos-gate-faq.838/
- https://board-fr.darkorbit.com/threads/guide-hades-fonctionnement-general.137511/
- https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/
- https://board-es.darkorbit.com/threads/faqs-aliens.135697/
- https://board-de.darkorbit.com/threads/faq-p-e-t-und-ausruestung.118714/
- https://board-en.darkorbit.com/threads/p-e-t-expansion-faq.126477/
- https://board-en.darkorbit.com/threads/p-e-t-expansion-overheat-faq.128144/

Kaynak ayrımı: FR "rehber" forum kullanıcısına ait, resmî FAQ değil. Birincil DE Galaxy Gates FAQ (2848) Hades için 30 normal / 20 Boss / 4 Uber / 1 Emperor yayımlıyor. Bu nedenle mevcut 165 NPC / 12 alt dalga korunacak; 50'ye çıkarılmayacak. Kronos 21 parça, 13 ana dalga / 50 alt dalga / 377 NPC mevcut; baştan yazmak yerine doğrula. P.E.T. 4–12 klasik modlar çalışıyor; modern 14–20 tüketicileri eksik. Retargeting ve Mega Mine PvP hedeflidir: NPC'ye sahte etkiler eklenmeyecek. NPC rütbe tablosunda modern kapı NPC'leri eksik; yayımlanmamış sayılar uydurulmayacak.

NPC doğrulaması: resmî DE NPC FAQ Convict ve Ravager için 32 ham puan yayımlıyor (önceki 16/0 yanlış). Kronos için moderatörün 121147/#4 yanıtı öldürme puanı olmadığını açıkça belirtiyor; TP ve şeref katkısı ayrıca işler. Hades Emperor / Kuiper / Uber korsanların ham puanları bu kaynaklarda yayımlanmamış; sıfır olduğu iddia edilmeyecek.

## Yapılanlar

- `game/hades-bosses.js`: Sibelon kalkanı bitince yerel destek noktalarına kaçar; native BuffCapsule ve EmperorSibelonBuffRing paketleriyle hasar/kalkan/HP desteği. Lordakium belirli gövde kaybında veya sınırda ışınlanır, iki 1HP aldatıcı kopya bırakır; kopyalar yaşarken onarım yapar. Kopyalar para, rütbe, diroit puanı, görev ve kapı ilerlemesi üretmez. Kristallon native kutupluluk işaretini ve kaçılabilir 300.000 hasarlı bombayı kullanır. Map kapanışı / boss ölümü destekleri ve bombaları temizler.
- `respawn.js`: native `RAID_GATE_REPAIR=7`; Hades'te kalan can varsa ölümden itibaren 30 saniyede ücretsiz kapıya dönüş. Sonrasında X-1 ücretsiz dönüş. Can ölümde bir kez düşer; seçim/tekrar paketinde ikinci kez düşmez. Sunucu süre/harita/sahiplik kontrolü yapar. Bu solo sunucuda ölüm mevcut ana dalgayı yeniden başlatır; grup instance davranışı değildir.
- `pet-link.js`: gerçek G-HPL1. 20 saniye gövde hasarını P.E.T. karşılar; geminin kalkanına gelen hasar normal çözülür, aktarım P.E.T. gövdesinden düşer. Koruma modu %25 ek hasar, %35 ek yakıt. Süre sonu / mod değiştirme / P.E.T. ölümü / docking / jump / çıkış bağlantıyı bitirir, 240 saniyelik DB bekleme süresini korur. Native 2D/3D HP Link efekti86 ve cooldown9 kullanılır. P.E.T. ölürse kapasitesini aşan hasar gemiye döner (açık yerel taşma politikası); NanoHull aktarılmayan hasarı karşılar.
- G-HPL1 P.E.T. modül mağazasında orijinal widget/ikon ile 1.000.000 U. (önceki yerel kampanya fiyat politikası). Satın alma, sahiplik, sürükleyip takma ve native mod16 seçimi test edildi. Orijinal ikon CDN'den önbelleğe alındı; ekran dışı bağlantı butonu eklenmedi.
- Convict/Ravager ham puanları32; 28 Kronos tipi bilinen0. Gerçek DB'de düzeltilmesi gereken eski Convict/Ravager/Kronos defter satırı bulunmadı; geçmişe tahmini puan verilmedi.
- `tools/audit-npc-ranks.js` salt katalog denetimi: `docs/npc-rank-audit.json` **108 tanım / 95 bilinen / 13 doğrulanmamış**. Kaynak kanıtları `docs/evidence/{npc-de-1,npc-de-2,npc-es,gg-de,kronos-rank,pet-de,pet-heat,pet-overheat,gg-new-rewards}.txt`.

## Doğrulama

**869/869 test**, gerçek HTTP/TCP **22.050 komut** PASS. `logs/hades-pet-tests.log`, `logs/hades-pet-targeted.log`, `logs/hades-pet-network.log`. Yeni testler: kalkan/gövde ayrımı, P.E.T. ölümü/hasar taşması, süre sınırı, docking/cooldown kalıcılığı, DB hata geri alma, native mağaza satın alma/takma, Hades kopyalarının sıfır yan etkisi, bomba uyarısı/kaçış/temizlik ve30s yeniden doğma/can tekrarına direnç.

Son kaynak denetimi: **316 JavaScript / 0 sözdizimi hatası**. Dağıtım sonrası `/health`:ok,solo,8096. Read-only SQLite karşılaştırması: yedekteki **60 tablonun tüm satırları kaynak DB ile aynen eşit**, farklı tablo yok; integrityOK/FK0. asd18/657.309.320TP/50.000.005.110U., test21/10milyarTP/1milyarşeref/maske127 korundu. Bu ağ/DB doğrulaması Qt görsel doğrulaması değildir.

3 hesap / 3 oyuncu / 13 gemi ve46sahiplik/ilerleme tablosunun tüm satırları kopya DB'de korundu. Yedek `backups/darkorbit-before-2026-10-23T15-46-00-226Z.db`; migration kopyası aynı damga. Source DB'de hesap, para, envanter veya kapı geçmişi düzenlenmedi. Hediye makbuzları tekrar çalıştırılmadı. MAIN/launcher/cache sürümü değişmedi. Sunucu kayıt alarak durdurulup PID20352 ile açıldı; `logs/hades-pet-server-{console,error}.log`.

## Açık işler — tamamlandı diye sunma

1. **Hades giriş kararı yanıtsız:** Orijinal4–8grup şartı mı, mevcut geçici solo giriş mi? Mevcut solo giriş değiştirilmedi. Grup/klan/PvP eklenmedi. Merkezde tüm grubun toplanması, ortak instance, NPC ödül bölüşümü ve çok oyunculu kutupluluk etkileşimi yok. Yalnız artı işaretinin gösterilmesi kutupluluk savaşını tamamlamaz.
2. **Hades birebir zamanlama/konum kanıtı yok.** Boss davranış türleri resmî FAQ'ya dayanır, fakat hız, eşikler, destek %'leri, noktalar, iyileşme hızı, bomba3s/500yarıçap/15s aralık yerel ayarlanabilir varsayımlardır (`hadesBosses` config). Sibelon kapsülleri etrafındaki mayınlar henüz yok. Bunlara orijinalle birebir denmeyecek. Yalnız Kristallon300k bomba hasarı ES tablosunda yayımlanır. Hades LF4 %25 ve Kronos Saturn %10 ihtimalleri önceden var olan, yayımlanmamış yerel oranlardır.
3. **Kronos:** mevcut21parça /13ana dalga /50alt dalga /377NPC, tüm28HP/kalkan/hasar/ödül tablosu, Evil görünümü ve checkpoint testleri tekrar geçti. DE FAQ klasik son ödülü mevcut500UBR/5000RSB dahil doğruluyor. Güncel EN yeni ödüller FAQ'sı farklı malzemeler de listeliyor; sürüm farkı çözülmeden tablolar gelişigüzel birleştirilmedi. Özgün spawn koordinatları/alt grup gecikmeleri ve Evil hızları kanıtlı değil.
4. **P.E.T. henüz tümü tamamlanmadı:**16katalog gear türünden10'u destekli (9klasik +HP Link). G-FS1/Combat Beacon/HP Beacon grup veya klan hedefli, G-RT1 düşman P.E.T. hedefli, G-MM1 oyuncu hedefli. Solo NPC'ye sahte etki verilmedi, satın alma/kullanım kapalı kalır. G-HR1 ve AI-AH1 için kalıcı HEAT ve özgün ısı üretim/eşik/soğutma sayıları eksik. P.E.T. seviye16–20, seviye bonusları/HP yükseltmesi, HEAT yuvaları ve3X ısı ölçekleri ayrıca yapılmalı. Modül tamamlama isteği bu nedenle açık.
5. **13 NPC ham puanı doğrulanmadı:** Uber Interceptor/Barracuda/Annihilator/Saboteur/Battleray, üç Hades Emperor, Soldier/Specialist/Turret/Emperor/Rocketeer Streuner. `known=0` sıfır ödül doğrulaması değildir. Bunların TP/şerefleri zaten rütbe formülüne katılır; ikinci kez türetilerek eklenmeyecek.
6. Native Qt/Flash görsel kontrolü yapılmadı. Açık kullanıcı izni olmadan UI girdisi verme. Stabilize/hiper ocak/yedi kapalı CPU kapsam dışı.
