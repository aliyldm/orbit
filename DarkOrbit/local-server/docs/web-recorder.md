# Web portalı kaydı (Aşama 1)

`tools/web-recorder.mjs` canlı launcher'ın DevTools portuna tarayıcı seviyesinde bağlanır ve
`*.darkorbit.com` trafiğini maskeleyerek `logs/web/<YYYYMMDD-HHMMSS>/` altına yazar. Aşama 2'de bu
kayıtlar portal sayfalarının local kopyası için kaynak olacak. `tools/summarize-web.mjs` bir kaydı
sayfa → uç → form alanı tablosuna çevirir.

> Kayıtlar maskelenmiş olsa da kişisel veri (pilot adı, envanter, mesajlar) içerir. `logs/` local
> kalır; paylaşmayın, commit'lemeyin.

## Ne kaydedilir

| Trafik | Kayıt |
|---|---|
| `*.darkorbit.com` — Document (sayfa HTML'i), XHR/Fetch, `flashAPI/*.php`, `ajax/*.php`, script/css/görsel | istek başına JSON + cevap gövdesi (metin maskeli; ikili gövde `bin/` altına) |
| Form POST'ları | maskeli gövde + alan adları (`formFields`) |
| Yönlendirmeler (30x) | her atlama ayrı kayıt, `redirect` alanında hedef |
| CDN `*.bpsecure.com` (`darkorbit-22.bpsecure.com`) | **yalnızca** URL listesi (`index.json` → `cdn`, sorgu kısmı atılır) |
| Diğer hostlar (deltadna, infinicast...) | yalnızca host adı ve sayı (`index.json` → `otherHosts`) |

İstek dosyası (`0001_GET_indexInternal.es.json`) alanları: `seq`, `time`, `page` (sayfa anahtarı,
ör. `gb1.darkorbit.com/indexInternal.es?action=internalDock`), `pageUrl`, `type`, `method`, `url`,
`requestHeaders` (yalnızca content-type/referer/x-requested-with), `requestBody`, `formFields`,
`loginPost`, `status`, `contentType`, `responseHeaders` (content-type/location/content-length),
`redirect`, `responseBody` veya `responseBodyFile`, `error`.

`index.json`: sayfa başına `endpoints` (`"POST gb1.darkorbit.com/ajax/shop.php": 3`), `formPosts`
(uç → alan adları), `files`; ayrıca `cdn` ve `otherHosts`. Kayıt sürerken saniyede bir güncellenir.

## Maskeleme

- `Cookie`, `Set-Cookie`, `Authorization` başlıkları hiç yazılmaz (başlıklar beyaz listeyle tutulur).
- Adı `sid|dosid|session|token|hash|auth|pass|secret|key|signature` içeren değerler `REDACTED` olur:
  URL sorgusu, form gövdesi, flashvars (`&amp;` dahil), JSON/JS (`"x": "..."`, `x = '...'`),
  HTML öznitelikleri, `<input name="sid" value="...">`, XML `<sid>...</sid>`.
- Çerez değerleri (`dosid` vb.; `Storage.getCookies` ile 5 sn'de bir, ayrıca Set-Cookie ve gönderilen
  çerezlerden öğrenilir) tüm URL ve gövdelerde **tam eşleşmeyle** `REDACTED_COOKIE` yapılır
  (URL-encoded hali dahil).
- 32+ haneli hex dizgileri `REDACTED_HEX` olur (oturum kimlikleri bu biçimde).
- Login POST'u (alan adında `pass/username/login/email` geçen veya URL'si login/auth olan POST)
  gövdesi hiç yazılmaz: `"[LOGIN POST GÖVDESİ KAYDEDİLMEDİ]"`, `formFields: []`.
- Bilinen yan etki: ad eşleşmesi geniş tutuldu (`key` → `keywords`, `onkeyup`; hex kuralı →
  `__cv` gibi önbellek damgaları). Aşama 2'de bu yerler local değerlerle doldurulmalı.

Maskeleme birim testi (canlı bağlantı gerektirmez):

```bash
node tools/web-recorder.mjs --self-test
```

## Kullanım

1. **Launcher'ı DevTools portuyla aç** (PowerShell, `D:\drk` klasöründen; Flash yolu göreli):

   ```powershell
   cd D:\drk
   $env:QTWEBENGINE_REMOTE_DEBUGGING = '127.0.0.1:9333'
   .\DarkOrbit_live.exe --ppapi-flash-path=./HCSFP32.dll --ppapi-flash-version=26.0.0.137 --disable-bundled-ppapi-flash
   ```

   Launcher komut satırı bayraklarını Chromium'a iletmiyorsa aynısını ortam değişkeniyle verin:
   `$env:QTWEBENGINE_CHROMIUM_FLAGS = '--ppapi-flash-path=./HCSFP32.dll --ppapi-flash-version=26.0.0.137 --disable-bundled-ppapi-flash'`.
   Port açık mı: `curl http://127.0.0.1:9333/json/version`.

2. **Girişi kendiniz yapın** (kaydı girişten önce de başlatabilirsiniz; login POST gövdesi zaten yazılmaz).

3. **Kaydı başlatın** (`local-server` klasöründen, ayrı bir terminalde):

   ```bash
   node tools/web-recorder.mjs --port 9333
   ```

   Seçenekler: `--host 127.0.0.1`, `--out logs/web`, `--duration <sn>` (verilmezse Ctrl+C'ye kadar).
   Mevcut sekmelere ve sonradan açılan sekme/pencerelere/iframe'lere otomatik bağlanır.

4. **Sayfaları gezin** (aşağıdaki liste). Her sayfada birkaç saniye bekleyin, sekmeleri/alt
   sekmeleri tıklayın ki ajax uçları da tetiklensin. Satın alma/ilerletme gibi geri alınamaz
   düğmelere basmayın; yalnızca listeleme/önizleme.

5. **Durdurun**: Ctrl+C (bekleyen gövdeler alınır, `index.json` yazılır).

6. **Özet**:

   ```bash
   node tools/summarize-web.mjs logs/web/<oturum>
   ```

   `--json` makine okunur çıktı verir.

## Gezilecek sayfalar

`action=` adları `indexInternal.es?action=...` biçimindedir. `internalStart` ve
`internalMapRevolution` canlıda görüldü (docs/live-observation.md); diğerleri beklenen adlardır,
gerçek değerleri kayıttan okuyun.

| Sayfa | Beklenen `action` | Dikkat |
|---|---|---|
| Ana sayfa | `internalStart` | haber kutuları, günlük ödül |
| Hangar | `internalDock` | gemi/ekipman/drone sekmelerinin hepsini açın |
| Dükkan | `internalDock...` / `internalShop` | her kategori sekmesi; satın alma yok |
| Galaxy Gate | `internalGalaxyGates` | kapı seçimi, enerji ekranı; spin yok |
| Skylab | `internalSkylab` | modül listesi; yükseltme başlatmayın |
| Görevler | `internalQuests...` | aktif/tamamlanmış görev sekmeleri |
| Pilot profili / Klan / Ayarlar | `internalPilotSheet`, `internalClan...`, `internalSettings` | isteğe bağlı |
| Oyuna giriş | `internalMapRevolution` | `flashAPI/*.php`, `spacemap/xml/maps.php`, `profile.xml` cevapları |

Kayıttan sonra `summarize-web.mjs` çıktısındaki `SAYFALAR` tablosu hangi sayfaların yakalandığını
gösterir; eksik kalanları ikinci bir oturumla tamamlayın.
