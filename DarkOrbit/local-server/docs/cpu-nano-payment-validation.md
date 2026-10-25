# CPU, savaş/NanoHull ve Payment — 20 Ekim 2026

Çalışma solo/yerel kaldı; çok oyunculu, PvP, grup, sohbet, klan ve açık artırma başlatılmadı.

## Sonuç ve kanıt

- **501/501 test** geçti: `logs/cpu-nano-payment-suite.log`. Yeni CPU27, savaş dengesi8, NanoHull15 ve Payment11 testi; mevcut HST8 ve gemi yetenekleri13 testi de kapsamda. Payment testi145 teslim edilebilir teklifin her birini ayrı geçici hesapta tam içeriği ve tam1m brüt kesintiyle satın alır.
- **188 JavaScript dosyası**, sözdizimi hatası0: `tools/check-source.js`.
- Gerçek HTTP/TCP: **13702 çözümlenmiş komut**, `logs/cpu-nano-payment-network.log`. Üretimden ayrı bellek DB'si/portlar kullanıldı.
- Gerçek soket akışı: SLE/JP/AJP/gizlenme ve1mUridyumluk HM7 alımı/takma; HM7 uzaktan satış100→99şarj; Activation5gizlenme; typedGGNanoHull kazanımı/güncelHP ve gelen hasar;10sn hazırlıklı AJP harita1→2/para/bekleme; beklemede JP reddi; yalnız QA fixture beklemesi temizlendikten sonra Activation9ileana üs dönüşü ve JP10→9şarj.
- Önceki görev/PET/kargo/korsan/kapı/oturum akışları aynı ağ testinde geçti. Görsel Flash kullanıcı testi yapılmış sayılmaz.

## Gerçek kayıtların korunması

Doğrulanmış proje sunucusu PID25204 kayıt/kapatma işleyicisiyle kapatıldı. SQLite online yedek:

`backups/darkorbit-before-2026-10-20T17-05-19-361Z.db`

Ayrı kopyada020/021 migrationları test edildi. Üretim yükseltmesinden sonra **22 tablonun** bütün önceki sütun/satırları bu yedekle karşılaştırıldı: accounts/players ve20 sahiplik/ilerleme tablosunda fark yok. `logs/cpu-nano-payment-production-check.json` ayrıntılı sonucu saklar.

İki hesap, iki oyuncu, altı gemi; `asd` bakiyesi1.000.118.400kredi/67.343.656Uridyum, iki Iris ve Alpha/Beta dalga1/can3 korundu. Üretime test para/ekipman/NanoHull eklenmedi; yeni NanoHull toplamı0, CPU şarj tablosu henüz0satır. Yeni şarjlar gerçek satın alınmış fiziksel eşyanın kullanımı/başlangıç durumu okunduğunda oluşturulur.

Güncel sunucu **PID22180**, HTTP8095/TCP8096, solo, migration021; health=ok, integrity=ok, FK ihlali0, başlangıç hata kaydı boş.

## Tamamlanmış sayılmayan noktalar

[CPU matrisi](cpu-local.md):34 gerçekCPU+6ilişkili eşya denetlendi. Modern top/sürüş/veba/PA-X işlevleri, cephanelik kapasiteleri, klan diplomasisi ve AJP kuponu eksiktir; çalışıyor olarak ilan edilmez. AJP fiyatı ve JP ailesinin ortak beklemesi açık yerel politikadır.

[Savaş](combat-balance-audit.md):lazer75–100% aralığı ve altı klasik yetenek süresi kaynaklıdır; genel NPC/roket/HST temel isabetleri ve gizli RNG/ArGe birleşimi tamamen doğrulanamadı. [NanoHull](nano-hull-local.md):hasar sırası kaynaklı;2000dolum ve dolu-havuz fallback'i yerel.

[Payment](payment-local.md):196teklifin tamamı1.000.000Uridyum;145teklif gerçek içerik teslim eder.51teklif eksik/açık olmayan içerik veya katalog yüzünden para çekmeden kapalıdır. Eventpass/tasarım/modern ekipman teslimi o ürünün bütün etkinlik/savaş tüketicisinin uygulandığı anlamına gelmez.
