# Klasik 2D gemi görünümünün kaynağı

19 Ekim incelemesinde mevcut yerel gemi dosyaları gerçek açılı, üç çeyrek görünümlü 2D çizimleri içeriyordu. Tepeden düz görünen geminin nedeni yalnız renderer seçimi değildir: istemcinin düşük gemi kalitesi ayrı bir sadeleştirilmiş dosyayı kullanır.

## Gerçek istemci yolu

`FlashVarsParser.as:137` içindeki `display2d` değeri `Settings.userType` olur. `Settings.as` sabitleri 2=2D, 1=3D'dir. `ClientSelectionCommand.as:32`, 2D seçimi için `FORCE_2D=true` yazar. `ScreenManager.as:347` bu bayrakla gerçek harita renderer'ını seçer. `DisplaySettingsHandler` içindeki `displayUse2d` alanı canlı renderer'ı doğrudan değiştirmez; yeniden başlatmada taze flashvars gerekir.

`map/view2D/display/ship/Ship2D.as:updateShipClip()` ise şu ayrı kalite kararını verir:

- `Settings.qualityShip > Settings.QUALITY_LOW`: önce yükleme yer tutucusu; ardından descriptor'ın gerçek `display2D.srcKey` SWF'si ve `resKey` klibi.
- `qualityShip == 0` (`QUALITY_LOW`): yalnız `replacementShips` dosyasındaki tek karelik sade gemi çizimi.

`ShipClip.as` gerçek SWF'nin `mc` klibinden yön açısına karşılık gelen kareyi seçer. Mevcut Spectrum ve Solace dosyaları 32 yön karesi içerir. Yedek çizim tek karedir ve gövde açısı farklıdır. Kamera açısını veya 3D modeli değiştirmek bu kaynak davranışını düzeltmez.

İnceleme sırasında oyuncu2'nin kaydında `displayUse2d:true`, fakat `QualitySettingsModule.qualityShip:0`, `qualityPresetting:1`, `qualityCustomized:false` bulunuyordu. Bu kayıt açılı ana çizim yerine düz sade çizimi seçer. Klasik görünüm için gemi kalitesi sıfırdan büyük olmalıdır; diğer ayrıntılar düşük tutulabilir. Özel karışık ayar için `qualityCustomized:true` UI'nin eski düşük önayarını tekrar uygulamasını önler. `SettingsWindowFUIProxy.as` düşük/orta önayarlarda gemiyi LOW, yüksek/çok yüksek önayarlarda HIGH seçer.

## Görsel ve dosya kanıtı

JPEXS26.3 ile `decompiled/ship-view-evidence/` altına dışa aktarıldı ve incelendi:

- `spectrum/1.png`: gerçek `ship_spectrum.swf` içindeki açılı çizim.
- `solace/17.png`: gerçek `ship_solace.swf` içindeki açılı çizim.
- `replacements/DefineSprite_282_ship_spectrum/1.png`: `replacementShips` düz çizimi.
- `replacements/DefineSprite_521_ship_solace/1.png`: `replacementShips` düz çizimi.

SHA256 dosya parmak izleri:

| Dosya | SHA256 |
| --- | --- |
| `client/spacemap/graphics/ships/ship_spectrum.swf` | `f93f4fb0a6aac70d0bef8a99f0b771c00fa731439f0b40065792e5341db2455f` |
| `client/spacemap/graphics/ships/ship_solace.swf` | `c1f1d31bff2c2994ed57bcd10d2886610abe7d045135d610a7bcb2769614dddf` |
| `client/spacemap/graphics/assets/replacementShips.swf` | `8b5246a18ab837fb61087859c04c129223f8e4fb0d4c907554602e41f03461e9` |

Örnek tekrar üretim: `D:\swfde\ffdec-cli.exe -format sprite:png -selectid 282,521 -export sprite decompiled/ship-view-evidence/replacements client/spacemap/graphics/assets/replacementShips.swf`. İnceleme dosyaları değiştirmedi. Sonuç kaynağa ve gerçek resimlere dayanır; ekrandaki aktif Flash renderer'ı ayrıca kullanıcı görünümünde doğrulanmalıdır.
