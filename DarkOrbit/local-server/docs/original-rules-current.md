# Orijinal mekaniklere geçiş — 23 Ekim 2026

Kullanıcı: "hepsi orijinalle aynı olsun". Aktif kapsam Hades/Kronos, P.E.T. ve NPC puanları. Bu istek eski Hades solo istisnasını kaldırır. Çok oyunculu altyapıya geçmeme kararı sürer. Önceden açıkça istenen ekonomi özelleştirmeleri (1mU.kampanya, Upgrade/Convert modülleri, vb.) iptal edilmedi; mekaniklerin orijinali ile karıştırılmayacak.

## Bu pakette değişenler

- Hades girişinde orijinal4–8kişilik grup şartı uygulanır. Bu solo runtime'da gerçek grup/ortak instance hizmeti olmadığı için Hades'e giriş kapalıdır. Gate inşa edilebilir; sahip olmak tek başına giriş yetkisi vermez. Sahte istemci grup sayısı veya config bayrağı kabul edilmez. Portaldan atlama engeli açıklama gönderir; native portal durumu da kapalıdır. Kaydedilmiş203haritasındaki oyuncu hiçbir ek can kaybetmeden X-1'e taşınır. Parçalar, hazır kapı ve geçmiş ilerleme silinmez.
- P.E.T. 15yerine20seviyeye ilerler. TP eşikleri mutlak birikimdir:15=27m,16=39m,17=50m,18=70m,19=100m,20=150m. Seviye1→2eşiği64.000; önceki8.000eşiği bir satır kaymıştı. Eski sahiplerin seviye/TP'si geriye çekilmedi; bundan sonraki ödüllerde doğru sonraki eşik kullanılır.
- Aktif P.E.T. sahibinin TP'sinin tam%5'ini (varsa mevcut P.E.T.TP desteğiyle) kazanır; küçük her ödülde zorla en az1P.E.T.TP üretilmez. Kesirler korunur. Seviye20üstüne geçmez; native seviye/TP/status komutları gerçek kayıtla eşleşir. Portal metadata21satırla seviyeyi20'ye kadar kapsar.
- Seviye kaynaklı pasif lazer/kalkan bonusları gerçek P.E.T. ekipman hasarına/kalkanına bağlandı.16:hasar%14,17:kalkan%16,18:hasar%16,19:kalkan%18;20'de bu değerler korunur ve kademe4erişimi açılır. Bunlar aynı bonusun her geçmiş seviye için yeniden toplanması değildir. Protokol/seviye çarpanlarının birleşim sırası hâlâ bağımsız orijinal sunucu ölçümüyle kanıtlanmış değil.
- On klasik protokolün kademe4değerleri retainedItemDataProvider'dan gelir. P.E.T.20şartı, gerçek satın alma, `pet_level=4` kaydı, ekipmana takma ve gerçek etki çalışır. Native YZ Protokolleri sayfasında dördüncü satır artık boş değildir. Özel satış fiyatı, kullanıcının önceki yerel talebi uyarınca1.000.000U.; bu fiyat orijinal ödeme fiyatı diye sunulmaz. Seçili4.kademe, mevcut kampanya gibi sabit fiyat kullanır; diğer kademelerin fiyatları korunur.
- Yeni P.E.T. taban canı50.000. Eski10.000+seviye×2.000otomatik model kaldırıldı. HP kapasitesi, XP'den ayrı `hp_upgrade_level` ile50.000+10.000×satınalınankademe şeklinde tutulur. Eski P.E.T.'lerin mevcut canı artırılmaz/doldurulmaz. HP kapasitesi satın alma UI/akışı bu pakette **yok**; kolon eklenmesi bu işlev tamamlandı demek değildir.
- Migration030yalnızseviye0–20sınırını genişletir, iki ekipman konfigürasyonunu ve bütün modül cooldownlarını korur.031HPkapasitesi kolonunu varsayılan0ekler.030birkez ilk testturusırasında gerçekDB'ye de uygulanmıştı; daha sonra uygulanmış dosya değiştirilmeyip HPkolonu ayrı031'e alındı. Node test işçilerinde örtük `db.open()` artık bellek DB'sine gider; gerçek hesap DB'sini açma/migrate etme yoluna karşı regresyon testi var. Bu sıra dışı şema uygulaması kullanıcı kayıtlarının değiştiği anlamına gelmez; dağıtımda eski bütün kolon/satırlar ayrıca karşılaştırılacak.

