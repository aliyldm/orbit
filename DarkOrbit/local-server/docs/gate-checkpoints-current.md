# Galaxy Gate dalga portalları — 23 Ekim 2026

Ana dalga temizlenince solda sonraki dalga, sağda ana üs portalı çıkar. Savaş sürerken sürekli açık kaçış portalı kaldırıldı. Aynı ana dalganın alt grupları otomatik gelir; örneğin Alpha'nın dört Streuner alt grubunun her biri ayrı portal seçimi istemez. Zeta'nın korumalı Devourer ve muhafız dizisi korunur.

Dayanak: [resmî Galaxy Gate FAQ](https://board-en.darkorbit.com/threads/galaxy-gate-faq.972/), dalga sonu iki merkez portalı ve üsse dönüşte ilerleme kaydı. Bunlar özgün davranışın doğrulanan kısmıdır; kaynak bütün modern kapıların birebir sunucu kodu değildir.

`026-gate-checkpoints.sql` yeni `waiting_next_wave` alanını varsayılan 0 ile ekler. Mevcut aktif kapı, can, parça, NPC ödül makbuzları ve plan snapshot'ı silinmez. Sonraki ana dalganın başlangıç fazı ve bekleme durumu DB'de tutulur. Oyunu kapatıp açmak yeni dalgayı kendiliğinden başlatmaz. Sağ portaldan çıkmak can tüketmez; ana haritadaki kendi kapısından tekrar girmek bekleyen dalgayı başlatır. Sol portal aynı kapı haritasını yeniden başlatır. Gecikmeli jump tamamlanırken sahiplik/aktif koşul ve gerçek portal tekrar doğrulanır; iptal edilen jump ilerlemez. Ölümde bekleme temizlenir ve mevcut ana dalganın başlangıcına dönülür; mevcut can/ödül güvenliği korunur.

Dosyalar: `game/galaxy-gates.js`, `game/gameplay.js`; migration026. `prepareTransition` yalnız sunucunun ürettiği mevcut portalı kabul eder. Sadece portala yaklaşmak veya pencereyi açmak dalga ilerletmez.

23 kapı odaklı test geçti (`logs/gate-checkpoint-review.log`). Bütün 10 desteklenen kapı tamamlanmaya kadar çalıştırılır; korumalı patronlar açılır, her ödül bir kez verilir. Ek Zeta testi kontrol noktasını kaydet/yükle, üsse çıkış, yeniden giriş ve eski portal isteğini sınar. Gerçek ağ testinin Alpha/Epsilon bölümü native `MapAssetActivationRequest` üzerinden portalları kullanır; testler canlı hesabı değiştirmez.

Sınırlar: Alpha/Beta/Gamma/Delta/Epsilon/Zeta/Kappa/Lambda/Hades/Kuiper desteklenir. Kronos ve diğer modern/etkinlik kapıları henüz yoktur. Hades grup mekaniğinin tamamı yerine belgeli solo uyarlamadır. Mevcut alt grup süreleri, harita koordinatları ve son ödülün ardından otomatik üsse dönüş davranışı bu tur bütünüyle özgün zamanlama olarak doğrulanmadı. Native Flash ekranının görsel kontrolü yapılmadı. Önceden kaydedilmiş planlar yeni katalogla zorla değiştirilmez; `docs/gate-content.md` kapsam/sürüm farklarını açıklar.
