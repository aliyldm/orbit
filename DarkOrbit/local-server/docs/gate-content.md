# Galaxy Gate savaş içeriği

`game/galaxy-gate-content.js`, ilk yerel sürümün tekrarlanan üç NPC planı yerine on kapının resmî FAQ düşmanlarını, ana dalga sırasını ve miktarlarını üretir. NPC modelleri, can/kalkan/hasar, hız ve dört para/XP ödülü `game/npc-catalog.js` üzerinden gelir. Katalog kaynak sürümleri ve yayımlanmamış hız değerleri `docs/npc-catalog-local.md` içinde açıklanır. Bu dosya dalga içeriğinin kaynağını ve henüz birebir olmayan mekanikleri ayrıca sınırlar.

## Seçilen kaynak sürümleri

Resmî FAQ'lar farklı tarihlerde yeniden dengelenmiştir. İngilizce klasik ABG listesi seçilmiştir; yeni Small Kubikon son dalgası alınmaz. Bazı Almanca/Fransızca listelerde daha az sayıda fakat güçlendirilmiş NPC vardır; bunlar klasik miktarlarla karıştırılmaz.

| Kapı | Ana dalga | Kalıcı alt faz | Toplam NPC | İçerik kaynağı |
|---|---:|---:|---:|---|
| Alpha | 10 | 40 | 446 | [Klasik Alpha FAQ](https://board-en.darkorbit.com/threads/alpha-gate-faq.784/) |
| Beta | 10 | 40 | 446 | Alpha sırası, [resmî 2x kuralı](https://board-de.darkorbit.com/threads/faq-galaxy-gates.2848/) |
| Gamma | 10 | 40 | 446 | Alpha sırası, aynı kaynaktaki 3x kuralı |
| Delta | 10 | 29 | 177 | [Delta FAQ](https://board-en.darkorbit.com/threads/delta-gate-faq.840/) |
| Epsilon | 11 | 30 | 152 | [Epsilon FAQ](https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/) |
| Zeta | 10 | 46 | 154 | [Zeta FAQ](https://board-en.darkorbit.com/threads/zeta-gate-faq.852/) |
| Kappa | 11 | 29 | 154 | [Kappa FAQ](https://board-en.darkorbit.com/threads/kappa-galaxy-gate-faq.837/) |
| Lambda | 7 | 21 | 121 | [Almanca resmî FAQ, bölüm 8](https://board-de.darkorbit.com/threads/faq-galaxy-gates.2848/) |
| Hades | 3 | 12 | 165 | Aynı kaynağın bölüm 10 listesi |
| Kuiper | 5 mantıksal harita aşaması | 54 | 222 | Aynı kaynağın bölüm 11 listesi |

Kaynaklar 20 Ekim 2026 tarihinde incelendi. Alpha listesi son dalgada 30 Protegit içerir. Beta/Gamma can, kalkan, hasar ve NPC ödülleri 2/3 katına çıkar; hız aynı kalır. Alpha'nın NPC toplamı katalogla bağımsız hesaplandığında resmî özetle eşleşir: 2.467.200 XP, 12.336 onur, 12.489.600 kredi ve 6.488 uridium.

Delta'nın dalgaya özel x2/x3/x4 çarpanları normal NPC'ye uygulanır; ayrıca Boss türü olanlara yanlışlıkla bir Boss çarpanı daha eklenmez. İşaretli büyük düşmanlar bütün ilgili eskortları yok edilene kadar ISH korumasındadır. Zeta Devourer aynı eskort bağımlılığını kullanır; finalde FAQ'daki a–f takviye sırası korunur. Kappa'nın iki ardışık üçlü Kucurbium grubu ardından sekiz Uber Saimon gelir.

Epsilon, genel LoW korsanlarıyla aynı istatistiklere sahip değildir; `epsilon-*` katalog sürümleri kullanılır. Kappa'nın Kucurbium/Boss Kucurbium/DemaNeR/Century Falcon sürümleri için `kappa-*` anahtarları kullanılır. Epsilon 8. dalgada İngilizce kaynaktaki 10 Hooligan, Kappa 9. dalgada aynı sürümdeki 5 Convict seçilmiştir; Almanca listedeki 9/6 değerleriyle harmanlanmaz.

Hades için Almanca 30 normal + 20 Boss + 4 Uber + 1 Emperor sırası üç kez kullanılır. Başka dil/sürümdeki 50 normal veya farklı Uber sayıları eklenmez. Seçilen tabloda ayrıca iki Uber Kristallon eskortu açıkça belirtilmediğinden fazladan düşman üretilmez.

Kuiper'in Almanca sürümü, bozuk İngilizce çevirinin yerine sabitlenmiştir. Her aşamanın iç sırası korunur; son aşamada önce Rocketeer grupları, sonra Emperor ve eskortları, ardından son Turret/Uber/Soldier grubu gelir. Emperor 54 alt fazın 46.'sında görünür; aşamanın başına taşınmaz.

## Kalıcılık ve ödüller

Migration `013-gate-content.sql`, `galaxy_gate_runs.plan_json/released_wave` ile `galaxy_gate_kill_claims` tablosunu ekler. Kapı kurulduğunda her NPC'nin çözülmüş istatistikleri, sayısı, fazı, eskort bağımlılığı ve tamamlama ödülü tek plan olarak saklanır. Sonraki katalog veya yapılandırma değişikliği devam eden kapıyı değiştirmez.

Henüz girilmemiş eski hazır kapılar (`wave=1`, `remaining_json=NULL`, ölüm beklemiyor) girişte gerçek plana geçirilir. Harcanmış parçalar, mevcut canlar ve para korunur; ikinci ödeme yoktur. Başlamış eski kapılar kalan eski NPC türleri, dalga sayısı ve eski tamamlama ödülüyle dondurulur. Eski kaydı kaynak planla habersizce değiştirmekten kaçınılır.

NPC öldürme ödülü, kalan slotun silinmesi ve gerekiyorsa faz/kapı tamamlanması aynı SQLite savepoint içinde yazılır. `run/phase/slot` anahtarı ödülün bir kez verilmesini sağlar. Can kaybında mevcut ana dalga yeniden başlar; daha önce ödenmiş slot yeni NPC nesnesi olsa da tekrar para, kargo, görev ilerlemesi veya drone XP üretmez. Bu, yerel yeniden oynatma korumasıdır. İlk hak edilmiş öldürmede skill/formation/booster yüzdeleri bir kez uygulanır. Combat'a normal NPC ödülü sıfır aktarılır; ikinci bir para ödemesi oluşmaz. PET XP commit sonrasında iletilir.

Kaynaklardan doğrulanmış temel tamamlama ödülleri kapıya göre farklıdır. Örneğin Alpha 20.000 uridium, 20.000 UCB-100, 4 milyon XP, 100.000 onur; Beta/Gamma bunların iki/üç katıdır. Doğrulanmış logfile, tamir kuponu ve yeşil anahtar miktarları da aynı atomik işlemle yazılır. Sonraki tamamlama ödülü denetimi LF-4/Havoc/Hercules, Kappa boosterı, Kuiper gemisi ve Kronos parçalarının teslimini eklemiştir; kaynak oranları, yayımlanmamış yerel olasılıklar ve eski koşu snapshot'larının korunması [ayrı denetimde](gate-completion-rewards-audit.md) açıklanır. Etkinlik günü ödülleri garantili klasik tabloya karıştırılmaz.

ISH kararı yaşayan ve henüz salınmamış gelecekteki eskort slotlarını birlikte denetler. Boss canlı kalırken sonraki eskort fazı açılabilir; yeniden bağlanmada boss veya koruma unutulmaz. Gerçek `0|n|ISH|id` görseli koruma sürerken yenilenir, koruma bitince istemcinin süreli efekti kendiliğinden söner. Hasar engeli görselden bağımsızdır.

## Açık kalan sınırlar

FAQ ana dalgalarının tüm alt faz zamanları ve salınma eşikleri yayımlanmamıştır. Toplam NPC ve açıkça sıralı takviyeler korunarak, istemcinin 40/29/30/46/21/12/54 sayaçlarına uygun dağıtım yapılır; eksik alt grup bölünmeleri ve varsayılan iki saniyelik geçiş yerel zamanlamadır. Genel doğma konumları ve çıkış portalı düzeni de henüz canlı sunucuyla birebir değildir.

Kuiper beş mantıksal aşamayı şu an harita 300 üzerinde oynatır. Mevcut istemci `maps-config.xml` içinde gerçek 300–304 haritaları vardır; aşamalar arasında bu ayrı haritalara geçiş henüz bağlanmamıştır. Specialist iyileştirmesi, Seeker kamikazesi, Turret'in kontrol bozması ve Emperor düşük HP takviyesi henüz özel yapay zekâ olarak uygulanmaz. Stationary Turret hızı sıfırdır.

Hades halen yerel tek oyunculu sahiplik modeli kullanır; resmî 4–8 kişilik grup başlatma/ödül paylaşma kuralı yoktur. Emperor Sibelon şamandıraları, Lordakium illüzyonları ve Kristallon polarite/bomba fazları bu sürümün standart hasar davranışına eklenmemiştir. Yayımlanmış hasar değerleri kullanılsa da bu özel mekanikler tamamlanmış sayılmaz. NPC para/XP ödülleri gerçek plan değerleridir; cevher kargo kutusu içerikleri halen ortak yerel davranıştır.

`config.galaxyGates.waveCount/npcsPerWave` yalnız açık QA azaltması olarak çalışır; üretimde bu seçenekler verilmedikçe üç NPC'lik genel plan geri dönmez. Test planlarının eski küçük tamamlama ödülü korunur.

## Doğrulama

`tests/systems-gate-content.test.js`, on kapının miktarlarını ve anahtarlarını, Beta/Gamma çarpanlarını, kaynak sürümlerini ve takviye sırasını, korunmuş bossun sonraki eskortlarını, tekrar ödül engelini, ana dalga ölüm tekrarını, SQL hata geri alımını, katalog değişikliğine dayanıklı snapshotı ve her iki eski kayıt geçişini denetler. Ek tam akış testi on kapıyı son NPC'ye kadar yürütür; kilitlenme olmadığını, bütün slot taleplerini, dört para/XP toplamını ve bir kez verilen son ödülü kontrol eder. Mevcut World/Combat ve HTTP/TCP testleri de gerçek protokolü doğrular; bunlar bütün özel boss mekaniklerinin Flash üzerinde görsel olarak tamamlandığı iddiası değildir.
