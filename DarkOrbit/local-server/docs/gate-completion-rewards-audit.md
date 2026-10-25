# Galaxy Gates tamamlama ödülü denetimi

20 Ekim 2026 tarihinde resmî kaynaklar ve sunucunun gerçek son-NPC teslim akışı karşılaştırıldı. Bu denetim kapı **tamamlama** ödülleridir; enerji basma ödülleri ve NPC cevher kargosu ayrı sistemlerdir.

## Garantili klasik tablo

Taban değerlerdir; etkin XP/onur boosterları ayrıca uygulanır. NPC'lerden kazanılanlar bu sayılara dahil değildir. Bütün kapılarda bitirme kredisi sıfırdır. Anahtarlar yeşil korsan anahtarıdır; kırmızı/mavi anahtar verilmez.

| Kapı | XP | Onur | Uridium | UCB-100 | Logfile | Tamir kuponu | Yeşil anahtar |
|---|---:|---:|---:|---:|---:|---:|---:|
| Alpha | 4.000.000 | 100.000 | 20.000 | 20.000 | 2 | 2 | 0 |
| Beta | 8.000.000 | 200.000 | 40.000 | 40.000 | 4 | 4 | 0 |
| Gamma | 12.000.000 | 300.000 | 60.000 | 60.000 | 10 | 6 | 0 |
| Delta | 9.000.000 | 225.000 | 45.000 | 45.000 | 8 | 5 | 0 |
| Epsilon | 5.000.000 | 150.000 | 25.000 | 20.000 | 10 | 0 | 5 |
| Zeta | 6.000.000 | 200.000 | 35.000 | 25.000 | 50 | 0 | 25 |
| Kappa | 9.000.000 | 350.000 | 15.000 | 30.000 | 10 | 0 | 5 |
| Lambda | 2.750.000 | 100.000 | 15.000 | 10.000 | 3 | 0 | 5 |
| Hades | 4.000.000 | 200.000 | 20.000 | 15.000 | 8 | 0 | 4 |
| Kuiper | 2.000.000 | 150.000 | 15.000 | 0 | 0 | 0 | 5 |

