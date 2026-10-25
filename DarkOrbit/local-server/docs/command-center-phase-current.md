# Komuta Merkezi, mağaza yolu ve Mimesis Phase Out — 24 Ekim 2026

Dağıtıldı: PID18964, solo HTTP8095/TCP8096, healthOK. 992/992 test,358 JavaScript dosyası/0 sözdizimi hatası,23.488 gerçek HTTP/TCP paketi geçti. Bu paket tüm yerel açıkları bitirmez; [kalanlar](remaining-work-current.md) günceldir.

Komuta Merkezi'nin `/flashAPI/brNews.php` açılış ucu boş XMLstub döndürüyordu. Artık native pencerenin beklediği layer/config/assignments/actions XML'i ve onunla eşleşen iki `BE_local_*` etkinliği üretiliyor. Mevcut cached yıldız gemisi görseli, native Haberler kategorisi, metin konumları ve düğme stili kullanılır. Özel Fırsatlar ve P.E.T./Modüller gerçek portal sayfalarına gider. Bunlar yerel içerik duyurularıdır; Bigpoint'in canlı kampanyaları/ödülleri etkinleştirilmez. Duyurular sayaçsızdır; uzun oturum ömrü takvim kampanyası değildir.

Eksik `InternalMapRevolution.referOpenerToUrl` JavaScript köprüsü eklendi. Açık portal penceresine yönlenir veya adlandırılmış portal penceresi açar. Bu yerel köprü yalnız aynı kökendeki indexInternal.es bağlantılarını kabul eder. Gerçek XML→istek kimlikleri, okundu kaydı/yeniden yükleme ve sahte/eski haberin kayıt açamaması test edildi. Kullanıcının açılmama tercihi korunur; yeni hesaplarda login/jump otomatik popup açmaz. Pencerenin gerçek Qt render kabulü henüz yapılmadı.

## Mağaza listesindeki yanlış eksik

Bu istemcide SHOP ve NEWSHOP, `FeatureMenuActionCommand` → `CommandCenterTriggerShopCommand` üzerinden portal dükkânına gider. News kategorisi sales olmadığı için duyurular mağaza düğmesini ele geçirmez. `ShopItemListCommand` signed-byte127vektör sınırı ayrı protokol iskelesine aittir; mevcut mağazanın görünen yolunu engellemez. MAIN patch veya sahte sayfalama eklenmedi. LF4tavanı için çıkarılmış ürünlerden sonra176korunan kampanya gerçek portal Özel Fırsatlar kategorisinde tek kez görünür. Önceki196/162sayıları tarihsel raporlardır; kapalı paketlerin manifest/işlev açıkları sürer.

## Phase Out

[Resmî Mimesis SSS](https://board-en.darkorbit.com/threads/new-ships-faq.118482/): rastgele yönde50harita birimi sıçrama; radyasyona çıkamaz;5dakika bekleme. GG/LoW/UBA/korsan haritaları yasaktır. Uygulama mevcut normal1-x..4-x haritalarını kabul eder; desteklenmeyen özel haritayı güvenli reddeder. 50mini-harita birimi mevcut istemci koordinat ölçeğinde5000dünya birimidir. Yuvarlamadan kaynaklanan1dünya biriminden küçük fark dışında mesafe sabittir; kenarda kısa mesafeye kırpılmaz. Uygun yönler içinden rastgele seçer, döngü sınırlıdır, uygun tam mesafe yoksa bekleme başlamaz.

Konum sunucuda anında değişir; eski rota, oyuncunun toplama ışını ve bekleyen gemi değiştirme iptal olur. CPUkamuflajı ve hedef bağı sırf sıçrama olduğu için silinmez; menzil denetimi normal savaş yolundadır. Ek dokunulmazlık verilmez. Native VisualModifier4ve MoveCommand(time0) kullanılır; yakalanmış istemci verisindeki2s süre yalnız efektin kaldırılmasını yönetir. Konum değişimi bu2s'yi beklemez. 2Dalpha ve3Dphase_out_skill_short.zip sözleşmeleri mevcut;3Ddosyası yerelde doğrulandı. Özgün görsel paketlerin ekranda sıralama/fade kabulü hâlâ açık;2s'nin orijinal özel sunucunun ağ zamanlaması olduğu iddia edilmez.

## Veri ve doğrulama

- Yedek: `backups/darkorbit-before-2026-10-24T17-18-13-051Z.db`.
-60tablonun şeması ve bütün satırları yedekle aynı;3hesap/3oyuncu/14gemi,integrityOK/FK0.
- MAIN SHA256 `d7322098f565d49622d57475591c9a3b47b0ea6fcab8b70102e4b2da9b4fc824`; cacheaynı. Migration/hediye/iade/Qtgirdisi yok.
- Kanıt `logs/command-center-phase-production-check.json`; tam test/ağ/kaynak logları aynı önekte.
- Ağ testi ayrı bellekDB/portlarda gerçek haber HTTPyanıtı, TCPokundu isteği ve PhaseOutmenü isteği/MoveCommand yanıtını içerir. Üretim hesabı üzerinde yetenek kullanılmadı. İlk ağ denemesi sandboxfetcherişiminde başarısız oldu; yetkili izole tekrar tam geçti.

Orijinal görev kataloğu en sona,5-xlabirenti kapalı,LF4tavanı ve çok oyunculuya henüz başlamama kararı korunur.
