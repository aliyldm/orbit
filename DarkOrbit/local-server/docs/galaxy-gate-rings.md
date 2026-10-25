# Galaxy Gate tamamlama halkaları

22 Ekim 2026. [Resmî forum açıklaması](https://board-en.darkorbit.com/threads/6-circles.18259/) Alpha, Beta, Gamma, Delta, Epsilon ve Zeta'nın ilk bitirişte ayrı halka açtığını, Kappa/Lambda/Hades'in halka vermediğini ve Kronos'un halkalar yerine taç gösterdiğini doğrular. Aynı kapıyı tekrar bitirmek yeni kapının işaretini açmaz.

Gerçek Flash sözleşmesi: `ShipInfoDisplay.setFinishedGalaxyGates`, `galaxyGatesDone` değerini toplam sayı olarak değil bit maskesi olarak çözer. `ShipInitializationCommand` → `ShipAssembly` → `ShipManager.createShip` → `info.galaxyGatesFinished` → native rütbe üzeri `ggIcon` akışı mevcut görselleri çizer. Yeni simge/konum tasarlanmamıştır.

| Kapı | Builder ID | Bit |
|---|---:|---:|
| Alpha | 1 | 1 |
| Beta | 2 | 2 |
| Gamma | 3 | 4 |
| Delta | 4 | 8 |
| Epsilon | 5 | 16 |
| Zeta | 6 | 32 |
| Kronos | 12 | 64 |

Örneğin Alpha+Zeta 33'tür. İki Alpha bitirişi 1 olarak kalır. Kronos builder kimliği kaynak `GalaxyGateBuilderModel` içindeki `gate_title_12` ile doğrulandı; bu değişiklik Kronos dalga/oynanışını eklemez.

Eski sunucu her bitirişte `galaxy_gates_done+1` yazıyordu; bu yanlış kapı işaretleri üretebilirdi. Yeni `game/gate-rings.js`, oyuncunun gerçek `won` koşularından veya ödeme/tamamlama makbuzu bulunan koşularından kapı kümesini çıkarır. Yalnız önbellek simge alanı düzeltilir; cüzdan, geçmiş ve koşular değişmez. Sunucu açılışı, oyuncu yükleme/kaydetme, native başlangıç ve atomik kapı ödülü bu kurala bağlıdır. Geçmişi olmayan eski sayılar halka kanıtı sayılmaz. Bitiriş sonrası ana haritaya dönüşün gerçek başlangıç paketi simgeyi yeniler.

Native istemcinin kendi konumları korunur: Alpha/Beta/Gamma `y=6`, Delta/Epsilon/Zeta `y=0`. Eski forumdaki satır tarifini bu farklı istemci sürümünün üzerine zorlamak yerine gerçek render sözleşmesi kullanılır. Kronos'un hazır `ui.swf/kronos_gg` kaynağı mevcuttur.

`tests/gate-rings.test.js` gerçek son NPC öldürme, aynı/farklı/halka vermeyen kapılar, tekrar istek, işlem geri alma, hesap ayrımı, eski sayı onarımı, kalıcı açılış ve gerçek kodlayıcılı hero başlangıcını sınar. Genişletilmiş kapı testleri 60/60; 747/747 tüm testler `logs/module-rings-suite.log`. Görsel halka gösterimi native kaynak sözleşmesiyle doğrulanmıştır; test hesabına bedelsiz kapı bitirişi eklenmemiştir.
