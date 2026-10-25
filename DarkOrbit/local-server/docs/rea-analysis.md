# REA ile yapılan analizler

Bu belge, projede REA (Ghidra 12.1.4 tabanlı tersine mühendislik aracı) ile yapılan statik analizlerin
bulgularını ve bu bulgulara dayanan yamaları toplar. Kaynak: oturum kayıtlarındaki REA çağrıları ve sonuçları.
SWF'lerin (main.swf, inventory.swf…) çözümlemesi REA ile değil JPEXS decompiler ile yapıldı; o kısım
`client-map.md` ve `protocol.md`'de.

## 1. DarkOrbit.exe (launcher)

| | |
|---|---|
| Dosya | `D:\drk\DarkOrbit.exe` (yamasız kopyası `DarkOrbit.exe.orig`) |
| SHA-256 (orijinal) | `c411adf3089a40fbef39cca360683673312340e29651df933b6039293dbcb9b4` |
| Biçim | PE, x86 (32 bit), image base `0x400000` |
| Bölümler | `.text` 0x401000–0x422a00 (137 KB), `.rdata` 0x423000–0x444e00, `.data`, `.rsrc` 0x447000–0x451200, `.reloc` |
| Boyut | 553 fonksiyon, 974 dize |
| Sürüm | Launcher 1.6.9, "(C) Bigpoint GmbH 2017" |

### Mimari
- Qt5 uygulaması: `QMainWindow` + `QWebEngineView` (Chromium) + Flash PPAPI eklentisi (`HCSFP32.dll`, Harman).
- Sınıflar (RTTI adlarından): `LauncherWindow`, `LauncherConfig`, `GameConfigParser`, `BrowserConfigParser`,
  `LoginMenuWindow`, `PasswordWindow`, `PasswordEditWindow`, `WebPopupWindow`, `BPRequestInterceptor` (`URLInterceptor` ad alanı).
- Gömülü Qt kaynakları: `:/ConfigResources/ConfigFiles/GameConfig.xml` ve `BrowserConfig.xml`.

### GameConfig.xml (gömülü)
- `<GameURL>https://darkorbit.com</GameURL>`: launcher'ın açılışta yüklediği adres. `<!-- <GameURL>chrome://gpu</GameURL> -->` yorum satırı da var.
- `<GameName>Dark Orbit</GameName>`, `<ID>175</ID>`, `<Version>1.6.9</Version>`, `<WindowLogo>icons_DarkOrbit.ico</WindowLogo>`
- `<ScreenResolution>` 1366×768
- `<BetaUrls>`: iç test adresleri (`test1…test6.darkorbit.com`, `acp.darkorbit.com/acp/`, `chwu-darkorbit-*.bpdevsys-22-darkorbit-01.bigpoint.net`)
- DeltaDNA telemetrisi: `<DdnaURL>https://collect16086drkrb.deltadna.net</DdnaURL>` ve canlı/test ortam anahtarları.

