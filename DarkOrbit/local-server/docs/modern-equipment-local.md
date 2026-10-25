# Modern Payment ekipmanlarının yerel çalışma durumu

21 Ekim 2026. Bu değişiklikler solo sunucu içindir. Gerçek hesaplara test eşyası, para veya ücretsiz yükseltme eklenmez.

## Çalışan yollar

- Prometheus: normal hasar, beş saniyede bir ek 200, belirtilen Blacklight NPC kimliklerinde taban hasar ×3,5. Caucasus: NPC taban bonusu ve beş saniyede ek 100. Scatter SL serisi ek atışları çalışır. Güncel tabanlar gömülü istemci kataloğundan alınır; eski FAQ tabanlarıyla değiştirilmez.
- Odysseus: gemiye takılan OS-L sayısından kritik olasılığı; üç eşik seti, %50 sınır ve yalnız OS-L katkısına ek kritik hasar. Diroit ve PET üzerinde gemi seti etkinleşmez.
- Asmodeus: yalnız kendi hasarına NPC öldürme yığınları, ilk 20 saniye ve sonraki öldürmelerle +10 saniye; beş yığın, süre dolunca tümü sıfırlanır. Harita değişimi, çıkış ve ölüm sıfırlar. Üç gemi lazeri set bonusu ayrıca uygulanır.
- LF-5 Mortifier: gemideki adede göre kendi hasarına set tablosu uygulanır. Hyperplasmoid gemi/PET taban HP’sine lazer başına %0,5 verir. LF-3, SLL ve Paritydrill NPC hasar farkları uygulanır.
- Üç parçacık topu türü: aynı türe uygun slug, gerçek stoktan bir adet tüketim, ortak dört saniye bekleme, kaynak tabanları/yükseltme/özel gemi bonusları, gerçek saldırı ve isabet paketleri. Thermal yakın hedeflere sıçrar; corrosive süreli beş yığın oluşturur; electro en yakın hedefler üzerinden toplam yedi hedefe zincirlenir.
- IgniDrive Lite/Apex/Prime: kendi ayrı sürücü yuvası, GSP ×1/2/3/4 cephanesi, ateşlenen sürücü başına tüketim, ortak bekleme ve sabit merkezli sekiz saniye alan hasarı. Apex/Prime adet setleri, altı Prime’ın menzili ve yalnız menzildeki sürücülerin tüketimi uygulanır.
- Lens ve refraktörler kendi yuvalarına takılır; yükseltilmiş savunma değerleri yalnız drive/ilgili cannon saldırısına uygulanır. Normal lazer/rokete etkileri yoktur.
- AGS-X ve RG-SL CPU’ları takılı aktif konfigürasyonda, menüde açıldığında ve lazer saldırısı sürerken seçilen kendi cephanelerini kullanır. Donanımsız, stoksuz, menzil dışı, korumalı, ölü veya harita değiştiren hedefe atış yapılamaz.
- SR-5: gerçek kimlik `ammunition_specialammo_sr-5`; uçuş tamamlanınca yalnız kalkandan en çok 80.000 eksilir, gerçek eksilenin %50’si kullanıcı kalkanına döner. Kullanıcı üç saniye %25 yavaşlar; bağımsız dört dakika bekleme vardır. K-300M: gerçek kimlik `ammunition_specialammo_k-300m`; 12.000 taban hasar, %75 isabet ve 15 saniye bekleme; isabette hedef iki saniye %20 yavaşlar ve doğruluğu beş puan düşer.

Cephane tüketimi ve kalıcı bekleme aynı SQLite işlemindedir. İşlem hatasında stok, veritabanı ve canlı bekleme birlikte geri alınır. Kayıttaki iki özel cephane tanımı önceki JSON çıkarımında atlanmıştı; özgün ActionScript alanlarıyla geri eklendi. Envanter PET’e özel lazeri gemiye takmayı ve aynı cannon türünden ikincisini takmayı reddeder.

## Kaynaklar ve açık farklar

Statik kanıt: `decompiled/main/scripts/net/bigpoint/darkorbit/items/ItemDataProvider.as` (SR-5:2743, K-300M:3386); `docs/client-map.items.json`; `porting/cannon/CannonType.as`; `AttackTypeModule.as` (21 cannon,22 drive); `CooldownTypeModule.as` (60 cannon,61 drive,14 SR5,15 K300M); `CannonAttackHandler.as`. Bunlar paket ve taban alanlarının kanıtıdır; özel sunucu matematiğinin kanıtı değildir.

