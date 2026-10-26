# Eski sunucu / .NET kapsam karşılaştırması

**Tam geçiş tamamlanmadı.** Eski Node/SQLite kaynakları korunuyor; dosyanın mevcut olması veya PG arşivine kopyalanması, aynı özelliğin yeni motorda çalıştığı anlamına gelmez. `/ready`503 kalır.

Kaynakta 106 kayıtlı native komut, 60 veri tablosu, 20 envanter API işlemi ve 23 portal şablonu bulundu. Bunlar aynı ağırlıkta özellikler değildir; bu sayılardan tamamlanma yüzdesi çıkarılmaz.

| Özellik | Durum | Kalan kapsam |
|---|---|---|
| Existing login/session/reconnect | Kısmi | New account/company selection and full lifecycle pending. |
| Normal maps, shared NPCs and normal portals | Kısmi | Durable shared normal world implemented; special NPCs and full field effects pending. |
| Classic outgoing laser/RSB | Kısmi | 75 formula cases and native fire use live stats; CPU/special effects and retaliation pending. |
| Modern lasers, drains and proc effects | Eksik | Unsupported loadouts/ammo are rejected rather than silently using a classic fallback. |
| NPC retaliation, player death and paid respawn | Eksik | Critical before shared play. |
| Rockets, hellstorm launcher and advanced weapons | Eksik | Manual/automatic rockets, reload, charges and effects. |
| Supported CPUs and automation | Eksik | Preserve supported source behavior; seven previously disabled CPUs remain outside the required feature set. |
| Cargo, ore/box collection and trade | Eksik | Capacity, residual cargo, drop tables, stations/HM7/PET and claim ownership. |
| Hangars, inventory, configurations and sales | Kısmi | 12 Flash mutation actions and native write/config paths use canonical PG rows. Full read/UI projections, drone repair/sale, slot unlock and header hangars pending. |
| Live bonuses and upgrade-derived stats | Kısmi | 364 cases / 48778 JS-C# field comparisons across91 hulls. Hero load/fire/movement uses live stats; PET/ability/CPU runtime layers remain pending. |
| Drones, designs, formations and set bonuses | Kısmi | Live mounted bonuses, sets, descriptor and owned formation selection. XP/repair/sale, timed formation effects and full UI pending. |
| PET modules, protocols, fuel and progression | Eksik | All source modes/activation/menu lifecycle need port and tests. |
| Research tree and reset | Eksik | Costs, bonuses and native/portal controls. |
| Ore enrichment and ammunition/time buffs | Eksik | Quantities, bonus application and depletion. |
| Ship abilities, passives, techs and utilities | Kısmi | Hull/module stat and level-gated reward bonuses are live; activated abilities/techs/utilities pending. |
| Assembly, repeat production and module currency | Eksik | CV-M/UP-M economy and all previously working native tabs. |
| Single/bulk upgrades and level bonuses | Eksik | Upgrade jobs, costs, quantities and native layout. |
| Shop/catalog/special offers and purchase restrictions | Eksik | Prices, sorting, ownership and transaction effects must match the source. |
| All Galaxy Gates and opening/completion conditions | Eksik | Private isolation exists; actual gate content/waves/requirements/rewards are not ported. |
| Quests, ranks, gate rings and NPC points | Eksik | Wallet EP/level updates work; other progression ledgers and calculations pending. |
| Daily login, campaigns and event windows | Eksik | Repeat guards, original UI and portal synchronization. |
| Settings, hotkeys and graphics/drone visibility | Eksik | Original assets unchanged; persisted settings handlers are pending. |
| Original web/Flash API and game bootstrap | Kısmi | Authenticated Flash inventory mutation envelope exists. Full read APIs, pages and bootstrap pending; indexInternal remains501 and /ready503. |
| Multiplayer reward ownership, PvP and groups | Eksik | Current classic prototype pays the finishing attacker; original claim/group rules are pending. |
| 5-x maze | Kullanıcı isteğiyle kapalı | User explicitly requested it remain disabled. |
| Skylab requirement | Kullanıcı isteğiyle kapalı | User explicitly requested no Skylab requirement; source is retained. |

Komut/tablo/API işlemlerinin tamamı `legacy-parity-report.json` içinde adlarıyla bulunur. Bilinmeyen yeni dispatcher dalı `review_required` olur; sessizce tamamlandı sayılmaz.

Eski per-pilot NPC kayıtlarının tek paylaşılan dünyaya nasıl alınacağı son geçişte ayrıca uzlaştırılmalı. Mevcut oyuncu ilerlemesinin üstüne eski snapshot yazılmaz. Profil paketleri, rütbe/diroit/PET/arge verilerinin canlı repository yerine geçmez.

Yenilemek: `node tools/audit-legacy-parity.js`. Güncellik kontrolü: `node tools/audit-legacy-parity.js --check`. Araç test şemasını bellekte açar; canlı DB varsa yalnız salt okunur tablo adlarını karşılaştırır. Hesap/satır/paket içeriği rapora yazılmaz. `legacy-schema-tables.json` canlıda eklenmiş yardımcı tabloları da unutmamak için adlarıyla korur.
