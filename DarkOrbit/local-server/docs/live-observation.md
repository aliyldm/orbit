# Canlı sunucu gözlemi (2026-10-17)

Orijinal launcher (`DarkOrbit_live.exe`, `DarkOrbit.exe.orig` kopyası) `QTWEBENGINE_REMOTE_DEBUGGING=127.0.0.1:9222`
ile açıldı. Kullanıcı girişi kendisi yaptı; DevTools'a giriş **sonrası** bağlanıldı. Oturum ID'si, hash'ler ve board token'ı
maskelendi, bu dosyada yer almıyor.

Kapsam: sadece HTTP(S) / sayfa seviyesi. Flash'ın TCP oyun soketi DevTools'ta görünmez; o kısım gözlenmedi.

## Sayfa akışı

- Giriş → `https://gb1.darkorbit.com/indexInternal.es?action=internalStart`
- Oyun → `https://gb1.darkorbit.com/indexInternal.es?action=internalMapRevolution` (başlık "Darkorbit | Game Client")
- Flash eklentisi: `Shockwave Flash HCSFP32.dll` (navigator.plugins'te görüldü).

## Embed

```html
<object id="preloader" type="application/x-shockwave-flash" width="100%" height="100%"
        data="{cdn}/spacemap/preloader.swf?__cv=...">
  <param name="allowfullscreen" value="true">
  <param name="allowscriptaccess" value="always">
  <param name="quality" value="high">
  <param name="wmode" value="gpu">
  <param name="bgcolor" value="#000000">
  <param name="allowFullScreenInteractive" value="true">
  <param name="flashvars" value="...">
</object>
```

Flashvar adları `config.json` → `client.flashvars` içinde (değerler local'e uyarlandı).
Canlıda: `cdn=https://darkorbit-22.bpsecure.com/`, `host=https://gb1.darkorbit.com`, `basePath=spacemap`,
`gameclientPath=spacemap`, `chatHost=eps.optimist.darkorbit.infinicast.io:7771`, `pid=502`, `platform=PC_CLIENT`.

## İstemcinin yüklediği ana dosyalar (CDN = darkorbit-22.bpsecure.com)

Zincir: `spacemap/preloader.swf` → `spacemap/loadingscreen.swf` → `spacemap/main.swf`

- XML: `spacemap/xml/resources.xml`, `resources_3d.xml`, `resources_3d_particles.xml`, `assets_loadingScreen.xml`,
  `do_img/global/xml/resource_items.xml`, `resource_achievements.xml`, `resource_events.xml`, `resource_jumpgate.xml`,
  `spacemap/graphics/maps-config.xml`, `spacemap/graphics/spacemap-config.xml`, `resources/resource_command_center.xml`
- Grafik/ses: `spacemap/graphics/**.swf` (lasers, rockets, engines, ui, windows...), `spacemap/audio/**.swf`
- Görseller: `do_img/global/**`

## Oyun sunucusu (host) endpoint'leri

| Endpoint | Not |
|---|---|
| `{host}/spacemap/xml/maps.php` | harita listesi; büyük olasılıkla oyun sunucusu adresini de verir (doğrulanmadı) |
| `{host}/spacemap/xml/profile.xml` | oyuncu profili |
| `{host}/flashAPI/loadingScreen.php`, `dailyLogin.php`, `brNews.php` | yükleme ekranı, günlük ödül, haberler |
| `{host}/crossdomain.xml` | Flash HTTP policy |
| `{host}/eurostileFonts.swf` | font |
| `{host}/ajax/messaging.php` | mesajlaşma sayfası |
| `{cdn}/unityApi/events/spaceSearch.php`, `ssRewards.php` | etkinlik API'leri |

Diğer hostlar:
- `eps-gameserver.optimist.darkorbit.infinicast.io`: oyun sunucusu adayı (sayfada görüldü; port/protokol gözlenmedi)
- `eps.optimist.darkorbit.infinicast.io:7771`: chat
- `collect16086drkrb.deltadna.net`: telemetri (local'de gereksiz)

## Açık sorular

1. `maps.php` / `profile.xml` / `loadingScreen.php` cevaplarının içeriği (gövdeler kaydedilmedi).
2. Oyun soketinin portu, TLS kullanıp kullanmadığı ve paket formatı. Paket yakalama için `pktmon` (yönetici yetkisi) veya Wireshark gerekir.
3. `__cv`/hash parametreleri local'de sabit değerle çalışır mı?
