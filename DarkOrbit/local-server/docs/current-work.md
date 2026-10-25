# Bu kayıt önceki sürümdür

**Güncel devam noktası:** [Son tamamlama çalışması](second-completion-work.md).835/835 test;22.044 gerçek ağ komutu;PID3628. Kronos/warp/otomasyon/diroit/rütbe/ödül/görev güncellemeleri ve açık iş sırası o dosyadadır. Aşağıdaki800test/PID7836 ve eski eksik tablosu tarihsel temel sürümdür.

# Devam kaydı — 23 Ekim 2026

Bu dosya son kullanıcı talebinin çalışma ve devam kaydıdır. Kullanım hakkı veya oturum kesilirse önce bu dosyayı okuyun. **Temel sürüm: 800/800 test, 283 JS / 0 sözdizimi hatası, gerçek HTTP/TCP 20.580 komut PASS.** Son ek: hangarın zorla gemi ekipmanına geçmesi düzeltildi,20 ilgili test geçti. Sunucu PID **7836**, solo HTTP8095/TCP8096; sağlık yanıtı `ok/solo`. PID yeniden başlatmayla değişebilir; kimliğini kontrol etmeden durdurmayın. Önceki PID22188 kaydederek durduruldu.

## Son ek — hangar açılışı

Normal `internalDock` açılışında `local-hangars.js` Flash hazır olur olmaz `changeHangarSlot(selectedIndex)` çağırıyordu. Native `HangarManagerProxy` bunu `HANGAR_SLOT_CHANGED` bildirimi yapar; `StageMediator` ekipman görünümünü açar. Bu yüzden kullanıcı önce Goliath ekipmanı görüyor, Geri ile gemi listesine dönüyordu. Normal açılış artık bu çağrıyı ve readiness poll'unu başlatmaz; özgün gemi seçici kalır. Sadece açıkça `hangarSlot=` içeren başlık numarası/atama bağlantısı ilgili ekipmanı açar. Boş seçili hangar normal açılışta bütün gemi listesini gizlemez. Betik cache sürümü `20261023-browser`. Kaynaklar: `client/resources/js/local-hangars.js`, `web/hangar-api.js`; `tests/hangar-client.test.js`, `hangar-http.test.js`, `hangars.test.js`20/20PASS (`logs/hangar-startup-tests.log`). İki değişen JS sözdizimi temiz. Yeni console/error kayıtları `logs/hangar-startup-server-console.log` ve `logs/hangar-startup-server-error.log`. Sağlık ve canlı betik yanıtı doğrulandı; native görsel kontrol yapılmadı. DB/MAIN değiştirilmedi.

MAIN bu tur değiştirilmedi: `d0d20e63a29e3182a33a7839b2f27e356b94841f90bcbcb1659d4ae2aa38403c`; `gameclientHash=local-20261023-bulk-upgrade`. İstemciyi yeniden açmak yeni menü/görünürlük ve sunucu durumunu yükler. Qt/Flash görsel testi bu tur yapılmadı.

## Kabul edilen kapsam

| İş | Durum | Sorumlu kaynak / sonraki kontrol |
|---|---|---|
| Otomatik normal roket ve 5'li HST/RLLB CPU | Kaynak düzeltildi; 81 odaklı test geçti | `docs/hellstorm-local.md`; altı launcher ve modern pasifleri eklendi |
| Büyük NPC dağılımı; özellikle1-7 Kristallon | Uygulandı; 27 odaklı test geçti | `docs/normal-population-current.md`; v3 seed canlıya uygulandı |
| Bütün P.E.T. modülleri/protokolleri | Denetlendi; 60 odaklı test geçti | `docs/pet-module-audit-current.md`; yedi modern gear/Heat/PET16–20 hâlâ eksik |
| Dükkânda boş yuvalar ve kredi-önce sıralama | Kaynak düzeltildi; 50 odaklı test geçti | `docs/shop-cleanup-current.md` |
| Bütün1mUri kampanya ürünleri ayrı Özel Fırsatlar sekmesi | Portal tamam; native gruplama açık | 196 ürün,162 alınabilir;34 kapalı. Native signedByte127 sınırı var |
| Oyun içi pencerelerin çalışmayanları | Denetlendi ve görünürlük filtresi uygulandı | `docs/ingame-window-audit-current.md` + JSON; 95 öğe,23 korundu;27 bozuk görünür düğme gizlendi. Eksikler aşağıda |
| Zeta ve bütün kapıların dalga sonu devam/üs portalları | Desteklenen10 kapıya uygulandı; 23 odaklı test geçti | `docs/gate-checkpoints-current.md`; soldan devam, sağdan üs; yeniden giriş/kayıt/ödül ve tam10kapı bitişleri testli |
| Toplu doğrulama/yedek/dağıtım | Tamamlandı | Günlükler ve yedek aşağıda; bütün canlı DarkOrbit özellikleri tamamlandı anlamına gelmez |