## Kaynaklar ve kanıt

- https://board-en.darkorbit.com/threads/hades-gate-faq.971/
- https://board-en.darkorbit.com/threads/p-e-t-level-up-table.1226/
- https://board-en.darkorbit.com/threads/p-e-t-level-update.120879/
- https://board-de.darkorbit.com/threads/faq-p-e-t-und-ausruestung.118714/
- https://board-en.darkorbit.com/threads/pet-10-faq.1228/
- `docs/evidence/pet-levels.txt`, `pet-level-update.txt`, `pet-de.txt`; `game/pet-catalog.js` kaynak SHA'sı ve mevcut decompile kaynak karşılaştırma testi.
- Önceki REA notları (`notlar/REA_ANALIZI.md`) launcher/Flash çalıştırıcısının analizidir. Kapalı orijinal sunucunun HEAT/ödül/RNG kodunu içermez. SWF metadata/paket/render kuralları için mevcut JPEXS decompile ağacı kullanıldı; bu pakette yeni SWF/EXE değişikliği yok.

## Açık kalanlar — birebir tamamlandı demeyin

Hades grup instance/ortak ödül/kutupluluk, yayımlanmayan boss konum/süreleri, HEAT üretim/eşik/değerleri ve HeatRelease; beş grup/PvP P.E.T.gearı; HP ve yuva satın alma/gerçek kilitler, başlangıç yakıt hediyesi, tamir sonrası özgün can oranı, bazı hız/deflection/bonus sırası formülleri, orijinal3Xısı ölçekleri,13özelNPC'nin hamrütbepuanı ve yayımlanmayan GGdüşmeoranları hâlâ açık. Bu veri olmadan orijinalle%100eşitlik garanti edilemez. Kaynakta olmayan sayıya orijinal etiketi verilmeyecek.

Stabilize/hiperocak/yedi kapalıCPU kapsam dışında. Çok oyunculu sistem ekleme. Gerçek Qt/Flash UI girdisi için yeni açık kullanıcı izni gerekli; bu pakette UI girdisi verilmedi.

## Doğrulama / dağıtım

878/878test;318JS/0sözdizimi hatası. `logs/original-rules-tests.log`. Yeni regresyonlar:7P.E.T./Hades kuralı +tabanHP +testDByalıtımı; mevcutXP/kalkan/HPtestlerinin eski yanlış beklentileri resmî tablolara göre güncellendi. KopyaDBkontrolü3hesap/3oyuncu/13gemi/46ilerlemetablosunu tüm eski kolonlarıyla koruyor. Son kontrol yedeği `backups/darkorbit-before-2026-10-23T16-17-58-843Z.db`. GerçekHTTP/TCPsonucu ve yeniPID aşağıya eklenecek.

**Dağıtıldı: PID6676**, solo8095/8096; `/health`ok. GerçekHTTP/TCP **22.086komut PASS** (`logs/original-rules-network.log`); ek akış P.E.T.20nativeLevelUpdate, sahibine ekTPüretmeme, gerçekkademe4HTTPsatınalma/FlashAPItakma ve nativeportal4.kademe satırını doğrular. Launcher/MAIN/cache değişmedi; Qt görsel kontrolü yok.

`logs/original-rules-production-check.json`:030öncesi16-05-47-644Zyedekle60tablonun eski kolonları karşılaştırıldı. **59tablo tüm satırlarıyla birebir aynı**; yalnız `schema_migrations` iki yeni030/031kaydını içeriyor. `pets.hp_upgrade_level` yeni0kolonu dışında eski P.E.T.alanları da aynı (ikiPET:seviye2,TP21255,can2806,yakıt99754). Cüzdan/hesap/gemi/envanter/kapiilerlemesi değişmedi; integrityOK/FK0. Geçmiş hediyeler/adminmakbuzları tekrar çalıştırılmadı.
