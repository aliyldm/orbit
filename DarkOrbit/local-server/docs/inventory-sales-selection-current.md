# Envanter satışı ve geniş görünümde çoklu seçim — 25 Ekim 2026

Dağıtıldı: PID26424, solo HTTP8095/TCP8096, health OK. Önceki20264, `tools/stop-server.js` ile kimliği doğrulanarak kaydedilip kapatıldı. Kanıt: `logs/inventory-sales-production-check.json`.

## Satış

Native `sell` ve `sellMultiple` isteklerinin API eylem tablosunda bulunmaması kesin köktü. `game/inventory-sales.js` ve API yolları eklendi. Sunucu fiyatı kaynak metadata/PET seviye kataloğundan hesaplar; istemcinin fiyat alanını kullanmaz. Örnek LF3:25000kredi, LF5-MF:50000kredi. LF5 satın alma kilidi sahip olunan eşyanın satışını engellemez.

Tekli eşya, yığın miktarı ve toplu seçim desteklenir. Kısmi yığın yanıtı `data.update.changed[id].Q`, tamamen satılanlar `data.update.deleted` olarak döner; native istemcinin model ve simge silme/güncelleme yolları bunları tüketir. Mevcut API para alanı da güncel bakiye verir. Satış ve kredi ödemesi aynı SQLite işlemindedir; sahiplik, pozitif tam sayı miktarı, stok, yinelenen ID, satılabilirlik, güvenli sayı sınırı ve işlemdeki upgrade/assembly hedefi kontrol edilir. Geçersiz toplu kuyruk bütün işlemi geri alır. Tam satılan eşyanın iki konfigürasyon/diroit/PET/CPU şarj bağları FK ile temizlenir. Canlı cüzdan esas alınır, sonraki world.save ödemeyi kaybetmez. Kullanıcı hesabında test satışı yapılmadı.

Takılı eşya satılabilir. Mevcut unequip kuralı gibi, SLE CPU satışı ek eşyaları kapasite dışında bırakacaksa önce genişletilmiş yuvaları boşaltma mesajıyla reddedilir; otomatik taşırma uygulanmadı. Kaynak metadata'da satılamayan eşya satılamaz. Gemi/PET gövdesi satışı bu eşya isteğine genişletilmedi.

## Geniş envanter seçimi ve yığın güncellemesi

Kurulu DragComponent, `Settings.inventoryOpen` durumunda Ctrl/Shift dallarına gelmeden tekli seçim yapıyordu. Geniş görünümde **Shift+tıklama** mevcut native aynı-tür toplu seçime, **Ctrl+tıklama** mevcut tek tek ekleme/çıkarma yoluna yönlendirildi. Normal tıklama seçimi teke indirir. Shift dikdörtgen sürükleme hâlâ özgün küçük görünüm yoludur; geniş dikdörtgen seçimi eklendi diye sunma.

Native Inventory.optionalItemUpdate, kısmi yığın yanıtında S yoksa yerel slotu sıfırlayabiliyordu. S yalnız sağlandığında atanır; Q normal güncellenir. Yeni yerleşim/kısayol tasarımı yapılmadı. İki sınıf tekrar derlendi/çıkarıldı; kod dışı bütün etiketler aynı, önceki kompakt filtre, kaydırma ve diroit toplu sürükleme yaması korunur. Native gerçek fare/klavye oynatımı yapılmadı; derlenen metotlar, yönlendirme ve API/ağ akışı testli.

Inventory SHA256: `1721614e40928882542eb84f2158e2309def9b02f5806a0b11e29fa7caf8336a`; portal cache `20261025sales`. MAIN `6839384b…`, gameclientHash `local-20261025-compact-rsb-2d` ve upgrade footer aynı. **Hangarı yeniden yükle.**

## Doğrulama

- 1067/1067 test;383 JavaScript dosyası,0 sözdizimi hatası. Son yalnız tanı eklenen test helper'ı ayrıca `node --check` ile doğrulandı.
- Gerçek bellek DB/ayrı port HTTP-TCP testi24155komut PASS. Tek/toplu/kısmi satış, ödeme, miktar, native cephane sayacı ve yinelenen satış reddi doğrulandı. İlk ağ çalışması mevcut korsan kutusu açma adımında zaman aşımına uğradı; diğer testler bitince tekrarı oyun davranışı değiştirilmeden geçti. Kutu testine sonraki hata için durum tanısı eklendi. Bu zaman aşımının kesin nedeni çözüldü diye sunma.
- Taze SQLite/WAL yedeği `backups/darkorbit-before-2026-10-25T08-07-04-435Z.db`; açılıştan sonra60tablonun bütün şema/satırları aynı:3hesap,3oyuncu,14gemi, integrityOK/FK0.
- Loglar: `inventory-sales-full-tests.log`, `inventory-sales-client-focused2.log`, `inventory-sales-source.log`, `inventory-sales-network-final.out.log`, `inventory-sales-database.log`.

Ek soru: diroit tekli/set bonusları güncel kod ve resmî FAQ ile tekrar karşılaştırıldı; `tests/ranks-designs.test.js` mevcut testleri de geçti. Havoc seti diroit lazerine%10; Hercules ilgili diroit kalkanına%15 ve tam setteHP%20; Spartan tekli ilgili lazer%1/tasarım başınaHP%1,10'lu sette toplam lazer/kalkan/HP%10/%10/%15. Depoda/visual yuvada bonus yok. Bu turda bonus formülü değiştirilmedi; kaynak ve kapsam `design-rank-current.md`.