### BrowserConfig.xml (gömülü): Chromium bayrakları
Zorunlu parametreler (launcher bunları `QTWEBENGINE_CHROMIUM_FLAGS` ile Chromium'a veriyor):
```
--ppapi-flash-path=./HCSFP32.dll
--ppapi-flash-version=26.0.0.137
--disable-bundled-ppapi-flash
--default-background-color=000000ff
--enable-accelerated-2d-canvas
--ignore-gpu-blacklist
--in-process-gpu
-platform windows:altgr
```
**Önemli ders:** `QTWEBENGINE_CHROMIUM_FLAGS` ortam değişkeni dışarıdan ayarlanırsa launcher'ın bu bayraklarının
üzerine yazılır ve Flash hiç yüklenmez ("Bu eklenti desteklenmiyor"). Bu değişken ayarlanacaksa yukarıdaki Flash
bayrakları da eklenmelidir. (Başta sertifika sorunu sanılan hatanın gerçek sebebi buydu.)

### Ağ ve davranış
- User-Agent'a `BigpointClient/1.6.9` ekleniyor (`QWebEngineProfile::setHttpUserAgent`), sunucu logunda doğrulandı.
- `BPRequestInterceptor` (`QWebEngineUrlRequestInterceptor`): `FUN_004183e0` (0x4183e0) her isteğin
  `requestMethod`, `firstPartyUrl`, `requestUrl`, `navigationType` ve `resourceType` değerlerini okuyor;
  `FUN_00418690` ile URL'yi bir desen listesine karşı sınıyor. Eşleşen ana çerçeve gezinmeleri (navigationType=0, resourceType 0/1)
  engellenip sistem tarayıcısında açılıyor. Desenler:
  - `.*://.*\.discord\..*`, `.*youtube\..*`, `.*twitter\..*`, `.*pinterest\..*`, `.*meinextraplus\..*`, `legal.bigpoint`, `www.bigpoint.ne*`
  - forum: `.*:.*board-.*\.darkorbit\..*`, `.*\.darkorbit\..*/.*\.redirectToBoard`, `bp-game-login`
  - facebook ve diğer Bigpoint oyunları (farmerama, seafight, skyrama, piratestorm)

  **Sonuç:** localhost bu listede yok, local sunucu engellenmiyor.
- `jshelper`: launcher sayfalara `QWebChannel` ile `window.jshelper` nesnesini enjekte ediyor (konsolda "jshelper is awesome").
  Giriş sayfasına bu betiği ekliyor: `$('#bgcdw_login_form_username').val("%1"); $('#bgcdw_login_form_password').val("%2");`.
  Bu yüzden local `login.html` aynı seçicileri (`#bgcdw_login_form_username`, `#bgcdw_login_form_password`, `.bgcdw_login_form`,
  `.bgcdw_remember_me_checkbox`) ve küçük bir jQuery taklidini (`mini-jquery.js`) içeriyor. Oyun sayfasında launcher
  `saveUserID(userId, instanceId)` çağrısını bekliyor.
- Açılışta `maintenancetool --checkupdates` çalışıyor (güncelleme deposu `darkorbit-22-client.bpsecure.com`).
  Güncelleme bulunursa "An update is available. Please update the application before proceeding." diyerek engelleyebilir.
- Süre dolumu dizeleri: "Launcher expired", "Unfortunately this application has expired."
- Diğer dizeler: "Clear Cache" / "Cache is cleared", kimlik bilgisi saklama ("Error loading credentials…"), `exitLauncher`,
  "URL changed to: %1", "Title changed to: %1".
- "Start" ile açılan oyun penceresi `WebPopupWindow` (aynı launcher içinde ayrı pencere).

### Yapılan yama: GameURL
- Gömülü `GameConfig.xml`'deki `<GameURL>https://darkorbit.com</GameURL>` aynı uzunlukta (21 bayt)
  `http://127.0.0.1:8095` ile değiştirildi. **File offset `0x277b1`.**
- Orijinal: `DarkOrbit.exe.orig`. Canlıya bağlanmak için yamasız kopya: `DarkOrbit_live.exe`.
- Yama Authenticode imzasını bozuyor; launcher kendi imzasını kontrol etmiyor (pratikte çalışıyor).

## 2. HCSFP32.dll (Harman Flash Player, PPAPI)

| | |
|---|---|
| Dosya | `D:\drk\HCSFP32.dll` (yamasız kopyası `HCSFP32.dll.orig`) |
| SHA-256 (orijinal) | `ea298dc33d3de089709475d3dd63128ac0a334fdd6ff1e172e22b392da007f73` |
| Biçim | PE, x86 DLL, ~15 MB, Flash sürümü 26.0.0.137 |

### Sorun
Launcher localhost'u açınca Flash, local SWF'yi yüklemeyi reddediyordu:
```
HCSFP32.dll: TRACE: *** Flash Player: Root Movie Blocked ***
'http://127.0.0.1:8095/client/spacemap/preloader.swf'
```
Harman'ın kurumsal Flash sürümü kök SWF'yi yalnızca izin verilen (imzalı/https) kaynaklardan ve deneme süresi
içinde çalıştırıyor. Kullanıcı sertifika eklemek istemediği için HTTPS yolu kullanılmadı.

### Bulgular
- Engelleme mesajı `0x10068f69` civarında basılıyor; hemen öncesinde (`0x10068d1b`) URL kontrolü yapılıyor.
  Bu bölge Ghidra'nın fonksiyon sınırlarına düşmediği için (`not_in_procedure`) dize ve bayt düzeyinde incelendi.
- Aynı bloğun yakınında `"Flash Player evaluation period has expired"` dizesi var.
- **VA `0x10069a0e` (file offset `0x68e0e`)**: koşullu dal `75` (JNZ). Bu dal kök SWF için iki kontrolü birlikte yönetiyor:
  deneme süresi ve URL izin listesi. Dal sonrası baytlar: `8d 4c 24 10 e8 02 91 01 00 83 be b8 00 00 00 00 0f 84 d8 00 00 00 …`

### Yapılan yama
- File offset `0x68e0e`: `75` → `EB` (koşullu dal → koşulsuz JMP). İki kontrol de atlanıyor ve localhost'tan gelen SWF yükleniyor.
- Orijinal: `HCSFP32.dll.orig`. Yama sonrası preloader.swf → loadingscreen.swf → main.swf local'den yüklendi (doğrulandı).

## 3. REA çağrı listesi (özet)

| Hedef | Araçlar | Amaç |
|---|---|---|
| DarkOrbit.exe | `open_binary`, `binary_overview`, `search_strings`, `list_strings`, `inspect_pe_resources`, `inspect_signature` | Genel yapı, gömülü XML'ler, URL ve Qt sınıfları |
| DarkOrbit.exe | `xrefs` (0x427874, 0x42660d, 0x424ab5), `search_procedures`, `resolve_containing_procedure` (0x4185e7), `procedure_pseudo_code` (0x4183e0), `procedure_callers` | `BPRequestInterceptor` mantığı, URL desen kontrolü |
| HCSFP32.dll | `open_binary`, `binary_overview`, `search_strings`, `resolve_containing_procedure` (0x10068f69, 0x10068d1b), `inspect_native_instruction`, `read_function_instructions`, `read_bytes`, `inspect_with_objdump`, `analyze_function` | "Root Movie Blocked" ve deneme süresi kontrolünü bulup tek baytlık yamayı belirlemek |

Toplam yaklaşık 45 REA çağrısı yapıldı (tekrar denemeler hariç). Ham sonuçlar oturum kayıtlarında duruyor; burada yalnızca sonuçlar özetlendi.

## 4. REA'dan sonra yapılan diğer çözümlemeler (REA dışı)

- **main.swf** (JPEXS ile decompile, `local-server/decompiled/main`): oyun protokolü, 1352 komut sınıfı → `tools/gen-codec.js`
  ile `game/codec/schema.json` üretildi. Ayrıntılar `protocol.md`.
- **43 SWF daha** (`decompiled/swf_global/...`): `inventory.swf` (portal hangarı, `flashAPI/inventory.php`), yükleme ekranı vb.
  Ağ/oyun mantığı yalnızca main.swf'de. İstemci haritası `client-map.md`.
- **Canlı trafik**: `tools/relay.js` (oyun soketi) ve `tools/web-recorder.mjs` (portal, DevTools) ile kaydedildi.
