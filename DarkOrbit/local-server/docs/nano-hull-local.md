# NanoHull — kaynak ve çalışan kapsam

20 Ekim 2026. NanoHull, normal candan ayrı kalıcı gemi havuzudur. Kaynak: [resmî Nano Hull Strength FAQ](https://board-en.darkorbit.com/threads/nano-hull-strength-faq.999/) ve eldeki istemcinin `ShipAttributes.maxNanoHull`, `ShipInitializationCommand`, `HitpointInfoCommand`, `AttackHitCommand` alanları.

## Uygulanan davranış

- `021-nano-hull.sql`, her fiziksel `ships` satırına `nano_hull` ekler; mevcut gemiler önceki sıfır NanoHull ile kalır. Hesaba ücretsiz dolum verilmez.
- Kapasite doğrudan o geminin gömülü katalogdaki `maxNanoHull` değeridir. HP ArGe, diroit formasyonu, HP booster ve konfigürasyon bunu çarpmaz. Örneğin bu istemci sürümünün Goliath kapasitesi356000'dir; başka dönemin istatistikleriyle aynı olduğu varsayılmaz.
- Gelen vuruşun kalkan payı önce hesaplanır. Gövdeye kalan hasar NanoHull'u tüketir; yalnız taşan kısım normal HP'yi düşürür. Roket, NPC lazeri ve özel saldırıların ortak hasar yolu bunu uygular. SAB yalnız kalkanı etkiler. ISH hasarı engeller.
- Başlangıç, güncel HP, stat yenileme, vuruş, atlama ve seviye/konfigürasyon akışları gerçek NanoHull değerini taşır. Bağlantı/harita değişiminde kalır; başka gemiye aktarılmaz. İmha havuzu temizler.
- Robot, Solace ve PET gemi tamiri yalnız normal HP'yi onarır; NanoHull üretmez veya mevcut havuzu sıfırlamaz.

## Galaksi Kapısı üretimi

Kaydedilmiş `game/handlers/systems-evidence.json` altı kategori içerir: cephane67%, Xenomit12%, tamir3%, parça13%, NanoHull4%, log1%. Önceki yerel71% cephane yönlendirmesi kaldırılıp bu tablo geri bağlandı.

Gerçek istemci `GalaxyGateBuilderItemModule.ITEMTYPE_HITPOINTS=7` çıktısını `SpecialOutputVO.TYPE_NANOHULL` olarak gösterir (`GalaxyGateBuilderModel.as:699`). Üretilen miktar aktif gemiye aynı para/enerji/çarpan transaction'ında yazılır; gerçek `GalaxyGateBuilderLootItemModule` ve `HitpointInfoCommand` gönderilir. Savaşta son kayıttan sonra azalan canlı NanoHull önce transaction'a yansıtılır; eski DB değeri kaybedilen gücü geri getirmez.

**Yerel sınırlar:** Her NanoHull çekilişi için varsayılan2000 güç, `galaxyGates.nanoHullPerSpin` ayarıyla değiştirilebilir. Bu miktar orijinal sunucudan doğrulanmadı. Seçili çarpan uygulanır; kapasiteyi aşan kısım verilmez, paket yalnız gerçekten teslim edilen miktarı gösterir. NanoHull dolu veya gemi imha edilmişse bu kategori normal cephaneye döner. Özgün dolu-havuz yeniden dağıtım algoritması kesinleşmediğinden bu fallback açık yerel politikadır. Diğer27 ödül paketinin miktar/nadirlik ayarları önceki yerel politikadır; bütün üretim ödülleri özgün ilan edilmez.

## Doğrulama

`tests/nano-hull.test.js`:15 test. Kapasite/HP ayrımı; sahiplik/cap/ölüm; kalkan→NanoHull→HP taşması; gerçek vuruş paketi; SAB/ISH; konfigürasyon/yeniden giriş ve ayrı gemiler; altı kategori ve typed ödül; çarpan/çoklu enerji/cap; dolu fallback; savaşta eski DB değeri koruması; SQL hata geri alma; tamir sırasında havuzu koruma.

`tools/test-network-cpus.js` gerçek soketten NanoHull çekilişini, güncel HP paketini, gerçek gelen hasarda havuz azalmasını ve CPU ile harita değişiminden sonra DB kaydını doğrular. Test fixture'ı ayrı bellek DB'sidir. Flash ekranında görsel oynanışın tamamlandığı iddia edilmez.
