# Kargo, kutu ve Galaxy Gates ödül denetimi

20 Ekim 2026. Hedef mevcut istemciyle çalışan klasik DarkOrbit profilidir. **Bütün ödüllerin, şansların ve etkinliklerin özgün sunucuyla birebir olduğu doğrulanmış değildir.** Kaynak miktarı, sürüm seçimi, işlevsel teslim ve yayımlanmamış RNG ayrı değerlendirilmiştir.

| Alan | Denetim sonucu | Uygulanan düzeltme / kalan sınır |
|---|---|---|
| Normal NPC kargosu |45 türün cevher satırları seçili resmî DE kaynaklarına eşleşiyor. | Sayılara varsayımsal Boss/Uber çarpanı eklenmedi. Kendi x-1 Streuner'ında kaynaklı seviye azaltımı bağlandı. |
| Kapı NPC kargosu | Önceki genel10 Prometium+10 Endurium bütün türler için doğru değildi. | Epsilon/Zeta/Kappa/Hades için kaynakla doğrulanan özel tablolar eklendi. LoW/Epsilon varyantları ayrıldı. Ölçeklenmiş Beta/Gamma/Delta ve bazı Kuiper özel türlerinin cevheri doğrulanamadı; uydurma10+10 verilmez. |
| Kargo kapasitesi | Xenomit kargo alanı tüketmez. | Toplama, oyuncu yükleme, stat yenileme ve Skylab kapasitesi aynı kurala geçti. Kargo doluyken Xenomit alınabilir. |
| Normal mavi bonus kutusu | Kredi/Uridyum/cephane/enerji miktarları resmî EN tabloyla doğrulanıyor. | Sabit200 kredi/20 Uridyum havuzu kaldırıldı. Miktarlar ve4-x karşılıkları düzeltildi; seçim ağırlıkları yayımlanmadığı için yereldir. |
| Renkli korsan kutuları | Yeşil/altın/kırmızı/mavi tipleri, gerçek görseller ve anahtar eşleşmeleri istemcide var. | Açma, hareket iptali, anahtar tüketimi, gerçek ödül ve sayaç teslimi bağlandı. Eski korsan ganimetinin tam eşya listesi/miktarları/olasılıkları bulunmadığı için yerel bir alt küme kullanılır. |
| Kapı bitirme garanti ödülleri | On kapının seçili klasik garanti miktarları kaynaklarla eşleşiyor. | Eksik özel ekipman/gemi/booster/Kronos parçası teslimleri eklendi. Başlamış/snapshot'ı bulunan eski koşular değiştirilmedi. |
| Kapı nadir ödül şansları | Klasik Epsilon/Zeta/Kappa kaynak oranları ayrıldı. | Hades LF-4 %25 ve Kuiper gemi %10 yerel olasılıklardır; tam özgün oranları doğrulanmadı. |

