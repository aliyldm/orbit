# Geliştirme alt paneli ve kayıp görünen gemi modülü — 25 Ekim 2026

**DÜZELTME, 25 Ekim:** Aşağıdaki EB teşhisi eksik ve yanlıştı. Kurulu `InventoryViewMediator`, ship/drone/pet bağlamını `toUpperCase()` ile dönüştürüyor; bu yüzden EB özgün **SHIP/DRONE/PET** olmalı. Küçük harfe çevirme dar envanteri boşaltan regresyondu; geri alındı. Önceki üç sınıflık test aradaki mediator adımını atlamıştı. [Yeni tam zincir doğrulaması ve sonuç](inventory-trade-audio-current.md). Geliştirme alt panelinin XML düzeltmesi korunuyor; aşağıdaki kayıt önceki dağıtımın tarihçesidir.

**Dağıtıldı: PID17180/solo8095–8096/healthOK.**1018test/369JS0hata/23840gerçekHTTP-TCPkomutuPASS. Önceki16172kayıtla durduruldu.22-16-56-352ZSQLite/WALyedekle60tablonun her satırı/şeması aynı;3hesap/3oyuncu/14gemi/integrityOK/FK0. Kanıt logs/upgrade-footer-production-check.json. ÜretimDBsaltokunurFlashAPIprojectionid570/DMG-VP01/EB[ship]/T12ilegörünürlüğü;gerçekHTTPXMLveMD5manifest dağıtımını doğruladı. Hediye/iade/migrationyok.

## Geliştirme penceresi

Native VerticalLayout varsayılan5px boşluğu ve alt listelerin gerçek141px yüksekliği önceki yerleşim testinde hesaba katılmamıştı. Alt panelin başlangıcı325, görünür alt sınırı490px iken pencere450px'ti. Önceki sadece113px parent-height toplamı bu taşmayı kaçırmıştı.

XML'de dikey boşluk açıkça0; standardViewContainer69+381=450; alt panel marginTop12/height128; bonus ve malzeme listeleri94px, kaydırıcıları88px. Alt panel281..409px aralığında, tüm build/building/collect/not_possible durumları450px içine sığar.120px envanter ızgarası aynı kalır ve büyük stokta kaydırılır; tüm öğeleri açıp paneli büyütmez.94px iki42px diroit bonus satırını5px arayla gösterir.

Kaynak delili `decompiled/upgrade-footer-layout/evidence.json`. Eski XML ayrı saklandı; regresyon eski490px taşmayı tekrar üretip yeni409px sınırı doğrular. Kaynak manifestindeki upgradeWindowUI MD5 yenilendi; resourcesXmlHash `local-20261025-upgrade-footer`. MAIN47a0… ve inventory SWF b782… değiştirilmedi. Native Qt görsel kabulü ayrıca kullanıcıda; geometri hesabı gerçek screenshot testi diye sunulmaz.

Seçili eşya azami16seviyedeyse özgün “Bu eşyayı daha fazla yükseltemezsiniz” durumu normaldir; yerleşim değişikliği azami seviyeyi veya maliyeti değiştirmez.

## Gemi modülü

Kullanıcı bunun Upgrade/Convert veya P.E.T. değil **gemi bonus modülü** olduğunu netleştirdi. Üretimde test/oyuncu3 envanterinde id570 `equipment_shipupgrade_dmg-vp01` bulundu;1adet, takılı değil.30x30ikonu kullanıcı istemcisine200ile gönderilmiş; dolayısıyla satın alınan öğe silinmiş değil.

Kurulu inventory.swf'den üç sınıf tekrar decompile edilerek gerçek sözleşme doğrulandı (`decompiled/module-visibility-check/evidence.json`). GridComponent.filterByContext, getEquipByOnly().indexOf(param4) ile **küçük harf** `ship/drone/pet` arar. Sunucu metadata'dan **büyük harf** SHIP/DRONE/PET gönderiyordu. Yanlış eşleşme ekipmanı nonFilteredItems'a atar ve görünmez yapar. Önceki inventory testi de yanlışlıkla uppercase'i doğru saymıştı; bu varsayım kaldırıldı.

web/inventory-api.js yalnız EB aktarımını özgün küçük harf formatına çevirir. Oyun metadata'sı uppercase kalır; backend ekipman doğrulaması değiştirilmez. Regresyon gerçek kurulu SWF'nin ifadesini çalıştırır: eski EBfalse, yeni EBtrue. Özgün12grubu ve Gemi Yükseltme Modülleri filtresi korunur. SUS/SUM uyumluluk/bonus verileri aynı kalır.

DMG-VP01'in özgün listesi Vengeance ailesi ve **normal Pusat**; **Pusat Plus dahil değil**. Yeni görünürlük bu uyumsuzluğu kaldırmaz. Testte modül Pusat Plus'a reddedilir ve normal Pusat'a takılır. Başka modül hediye edilmez veya satın alım/iade tekrarlanmaz.

Kullanıcı: hangarda Gemi sekmesi, envanter filtresi **Gemi Yükseltme Modülleri**. Yeni XML için oyunu tamamen kapatıp yeniden açmalı; hangarı da yeniden yüklemeli.
