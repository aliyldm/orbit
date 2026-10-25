# Oyun soketi protokolü

Kaynaklar: canlı oturum kaydı (`tools/relay.js`) ve istemci kodu (`spacemap/main.swf`, JPEXS ile decompile).
Tüm kayıtlı paketler (3563/3563) şema ile çözülüp birebir aynı baytlarla yeniden üretilebiliyor.

## Çerçeve

| Yön | Uzunluk öneki |
|---|---|
| istemci → sunucu | ilk paket `uint32 BE`, sonrakiler `uint24 BE` |
| sunucu → istemci | `uint24 BE` |

Gövde: `[int16 modül ID][alanlar]`. Modül ID'leri işaretli (ör. `-5398`).

Sunucu birden çok paketi tek kapta gönderebilir:
`ff ff "DOB3" | uint32 açık boyut | uint32 CRC32(açık veri) | LZ4 bloğu`. Açılan veri aynı `uint24` çerçeveli paketleri içerir.
İstemci girişte `do-lz4-block-v3` talep eder; local sunucu sıkıştırmasız düz çerçeve gönderir ve istemci bunu kabul ediyor.

## Alan kodlaması

Her paket sınıfının `read()` metodu `game/codec/schema.json`'a çevrildi (`tools/gen-codec.js`):

- `int`: 32-bit; çoğunda sınıfa özgü bit rotasyonu (ör. `MoveRequest.positionX` 11 sağa).
- `short`/`byte`: 16/8-bit rotasyon ve işaret düzeltmesi olabilir.
- `utf`: `uint16` uzunluk + UTF-8.
- `module`: `int16` ID + o sınıfın alanları; ID 0 = boş.
- `vector`: `byte/short/int` uzunluk + elemanlar.
- Kalıtım: alt sınıf önce üst sınıfın ID'sini (`int16`) yazar, sonra üst alanlar, sonra kendi alanları.

`game/codec/codec.js`: `decode(gövde)` → `{ _: 'SınıfAdı', alan: değer }`, `encode(nesne)` → gövde.

## Akış (kayıttan)

1. `VersionRequest {version}` → `VersionCommand {version, equal:true}`
2. `LoginRequest {userID, factionID, sessionID, version:"do-lz4-block-v3", instanceId, isMiniClient}`
3. Sunucu açılış paketleri: `UserSettingsCommand`, `UserKeyBindingsUpdate`, `UILayoutCommand`, `LegacyModule` ("0|A|BK…" eski metin komutları), `ShipInitializationCommand`, görev/envanter/harita nesneleri…
4. Hareket: istemci `MoveRequest {positionX, positionY, targetX, targetY}` gönderir; kendi gemisini yerel olarak hareket ettirir. Sunucunun bu oyuncuya özel cevabı gözlenmedi; `MoveCommand` diğer varlıkların hareketidir.

## Araçlar

| Araç | İş |
|---|---|
| `tools/relay.js` | canlı soketi aktarır ve kaydeder (yalnızca oturum anahtarı maskeli) |
| `tools/decode-session.js` | kaydı zaman sıralı paket listesine çevirir, DOB3 kaplarını açar |
| `tools/dump-session.js` | paketleri adlandırılmış komutlar olarak döker (`--only`, `--from/--to`, `--json`) |
| `tools/gen-codec.js` | decompile edilmiş sınıflardan şemayı üretir |
| `tools/build-bootstrap.js` | harita açılış paketlerini `game/replay/bootstrap.json`'a yazar |

## Gizlilik

`logs/` ve `game/replay/bootstrap.json` canlı oturumdan gelen veriler içerir: oyuncu ve diğer oyuncuların adları, hesap değerleri.
Bu dosyaları paylaşmayın.
