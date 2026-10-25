# Native home quest station

The home-base exclamation NPC now receives an actual `QuestGiversAvailableCommand` after its `AssetCreateCommand`. The native Flash click opens the existing quest-giver window, sends `QuestGiverApproachedRequest`, and requests quest details. The server supplies the existing twenty quest definitions and persisted running quests; this change does not add a separate HTML quest window or claim that every original DarkOrbit mission is present.

## Evidence and cause

Paths below are relative to `local-server`:

| Source | Observed contract |
| --- | --- |
| `decompiled/main/scripts/net/bigpoint/darkorbit/map/model/traits/clickIcon/ClickIconTrait.as` | Starts disabled; click processing requires enabled state. |
| `decompiled/main/scripts/net/bigpoint/darkorbit/map/model/env/homebase/QuestGiver.as` | Icon click opens the native quest window, sends the asset ID in `QuestGiverApproachedRequest`, and refreshes selected quest details. Disabling the icon closes that window. |
| `decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/QuestGiversAvailableHandler.as` | Disables all quest-giver icons, then enables listed `mapObjectId` values. Repeating an unchanged command can close an already open window. |
| `decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/questfm/QuestListHandler.as` | Registers the selected-detail refresh handler when constructing `QuestProxy`; the availability handler's constructor path omits this registration. Therefore `QuestListCommand` must precede availability. |
| `game/templates/init.json` | Captured quest-giver asset 150000000 at (2000, 3080), type 34/design 3; captured availability is empty. Replaying that empty packet before the generated quest list created the wrong proxy initialization path and left the asset disabled. |
| `decompiled/pet-patterns/lib-assets.xml` | Company home designs 3/6/9 are Morgus Petterson, Reginald Crowley and Vanessa Arkadium respectively. Turkish character descriptions in `client/spacemap/templates/tr/resource.xml` confirm their names. |

No nonempty availability packet was recovered from the available recorded sessions. The generated command follows the decompiled handler and generated wire codec. `questGiverId` in its `QuestGiverModule` remains default 0 because this client does not read that field; `mapObjectId` is the actual asset ID 150000000. Tooltip replacement type 0 is the source-defined plain string type.

## Server behavior

`game/quest-station.js` enables only the player's own lower home-map actor, while alive, not jumping, and within the authoritative actor range. The configurable `gameplay.questGiverRange` defaults to 1800 map units; this is a local range, not a recovered server constant. Other companies' bases, upper bases and maps without that actor send an empty availability list. Existing EIC/VRU mirrored station placement remains local; the actor position exactly matches its emitted asset.

The approach handler validates authentication, session membership, exact asset ID and actual actor position. It no longer measures against the center of the space station. Combat ticks send availability only on transitions, preserving an open native window while the player remains in range. Leaving range, death or jumping disables it; map bootstrap initializes the next map's state.

A validated approach records HOME and remembers an open window for that player/map/actor. Accepting a quest while this window is still open and in range records HOME only for the newly accepted quest and only if HOME is already active as the first objective. This makes the initial captured HOME tutorial usable without closing and reopening the NPC window. Later ordered HOME objectives still require a fresh real approach after their preceding objectives. Closing the window, moving away or changing map prevents this accept-time shortcut.

Quest completion still uses persisted snapshots, ordered progress and an atomic reward claim. An injected item-write failure leaves the quest running with unchanged progress/reward balances and emits no completion; a subsequent valid approach retries once. Captured starter 20000–20004, reconstructed continuation 20005/20006, Skylab 2 and explicitly local 900xxx content retain their existing provenance in `game/quests-content.js` and `docs/quests-local.md`.

## Verification and limits

`tests/quest-station.test.js` checks full bootstrap order and codec roundtrips, all three company actors, invalid actor/session/range/death/jump cases, transition suppression, native request flow, accept-time HOME, ordered hand-in, reconnect snapshots, reward rollback and live combat tick updates. Existing systems and expanded-quest suites also pass. These are source, codec and isolated SQLite/runtime checks; this work did not visually operate a running Flash client, restart production or modify its database.

On 2026-10-21 the complete suite passed 725/725 tests (`logs/quest-station-full-tests.log`); `tools/check-source.js` checked 247 JavaScript files with zero syntax errors, and `tools/check-client.js` passed all four packaged-client checks. The focused station/systems/expanded suites passed 52/52.
