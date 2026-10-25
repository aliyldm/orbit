# Native ödüller ve günlük takvim — 23 Ekim 2026

`game/native-rewards.js`, `payment-events.js` içindeki mevcut gerçek sahiplik/ilerleme/ödeme kayıtlarına bağlanır. Native ve web aynı bilet etkinliğini, ödül seviyesini, alınmış bayrağını, görev ilerlemesini ve takas sayacını kullanır. Bilet sahibi olmayan hesaba VIP ödülü teslim edilmez. Tekrar istekleri ikinci teslim oluşturmaz. Battle Pass'ın iki anahtar takası native listeye, filtre seçimi kalıcı ayarlara bağlandı. Yerel sezonun altı görevi ve ödül seviyeleri **yerel uyarlamadır**; özgün etkinlik görevleri olduğu iddia edilmez.

BattlePassInfo'nun istediği `pass_local.xml` gerçek asset manifestine kaydedildi. Altı görev başlığı Türkçe kaynak dosyasında bulunur. Aksi halde yalnız paket göndermek pencerenin yüklenmesini tamamlamaz. Tamamlanmış günlük/sezon görevleri her sonraki NPC imhasında tekrar tamamlandı bildirimi üretmez. `TrinityTrialsMainProxy` özgün istemcide her ödül tıklamasını seviye0 gönderiyordu; derlenmiş MAIN artık tıklanan seviyeyi gönderir.

Trinity/Voyagers **ödül yolları** bağlıdır. Özgün etkinlik haritaları, Trinity drop-level geliştirmesi, günlük etkinlik giriş hakları ve haritaya özel hasar henüz yoktur. Bu istekler ücret kesmez ve açıklama döndürür. Klasik kapı bitirerek ilerleme önceki yerel uyarlama olarak korunur; gerçek modern etkinlik oynanışı diye sunulmaz. Monthly Deluxe'in doğrulanmamış paket bileşeni hâlâ kapalıdır.

Günlük giriş takvimi `web/stubs/dailyLogin.json` içindeki kaynak ödül havuzunu kullanır; eski hesabın booked/premium bayrakları kullanılmaz. `028-native-rewards.sql` oyuncu+dönem ve ay+ödül günü için tekil teslim kaydı tutar. Ayda25 ödül; kaçırılan gün dizi ilerlemesini sıfırlamaz; premium ekleri gerçek premium durumuna bağlıdır. Aynı ay için bu kaynak havuzu sabittir; bütün güncel aylık kampanyaların özgün takvimi değildir.

`/flashAPI/dailyLogin.php` oturum gerektirir. Salt GET ödül vermez. Gerçek istemcinin `LoginBonusBookCommand` kodundaki POST `?doBook=1` bir kez teslim eder; Flash `Loader` görsel beklediği için başarı cevabı geçerli1×1 GIF'tir. Böylece JSON'u resim sanıp yükleme hatası üretmez. Native günlük bilgi/al istekleri aynı kaydı kullanır. Günlük/haftalık reset05:30 Türkiye saati; teslim ve sahiplik SQL işlemi içinde geri alınabilir.

Testler: `tests/native-rewards.test.js`, `tests/multi-launcher-client.test.js`, gerçek HTTP/TCP `tools/test-network-second-completion.js`. Tam dağıtım kaydı `second-completion-work.md`. Native pencerenin gerçek Flash render kontrolü yapılmadı.
