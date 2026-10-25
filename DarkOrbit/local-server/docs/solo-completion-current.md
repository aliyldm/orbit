# Yerel tamamlama çalışması — 24 Ekim 2026

Kullanıcı kalan yerel eksiklerin tamamlanmasını, ardından çok oyunculu sunucuya aşamalı geçişi istedi. Bu tur çok oyunculu altyapı başlamadı. Önceki özel ekonomi, LF4 lazer tavanı ve labirentin iptali kararları geçerli.

## Kapatılan işlevler

### P.E.T. can kapasitesi ve yuva alımı

`game/pet-progression.js` HP seviyelerini sırayla satın alır; her biri10.000HP, fiyat ilk10seviye5.000×kademe,11–20için50.000U. KademePETseviyesini geçemez. Satın alma canı doldurmaz, yalnız kapasiteyi artırır. Tekrar gönderilen eski kademeSKU'su reddedilir; yetersiz para ve SQL hatasında işlem geri alınır. Can/para canlı oturuma yansır ve çıkış kaydı eski bakiyeyi geri yazmaz.

HP kartı mevcut P.E.T./Modüller sayfasının orijinal kutucuğu, görseli ve satın alma bileşenleriyle eklenir. Fiyat/kimlik oyuncunun sıradaki kademesidir. Sonraki kademeyi almak için sayfa yenilenir. Ayrı sabit düğme veya sayfa eklenmez.

Orijinal hangar kilit simgesinin `unlockSlot` FlashAPI isteği çalışır. Lazer slotu12'ye, jeneratör22'ye kadar PETseviyesine göre alınabilir. Önceki yerel6lazer/12jeneratör/6modül/12protokol ücretsiz sahipliği geriye çekilmez; mevcut hesaplara yeniden ödeme çıkarılmaz. Kalıcı `pet.unlockedSlots` ayarı mevcut `settings` tablosundadır. MetadataQ / lockedSlots / costWeaponSlot / costGeneratorSlot orijinal istemcinin alanlarıyla gönderilir. Ekipman taşıma satın alınmamış yuvaya geçemez; iki konfigürasyon aynı hesabın yuva sahipliğini kullanır.

**Açık sınır:** başlangıçtaki ücretsiz yerel yuvalar ve metadata ile eski rehber arasındaki seviye kaymaları yeniden dengelenmedi.7–8.modül yuvası için doğrulanmış fiyat yok;6mevcut modül yuvası korunur. Isı yuvaları HEATuygulanana kadar açılmaz. Tüm PETekonomisi birebir tamamlandı denmemeli.

