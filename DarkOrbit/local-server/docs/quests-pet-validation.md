# Görev / PET doğrulaması — 20 Ekim 2026

- `logs/quests-pet-suite.log`: **440/440 test**, hata/atlanan test yok.
- `tools/check-source.js`: **176 JS**, sıfır sözdizimi hatası. Son bulucu ilk-tıklama düzeltmesi ve testi ayrıca kontrol edildi; ardından 440 test tekrar geçti.
- `logs/quests-pet-network.log`: ayrı bellek DB'si/portlarda gerçek HTTP/TCP, **12320 çözümlenmiş komut**. PET'in kilitli kademe reddi, doğru fiyatla modül/protokol satın alımı, Flash hangar API'siyle PET'e takma ve native mod seçimi geçti. Görev20005 gerçek soketten kabul edildi, üç gerçek toplama isteği işlendi, görev merkezinde tekil ödül/claim oluştu;20006 kabul edildi. Önceki kapı/kutu/savaş/oturum kontrolleri de geçti.
- `tests/pet-runtime-expanded.test.js`:15 test. Kalıcı cooldown/yakıt kesri; saldırı/koruma; gerçek mantıksal bulucu kimliği ve ilk native tıklamanın0 parametresi; ticaret bonusu/yokluk ve SQL rollback; CSR yakıt/süre/iptal; kamikaze gecikmesi/korunmuş hedef/harita; PET görev XP'si; iki konfigürasyon ve dolu eski PET migration019 korunması.
- `tests/quests-expanded.test.js`:15 yeni görev testi. Diğer mevcut sistem testleriyle kaynak görevleri, mantıksal NPC eşlemesi, map/sıra, sabit kabul snapshot'ı, ön koşul, iptal/yeniden giriş, tekil/atomik ödül ve migration018 kapsandı.

## Gerçek veriyi koruma

Eski sunucu önce doğrulanmış kayıt/kapatma işleyicisiyle kapatıldı. SQLite online backup:

`backups/darkorbit-before-2026-10-20T16-39-53-938Z.db`

Önce ayrı kopyada018/019 denendi. Gerçek sunucu yükseltildikten sonra accounts/players/ships ve16 sahiplik/ilerleme tablosunun **bütün eski sütun/satırları** durdurulmuş sunucu yedeğiyle karşılaştırıldı; fark yok. Integrity=ok, FK ihlali0. İki hesap, iki oyuncu, altı gemi; `asd` oyuncusunun iki Iris'i,1.000.118.400 kredi/67.343.656 Uridyum'u ve Alpha/Beta dalga1/can3 ilerlemesi korundu. Üretime test PET'i, ödülü veya ekipmanı eklenmedi.

Sunucu HTTP8095/TCP8096 üzerinde yeniden açıldı, migration019; sağlık ok/solo, başlangıç hata kaydı boş. Son süreçPID25204.

## Kanıt sınırı

Bu sonuç bütün Flash pencerelerinde görsel oynanış kanıtı değildir.20 görev bütün özgün kataloğu temsil etmez;12 görev `[Yerel]` etiketlidir. Kamikaze hasar eğrisi ve kombo kalkan takvimi birebir özgün sunucu formülü değildir. Heat/tasarım/modern PET modülleri ve ücretli slot takvimi yoktur. Ayrıntılar: [görevler](quests-local.md), [PET](pet-local.md).
