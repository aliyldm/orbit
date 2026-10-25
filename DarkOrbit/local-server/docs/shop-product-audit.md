# Shop capability audit — 2026-10-21

24 October supersession:31 stable ship modules now have real equip/stat/native UI consumers; unstable modules remain unsupported. Retired17 laser types and mixed bundles containing them are hidden/rejected; LF4 ceiling is active. Historical counts below predate this policy. See [current report](cargo-maze-current.md).

Later24October: eight additional ability menus across ten additional hulls, native paid PET HP/laser-generator slots and independent ALB/RB ammo selections now have consumers. Some other abilities on those same hulls remain incomplete; no claim that all80hulls are complete. See [solo completion](solo-completion-current.md).

This is a catalogue-to-consumer audit, not proof that every original private server formula has been recovered. It covers the captured normal shop, generated canonical aliases and every component of each resolved Payment manifest. `node tools/audit-shop-products.js` prints the complete reproducible report without opening a player database. The JSON snapshot is `docs/shop-product-audit.json`.

Initial result: 523 offer/alias rows, not 523 distinct products. 330 have an implemented local consumer, 134 are partial, 11 are valid stored materials/keys, 25 are unavailable because an actual advertised function is missing, and 23 Payment offers lack complete manifests. There are no unclassified offered types or resolved components. These counts include aliases and do not assert exact original behavior for the implemented category.

22 October snapshot adds the local Seprom offer: 524 rows, with stored materials/keys now12; the other category counts remain unchanged. `docs/shop-product-audit.json` was regenerated from the actual current catalogue.

Of the 196 captured Payment manifests, 173 have complete delivery descriptions. Eleven of those contain a known unsupported functional component, so 162 remain purchasable. These additional closures are deliberate: a complete inventory manifest is insufficient evidence that its advertised effect works.

## Runtime coverage

| Client type | Local consumer / limit |
| --- | --- |
| ShipType | Hull slots/statistics, ownership and native appearance; explicit hull passives below. Six classic abilities have solo consumers; other advertised active abilities and PvP/group portions are marked partial. Hull purchases stay available. |
| LaserType | `stats`, `modern-lasers`, `combat`; laser-specific formula evidence/limitations are separately documented. |
| HellstormLauncherType | `hellstorm.hardware`, reload, five/three-round volley and impact. |
| AmmunitionType / SpecialAmmoType | Actual menu dispatcher: `laser-ammo`, `rocket-types`, `advanced-weapons`, `hellstorm`, `combat-utilities`. PIB has base damage but its infection is partial. IM-01/WIZ-X have no infection/transformation consumer and are blocked. |
| EngineType / ShieldType | Active configuration stat pool; shields include upgrading, absorption and Fusion regeneration. |
| CPUType / ModuleType / UpgradeType / RobotType | `cpu-catalog`, `cpu`, `jump-cpu`, `hellstorm`, repair and cargo paths. Anti-Z1/XL, RD-X and PA-X do not have their required infection/diplomacy/PvP consumer and are blocked. |
| ExtraType with Booster kind | `boosters.addOwned/applyStats/applyReward`; PRC/PvP are blocked, owner-only shared boosters are explicitly partial. |
| DroneType / DroneFormationType | `drones` ownership, equipment, effects and visible formation. |
| ShipDesignType / DroneCustomizationType / DroneDesignType / PET appearance types | Native ownership, appearance and verified passive effects. A cosmetic need not have an action button. |
| PetType / PetGearType / AIProtocolType | `pet` ownership, stock, gear/protocol stats and tick; only source-backed supported gear/protocols offered. G-FS1/G-HR1/AI-AH1 are blocked. |
| ItemType / OreType / HardwareType | Fuel, pilot logs and booty keys have real consumers. Other material stock is valid for declared assembly/tokens/trades. DSE/Echo event keys remain stored and are explicitly labelled as lacking their event destination. |
| TechType | Nine supported technologies use `techs` stock/cooldown/effect consumers. Unsupported AMT/Frost and other missing tech effects cannot be purchased in mixed bundles. |
| ShipUpgradeType | Slots/ownership alone do not implement the advertised bonus. SPC-XP01/02 and unresolved bonus modules are blocked. |
| CaptainType | NOVA skill/energy system is missing; purchase blocked. |

