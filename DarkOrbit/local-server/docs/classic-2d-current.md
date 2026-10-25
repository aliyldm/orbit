# 2D görünüm ve grafik kalitesi — 23 Ekim 2026

İstek: 2D'yi mevcut özgün DarkOrbit istemcisinin görünümüne göre, kalite farklarını da gözeterek ayarlamak. Bu çalışma güncel yerel Flash sürümünün kaynak/asset davranışını korur; bütün tarihî DarkOrbit sürümlerinin aynı olduğu iddia edilmez.

## Uygulanan değişiklik

Sunucu artık `ReadyRequest` içindeki gerçek harita renderer'ını kaydeder: MAP_LOADED_2D=0 → renderer2; MAP_LOADED_3D=1 → renderer1. UI_READY=2 renderer değiştirmez. Daha önce yalnız girişte istenen tercih kullanılıyordu; Flash 3D yerine 2D'ye düşerse kısa mesafeli roket hasarı 2D'nin500ms süresi yerine 3D'nin1000ms minimumuyla işlenebiliyordu. Artık sahnenin gerçek modu esas alınır. Ayarlarda sonraki açılış tercihini değiştirmek mevcut sahneyi/füzeyi retime etmez. Eski oturum/geçersiz ready istekleri reddedilir. Mevcut cloak resync aynı yolda korunur.

`asd` / oyuncu2 için yalnız `DisplaySettingsModule.displayUse2d` false→true yapıldı. Mevcut gemi/saldırı kalitesi3, diğer kalite ayarları ve otomatik kalite azaltma tercihi korundu. Diğer hesabın ayarları, paralar, eşyalar ve ilerleme değiştirilmedi. `decompiled/classic-2d-audit/account-setting-change.json` değişimi ve48tabloda yalnız beklenen ayar farkını kaydeder.

## Korunan native kalite davranışı

Kurulu MAIN'den beş ilgili sınıf yeniden JPEXS26.3 ile dışa aktarıldı: SettingsWindowFUIProxy, SettingsWindowFUISaveSettingsCommand, Ship2D, ShipClip, LaserSalvo2D. Kaynaklar `decompiled/classic-2d-audit/current/`, kaynak hash'leri `evidence.json` içinde.

| Önayar | Arka plan | Bölgeler | Gemi | Motor | Patlama | Kutu/maden |
|---|---:|---:|---:|---:|---:|---:|
| Düşük |0|0|0|0|0|0|
| Orta |1|1|0|1|1|0|
| İyi |2|3|3|2|1|3|
| Yüksek |3|3|3|3|3|3|

Kaynak: `SettingsWindowFUIProxy.updateModelWithDisplayQualityPresetting`. GPU desteği yoksa yüksek arka plan native kod tarafından2'ye indirilir. Gelişmiş/özel ayarlar ayrı değerlerini korur; sunucu bütün seviyeleri zorla yükseğe çekmez. Otomatik kalite azaltma istemcinin kendi kontrolünde bırakılır.

`Ship2D.updateShipClip`: gemi kalitesi0'da `replacementShips` sade çizimi; >0'da gerçek `display2D.srcKey` SWF ve yön kareleri. `ShipClip` dönüş açısını o karelere bağlar. Yüksek ayardaki açılı gemiyi elde etmek için 3D kamerayı eğmek veya gövdeye dönüşüm uygulamak gerekmez. Mevcut Spectrum/Solace açılı asset kanıtları [klasik 2D incelemesinde](classic-2d-evidence.md) korunur. Düşük/orta önayarda sade çizime dönülmesi hatalı ayar sayılmaz.

Lazer ses/animasyonu değiştirilmedi: 2D normal salvo yolu native sesini tur başında çalar; namlu grupları mevcut istemci takvimini kullanır. Düşük gemi kalitesinde kalkan vuruş ayrıntısı sadeleşir. RSB'nin3sn beklemesi, normal lazerin1sn hasar turu, ArGe kalın lazer bayrağı ve gemiye özgü namlu noktaları korunur. Önceki [lazer ritmi denetimi](laser-cadence-current.md) geçerlidir. Görüntü kalitesi ile hasar/cephane hesabı birbirine bağlanmadı.

## Doğrulama ve dağıtım

- `logs/classic-2d-focused.log`:28/28 ilgili test. Yeni5test gerçek renderer/tercih ayrımı,500ms gerçek roket çarpması,4kalite önayarı,özel ayar/yeniden giriş ve ilgisiz sekmelerin kaliteyi bozmamasını kapsar.
- `logs/classic-2d-full-tests.log`: **855/855**,0hata; `logs/classic-2d-source-check.log`: **308 JS/0 sözdizimi hatası**.
- `logs/classic-2d-network-check.log`: **22.055 gerçek HTTP/TCP komutu PASS**. Native4önayar request/ack,2D ve3D ready,kalıcı tercih ve uçuş hesabı doğrulandı. Testler izole bellekDB'sinde; gerçek hesaba test eşyası/para verilmez.
- Kapanış yedeği `backups/darkorbit-before-2026-10-23T12-26-25-139Z.db`, yükseltme kontrol kopyası aynı damgayla.2hesap/2oyuncu/7gemi/46sahiplik tablosu kontrolü geçti. Gerçek DB'de hesap/oyuncu dahil48tabloda yalnız oyuncu2'nin2Dtercihi farklı; integrityOK/FK0.
- **Güncel PID9940**,solo8095/8096. PID22308 kimliği doğrulanarak kaydet/kapat yoluyla durduruldu. `logs/classic-2d-server-console.log`, `logs/classic-2d-server-error.log`; sağlık/MAIN/hesap modu kanıtı `logs/classic-2d-live-verification.log`.
- MAIN aynı: `e672b127d1f7898e1d558e4bb7f03f4dfd5372f56f8ac6ecb3a063facc3b6a8d`; cache `local-20261023-launcher-native-rewards`. SWF/grafik/ses dosyası değiştirilmedi. Oyundan çıkıp yeniden giriş2Dflashvars'ı yükler.

Önceki Escape durdurması nedeniyle native Qt ekranına girdi verilmedi. Kaynak/asset/codec/gerçek ağ doğrulaması yapılmıştır; gerçek oyun görüntüsü ve sesli son kontrol henüz yapılmadı. [Önceki CPU sonucu](cloak-cpu-current.md) ve [ana kapsam/açık işler](second-completion-work.md) geçerlidir. Hades/çok oyunculu/mimari geçişine dokunulmadı; geçmiş yönetici hediyelerini tekrarlamayın.
