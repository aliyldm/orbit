# Roket uçuşu ve hasar zamanı

`game/projectiles.js`, standart roket ve Hellstorm hasarını gerçek istemcinin görsel uçuş süresine erteler. Atış anında cephane düşer, bekleme başlar ve görsel paket gönderilir. `AttackHitCommand`, ölüm, kargo ve ödül çarpma zamanında oluşur.

Kanıtlar `decompiled/main/scripts/net/bigpoint/darkorbit/map/` altındadır:

- `view2D/effects/combat/rocket/Rocket2D.as`: 500 birim/saniye; en az 0,5 saniye. Hellstorm için ek 0,3 saniye.
- `view3D/effects/combat/rocket/Rocket3D.as`: aynı hız, en az 1 saniye ve Hellstorm için ek 0,3 saniye.
- `AirstrikeEffect2D.as` ve `AirstrikeEffect3D.as`: her mermi için `0,5 * sıra / salvoAdedi` saniye çıkış gecikmesi.

Standart uçuş `max(minimum, mesafe/500)` saniyedir. Hellstorm toplam hasarı son mermide çözülür: buna `0,3 + 0,5*(salvoAdedi-1)/salvoAdedi` eklenir. Örneğin 400 birim mesafede 2D standart roket 800ms, üçlü salvo 1434ms; 3D'de 1000ms ve 1634ms sürer. Salvo tek hasar paketi olarak çözülür; her mermi için ayrı hasar yazımı uygulanmaz. Kaynak homing efektinde hareketli hedef aynı süre boyunca izlenir; hedefin hareketi süreyi yeniden başlatmaz.

Aktif renderer girişte istenen moddan başlatılır; `ReadyRequest` MAP_LOADED_2D/3D gerçek çalışan modu doğrular (3D'den2D'ye fallback dahil). Önce `world.rendererMode`, ardından oturumun `rendererMode` alanı; 2=2D, 1=3D. Yedek flashvar `display2d` aynı değerleri taşır. Yeni kaydedilen görüntü ayarı yeniden girişten önce uçan roketin zamanını değiştirmez. `config.combat.projectileView='2d'|'3d'` açık bir yerel test/ayar geçersiz kılmasıdır. [23 Ekim2Ddoğrulaması](classic-2d-current.md).

Bekleyen atış tam oyuncu/oturum/harita/epoch ve NPC nesne kimliğini taşır. Çıkış, bağlantı değiştirme, ölüm, atlama başlangıcı veya harita temizliği zamanlayıcıları iptal eder. Aynı kimlikle yeniden doğan NPC eski atıştan hasar almaz; iki öldürücü salvo aynı ölümü iki kez ödüllendirmez. Çoktan ateşlenmiş mermi iptal edildiğinde envantere iade edilmez.

`node --test tests/projectiles.test.js`: 9 test; kaynak 2D/3D süreleri, aktif renderer önceliği, salvo gecikmesi, hasar/ödülün gecikmesi, çıkış/atlama/ölüm temizliği, nesne kimliği, hareketli hedef ve tek ödül doğrulanır. Paketler gerçek codec ile kodlanır. Bu testler Flash ekranındaki görsel uçtan uca doğrulamanın yerine geçmez.
