# ArGe etkileri ve açıklamaları

21 Ekim 2026. `skills.BENEFITS` bütün 25 dalın seviye tablolarını hem gerçek hesaplamaya hem özgün temadaki mevcut/sonraki bonus açıklamasına verir. Önceki tooltip sadece maliyet ve önkoşul gösteriyordu. II. aşamalar I. aşamanın yerine geçer; iki toplam bonus toplanmaz.

Kontrol edilen tüketiciler: gemi can/kalkan/kargo kapasitesi, kalkan emişi, robot tamir hızı, lazer/roket hasarı ve isabeti, kaçınma, mayın hasarı/yarıçapı, NPC imhasından TP/kredi/şeref, düşman kargosu ve bonus kutuları. Kelle Avcısı yalnız oyuncu hasarı içindir; solo NPC hasarına eklenmez. Kalın lazer koşulu I 2/2 ve II 3/3'tür. Bu çalışma PvP eklemez.

- [Resmî Pilot BIO FAQ](https://board-en.darkorbit.com/threads/pilot-bio-skill-tree-faq.1224/): klasik sayısal tablolar ve kapsam. Bağlayıcı Işın II artık `%2/6/10/15/20`; önce `%2/4/6/8/12` kullanılıyordu. Eski [Pilot Bio Guide](https://board-en.darkorbit.com/threads/pilot-bio-guide.1015/) farklı tablo içerir; esas FAQ ve sonraki kutu açıklamaları tercih edildi.
- Ayarcı için eski FAQ `%2…12` yazarken gönderilen güncel pilot sayfası ilk seviye `%5` gösterir. Mevcut `%5/10/15/20/25` sürümü korunur. [2016 sürüm tartışması](https://board-en.darkorbit.com/threads/ti-electro-optics.113600/) bu değişikliğe de işaret eder; tabloyun temel kanıtı eldeki istemci kaydıdır.
- Gerçek sunucunun isabet bonuslarını birleştirme sırası yayımlanmamıştır; mevcut belgeli yüzde puanı hesabı korunur. Varsayılan roket isabeti `%100` yerel olduğundan bu ayarda Isı Arayıcısı ilave görünür isabet sağlamaz; özgün kurtarılan vuruş ışığı daha düşük taban isabette çalışır.
- Azami Mühendis için Beacon'ın `repairBotSkilled` alanı da açılır. Mayın ArGe bonusunun akıllı bombaya yanlış uygulanması kaldırıldı; resmî kılavuz bu ayrımı açıkça yapar.

Seprom kullanılmaz; kullanıcının yerel kuralıdır. Sıfırlama sabit 300.000 U. tutar; dağıtılmış puanları geri verir. Kazanılmış puan, can kaybı, NanoHull ve güncel bakiye korunur. Azami can/kalkanın büyümesi mevcut hasarı ücretsiz tamir etmez.

`tests/skill-benefits.test.js`: her dalın her seviyesi, aşama yerine geçmesi, özgün tooltip, gerçek canlı World yükseltme/sıfırlama paketleri, kutu/kargo teslimi ve PvP/NPC ayrımı. `tests/skills.test.js` önkoşul/ödeme/sıfırlama; `tests/laser-specials.test.js` gerçek savaş etkileri için ek doğrulamadır. Gerçek Flash ekranındaki her görselin görüntülendiği iddia edilmez.