Kaynak: [PET FAQ](https://board-en.darkorbit.com/threads/pet-10-faq.1228/), [Level Update](https://board-en.darkorbit.com/threads/p-e-t-level-update.120879/). Resmî fiyat görseli `docs/evidence/pet-slot-costs.png` (attachment6072). Native sözleşme `DragComponent.as`, `ConnectionProxy.handleUnlockSlot`, `ItemInfoManager`, `GridComponent.createUnlockableSlots`.

### Gemi yetenekleri

`tools/extract-ship-abilities.js`, dağıtılan `ItemDataProvider.as` içinden dükkândaki80gövdenin kendi süre/bekleme/parametrelerini çıkarır. Sonuç `game/data/ship-abilities.json`; kaynak dosyası veSHA256içerir. Kod veya ASçalıştırılmaz. `game/ship-abilities-expanded.js` bu tablodaki sekiz ek menüyü gerçek oyun döngüsüne bağlar. Önceki altı klasik yetenek aynı sözleşmeyle çalışır. Toplam14farklı yetenek menüsü;10ekgövdede en az bir ek işlev bulunur. Bütün80geminin tüm yetenekleri tamamlandı anlamına gelmez.

| Yetenek | Solo davranış |
|---|---|
| Aegis HP tamiri | 7sn,20.000HP/sn,90sn bekleme |
| Aegis kalkan tamiri | 5sn,15.000kalkan/sn,30sn bekleme; HPileeşzamanlı kullanılabilir |
| Aegis tamir podu | Sabit nativeHealingPodAsset33;10sn,20.000HP/sn,500menzil,120sn bekleme; uzaklaşınca tamir etmez |
| Aegis Elite/Veteran | Kendi gövde süreleri; Elite6sn/4sn/15sn. Eksik parametreler kendi Aegisailesinin tabanını kullanır |
| Hammerclaw | 25kHP/sn×7sn,40kkalkan/sn×3sn,17.5kpod×10sn;140/60/160sn bekleme |
| Hammerclaw Plus | 37.5kHP/sn×6sn,50kkalkan/sn×3sn,25kpod×8sn;160/80/60sn bekleme. Reallocate hâlâeksik |
| Solace Plus | Gerçek azamiHP'nin%50'sini anlık tamir;90sn bekleme, NanoHull'a dokunmaz; kaynaklı%15kalkan pasifi |
| Liberator Plus | 10sn×35.000HP/sn;100sn bekleme. Özel SelfRepairgörselinin başlatma yolu henüz bağlanmadı; gerçekHP/HUD/timerçalışır |
| Solaris/Solaris Plus | 10sn boyunca600yarıçapta10k/15khasar/sn; korumalıNPCatlamaz. Kapatılabilir;90/80sn bekleme kapanınca başlar |
| Solaris Plus pasifi | Takılı uyumlu gemi modülü başına%3silah hasarı, en fazla%12; aktif konfigürasyonla değişir |
| Citadel Plus Prismatic Endurance | 25sn boyunca gelen lazer hasarında%80azalma; roket hasarına aynı azalma uygulanmaz;200sn bekleme |

Cooldownlar kalıcıdır. Aynı gövde/oturum/harita kontrol edilir; ölüm, harita değişimi, warp ve çıkış bütün aktif efektleri/podları temizler. SolacePlus HPve cooldown'u aynı transaction'da kaydeder; SQLhatası sahte iyileştirme üretmez. Solarisalan hasarı gerçek öldürme/ödül/kargo yolunu kullanır; tekilleştirme kapı katmanında korunur. Yetenek hasarı silah booster'ıyla büyütülmez.

Native kanıtlar: `AbilityEffectActivationCommand`, `AbilityEffectDeActivationCommand` (büyükAkritik), `AssetCreateCommand/AssetRemoveCommand`, `VisualModifierCommand`87Incinerate/105PrismaticEndurance ve ilgili2D/3Dassembly. SWFdeğişmedi. Liberatorözel efekti, grup tamirleri, bazı menzil/hasar birleştirme ayrıntıları ayrı açık kalır. Aegispod10sn veElit15sn seçilmiş istemci sürümündendir; eski resmî forum tartışmasındaki9sn/13.5sn tablosuyla karıştırılmamalı.

Kaynaklar: [Plus ilk güncelleme](https://board-en.darkorbit.com/threads/faq-ship-plus-update-upgrade-your-ships.127618/), [Solace/Solaris Plus](https://board-en.darkorbit.com/threads/faq-ship-plus-update-solace-and-solaris.127809/), [Solaris10k dengelemesi](https://board-en.darkorbit.com/threads/darksilver-pirates-expansion-faq.127449/), [yetenek hasarı silah bonusuyla büyümez](https://board-en.darkorbit.com/threads/hellstorm-rocket-launchers-faq.893/).

### ALB-X / RB-X seçimleri

Hangardaki orijinal CPUcephane seçim penceresi `setAbCpuAmmo` ile sunucuya bağlı. Her sahip olunan CPU'nun seçimi ayrı kalıcıdır; `properties.attachedAmmo` istemciye geri döner. ALB:LCB10/MCB25/MCB50/SAB50. RB:R310/PLT2026/PLT2021/PLT3030/ECO10. Sonuncusu roketatar cephanesidir. Ateşlenen lazer/tekli roket seçimi değişmez. Aktif konfigürasyondaki CPU yalnız seçilmiş stoğu gerçek fiyatıyla tamamlar; kapalıCPU/pasifconfig/azpara satınalım yapmaz. Sahipsiz kimlik ve yanlış cephane kategorisi reddedilir. Kaynak `inventory.swf PopUp.createAutoBuy*Components`, `ConnectionProxy.cpuModeChange`, `Inventory.properties.attachedAmmo`.

## Doğrulama ve devam

939/939test,352JS/0hata. `tests/pet-purchases.test.js`, `ship-abilities-expanded.test.js`, `cpu-ammo-selection.test.js`20yenitesttir; önceki lazer/modül/kargo testleri de geçer. Gerçek HTTP/TCP23.027komutPASS (`logs/solo-completion-network.log`): yeniHPalımı, orijinalunlockSlot veCPUmodeisteği, üçgövde satınalımı/nativeyetenekbutonu, Aegis20ktamir/Solace+native140/Solaris+87gerçekhasar. İlk izole ağ denemesi, testte bir saniye ileri alınan lastCombat'ın çıkışı iptal etmesi nedeniyle tamamlanmadı; QAfixturetemizliği düzeltildi ve tam senaryo baştan geçti. Üretim hatası diye raporlama. Bu teşhis sırasında yalnız bellekDB'si kanıtlanan test süreci kayıtla kapatıldı.

Ayrı headlessPETsayfasında HP/fuel görselleri2/2yüklendi, HPkartı5.000U.seçili: `logs/pet-progression-preview/shop.png` ve `report.json`. Kullanıcının Qt/Flash penceresine girdi verilmedi; bu ekran içi oyun görsel kabulü yerine geçmez.

Bu çalışma bütün kalan işlerin bittiği anlamına gelmez. Güncel sıra/kapsam [eksik listesinde](remaining-work-current.md); HEATveHeatRelease, diğer modern yetenekler, görevler, modern pencereler, kaynak doğrulama boşlukları ve Qt/offlinekabul sürer. Kaynağı belirsiz orijinal sayılar uydurulmadı. Dağıtım ve DBkorunumu sonucu aşağıya eklenir.

**Dağıtıldı: PID21516**, soloHTTP8095/TCP8096, healthOK. PID16180 kayıt işleyicisiyle kapatıldı; son kayıt sonrası WALuyumlu yedek `backups/darkorbit-before-2026-10-24T11-54-29-347Z.db`. Yeniden başlatma sonrasında60tablonun bütün kolon/satırları aynı; değişen tablo yok.3hesap/3oyuncu/14gemi/integrityOK/FK0. Yeni migration/hesap hediyesi/para iadesi yok. `logs/solo-completion-production-check.json`. MAIN SHA256 `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824`, cache aynı. Yeni menüleri almak için oyun yeniden açılmalı.
