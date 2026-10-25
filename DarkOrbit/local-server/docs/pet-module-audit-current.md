# P.E.T. modül denetimi — 23 Ekim 2026

**24 Ekim düzeltmesi:** Bu raporun PET15/HPLinkkapalı/kademe4erişilemez satırları eskidir. PET20, HPLink ve kademe4çalışır; HPkademesi ve ek lazer/jeneratör yuvası satınalma da eklendi. Isı/HeatRelease ve gerçek grup modülleri hâlâ açık. [Güncel paket](solo-completion-current.md) ve [orijinal seviye düzeltmesi](original-rules-current.md).

Kapsam: yerel tek oyuncu sunucusu; gerçek SQLite, native paket codec'i, mevcut decompile kaynakları ve resmî rehberlerle kontrol. 27 katalog kökü: 16 modül, 11 protokol. İki temel mod (pasif/koruma), 9 klasik modül ve 10 klasik protokol oyun döngüsüne bağlı. 7 modern modül ve ısı protokolü desteklenmiyor; bunlar tamamlandı sayılmaz.

## Bu tur düzeltilenler

- Koruma/kombo koruma, 500 ms dünya tick'inde iki kat hızlı ateş ediyordu. Gerçek PET salvosu ve cephane tüketimi artık en erken 1000 ms aralıkla olur; RSB'nin ayrı 3000 ms beklemesi korunur. Hareket/yakıt/toplama 500 ms döngüde çalışmayı sürdürür. Bu, sunucudaki normal lazer çevrimiyle tutarlı yerel zamanlamadır; orijinal sunucunun bağımsız yakalanmış PET atış ölçümü değildir.
- NPC'nin PET saldırı dalı normal NPC atış zamanlayıcısını atlıyordu. PET hasarı aynı `npc.nextLaserAt` süresini denetler/yazar; kalkan savuşturması/kaçırma da gerçek bir atışı tüketir. Gemi/PET hedef değişimi beklemeyi sıfırlamaz. Ana savaş çağrısı güncel tick zamanını beşinci argüman olarak geçirir.
- Koruma sonrası otomatik ganimet/kaynak moduna geçince eski NPC PET hedefi kalabiliyordu. Mod değişimi bağı kaldırır; hasar katmanı da bu iki mod ve yok olan ticaret PET'i için NPC bağışıklığını uygular. Bu davranış resmî DE rehberindeki mod kurallarına uygundur. Oyuncunun kendi NPC hedef bağı silinmez.
- CSR-02 kısayolu kapalı PET'i açamıyordu. Yaralı oyuncu, takılı uygun CSR, yeterli yakıt, canlı PET ve bekleme koşulları doğrulanınca doğrudan açılır. Başarısız koşul boş yere PET'i başlatmaz. Kullanım yakıtı native sayaçta hemen görünür.
- CSR-02 süresi/tamiri bitince takılı kombo koruma yerine düz koruma seçiliyordu. Artık takılı CGM-02 varsa ona, yoksa temel korumaya döner. Mod değişimi eski PET lazer animasyonunu native durdur komutuyla sonlandırır.

## Modül matrisi

`game/pet-catalog.js` bütün sayısal kademe metadatasını korur. `pet_level` modül kademesi, `upgrade_level` lazer/kalkan geliştirmesidir; birbirinin yerine kullanılmaz. 2. kademe için PET 4, 3. kademe için PET 8 şartı; menü yalnız takılı desteklenen modülleri açar. `12X` ürünleri kademe 3 ile aynı değerlere sahip ayrı varyantlardır, dördüncü kademe sayılmaz.

| Kök / mod | Durum ve gerçek tüketici | Açık sınır |
|---|---|---|
| Pasif (1) | Sahibinin yanında hareket, yakıt | PET hızı oyuncuya eşit yerel karar |
| Koruma (2) | Takılı PET lazeri, sahip cephanesi, isabet, 1 sn salvo, RSB, SAB | Özgün PET hasar bonus sırası bağımsız doğrulanmadı |
| `g-al1` ganimet (4), kademe 1/2/3 + 12X | Kargo/bonus kutusuna gerçek hareket/toplama, radar; NPC bağışıklığı | Korsan kutusu açmaz; dolu kargoda cevher toplanmaz |
| `g-ar1` kaynak (5), kademe 1/2/3 + 12X | Serbest cevher, cargo kapasitesi, radar; NPC bağışıklığı | Native seçmeli cevher alt menüsü eklenmedi; bütün kaynakları toplar |
| `g-el1` NPC bulucu (6), kademe 1/2/3 + 12X | Gerçek harita NPC türleri, en yakın koordinat, hedef doğrulama | 2000/3000/5000 metadata menzili |
| `g-rl1` kaynak bulucu (7), kademe 1/2/3 + 12X | Gerçek cevher türü ve koordinatı; yoksa -1/-1 | Aynı menzil tablosu |
| `g-tra1` ticaret (8), kademe 1/2/3 | Sahip olunan cevheri atomik satma; %5/15/30 gelir, 300/120/30 sn yokluk | Tek istekte tek cevher, gelir anında; özgün sepet/geri dönüşte ödeme yok |
| `g-rep1` PET tamiri (9), kademe 1/2/3 | 2000/6000/12000 HP/sn | Tam HP'ye kadar; farklı kaynaklardaki süre sınırı seçilmedi |
| `g-kk1` kamikaze (10), kademe 1/2/3 | Düşük HP ve gerçek saldırgan; bekleme, hareket, alan hasarı, imha, kalıcı cooldown | Yarıçap içi tam hasar, metadata 163/228/293 yarıçap ve 3/4/5 sn hazırlık **yerel yorum**; özgün mesafe düşüşü yok |
| `csr-02` gemi tamiri (11), kademe 1/2/3 | 5 sn × 10000/15000/25000 HP; 200/400/750 yakıt; 15 sn cooldown; hasarda korumaya dönme | NPC'nin PET'e hasarı tamiri durdurmaz; gerçek grup sistemi yok |
| `cgm-02` kombo koruma (12), kademe 1/2/3 | Koruma ateşi; %65/75/85 olasılıklı tam savuşturma; %35 ek yakıt | Anlık kalkanın orijinal aktivasyon takvimi doğrulanmadı |
| `g-fs1` dost fedası (14), metadata 1–4 | Kapalı; satın alma/takma/menü desteği ilan edilmez | Grup/klan dost hedefleri gerekir; kendine kalkan olarak değiştirilmedi |
| `g-rt1` retarget (15) | Kapalı | Düşman PET/PvP gerektirir; NPC hasarına çevrilmedi |
| `g-hpl1` HP bağlantısı (16) | Kapalı | Sahibin gövde hasarını PET'e aktaran savaş önceliği ve native efekt zinciri eksik; solo kullanım mümkün ama henüz bağlı değil |
| `g-mm1` mega mayın (17) | Kapalı | Orijinal hedefleri oyuncular, grup/PvP mayın varlığı yok; NPC mayını olarak uydurulmadı |
| `g-bc1` savaş beacon (18) | Kapalı | Grup/klan dost alan etkisi/yaşam döngüsü eksik |
| `g-bh1` HP beacon (19) | Kapalı | Grup/klan dost alan etkisi/HP geri alma zinciri eksik |
| `g-hr1` heat release (20), metadata 1/2/3 + 12X | Kapalı | Kalıcı PET heat ve HEAT seviyesi sistemi yok |