## Korunacak kararlar

- Çok oyunculu sistemler henüz uygulanmayacak. Grup/PvP gereken modülleri çalışıyormuş gibi sunmayın.
- Özgün davranış için resmi kaynak ve gerçek SWF sözleşmesi kullanın. Yerel NPC adetlerini özgün kesin sayılar gibi tanıtmayın.
- Kullanıcı daha önce fiziksel Escape ile Computer Use'u durdurdu. Yeni açık devam izni olmadan native ekran girdisi göndermeyin; kaynak, test ve sunucu araçlarıyla çalışın.
- Yeni SWF gerekirse bütün önceki yamaları koruyun, gerçek kurulu SHA'yı doğrulayın; eşzamanlı SWF yazmayın.
- Hesaba tekrar para/tasarım eklemeyin: +50milyarU ve Havoc/Hercules/Spartan/Demon10'ar önceki talepte teslim edildi, `settings` makbuzları var.
- İlerlemeyi silmeyin. NPC sürüm güncellemeleri kimlik/öldürme/yeniden doğma kayıtlarını korumalı.

## Uygulanan davranış

- AROL-X seçili tek roketi lazer saldırısında atar. ROK-T01 ayrı cooldown'a uygulanır. RLLB-X launcher'ı boşta yükler ve lazer hedefi olduğunda gerçek salvo atar. Lazer cephane bildirimleri launcher mühimmat seçimini bozmuyor. HST-2 beş mermi tüketir; atış sonrası3sn kilit + mermi başına1sn yükleme. Konfigürasyon değişimi yükü temizler, cooldown korunur.
- Önceden hiç tanınmayan Triskelion/Hydra/Neptune/Ouroboros kapasiteleri ve doğrulanan pasifleri eklendi. Triskelion3/Hydra5/Neptune5/Ouroboros6. Citadel çoklu launcher sınırı aşağıda.
- Her şirkette x-7 Kristallon18, x-6 Kristallon12, x-5 Lordakium12, x-3 Devolarium16, x-4 Sibelon16; korsan Annihilator6. Küçük NPC oranı üst haritalarda azaltıldı. Bunlar **yerel nüfus ayarlarıdır**. Tür üyeliği korunur; x-8'e asılsız Kristallon eklenmedi. Migration mevcut spawnID/hasar/respawn beklemelerini korur.
- PET koruma ateşi1sn; NPC PET'e her tick vurmaz. Toplayıcı/ticaretteki PET eski hedef yüzünden hasar almaz. CSR kapalı PET'i koşulları sağlanınca açar; tamamlanınca takılı CGM'ye döner. Yakıt/mod değişimi native durumla eşlenir.
- Portal dükkânında196 kampanya Özel Fırsatlar'a taşındı; normal kategorilerden çıkarıldı.162 alınabilir,23 eksik manifest+11 işlevsiz ürün kapalı ve gerekçelidir. Kart boyu/gerçek ürün sayısı/ilk seçim ve günlük-limitli fiyat güncellemesi düzeltildi. Kredili ürünler önce, sonra Uridyum; her para biriminde artan fiyat. Native mağazada da kredi-önce sıralama var, kategori kapsam farkı aşağıda.
- Ana kapı dalgası bitince iki merkez portalı çıkar; alt fazlar otomatik. Savaşta sürekli kaçış portalı yok. Sağ portaldan çıkış ilerlemeyi/canları korur; yeniden giriş sonraki dalgaya başlar. Checkpoint içinde yeniden giriş yapmak kendiliğinden dalga başlatmaz. On desteklenen kapının tam bitişleri test edildi.
- Desteklenmeyen native menüler kayıtlı hesaptan açık geliyordu.95 benzersiz öğe incelendi;23 desteklenen korundu, toplam72 desteklenmeyen gizli (27'si daha önce görünürdü). Bu özellikler uygulanmış sayılmadı. Çalışan native SeasonPass ve web ödül defterleri korunur.

## Doğrulama ve dağıtım

- `logs/current-full-suite.log`:800/800 PASS,0 fail/skip. İlk koşuda eski NPC testi12 bekliyordu; kullanıcı isteğiyle16 olan hedefe güncellenip tam paket tekrar geçti.
- `logs/current-syntax.log`:283 JS,0 hata. `logs/current-client-check.log`: mevcut launcher/Flash patch kimliği doğrulandı.
- `logs/current-network.log`:20.580 çözülen komut, gerçekHTTP/TCP PASS. Alpha'nın4alt grubu ve native üs portalı; Epsilon devam portalları/tam ödül; CPU, AJP, cannon/drive/SR5, PET, görevler, Payment, assembly, toplu upgrade, relogin. Test hesapları bellekDB'sindedir. Önceki ağ denemesiSR5bekleyişinde timeout olmuştu; son tam koşu geçti, önkoşul tanısı testte korundu.
- `logs/current-db-check.log`: yükseltme kopyasında2 hesap/2 oyuncu/7 gemi/41 sahiplik-ilerleme tablosu korundu; integrityOK/FK0. Yedek: `backups/darkorbit-before-2026-10-23T06-38-17-790Z.db`; kontrol kopyası aynı zaman damgasıyla `darkorbit-migration-check-...db`.
- Yeni migration026 ve `normal-population-2026-10-23-v3` canlı başlangıçta uygulandı. Sunucu konsolu `logs/current-server-console.log`, hata kaydı `logs/current-server-error.log`; son sağlık `ok/solo`,PID22188.

## Açık işler — buradan devam et

1. **Native mağaza kampanya gruplaması:** portal tamam. Flash `ShopItemListCommand.itemList` uzunluğunu signedByte okur;127 üstü güvenli değil.162 alınabilir teklifi tek native listeye taşımak veri keser. Mevcut native kategoriler korundu. Çözüm: gerçek istemci sözleşmesine uygun sayfalama veya doğrulanmış SWF/protokol yaması; körce byte türünü değiştirme. `docs/shop-cleanup-current.md`.
2. **Çoklu roketatar:** Citadel gibi birden fazla launcher takılabilen gemide şu an en yüksek kapasiteli tek launcher çalışır. Çoklu salvo/yük/ses/menü modeli gerekir. Ouroboros6'nın eski Flash5kapasiteli çember/sesini görsel doğrula; çoklu launcher pasif istifleme ayrıca doğrulanmalı. Kesirli yükleme süreleri1sn tick'e yuvarlanıyor. UBR özelNPC/PIR/OBR etkinlik etkileri henüz doğrulanmadı. `docs/hellstorm-local.md`.
3. **PET:** klasik13gear/onprotokol yerel akışları testli.7moderngear veHeat protokolü kapalı. G-HP-link solo uygulanabilir ama gerçek hasar/efekt zinciri eksik; grup/PvPgerekenleri kullanıcı talimatına göre sonraya bırak. PET16–20, ücretli HP/slot açma, kademe4ilerleme ve salvage olasılıkları eksik. `docs/pet-module-audit-current.md`.
4. **Kapılar:** Kronos/diğer modern kapılar yok. Hades orijinal grup mekaniklerinin tamamı yerine solo uyarlama. Alt faz süreleri, finalden otomatik üsse dönüş ve tüm kaynak sürümlerinin birebir eşitliği ayrı doğrulama ister. Aktif kayıtlı planları bozma. `docs/gate-content.md`, `docs/gate-checkpoints-current.md`.
5. **Native pencereler:** gemi warp; Komuta Merkezi gerçek haber/boş yüklenme; autoBoost/autoRefinement/autoChangeAmmo/yeşil anahtar otomatik alımı; Dispatch/NOVA/synthesis/update_engine/pathfinder ve modern etkinlik ekranları eksik. Görünürlük filtresi bunları uygulamaz. Tam95öğe/handler matrisi `docs/ingame-window-audit-current.md` + JSON.
6. **Birleştir gelişmiş sekmeler:** Stabilize Et/Hiper Ocak bireysel modül/çekirdek bonusları ve kayıtları yok; hiçbir kaynak tüketmeden gerekçeyle reddedilir. `docs/assembly-native-tabs.md`.
7. **Önceki ayrı eksikler:** Havoc/Hercules/Spartan tam set bonusları, özgün günlük rütbe hesaplaması, bütün orijinal görevler ve bazı savaş/RNG formülleri. `docs/upgrade-effects-validation.md` ve `docs/latest-local-validation.md`.
8. **Görsel kontrol:** kullanıcı native ekran kontrolünü Escape ile durdurmuştu; bu tur sadece kaynak/codec/CLI/ağ doğrulaması yapıldı. Yeni açık yetki olmadan native ekran girdisi verme. Yeniden bağlantıda HST5animasyonu, kapı sol/sağ yerleşimi, Özel Fırsatlar görünümü ve yeni toolbar pratikte kontrol edilebilir.

Bu listede çok oyunculu geliştirmeye başlanacak iş yoktur; PvP/grup/sohbet/klan/açık artırma kullanıcı kararıyla ertelenmiştir. Üretim hesabına bu tur para/eşya verilmedi.
