# Lazer sesi ve animasyon ritmi — 23 Ekim 2026 yeniden denetim

**Sonraki kullanıcı tercihi uygulandı:** normal lazer sesi2s ile sınırlandı; RSB ve hasar/cephane/görsel ritim korunur. [Yeni ses yaması ve dağıtım](audio-escorts-upgrade-current.md). Aşağıdaki “değiştirilmedi” ifadeleri bu eski denetimin tarihsel sonucudur; güncel MAINd7322098… artık ses kapısı içerir.

Kullanıcı normal lazerleri/seslerini hızlı, RSB'yi uygun buldu ve özgünlüğünü sordu. Bu incelemede çalışma kodu, SWF, hasar, cephane, DB veya çalışan sunucu değiştirilmedi.

Sunucunun normal lazer turu en az 1000ms, RSB beklemesi 3000ms. Aynı turda tekrar saldırı isteği veya ana timer fazladan AttackLaserRunCommand üretmez. `node --test tests/laser-cadence.test.js` yeniden 4/4 geçti (`logs/laser-cadence-recheck.log`). Normal LF4 için [resmî FAQ](https://board-en.darkorbit.com/threads/permafrost-fissure-faq.117725/) 1 saniye bekleme bildirir. Bu sayı saniyede yalnız bir ses/ışın olacağı anlamına gelmez.

Kurulu MAIN ve önbellekteki host MAIN, JPEXS ile ayrı ayrı yeniden decompile edildi. LaserEmissionSchedule, LaserSalvo2D ve LaserSalvo3D sınıflarının üçü de iki kopyada tamamen aynı kaynak hash'ine sahip. Kanıt: `decompiled/laser-cadence-audit/evidence.json`; exportlar aynı klasörde `current/` ve `host/`. Kurulu MAIN e672b127…, host önbelleği1170d6ae….

İstemci LaserEmissionSchedule her ağ turunda geminin bütün namlu gruplarını kullanır; grupların gecikmesi sıra×200ms. Örneğin dört gruplu desen 0/200/400/600ms, iki gruplu desen0/200ms. 3D LaserSalvo3D.shotSalvo her grupta ses çalar. 2D normal yolunda ses startAttack'ta bir kere çalar. İki namlulu tek grupta ses iki kez çağrılmaz. Böylece hasar ve ağ paketi saniyede bir olsa bile 3D sesi daha sık gelir. RSB'de aynı görsel grup mantığı üç saniyelik ağ turuyla tetiklenir; daha seyrek algılanması bununla uyumludur.

Bu, önbellekteki istemci kodunun korunduğunu gösterir. Önbellek kaydının özgünlük zincirini veya canlı sunucunun bütün cephaneler için paket zamanlamasını kanıtlamaz. Gerçek Qt ekranı/ses kaydı alınmadı. Önceki “1 saniye özgün” ifadesi hasar/atış turuyla sınırlıdır; bütün görsel/ses deneyimine genişletilmemelidir. Kullanıcı daha seyrek bir ritim isterse RSB'yi koruyan görsel/ses düzenlemesi ayrı uygulanabilir; kanıtsız bir değeri özgün diye sunmayın, sırf sesi azaltmak için DPS'yi düşürmeyin.

Ana durum değişmedi: [görünmezlik/CPU son dağıtımı](cloak-cpu-current.md),850 test, PID22308/solo8095–8096. Bu tur yalnız analiz dosyaları ve4testlik yeniden doğrulama eklendi.