An unknown future type is reported as `unverified`, not automatically denied. Materials/cosmetics are never blocked for lacking an active button. `economy.purchase` checks genuine unsupported effects before dispatch, player snapshots, debit, grants or receipt writes. Portal rows use the existing native `notBuyable/isBuyable` flags and their original descriptions with a local-status addition; the in-game shop omits disabled entries. Ordinary prices, dynamic drone prices, quantity rules and original fixed-price Payment rules remain unchanged.

Additional disabled Payment rows: Halloween S/L/corn/mega packages (WIZ-X and/or AMT); Halloween tech (Frost); Dusklight Hecate Plus (SPC-SPD01); Dusk Citadel Plus (SPC-C02); four module/resource bundles (HP/SHD/DMG/SPC-XV03). Original manifests remain preserved; nothing is replaced with a fabricated icon item.

## Ship passive repair and evidence

The exact IDs and Turkish descriptions in `web/portal/pages/internalDock~internalDockShips.html`, `Shop.Parameters.itemData`, are the edition reference. `docs/client-map.items.json` proves the hull IDs and base values, but does not contain these passives. The official [Ships FAQ](https://board-en.darkorbit.com/threads/ships-faq.114154/) independently confirms the classic damage, shield, XP and honour bonus families; its historical base HP/Spectrum values differ from the supplied newer capture, so no historical hull base values are substituted.

`ship-passives.js` applies the following source-backed bonuses, once on each fresh player load, before existing drone/skill/ore/booster composition:

- Enforcer, Diminisher, Venom, V-Lightning: +5% weapon damage. Bastion, Solace, Sentinel: +10% shields. Spectrum: **+25% shields**, matching the captured description rather than the older FAQ's 10%.
- G-Veteran and G-Goal/V-Adept/BB-Solemn: +10% XP. G-Exalted/V-Corsair: +10% honour. V-Revenge/G-Referee: +5% damage; G-Kick/V-Avenger: +10% shields.
- G-Champion: +5% damage/+10% honour. G-Centaur/G-Saturn: +10%/+20% HP. G-Surgeon: +6% damage/XP/honour. A/C/S-Veteran: +5% XP/honour. A/C/S-Elite: +5% damage, without claiming their unimplemented ability duration changes work.

Damage composes with actual laser and normal/Hellstorm rocket paths through `laserDamage` and `rocketMultiplier`. Tech fixed damage and cosmetics do not gain another hull multiplier. `applyReward(playerOrId,reward,{db})` resolves the currently active owned hull and adjusts only positive `ep`/`honour`; other grants and penalties are preserved. The common `boosters.applyReward` entry composes this helper exactly once for NPCs, quests and gate completion. Direct purchases keep their fixed grants. `tests/systems-boosters.test.js` also exercises an actual progression grant, stacking and active-hull switch. Stacking with the other bonus systems uses the existing local multiplier pipeline; exact original additive-versus-multiplicative stacking is not asserted.

## Fusion repair and evidence

The captured generator descriptions and official [Generators FAQ](https://board-en.darkorbit.com/threads/generators-faq.968/) identify FS-01/02/03 and give **6.25% additional shield regeneration per equipped shield**, additive across Fusion shields. `fusion-shields.multiplier` adds this to the active ship/drone pool; regeneration boosters multiply that result. It does not boost max shield, count unequipped stock or accumulate on reload.

The existing local regeneration base/lockout was deliberately preserved: 5% per combat tick, after 10 seconds since `lastCombat` (including own attacks). The FAQ describes five seconds without damage. That timing/base remains a separate accuracy gap. Applying the mixed Fusion/ordinary multiplier to the ship's whole shield pool is the explicit local policy; exact old mixed-pool server semantics have not been recovered. PET regeneration is not supplied by this ship-only hook.

## Verification

`tests/shop-product-audit.test.js` tests complete classification, all known unsupported normal purchases with unchanged player/items/boosters, mixed-bundle rejection before delivery, valid materials/cosmetics/hulls, native portal flags/messages and the native shop packet list. `tests/ship-passives-fusion.test.js` tests real fresh-load application, no repeated stacking, active-hull reward changes, penalty preservation, captured source percentages, mixed shields and regeneration booster composition. All use an in-memory database. No production grants, account changes or server restart are performed by this audit.
