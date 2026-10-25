# Zephyr Momentum ve Retiarus Supercharge — 24 Ekim 2026

Dağıtılan sürüm: PID24352, solo HTTP8095/TCP8096, healthOK. **1.001/1.001 test**,359 JS dosyası/0 sözdizimi hatası,23.661 gerçek HTTP/TCP paketi geçti. Toplam27 solo yetenek menüsü bağlıdır; bütün gemi yetenekleri bitmiş değildir.

## Momentum

[Resmî Frozen Labyrinth SSS](https://board-en.darkorbit.com/threads/winter-event-frozen-labyrinth-faq.124941/) ve yerel Türkçe `items_skill_MOMENTUM_description` aynı kuralı verir: NPC öldürünce bir yük, en fazla20; yük başına +5 sunucu birimi lazer menzili. Etkinleştirince bütün yükler harcanır, menzil tabana döner ve20s boyunca yük başına%1,5 hız kazanılır;750 hız sınırı vardır. Yeni yük olmadan etkinleşmez; ayrı bekleme süresi yoktur. İlk sızıntıdaki%5 hız kullanılmaz.

Sayaç gerçek, başarıyla ödüllendirilmiş NPC imhasından artar. Aynı NPC'ye ikinci kill, ödülsüz destek kopyası veya başarısız ödül kaydı yük üretmez. Orijinal menü sayacı ve tooltip korunur. Menzil hem ilk lazer isteğinde hem sonraki gerçek atışlarda uygulanır; yüksüz taban600 iken20yükte700 olur. Native `MapAssetAttackCommand` bu aralık için ek istemci yaması gerektirmez; menzil kararı sunucudadır.

Hız katmanı süreli çarpanı ve750sınırını gerçek hareket/stat yenilemelerine uygular. Ekipman yenilenince ikinci kez katlanmaz; süre sonunda gerçek taban hız döner. Aktivasyon kaydı başarısızsa yük ve hız değişmez. Etki sırasında yapılan NPC imhaları yeni yük biriktirir; bunların menzil etkisi aktif hız süresi bitince başlar. Sayaçlar oyuncu/gövdeye ait dünya belleğinde tutulur ve sunucu yeniden başlatılınca sıfırdır. Harita yeniden kurulumu ve yeniden girişte aynı sunucu belleğindeki yükler korunur. Aktivasyon sırasında yeni yük toplama ile harita/ölüm/oturum kenarlarının tamamı yayımlı SSS'de tanımlanmadığından bu ayrıntılar seçilmiş yerel politikadır; eski2019haritaya özel sayaç bug'ı taklit edilmez.

## Retiarus ve açık kaynak farkı

Supercharge gerçek hız katmanında10s boyunca%10 artış,300s bekleme kullanır. Kaynak: [2020 resmî Galactic Strife SSS](https://board-en.darkorbit.com/threads/galactic-strife-faq-09-2020.126388/) ve yakalanmış `ItemDataProvider.as` SUPERCHARGE param10/süre10/bekleme300. Süre/stat/menü ve bekleme gerçek ağdan da test edildi.

**Çelişki açık:** yakalanmış Türkçe `items_skill_SUPERCHARGE_description` ve [2026 Türkçe gemi rehberi](https://board-tr.darkorbit.com/threads/sss-gemiler-ve-gemi-tasarimlari-hakkinda-genis-bilgi.160373/page-2) %30 der. Bu sürüm %10 kuralını seçer;2026canlı hız miktarı birebir doğrulandı denmez. Türkçe açıklama bu tur değiştirilmedi. Charge Shot ve Supercharge'ın özgün özel efekt aktivasyonu hâlâ açık; sırf hız yeteneği diye başka teknolojiye ait95SpeedBurst efekti uydurulmadı. Momentum'un özel efekt aktivasyonu da ayrıca doğrulanmalıdır. Çok oyunculu JAMX etkileşimi ertelenmiştir.

Zephyr Triple Barrage'ın NPC hedefi/3patlama/200yarıçap/20khasar/10dkbekleme kuralları kaynaklıdır; özgün üçgen merkezleri ve görsel sözleşme tamamlanmadığından bu pakette açılmadı. Retiarus Charge Shot da uygulanmış sayılmaz.

## Korunmuş veri

- Önceki PID18964 kayıt işleyicisiyle kapatıldı.
- Yedek `backups/darkorbit-before-2026-10-24T17-27-26-722Z.db`.
-60tablonun şeması ve bütün satırları yedekle aynı;3hesap/3oyuncu/14gemi,integrityOK/FK0.
- Kanıt `logs/momentum-production-check.json`; full-tests/source/network/database/server logları aynı önekte.
- MAIN SHA256 `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824`;cacheaynı. Migration/hediye/iade/Qtgirdisi yok.

Önceki Komuta Merkezi/Phase Out paketi korunur. Güncel devam işi [kalanlar](remaining-work-current.md);5-xlabirenti kapalı ve LF4tavanı devam eder. Çok oyunculu mimariye başlanmadı; orijinal görev kataloğu en sona kalır.
