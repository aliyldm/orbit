# Normal haritalarda NPC davranışı

`Combat.spawnAll()` normal harita nüfusunu `normal-map-content.spawnRows(db,mapId)` üzerinden alır: `{def,count,spawnId}`. Her NPC tanımına `normalSpawnId` ve satır içi `normalSpawnSlot` eklenir. İstemcide ilk gösterimden önce kullanılabilen `spawn(def,{x,y})` konumu harita sınırına kırpar. Aynı profil/yuva doluysa ikinci NPC üretilmez; ölümden sonra aynı profil ve davranışla tek yenisi doğar. Çıkış, harita/epoch değişimi ve combat temizliği eski haritada doğum üretmez. `transient:true` destek NPC'sinin bağımsız yeniden doğmasını engeller.

## Kaynak ve veri ayrımı

Türe özgü sınıflandırma profil/katalog katmanından gelir; Combat bütün normal NPC'leri otomatik saldırgan ilan etmez. Resmi [normal NPC FAQ](https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/) Lordakium, Cubikon ve StreuneR için saldırı gelmeden ateş etmemeyi, Kristallin için yakın oyunculara saldırmayı açıklar. [Boss FAQ](https://board-en.darkorbit.com/threads/boss-alien-faq.801/) Boss Mordon/Saimon/Devolarium/Sibelonit saldırganlığı ile Boss StreuneR'ın pasifliğini ayırır. Bu nedenle tek bir genel Boss/Uber etiketi otomatik saldırı kuralı değildir. Profil katmanının seçtiği kaynak sürümü korunur.

Normal haritaların paketlenmiş `spacemap-config.xml` NPC bileşimi, harita/kapı düzeni ve sayısal NPC istatistikleri ayrı modüllerin kapsamındadır. Combat grafik kimliğinden tür veya güç tahmin etmez. Özel Cubikon/Battleray muhafızları `normal-npc-special` adaptörüne aittir; bu belge özel becerilerin bütün canlı algoritmalarının kurtarıldığını iddia etmez.

## Davranış sözleşmesi

`def.behavior` nesnesinin alanları:

| Alan | İşlev / varsayılan |
| --- | --- |
| `aggression` | `passive`/`retaliate`: geçerken saldırmaz, saldırı üzerine karşılık verir; `aggressive`: fark etme yarıçapında oyuncuyu hedefler. |
| `acquisitionRadius` | İlk fark etme mesafesi; yerel varsayılan900. |
| `retainRadius` | Normal NPC'nin takibi bırakma mesafesi; yerel varsayılan2500. |
| `attackRange` | NPC'nin ateş mesafesi; yerel varsayılan600. |
| `chaseDistance` | Bu mesafeden uzakta hedefe yaklaşır; yerel varsayılan450. |
| `roam` | Boştayken gezinme; varsayılantrue. |
| `chase` | Hedefi takip etme; varsayılantrue. |
| `canAttack` | Ateş edebilme; varsayılantrue. False olduğunda sahte sıfır hasarlı lazer veya hit gönderilmez. |
| `fleeToCorner` / `fleeAt` | Yalnız açıkça açılan düşük can kaçışı. Varsayılan kapalı/0. |
| `cornerInset` | Kaçış noktasının sınırdan uzaklığı; yerel varsayılan500. |

Yarıçaplar, saniyelik karar/ateş sıklığı, takipteki rastgele yaklaşma ofseti ve dört iç köşeden en yakınına kaçış **yerel AI politikasıdır**. İstemci sunucudaki NPC beynini içermez; bu değerler decompiler'dan kurtarılmış orijinal formüller diye sunulmaz. Profilin klasik ailelere verdiği %10 can kaçış eşiği de yerel tercihtir. Escape yalnız bu iki alan açıkken ve NPC hasar almış/hedeflemişken çalışır; taret, sınıflandırılmamış NPC veya her büyük NPC için kendiliğinden açılmaz. Kaçan NPC takibi/ateşi bırakır, aynı köşeye devam eder; hareket her tick yeniden başlatılmaz. Hasar kesildiğinde mevcut yerel kalkan yenilemesi korunur.

