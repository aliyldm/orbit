# Yerel hangar, satın alma ve yükseltmeler

Portal hangarı `inventory.swf` içindeki DataInterchange, Inventory, GridComponent,
ItemInfoManager ve ConfigManager sözleşmelerini kullanır. Ana oyun soketindeki
envanter, `net.bigpoint.darkorbit.asset...` sınıf adlarını kullanır; portalın grup
haritası ise `Weapon_LaserType` gibi kısa adlar içerir.

## Kompakt görünüm düzeltmesi

`GridComponent.filterByContext` eşyayı ancak `EB` dizisi açık ekipman hedefini
(`SHIP`, `DRONE`, `PET`) içeriyorsa gösterir. Bu alan gerçek istemci kataloğundaki
`equipable.entities` listesinden üretilir. Depodaki eşyaya `EQH: 0` gönderilmez:
AS3, bu değeri `"0"` dizgesine dönüştürür ve başka hangarda takılı sayar.
Takılı eşyaların `EQH/EQC/EQT` alanları gerçek atamadan gelir. Sürükleme işlemi
sahiplik, konfigürasyon, eşya türü ve boş yuva kontrolünden sonra DB'ye yazılır.

## Satın alma

Gemi/diroit/eşya ekleme ile bakiye düşümü aynı SQLite işlemindedir. Eski DB'de
eksik bir diroit veya booster katalog girdisi varsa gerçek SWF meta verisinden
aynı işlem içinde tamamlanır. Diroitler ve boosterlar sahte depo eşyası olarak
eklenmez; kendi sahiplik/süre tablolarına yazılır.

Portalın sayısal destek ürünleri, örneğin `1`, doğrudan
`BoosterAttributes.boosterId` ile `booster_ep-b01` adına eşlenir. Desteklenmeyen
etkiler para düşülmeden açıklamalı hata verir.

Diroit sayfasının sayısal `1`/`2` satırları Flax/Iris anlamına gelirken destek
sayfasında aynı sayılar TP/Şeref desteğidir. Tarayıcı bu satırlar için gerçek
`imageVars.loot_id` değerini gönderir; eski istekler ayrıca `category=drone`
ile ayrıştırılır. Sadece başarı mesajını değiştirmek yeterli değildir: önceki
belirsiz istek yanlış ürünün destek süresini ekleyebilirdi.

Flax fiyatı aynı hesaptaki mevcut Flax sayısıyla 100.000 krediden başlayarak
ikiye katlanır; sekizinci 12.800.000 kredidir. Iris sırası 15.000, 24.000,
42.000, 60.000, 84.000, 96.000, 126.000 ve 200.000 uridyumdur. Türlerin fiyat
sayaçları ayrıdır, toplam Flax/Iris kapasitesi sekizdir. Fiyat tabloları
[resmî yönetici SSS'sinden](https://board-de.darkorbit.com/threads/faq-drohnen.2892/)
alınmıştır. Sunucu fiyatı ödeme transaction'ında yeniden hesaplar; portal
açılışta ve her alışverişten sonra yeni fiyatı, satış fiyatını, bakiyeyi ve
kapasite durumunu günceller. Başarısız işlem fiyat sayacını ilerletmez.

## Diroit deneyimi ile eşya yükseltmesi farklıdır

Diroit deneyim seviyeleri 1–6'dır. DB ve SWF içindeki karşılığı 0–5 tutulur;
puan eşikleri sırasıyla 0, 100, 200, 400, 800 ve 1600'dür. Her deneyim seviyesi
diroit üzerindeki lazer hasarına %2, kalkana %4 ekler. Altıncı seviyede toplam
bonus %10 hasar ve %20 kalkandır. Tamir, deneyim seviyesini bir düşürür;
eşya yükseltme seviyesi korunur.

Standart NPC/oyuncu gemisi puan matrisi [resmî Almanca diroit SSS'sinden](https://board-de.darkorbit.com/threads/faq-drohnen.2892/)
alınmıştır. [Resmî İngilizce SSS](https://board-en.darkorbit.com/threads/drone-faq.896/)
altı deneyim seviyesi, tamirde seviye kaybı ve ayrı 16 kademeli yükseltmeyi açıklar.
[Eşik tablosu](https://darkorbitwiki.com/drones/) ayrıca kontrol edilmiştir.
Standart olmayan/mevsimlik NPC'lerin puan kuralı istemcide yoktur; bunlar açık
yerel uzantıdır: `config.drones.pointsByNpc[typeId]` veya `unknownNpcPoints` ile
ayarlanabilir. Varsayılanı her 400 TP için en az 1 diroit puanıdır. Güçlü gemiler
Streuner/Lordakia gibi zayıf standart NPC'lerden 0 puan alabilir.

Yükseltme işlemleri Montaj/Yükseltme penceresinin `AssemblyBuildRequest`,
`AssemblySkipRequest` ve `AssemblyCollectRequest` paketleriyle çalışır. İşler,
malzeme/bakiye maliyetleri ve bitiş zamanı DB'de saklanır; sonuç yalnız bir kez
toplanır. Birinci görüntülenen seviye DB'de 0'dır; 16. seviye DB'de 15'tir.
İstemcide 20 seviyeye kadar tarifi bulunan eşyalarda üst sınır gerçek tariften
alınır. Deneyim puanıyla otomatik yükselme, bu malzeme harcayan işlemden ayrıdır.

Etkinlik takvimi istemciden doğrulanamayan tarifler otomatik etkinleştirilmez;
yerel kullanım için `config.assembly.enabledRecipes` listesi kullanılabilir.
