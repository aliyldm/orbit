# Classic PET special gear investigation, 2026-10-20

This document records static client and official FAQ evidence, not an assertion that all features have been implemented or visually tested. No production DB changes were made for this investigation.

## Client command contract

All paths below are relative to `decompiled/main/scripts/net/bigpoint/darkorbit/`.

| Command | ID | Relevant fields |
|---|---:|---|
| PetGearActivationRequest | 154 | gearTypeToActivate.typeValue; optParam |
| PetLocatorGearInitializationCommand | 166 | locatorType.typeValue; possibleTargetValues:int[] |
| PetGearLocatorUpdate | 237 | x,y; (-1,-1) means no result |
| PetTradeWindowShowCommand | 247 | no payload |
| TradeSellOreRequest | 131 | toSell.oreType.typeValue; toSell.count |
| OreTradeInfoCommand | 1870 | type:3 for PET; ore prices |
| PetIdleModeCommand | 242 | petId; isIdle (hides PET, preserves entity) |
| PetBuffCommand | 239 | effectAction:0 add/1 remove; effectId; addingParameters:[seconds] |
| PetIsDestroyedCommand | 227 | destroyedType:1 means kamikaze |
| PetBlockUICommand | 246 | blocked; blockAll |
| PetUIRepairButtonCommand | 244 | enabled; repairCosts |
| AttackHitCommand | 28 | attackType.attackTypeValue:9 kamikaze,10 repair; attackerId/victimId/HP/shield/damage |

Gear types: 1 passive,2 guard,4 autoloot,5 resource collection,6 enemy locator,7 resource locator,8 trader,9 PET repair,10 kamikaze,11 combo ship repair,12 combo guard. Buff IDs:3 trade,5 kamikaze cooldown,6 combo repair cooldown.

`net/PetWindowAssembly.as:607+` builds locator target menus from InGameCatalog NPC IDs or ore IDs. It sorts translated titles; optParam is the selected target ID, not the displayed row number. Main selection without explicit target defaults to the first submenu entry. `net/PetAssembly.as:342+` applies gear select/change; `gui/BuffCoolDown.as` consumes seconds. `map/hud/ship/LocatorGearView.as` dims the ring for (-1,-1); updates sent before the locator asset finishes loading are ignored, so periodic updates are necessary.

`net/MapEventsAssembly.as:273+`: `0|n|fx|start|KAM|petId` plays the kamikaze sound, not an independently verified warning animation. `0|n|BOOOM|petId` sets the entity's explosionTypeID=6; send before a destructive entity removal. `0|n|HEAL_RAY|petId|ownerId` creates a two-second heal beam. AttackHit repair type10 displays healing and applies the received HP state. These are client capabilities; original server event scheduling is not present in the SWF.

## Embedded numeric item metadata

`items/ItemDataProvider.as`, around44294 (kamikaze),44638 (trade),44735 (repair),44797 (combo guard),44938 (combo repair). Level suffixes0/1/2 correspond to human levels1/2/3.

| Attribute | Level1 | Level2 | Level3 |
|---|---:|---:|---:|
| Kamikaze max_damage |25000|45000|75000|
| Kamikaze radius |163|228|293|
| Kamikaze cooldown seconds |120|60|30|
| Kamikaze survival_time |3|4|5|
| Kamikaze speed_increase % |15|30|60|
| Kamikaze player_hp_threshold % |10|10|10|
| Kamikaze pet_hp_threshold % |20|20|20|
| Kamikaze min_damage |200|400|400|
| Kamikaze dmg_reduction |0.5|0.6|0.75|
| Kamikaze hitpoint_percentage |12.5|16.67|25|
| Trader absent/cooldown seconds |300|120|30|
| Trader trade_bonus % |5|15|30|
| PET repair hps |2000|6000|12000|
| PET repair duration |89|30|15|
| Combo repair hps |10000|15000|25000|
| Combo repair duration seconds |5|5|5|
| Combo repair upfront fuel |200|400|750|
| Combo gear deflection chance % |65|75|85|
| Combo gear fuel consumption increase % |35|35|35|

Only names/values are established for kamikaze reduction, hitpoint_percentage and survival_time. The missing original server code prevents claiming an exact falloff formula or translating survival_time directly into a fuse. Do not invent that interpretation silently.

## Official FAQ corroboration and conflicts

[English classic PET FAQ](https://board-en.darkorbit.com/threads/pet-10-faq.1228/), [English combo FAQ](https://board-en.darkorbit.com/threads/p-e-t-combo-gears-faq.1227/), [Turkish PET guide](https://board-tr.darkorbit.com/threads/sss-p-e-t-kullanim-kilavuzu.127074/) checked2026-10-20.

The FAQs corroborate trader bonuses/absence, kamikaze damage/cooldowns, repair rates, combo fuel/heal values. Combo repair stops on owner attack and returns to guard, preferring equipped combo guard; PET attack alone does not stop it. Combo repair cooldown is15seconds.

Conflicts: FAQ kamikaze radii250/350/450 versus embedded163/228/293. FAQ PET repair durations120/45/30 versus embedded89/30/15. FAQ resource-collector LV3 range2500 versus embedded3000. Choose an explicit edition; no radius conversion formula is proven.

Fuel capacity100000; classic base consumption per minute=1+2×level+2×equipped protocols+4×equipped gears. PET speed matches owner. Active PET receives5% earned XP, including quests and gates. Human gear levels unlock at PET0/4/8. FAQ XP thresholds:8000×L³ through15; then39m,50m,70m,100m,150m. Current local PET starts at1; migration indexing needs an explicit policy.

Repair-cost table levels0..15:0,0,0,10,20,30,50,70,90,120,150,180,220,260,300,350; cap350 thereafter; premium free. FAQ prose contradicts its own low-level table, so document selected table behavior.

## Runtime decisions still requiring explicit local policy

Kamikaze damage falloff and shield/HP split; target and low-HP trigger timing; survival_time meaning; travel/cancellation/target disappearance; repaired HP percentage; exact XP indexing for preexisting level1 records; fuel fractional accumulation and restart persistence; cooldown start versus repair completion; server-authoritative trade price rounding. Trade must atomically remove only owned ore and award credits once; rejected/replayed requests must not grant credits or bypass absence. Unsupported modern heat/gears should remain unsupported.