Pasif NPC'nin yalnız seçilmesi saldırı başlatmaz. Gerçek saldırı/hasar yollarının verdiği hedefe karşılık verebilir. Normal NPC; ölü, atlayan, eski/ayrılmış oturum veya kendi ana istasyonunun barış alanındaki oyuncuyu hedeflemez. Takibi bırakırken hareket de sunucu konumunda durdurulur; yalnız hedef referansı silinip NPC'nin eski hedefe süzülmesine izin verilmez. `speed=0` varlık hareket etmez. Cubikon gibi `canAttack:false,chase:false` tanımı verilen anne varlık destek mekanizmasına bağlı kalır.

## Kapı uyumluluğu ve özel adaptör

`def.gateRunId` olan veya gerçek galaksi kapısı haritasındaki NPC normal davranış kurallarını kullanmaz. Var olan kapı saldırganlığı, 2500 ötesi takip ve koruma/dalga kuralları korunur. Eski özel tanımların yalnız `def.aggressive` alanı varsa eski davranışı değişmez.

`normal-npc-special.tick(combat,now)` NPC konum interpolasyonundan sonra ve oyuncu ateşinden önce çağrılır. `normal-npc-special.isProtected(combat,npc)` ortak koruma denetimine katılır; böylece lazer/SAB/roket/HST/PET/doğrudan efektler aynı korumayı görür. `onKilled(combat,npc)` başarılı ölüm/emeklilik kaydı ve NPC kaldırılması sonrasında muhafızları temizler; bu temizlik ödül verilmesinden bağımsızdır. Desteklerin doğum konumu ilk `ShipCreateCommand` paketinde doğrudur; sonradan oyuncu ekranına ışınlanmaz.

Temel korsanların özel saldırı adaptörü `npc-special-attacks.js` içindedir. Saboteur hız etkisi, Barracuda fitili/ödülsüz patlama ve Annihilator gecikmeli Hellstorm, [ayrı kaynak ve yerel denge belgesinde](npc-special-attacks-local.md) açıklanır.

`node --test tests/normal-npc-ai.test.js`: 11 test; pasif/saldırgan farkı, yalnız seçim, karşılık verme, üç ayrı mesafe, barış alanı/ölüm/atlama/eski oturum, takip durması, açık düşük can kaçışı, kalkan yenilenmesi, gate/taret ayrımı, saldırmayan anne, ilk konum, nüfus yuvası, tek yeniden doğma ve harita temizliği gerçek codec ile doğrulanır. Flash görsel uçtan uca doğrulaması ayrıca gerekir.

## Kalıcı normal NPC durumu

`normal-map-runtime.js` ve `normal_spawn_state`, gerçek profil satırı/yuvası ile oyuncuya ait solo dünyayı eşler. Can, kalkan, konum, son hasar zamanı ve nesil tutulur; oyuncu haritadan ayrılınca ve beş saniyelik savaş kaydında güncellenir. Son soket çıkarıldıktan sonra da oyuncu nesnesi temizlenmeden kayıt yapılır. Haritaya dönüş ve dosya DB'si yeniden açıldığında kalan durum yüklenir. Harita dışındaki NPC'ler aktif AI veya çevrimdışı rejenerasyon simülasyonu çalıştırmaz.

Öldürme talebi, geçerli neslin `respawn_at=0` satırını ölüm/bekleme durumuna atomik geçirir ve para ödülünü aynı transaction'da yazar. Nesil daha önce talep edilmişse para, kargo, görev ve diroit ödülü tekrarlanmaz. Ödül paketleri başarılı commit sonrasında gönderilir. Kayıt hatasında bakiye ve bekleme geri alınır; sahte ölüm gönderilmez. Sonraki gerçek yeniden doğum nesli artırır. Eski vuruş aynı yuvanın yeni neslini ödüllendiremez.

Haritadan çıkıp dönmek Boss/Uber beklemesini sıfırlamaz. Yalnız etkin haritada kalan süre kadar tek zamanlayıcı oluşturulur; çıkışta iptal edilir, dönüşte DB'deki son tarihten yeniden hesaplanır. Transient muhafızlar ve elle tanımlanmış test/özel NPC'ler profil kaydı gibi saklanmaz; anne muhafızlarını yeniden kurar. Galaksi kapısı snapshot akışı ayrı kalır.

`tests/normal-map-runtime.test.js` altı testle hasar/son-vuruş/konum dönüşünü, Boss'un 90 saniyelik yerel beklemesini ve tek nesil üretimini, tekrar ödül engelini ve SQL hatasında rollback'i, son soket temizliğini, gerçek dosya DB kapat/aç döngüsünü ve transient ayrımını doğrular.
