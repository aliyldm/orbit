# LF4 sonrası lazerlerin satış kısıtı — 25 Ekim 2026

Kullanıcının yeni isteği satın almayı kapatıp ürünleri dükkânda tutmaktır. Bu, önceki envanter silme politikasının geri gelmesi değildir.

`game/laser-sales.js` sadece satış uygunluğunu belirler. Klasik9tür (MP-1,LF1–4,SL01–03,AA-1) alınabilir; kalan17 lazer görünür fakat satın alınamaz. LF5/Anchorlock/Mortifer,Prometheus,Odysseus,Asmodeus,geliştirilmiş/unstableLF4,Caucasus,AA-P1,LF-P01/PX01,SLL01–03 bu17türdedir. Tüm26 kart ve196ÖzelFırsat kaydı kalır. İçinde kısıtlı lazer olan paket/alias da komple engellenir; paket içeriğinden lazeri sessizce çıkartıp kalanını satma yok.

Portalın özgün `notBuyable=true/isBuyable=false` alanları ve açıklaması güncellenir. Native listeden ürün silinmez. `economy.purchase` ortak doğrulaması hem doğrudan hem paket hem native/HTTP isteklerini, ücret veya receipt yazılmadan reddeder. Diğer işlevsiz ürünlerin önceki satış kısıtları korunur.

Envanter, yükseltme seviyeleri, ekipman atamaları, ödenmiş işler, üretim ve ödül yolları değiştirilmez. Modern lazer formülleri çalışmaya devam eder. Doğrudan fulfil eski ödenmiş manifest teslimini korur; yeni satın alım ortak kapıdan geçer. Silme/iade/hediye/migration yapılmaz. MAIN ve cache önceki47a0… sürümünde kalır.

Doğrulama: bütün26kart/17kilit ve196kampanya görünürlüğü; her kısıtlı ürün ve pakette1/3adet denemesi, bakiye/öğe/receipt değişmemesi; LF4/normalcephane alımı; takılı19seviyeMortifer korunması; nativeBuyCommand reddi. Tam kaynak testi1016PASS/368JS0hata. Gerçek HTTP/TCP senaryosu23846komutPASS. Dağıtıldı:PID16172/solo8095–8096/healthOK. Önceki24464kayıtla durduruldu;21-11-39-742ZSQLite/WALyedekle60tablonun her satırı/şeması aynı.3hesap/3oyuncu/14gemi/integrityOK/FK0. Kanıt logs/laser-sales-production-check.json. Mevcut hesaplara satınalma denemesi/hediye/iade uygulanmadı.