Kaynaklar ve tek tek tablo karşılaştırmaları: [NPC kargosu](npc-cargo-reward-audit.md), [kutu protokolü ve resmî FAQ'lar](box-reward-evidence.md), [kapı bitirme ödülleri](gate-completion-rewards-audit.md).

## Normal bonus kutuları

`bonus-boxes.js` klasik havuzu: LCB-10 için10/20/50; MCB-25 ve MCB-50 için5/10/20; kredi200/500/1000; Uridyum20/50/100; ekstra enerji1. Battle haritalarında4-1…4-5 miktarlar%50 artar;5 mühimmat8 olur. Ekstra enerji kaynak tablosuna göre yine1'dir. ArGe ve destek etkileri temel miktardan sonra uygulanır. Jackpot/gerçek para ödülleri yeniden açılmadı.

Ödül toplama anında sunucuda seçilir; istemcinin gönderdiği koordinat/ödül bilgisi kabul edilmez. Her temel olasılık eşit ağırlıklıdır; **bu ağırlıklar özgün kazanma olasılıkları değildir**. Aynı kutudaki SQL hatasında ödül yeniden çekilmez; yeni doğan kutuya eski ödül kopyalanmaz. Ekstra enerji `galaxy_gate_accounts`, mühimmat gerçek `items` kaydıdır.

## Korsan kutuları

Altın/sarı kutu ayrı sarı anahtar istemez: yeşil `resource_booty-key` tüketir. Kırmızı ve mavi kutular `resource_booty-key-red` ve `resource_booty-key-blue` ister. Gerçek BK/BKR/BKB sayaçları giriş, satın alma, üretim, kapı bitişi ve toplamada güncellenir. Yeşil anahtarın1500U bedeli kaynaklıdır. Kırmızı/mavinin3000/4500U yerel mağaza bedelleri istemci metadata'sından alınmıştır; bunlar özgün ödeme mağazasının aynı teklifleri olduğu anlamına gelmez.

Yerel ganimet alt kümesi mühimmat, mayın, log disk, ekstra enerji, LF-3/LF-4, kalkan jeneratörü ve Apis/Zeus parçaları içerir. Renklerin yerel ağırlıkları `booty.js` içinde açıkça tanımlıdır. Kırmızı/mavi havuzu2017/2026 dönen PET etkinlik tablosuyla aynı değildir. Değişen resmî etkinlik tabloları klasik içerikle sessizce birleştirilmedi.

`config.booty.zeusEvent=true` ve `redBlueEvent=true`, yerel grupta dört rengi deneyebilmek için açıktır. Özgün oyunda altın Zeus, kırmızı/mavi kendi etkinliği sırasında çıkar; bu etkinlikleri sürekli açık tutmak yerel seçimdir. Her renkten6 kutu,5 saniye açma ve60 saniye yeniden doğma yerel ayarlardır. x-1 ve Galaxy Gates'e korsan kutusu doğmaz; kapılardaki sahte normal bonus/zemin cevheri de kaldırıldı.

Açarken sabit durulur; hareket iptal eder. EN FAQ seçilerek açma sırasında saldırıya izin verilir. Anahtar yalnız başarılı tamamlamada harcanır; eksik anahtar, mesafe, ölüm, atlama ve PET otomatik toplama ile açma atlanamaz. NPC'den rastgele korsan kutusu düşmesi, otomatik yeşil anahtar satın alma ve toplanmayan kutunun kaynak benzeri ömrü henüz uygulanmadı. Toplanmayan korsan kutuları haritadan çıkışa kadar kalır. Apis/Zeus parçaları gerçek envanter ödülüdür; bunları diroit üretimi/indirimine bağlayan sistem henüz tamamlanmadı.

## Kayıt güvenliği ve doğrulama

016 geçişi gerçek kapı bitirme sonucunu `galaxy_gate_completion_claims`,017 geçişi kutu teslimini `loot_claims` ile tekilleştirir. Anahtar ve ödüller aynı transaction içindedir. SQL hatasında bakiye/eşya/enerji/anahtar geri alınır. Başarıdan sonra aynı kutu/koşu yeniden ödemez. Uyarı/ganimet efektleri özgün protokol alanlarıyla gönderilir.

401 otomatik test geçti;169 JavaScript dosyası sözdizimi kontrolünden geçti. Son değişen dosyalar ayrıca `node --check` ile doğrulandı. Gerçek HTTP/TCP'de12.146 komut çözüldü: dört renk için satın alınmış doğru anahtar, açma süresi, tüketim ve eşya teslimi; Epsilon'un bütün dalgalarının bitirilmesi, ilk LF-4 ve5 yeşil anahtar, tek bitirme makbuzu doğrulandı. Bu ağ testinde konum, kontrollü ödül ve NPC öldürmeleri yalnız bellek DB'sindeki güvenilir QA fixture'larıdır; istemcinin kendisine keyfi ödül/öldürme yetkisi verilmedi. Flash üzerinde görsel oynanış testi yapılmadı.