Önceki sunucu bu sayıları zaten doğru kullanıyordu. Kaynaklar: [Alpha](https://board-en.darkorbit.com/threads/alpha-gate-faq.784/), [Beta](https://board-en.darkorbit.com/threads/beta-gate-faq.792/), [Gamma](https://board-en.darkorbit.com/threads/gamma-gate-faq.841/), [Delta](https://board-en.darkorbit.com/threads/delta-gate-faq.840/), [Epsilon](https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/), [Zeta](https://board-en.darkorbit.com/threads/zeta-gate-faq.852/), [Kappa](https://board-en.darkorbit.com/threads/kappa-galaxy-gate-faq.837/), [Lambda](https://board-en.darkorbit.com/threads/lambda-gate-faq.842/), [Hades](https://board-en.darkorbit.com/threads/hades-gate-faq.971/), [Kuiper](https://board-en.darkorbit.com/threads/kuiper-galaxy-gate-faq.110141/).

Kappa'nın eski İngilizce FAQ'sında onur 350.000, [2021 yeni ödül FAQ'sında](https://board-en.darkorbit.com/threads/galaxy-gates-new-rewards-faq.127345/) 325.000'dir. Burada eski tablo korunur. Yeni ASR/Diametrion, etkinlik tasarımları ve çift ödül günü eklenmedi. Dolayısıyla bu tablo güncel 2026 etkinlik tablosuyla birebir olduğu iddiası taşımaz.

## Tamamlanan eksikler

- Epsilon: İlk kazanılan kapıda bir LF-4; sonraki bitirmelerde %25. İlk manuel garanti ve sonraki oran [resmî ödül açıklamasında](https://board-en.darkorbit.com/threads/galaxy-gates-new-rewards-faq.127345/) açıkça yayımlanır. Eski FAQ yalnız şans der; ilk garanti bu resmî açıklamayla tamamlanmıştır.
- Zeta: İlk kazanılan kapıda bir Havoc; sonra klasik %33. [Spartan FAQ](https://board-en.darkorbit.com/threads/spartan-drone-design-faq.119171/) eski %33 ile yeni %45'i ayrı gösterir. Burada yeni %45 kullanılmaz.
- Kappa: Tek çekilişte dört eşit sonuç: Hercules, LF-4, beş saatlik Kappa çoklu boosterı veya ek ödül yok. [Resmî Almanca FAQ](https://board-de.darkorbit.com/threads/faq-galaxy-gates.2848/) bu dört seçeneği açıkça listeler; eski Hercules oranı Spartan FAQ'da da %25'tir. Boosterın %5 hasar/XP/kalkan etkileri ve beş saat süresi istemcideki `booster_kappa-b01` tanımından gelir.
- Hades: LF-4 çekilişi [kapının resmî FAQ'sında](https://board-en.darkorbit.com/threads/hades-gate-faq.971/) doğrulanır; kesin yüzdesi yazmaz. **Yerel varsayılan %25'tir; özgün oran doğrulanmış sayılmaz.** `galaxyGates.hadesLf4Chance` ile 0–1 aralığında ayarlanabilir. Hitac FAQ'sındaki dörtte bir örneği etkinliğin Legend gemisini de anlatabildiği için LF-4 oranına kesin kanıt kabul edilmedi. Mevcut tek oyunculu uygulama grup paylaşımı iddiasında bulunmaz.
- Kuiper: Aegis Elite, Citadel Elite, Spearhead Elite, Venom veya Pusat. Yeni gemi depoya eklenir; aktif gemi değiştirilmez. Seçilen gemi zaten varsa klasik 200.000 Uridium verilir. Bu eski bedelin 2021'de 10.000'e düşürüldüğü [resmî duyuruyla](https://board-en.darkorbit.com/threads/updated-galaxy-gate-rewards-after-dispatch-expansion.127346/) doğrulanır. **Düşme oranı ve beş geminin kendi aralarındaki ağırlıkları yayımlanmış değildir.** Yerel varsayılan kazanma oranı %10, gemi seçimi eşit ağırlıklıdır. `galaxyGates.kuiperShipChance` 0–1 aralığında ayarlanabilir; yeni kapı kurulurken snapshot'a yazılır. Bu oran özgün algoritma diye sunulmaz.
- Alpha–Lambda bitirmeleri bir kaynak türü Kronos parçası biriktirir. Parçalar envanterde saklanır ve istemcideki sınırları aşmaz: Alpha 4, Beta 3, Gamma 1, Delta 1, Epsilon 4, Zeta 1, Kappa 2, Lambda 5. Kaynak [resmî Kronos bölümü](https://board-de.darkorbit.com/threads/faq-galaxy-gates.2848/). Kronos'u kurup oynama ve builder arayüzüne bu parçaları bağlama henüz tamamlanmamıştır.

LF-4 ve tasarımlar ayrı `amount=1` envanter satırlarıyla teslim edilir; iki lazer yanlışlıkla tek takılamayan `amount=2` satırına dönüşmez. Kappa boosterı etkinleştirilir ve gerçek etkisi istemciye bildirilir. Yeşil anahtar sayacı son teslimden sonra gerçek bakiye ile yenilenir.

## Kalıcılık ve sınırlar

Yeni ödül politikasının kimliği `classic-rare-2026-10-20-v1`'dir. Yalnız yeni kurulan kapılar bu politikayı kaydeder. Önceden `plan_json/rewards_json` ile kaydedilmiş başlamış veya hazır kapıların hakları değiştirilmez. Eski, hiç girilmemiş ve henüz snapshot'ı olmayan kapılar önceki geçiş kuralıyla ilk girişte yeni içerik alabilir; can/parça/para korunur. Başlamış eski snapshot rastgele ek ödül kazanmış gibi yeniden yazılmaz. Önceki `state='won'` kayıtları ilk bitiriş garantisi hesabında sayılır; geçmişte verilmemiş ödüller geriye dönük uydurulmaz.

Migration `016-gate-completion-rewards.sql` her bitmiş koşunun gerçek ödülünü `galaxy_gate_completion_claims` içinde tekilleştirir. Son NPC ödülü, ekipman/gemi/anahtar teslimi, bitirme parası ve kazanma durumu tek savepoint içindedir. SQL hata verirse hiçbir kısmı verilmiş sayılmaz; istemciye başarı gönderilmez. Başarılı işlemden sonra aynı NPC/koşu tekrar ödemez. Kazanan veya boş çıkan çekiliş sonucu ve gerçek teslim miktarları denetlenebilir.

Kappa boosterı mevcut genel booster altyapısını kullanır: süre duvar saatiyle azalır; çevrimdışıyken durması henüz uygulanmamıştır. Bu nedenle kaynaktaki beş saat **oynama süresi** davranışı tam eşleşmez. Kronos kapısı, ilk bitirişe özel doğru halka görünümü, Kappa/Lambda/Hades unvanları ve özel gün takvimi açık eksiklerdir. `galaxy_gates_done` eski toplam bitiriş sayacını korur; bütün kapılarda halka kazanıldığı anlamına gelmez. Tasarımlar teslim edilip diroide takılabilir ve Hercules'in tek diroit kalkan etkisi vardır; tam Havoc setinin %10 diroit lazeri ve tam Hercules setinin %20 HP etkilerinin mevcut `drones/statItems` hattında bağlandığı bulunamadı. Bu set etkileri ödül tesliminden ayrı açık eksiktir.

## Doğrulama

`tests/gate-completion-rewards.test.js`: on garantili tablo, ilk garanti, eski kazanılmış kayıt, RNG sınırları, bütün Kappa dalları, ayrı envanter satırları, booster etkileri, beş Kuiper gemisi/200k telafisi/boş çekiliş, Kronos limitleri, eski ödül snapshot'ı, hatalı çekiliş, gerçek son NPC teslimi/tekrar engeli ve SQL geri alımı.

Mevcut on-kapı tam akış testi artık Kappa booster dalını deterministik seçer; sonraki kapıların XP toplamını gerçek booster etkisiyle doğrular. Flash içindeki görsel oynanış bu testlerle doğrulanmış sayılmaz.
