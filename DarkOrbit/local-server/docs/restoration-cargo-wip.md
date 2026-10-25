# 24 Ekim — aktif çalışma, henüz dağıtılmadı

**25 Ekim güncellemesi: Aşağıdaki WIP artık tarihsel. Paket dağıtıldı, PID24464/healthOK. [Son durum](restoration-cargo-current.md) ve logs/restoration-production-check.json kullanılmalı. 1011test/23838ağ komutu PASS. MAIN47a0… kuruldu;67lazer/4iş iadesi YAPILDI, tekrar uygulama. Cubikon yalnızXenomit nedeni397000Seprom ile dolu ambar;45normalNPC gerçekölüm/toplama doğrulandı, beşKuiper/23çarpan hâlâ belirsiz.**

Üretimde son bilinen PID24352, HTTP8095/TCP8096. Önceki Momentum sürümü. Bu not en yeni kapsamı belirtir; eski LF4 tavanı notları GEÇERSİZDİR.

Kullanıcının biriken istekleri: bütün lazerleri geri aç ve seçici arşivden sahip olunan 67 lazer/4 ücretli geliştirme işini geri getir; günlük giriş BAŞLA; normal ekipman tekrar üretimi; diroit XP metadata kaynaklı −1% upgrade; diroit tasarımını çıkarma; normal lazer sesi 1s ve görsel alt salvo220ms (RSB aynı); maden ticareti istasyonunu etkinleştir; bütün NPC ölüm kargolarını özgün kaynakla denetle/düzelt.

Kaynak değişiklikleri mevcut, henüz tüm paket test edilmedi/dağıtılmadı. MAIN kurulu d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824. Derlenen zincir repeatable-equipment → laser-rhythm, son aday47a0a55587987d5918ccb41e3e8fa9f3da2c13a8514b01e1e5be0f296894e585. Deliller decompiled altındaki evidence.json dosyalarında; medya tagları aynı. Henüz kurma/hesap iadesi yapıldı diye sunma.

Geri yükleme game/restore-lasers.js seçici/idempotent, henüz çalıştırılmadı. Makbuz logs/retired-lasers-removal.json ve özgün 10-17-46-378Z yedeğini kullanır. Yeni graceful save+SQLite backup zorunlu; bütün DB geri alınmaz. Cüzdan/başka ilerleme korunur. Test et, durdur, taze yedek al, seçici iade, yeniden başlat ve delta doğrula.

NPC kargoları: önceki103/108 kaydı kontrol yeterli sayma. Ölümde kullanılan gerçek def ve kutu/ambar hattını incele. Beş Kuiper ve23 çarpanlı kapı varyantı eski raporda belirsiz. Kaynaksız sayılar uydurma. Normal45 satır cached resmi DE rehberinden; native oreID eşlemesi de denetlenmeli.

5-x labirenti kapalı kalır. Module/Convert ekonomisi korunur. Çok oyunculu/.NET başlamaz. Native Qt girdisi verilmez; kullanıcı önceki otomasyonu Escape ile durdurdu. Görev kataloğu en sona. Bu pakette hediye taleplerini tekrar uygulama.
