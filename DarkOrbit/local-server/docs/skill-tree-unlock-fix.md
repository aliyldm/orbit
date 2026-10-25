# ArGe dallarının açılması — 21 Ekim 2026

Kullanıcının ekranında 22/50 puan dağıtılmış, 28 puan boş ve Skylab Seprom 0 idi. Önceki web görünümü `prerequisites && available && credits && seprom` sonucunu hem satın alma hem dalın görsel kilidi için kullanıyordu. Kullanıcının sonraki açık talebiyle **ArGe Seprom gereksinimi kaldırıldı; Skylab kullanılmaz**.

Dal açılması artık yalnızca gönderilmiş profil kaydından çıkarılan `game/skill-tree-data.json` önkoşullarına bağlıdır. Öğrenilmiş/açık/azami düğümler kendi görsel durumlarını kullanır. Puan ve dal koşulu yeterliyse düğüm tıklanabilir; satın alma gerçek kredi ve boş puan kontrolünden geçer. Seprom maliyeti sıfırdır; ArGe görüntüleme/geliştirme Skylab üretimini de başlatmaz. Tooltip mevcut dallardaki seviyeleri ve eksik kredi/koşulu gösterir; alt satırda boş puan ve Seprom gerekmediği yazılır.

Örnek: Kelle Avcısı I için Kalkan Enerjisi ve Isı Arayıcısı üzerinde toplam en az 2 puan gerekir. Kelle Avcısı II, Ayarcı/Bağlayıcı Işın II üzerinde toplam 3 puan **ve** Kelle Avcısı I 2/2 ister. Bir dalın açılması toplam 22 veya 23 puan harcanmasına bağlanmaz; ilgili önkoşullar gerekir. Kalın lazer için Kelle Avcısı I 2/2 ve II 3/3 korunur.

Mevcut hesapların ArGe seviyeleri sıfırlanmaz, ödül veya Seprom eklenmez. `tests/skills.test.js` bütün 25 tanımın AND/toplam/her birinde kurallarını, sıfır Seprom ile geliştirmeyi ve Skylab çağrılmadığını sınar.