## Protokol matrisi

On klasik türün metadata kademe 1/2/3/4 değerleri aynen saklanır. Yerel PET seviye tavanı 15 olduğundan kademe 4 için gereken PET 20 şu anda normal ilerlemeyle erişilemez. Kademe 4'ü satın alınabilir/çalışıyor saymayın. Aynı tür protokoller taban üzerinde toplanır; yalnız aktif konfigürasyonun PET yuvaları tüketilir.

| Kök | Etki / gerçek tüketici |
|---|---|
| `ai-lm1` | PET lazer hasarı / `pet.stats` ve gerçek savaş hasarı |
| `ai-al1` | PET lazerinin NPC çarpanı / `pet.tick`; kamikazeye uygulanmaz |
| `ai-sm1` | PET azami kalkanı / `pet.stats`, native durum, gerçek emilim |
| `ai-hp1` | PET azami canı / `pet.stats`, tamir/hasar |
| `ai-aim1` | PET lazer isabeti / `combat-balance.hitChance` |
| `ai-e1` | PET'e NPC isabetini azaltma / `pet.damage` |
| `ai-r1` | Toplama ve bulucu menzili / `pet.tick`, `pet-special.tick` |
| `ai-eco1` | Dakika yakıtını azaltma / kesirli kalıcı yakıt hesabı |
| `ai-cr1` | Aktif PET sahibinin kargo kapasitesi / açma-kapatma/ekipman yenileme |
| `ai-s1` | PET'in aldığı normal bonus/kargo miktarı / `collectables.collect`; anahtar/ekipman kopyalamaz |
| `ai-ah1` | **Kapalı**: heat generation; ısı sistemi yok |

Yakıtın dakikalık hesabı `1 + 2×PET seviye + 2×protokol + 4×modül`; ekonomi ve seçili kombo katsayısı uygulanır. Kesir DB'de korunur, kapalı PET yakıt yakmaz. Depo 100000; yerel 6 lazer/12 kalkan/6 modül/12 protokol açık kalır. PET XP payı %5, seviye tavanı 15; orijinal ücretli HP/slot açma ve seviye 16–20 ilerlemesi ayrı eksiktir. Salvage rastgele arıza/bonus dağılımı çözülmedi.

## Kanıt ve doğrulama

Statik sözleşmeler: `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/PetRequest.as`, `PetGearTypeModule.as`, `PetGearActivationRequest.as`; `net/PetWindowAssembly.as`, `net/PetAssembly.as`; sayılar `items/ItemDataProvider.as` ve `docs/pet-catalog-local.md`. Kaynaklar sonradan orijinal sunucu kodu gibi sunulmaz.

23 Ekim 2026 tarihinde resmî [PET FAQ](https://board-en.darkorbit.com/threads/pet-10-faq.1228/), [kombo rehberi](https://board-en.darkorbit.com/threads/p-e-t-combo-gears-faq.1227/) ve [DE PET/ekipman rehberi](https://board-de.darkorbit.com/threads/faq-p-e-t-und-ausruestung.118714/) kontrol edildi. Üstteki desteklenmeyen özellikler bu kaynaklardaki hedef kapsamına göre ayrıldı; çok oyunculu sistem eklenmedi.

`logs/pet-module-audit-current-tests.log`: **60/60 PASS**. Altı mevcut PET test dosyası; kaynak sayıları/kademeler, gerçek codec, satın alma/rollback, iki konfigürasyon, bütün klasik modlar ve on protokol, yakıt, recall, imha, harita geçişi, locator, ticaret, salvage, CSR ve kamikaze. Bu tur 3 yeni entegrasyon testi: hızlı tick'te gerçek cephane/hasar sayısı; NPC atış zamanlayıcısı ve mod bağışıklığı; kapalı PET'ten CSR başlatıp CGM'ye dönme. Mevcut kaçınma/savuşturma testi yeni gerçek atış zamanına göre ilerletildi. Testler bellek DB'sinde; üretim hesabına eşya/yakıt eklenmedi. Flash çizilmiş ekran kontrolü yapılmadı.