- [Blacklight FAQ](https://board-en.darkorbit.com/threads/blacklight-faq.123290/): Prometheus katkıları, dönem tabanı, beş saniye ve dört Blacklight NPC kapsamı.
- [Odysseus FAQ](https://board-en.darkorbit.com/threads/faq-new-laser-odysseus-laser.129128/): adet, kritik ve gemi yerleşimi kuralları.
- [Asmodeus resmi İspanyolca FAQ](https://board-es.darkorbit.com/threads/faqs-asalto-hitac-agosto-2023.147994/): öldürme yığınları, süre, sıfırlama ve set bonusu.
- [Mortifier FAQ](https://board-en.darkorbit.com/threads/faq-trial-of-terrors.129920/): 452 taban ve adet set tablosu.
- [LF-4 FAQ](https://board-en.darkorbit.com/threads/lf-4-enhancement.118139/) ve [lazer FAQ](https://board-en.darkorbit.com/threads/lasers.892/): tip etkileri. Eski ve güncel taban farklılığında eldeki istemci tabanı korunur.
- [Particle Weapon FAQ](https://board-en.darkorbit.com/threads/faq-particle-weapon-system.129990/): %80 isabet, %75–100 hasar, dört saniye, %10 kritik/ek %15 hasar, thermal %40 sıçrama/275 menzil/beş ek hedef, corrosive %5/20 saniye/beş yığın.
- [Fiesta FAQ](https://board-en.darkorbit.com/threads/faq-fiesta-gate.130034/): electro yedi hedef ve adım başına %15 azalma. Zincirin azami adım menzili açıklanmadığından yerelde 275 kullanılır. Electro savunma FAQ’sı eldeki katalogla farklıdır; katalog korunur.
- [Voyagers FAQ](https://board-en.darkorbit.com/threads/faq-voyagers-ascent.130327/): drive hasarları/setleri, alan150, süre8, isabet%85, GSP ve AGS-X. Aynı sayfada bekleme örneği12, tablo10 saniyedir; yerelde ortak12 saniye seçilir (`combat.driveCooldownMs` ile değişir). Alan darbe sıklığı açıklanmadığı için yerelde saniyede bir, toplam sekiz darbe; ilk isabet denemesi alan başına bir kez yapılır.
- [SR-5 FAQ](https://board-en.darkorbit.com/threads/blacklight-surge-event-faq.124283/) ve [K-300M FAQ](https://board-en.darkorbit.com/threads/hitac-assalt-faq.124510/): yukarıdaki özel roket değerleri. K-300M’nin özgün roket görsel kimliği bulunamadı; bilinen PLT-3030 görseli yerel geçici gösterimdir. Roket etkisi uçuş bitimine ertelenir.

**Özgünlüğü doğrulanmayan yerel bileşim:** savunmada `hasar × 1000 / (1000 + max(0,savunma−delme))`; dönemlerin yükseltme/bonus sırası; OS-L için lazer başına bağımsız kritik denemesi; scatter’ın ilk ateşten beş saniye sonra şarj olması. Drive kalıcı alanının tam istemci görseli henüz sahneye sabit nesne olarak çizilmez; kaynak atış efekti ve gerçek hit paketleri gönderilir. Kritik/set özel görsellerinin hepsi uygulanmış değildir.

Rastgele cannon/drive yan nitelikleri, yeniden dağıtma/geri dönüşümün modern tam tabloları ve PvP’ye özel LF-5 Anchorlock etkileri bu çalışmada tamamlanmış sayılmaz. Mevcut sunucu NPC’leri drive/cannon ile kendiliğinden saldırmaz; lens/refraktör tüketicisi gerçek gelen saldırı türü için hazır ve testlidir. Tam Flash görsel uçtan uca testi yapıldığı iddia edilmez.

## Doğrulama

`tests/modern-equipment.test.js`: **24/24**. Donanım/aktif konfigürasyon, sınırlar, gerçek cephane, kaynak tabloları, paylaşılan bekleme, hedef menzili/koruma, darbe zamanı, sekiz pulse, thermal/corrosive/electro, kalıcı SR-5, yeni CPU’lar, işlem geri alma, bütün klasik diroit seviyeleri/menü görünürlüğü ve lazer/PET yerleşimi ayrımı. Her üretilen komut gerçek codec ile kodlanır. Mevcut PET/CPU/lazer görsel regresyonuyla **124/124** (son PLD/DCR testi eklenmeden önce). `tools/test-network-payment-weapons.js` gerçek HTTP Payment alımı/equip/dizilim ve TCP lazer/cannon/drive/SR-5/dizilim seçimi yolunu ana izole ağ testine ekler.
