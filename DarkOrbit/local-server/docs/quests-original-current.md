# Kaynaklı solo NYX görevleri — 23 Ekim 2026

Diğer kapsam tamamlandıktan sonra33solo görev eklendi; toplam görev sayısı53. Önceki20görev ve kabul edilmiş snapshot'lar değişmedi. `game/quests-original.js` tablosu her hedefi, harita koşulunu ve ödülü okunur biçimde içerir.5.seviyeden2,6.seviyeden12,8.seviyeden7,12.seviyeden12 görev vardır.

Kaynak: [NYX MISSION FAQ,2015](https://board-en.darkorbit.com/threads/nyx-mission-faq.102728/). **Resmî forumda yayımlanmış oyuncu raporudur; özgün sunucu paketi değildir.** Ödül/hedef sayıları kaynaklıdır. Özgün görev kimlikleri ve bütün prerequisite zincirleri bu kayıtta bulunmadığından yerel910001..910033 kullanılır; seviye koşulu uygulanır. `[NYX]` başlıkları ve kısa Türkçe hedef açıklamaları yerel kaynak XML'ine eklendi. Kaynakta süre/PvP/başarısızlık/konum şartı olup desteklenmeyen görevler şartı silinerek kolaylaştırılmadı; bu sürüme alınmadı.

Örnek Stronghold:12.seviye, şirketin x-7'sinde1Kristallon+7Kristallin;60U.,565.000TP,120.000kredi. Boss türü normal tür yerine sayılmaz; yanlış harita ilerletmez. Her şirketin haritası kabul anında çözülüp snapshot'a kaydedilir. Sabotage Suppliers/Target Unclear aynı türün x-6/x-7 hedeflerini ayrı tutar. Süresiz, paralel solo hedefler genel motorla yürür; ödül/claim/progress tek SQL işlemindedir.

`tests/quests-original.test.js` bütün33görevi kabul/ilerletme/ödül/tekrar kabul reddiyle bitirir. Normal/Boss ve harita ayrımı ayrıca testlidir. Tüm53başlığın Flash kaynaklarında bulunduğu, codec yapıları ve önceki görev testleri de doğrulanır.

Tam özgün katalog, yüksek seviye zincirleri, kaynağı bulunmamış açılma örüntüsü, gerçek günlük/haftalık görev döngüsü, süre/başarısızlık koşulları ve PvP/grup görevleri hâlâ açık iştir. Kalıcı yerel sezonun altı görevi bu katalogdan ayrı sistemdir.
