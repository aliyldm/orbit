# Teknolojilerin gerçek kullanımı — 21 Ekim 2026

`game/techs.js` menüde bulunan 15 teknolojinin dokuzunu gerçek eşya stoku, atomik tüketim, kalıcı bekleme süresi ve savaş etkisiyle çalıştırır. Kullanım başına bir nesne tüketilir. Menü sayacı kaydedilmiş örneklerden değil `items` tablosundan gelir. Üretim veya paket tesliminden sonra savaş tick'i stok değişimini görüp menüyü günceller.

## Kanıtlar ve çalışan teknolojiler

[Resmî Tech Centre FAQ](https://board-en.darkorbit.com/threads/tech-centre-faq.894/) klasik beş etkinin sürelerini ve beklemelerini verir. [Resmî Alman Tech Factory açıklaması](https://board-de.darkorbit.com/threads/faq-tech-factory.2720/) isabet teknolojisinin Hellstorm, DCR-250 ve PLD-8'e uygulanmadığını ayrıca belirtir.

| Kimlik | Gerçek etki | Süre / bekleme |
| --- | --- | --- |
| `tech_energy-leech` | Gerçekte verilen uygun lazer hasarının %10'u DP'ye döner. SAB ve RSB hariç; maksimum DP aşılmaz. | 15 dakika / etkinleştirmeden 30 dakika |
| `tech_chain-impulse` | Seçili hedefle başlayan, en fazla 7 NPC'nin doğrudan DP'sine 10.000'er hasar; kalkan korunur. | Anlık / 1 dakika |
| `tech_precision-targeter` | R-310 ve PLT-2026/2021/3030 temel roketlerinin isabeti %100. Diğer mühimmatın oranı değişmez. | 15 dakika / etkinleştirmeden 5 dakika; aynı etkin teknoloji üst üste açılamaz |
| `tech_backup-shields` | 75.000 kalkanı gerçek maksimuma kadar doldurur. | Anlık / 2 dakika |
| `tech_battle-repair-bot` | Savaşta da saniyede 10.000 DP, 10 ayrı onarım tick'i. | 10 saniye / etkinleştirmeden 2 dakika |

[Resmî Plutus deneyleri açıklaması](https://board-de.darkorbit.com/threads/faq-plutus-experimente.116621/) ikinci nesil destek ve NPC bombasını tanımlar. [Resmî Eternal Blacklight FAQ](https://board-en.darkorbit.com/threads/eternal-blacklight-faq.126632/) AAER'nin NPC hasarına karşı korumasını verir.

| Kimlik | Gerçek etki | Süre / bekleme |
| --- | --- | --- |
| `tech_battle-repair-bot2` | Saniyede 20.000 DP ve 35.000 kalkan, 10 tick; NanoHull yenilenmez. | 10 saniye / bitişten 20 dakika |
| `tech_shield-backup2` | 450.000 kalkanı gerçek maksimuma kadar doldurur. | Anlık / 20 dakika |
| `tech_npc-nuke` | Etkinleştiğinde ve 10 saniyede bir 100.000 hasar; toplam 6 darbe. | 60 saniye / bitişten 20 dakika |
| `tech_anti-ai-emergency-reserves` | Gerçek NPC hasarından sonra DP 1'in altına düşmez. | 10 saniye / 30 dakika |

## İstemci sözleşmeleri

Yerel `ItemDataProvider.as` gerçek teknoloji loot kimliklerini, `resource_items.xml` ad/açıklamaları verir. `CooldownTypeModule.as` klasik grupları 18/19/20/21/23 olarak tanımlar. `VisualModifierCommand.as` Enerji Transferi 59, robot 60 ve robot2 61 değerlerini; `VisualModifierAssembly.as` bunların gerçek 2D/3D efekt kurulumunu içerir.

`TechAssembly.as` zincir darbesinin `0|TX|ECI|1|kahraman|hedefler` ve kalkan desteğinin `0|TX|A|0|SBU/SBU2|kahraman` biçimlerini işler. Yeni desteklerde menüye özel etkin süre/bekleme paketi kullanılır. Bütün üretilen komutlar testte gerçek codec ile kodlanır.

## İşlem ve yaşam döngüsü

Stok azaltma ile `settings.game.techCooldowns` yazımı aynı SQLite işlemi içindedir. Başarısız yazım stoku ve beklemeyi birlikte geri alır. Sahte menü isteği, stok yokluğu, ölü oyuncu, atlama durumu ve eski oturum aktivasyon yapamaz.

Aktif etkiler yerel çalışma belleğindedir; map değişimi, çıkış/bağlantı kesilmesi ve ölümde sonlandırılır. Bekleme süresi kayıtta kalır; harcanmış ürün geri verilmez. DP/kalkan artışları normal oyuncu kaydetme yolundan kalıcılaşır. ArGe, NanoHull ve normal tamir robotu değerleri teknolojiyle değiştirilmez.

## Açık yerel tercihler ve sınırlar

- Klasik kaynakta aynı anda üç farklı teknoloji sınırı vardır. Bu yerel sunucu yeni desteklere de aynı eşzamanlılık sınırını uygular.
- Zincir/NPC bomba menzili birincil metinde sayısal verilmez: yerel varsayılan **500**, `combat.techs.chainRange` / `nukeRange` ile değiştirilebilir. Zincir için seçili hedef gerekir, hedefler en yakından zincirlenir. Resmî İngilizce metindeki sabit 10.000 kullanılır; zincir başına özel hasar düşümü doğrulanmış değildir.
- NPC bomba hasarı normal NPC kalkan emiliminden geçer; metin özel kalkan delme belirtmediği için ek delme uygulanmaz. Korumalı ve menzil dışı NPC'ler etkilenmez; gerçek ölüm/ödül yolu bir kez çağrılır.
- Yerel Türkçe açıklama enerji transferinde UCB adını anıyor. Resmî İngilizce ve Alman açıklama bütün lazerlerden SAB/RSB'yi ayırır; burada o kapsam kullanılır.
- Tam kalkanlı gemide kalkan desteği veya onarılacak değeri olmayan gemide robot reddedilir; stok/bekleme tüketilmez. Bu, kaynaklardaki tam kalkan davranışının belirsizliğinde seçilmiş yerel politikadır.
- Altı teknoloji etkin değildir: **explosive-charging-blob**, **burning-trail**, **versus-laser-overdrive** PvP/özel harita gerektirir; **speed-burst** ve **frost-field** sayısal etkilerinin tamamı doğrulanmamıştır; **anti-mine-transmitter** için düşman oyuncu/IceMine tetikleme sistemi yoktur. Bunlar stoklu olsa da menüden başarılı kullanım gibi gösterilmez, stokları tüketilmez.

## Test

`node --test tests/techs.test.js` — **12/12 geçti**. Gerçek stok/codec, kapalı ürünler, geçersiz durumlar, kalkan sınırı, iki robotun kesin tick sayısı, NanoHull korunması, enerji transferi mühimmat ayrımı, isabet kapsamı, yedi zincir hedefi, altı NPC bomba darbesi, gerçek NPC hasarında AAER, üç etki sınırı ve işlem geri alma/yeniden yükleme doğrulandı. Bütün hesaplar `:memory:` veritabanındadır; gerçek oyunculara eşya/para verilmedi.
