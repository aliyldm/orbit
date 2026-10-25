# Kısayollar, diroit görünümü, hangarlar ve P.E.T.

21 Ekim 2026. Yerel tek oyunculu sürüm; Qt başlatıcısı yeniden yazılmadı.

## C ve M

Özgün `ChangeConfingCommand.execute` C için `S|CFG|<1/2>|...` gönderiyordu. Sunucu yalnız `ConfigChangeRequest` dinliyordu. İki yol artık aynı doğrulanmış aktif oturum/gemi işlemini kullanır; iki konfigürasyonun ekipman/kalkan kayıtları korunur, ardından özgün `0|S|CFG|n` cevabı gelir. Paket içinde gönderilen başka kullanıcı kimliği işlem sahibini değiştiremez. Geçersiz hedef, ölü oyuncu ve atlama sırasında değişiklik yapılmaz.

Bu istemcinin `UserKeyBindingsModule` türlerinde harita açma eylemi yoktur. `KeyboardMapper.activateKey` yalnız boşta olan M için mevcut `createSpaceMapWindow` ve `TOGGLE_WINDOW_BY_ID` yolunu çağıracak şekilde yamalandı. Böylece aynı **Yıldız sistemi** penceresi açılır/kapanır; HTML harita veya yeni pencere oluşturulmaz. Kullanıcının M'ye atanmış başka eylemi varsa ona öncelik verilir. `EventManager` kilit, metin alanı ve basılı tuş tekrarı kontrolleri aynen korunur.

`tools/patch-map-hotkey.js` gerçek kurulu MAIN üzerinden tek sınıfı derler; kaynak, derleme ve tekrar decompile kanıtları `decompiled/map-hotkey-patch/` içindedir. Önceki diroit HUD yaması korunur. 256 ABC dışı varlık etiketi aynı; yalnız bir DoABC etiketi değişmiştir. Kurulu SHA256: `a3d3e67288f6c4d9f4a1550eb46c91165a1a77e0f6d896ef00432bb7860d25e8`. MAIN önbellek anahtarı değiştirildi; açık eski Flash örneği tamamen kapatılmalıdır.

## Diroitleri gizleme

Genel `displayDrones=false` artık kendi diroit alanını da false yapar. Eski kayıtlı genel-kapalı/kendi-açık birleşimi girişte normalize edilir. Bu, kullanıcının genel kutudan bütün modelleri kapatabilmesi için yerel kullanım tercihidir; özgün iki bayrak aslında bağımsızdır. Genel açıkken kendi diroitleri ayrıca kapatılabilir.

Başarılı kayıt cevabı gerçek native `DisplaySettingsModule`'dür. İstemcide bu iki BindableBoolean 2D bütçe/yeniden kurma ve 3D model temizleme işleyicilerini tetikler. HUD'da özgün `Drones.simpleDroneRepresentation` kullanılır: F/I/A/Z, gerçek Havoc kırmızısı ve Hercules mavisi; modeller gösterilirken kısa satır kaldırılır. Diroit sayısı ve sahipliği değiştirilmez. Ayrıntılar: `settings-runtime-local.md`.

## Doğrulama sınırı

Kısayol/ayar testleri gerçek codec, oturum ve SQLite kullanır. MAIN yaması derlenip tekrar decompile edilmiştir. Bunlar gerçek Flash penceresinde görsel uçtan uca kontrol yapıldığı anlamına gelmez; bu oturumda açık istemciye CDP bağlantısı bulunamadı.

Hangar satın alma/seçim/atama akışı [native-hangars.md](native-hangars.md), PET durum ve geri çağırma akışı [pet-native-state-sync.md](pet-native-state-sync.md) içinde tamamlanmıştır. Hangar satın alma ve atama ayrıca bellek içi test hesabıyla tarayıcıda kontrol edildi. Güncel **725 test / 247 JS / 16.529 gerçek ağ komutu** kaydı ve kalan işler [latest-local-validation.md](latest-local-validation.md) içindedir.
