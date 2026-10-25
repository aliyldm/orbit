# Native header hangars — 2026-10-21

The original HANGAR header arrow now expands numbered hangars and its original `+` button. Each extra slot costs **250,000 Uridium**, a user-requested local price. A slot purchase creates a persistent **empty slot**, not a new ship. Existing ships, physical items, both configurations, drones and PET loadouts remain intact. The native inventory ship browser continues to expose every already-owned ship.

## Original evidence and boundaries

| Finding | Source / confidence |
| --- | --- |
| Arrow toggles numbered slots and `.header_hangar_slot_getNext` | `client/js/base-jQuery3.6.0.js:275`, `HeaderFunc.hangarSlotMachine`; directly inspected shipped JavaScript. |
| Original header appearance | `client/css/cdn/darkorbit.css:532–586`; existing `hangar_slots_sprite.png` / `hangar_extension_sprite.png` under `client/_host/do_img/global/header/buttons`. No new button artwork. |
| Old plus handler selects `hangar_slot` in ship shop | `client/resources/js/shop.js:698`, `onBtnGetNextHangarClick`. The captured shop has no corresponding purchasable row. The adapter removes that specific callback and provides an authenticated atomic purchase path. |
| Purchase confirmation | Original initialized shop uses `Tools.Popup.Presets.showQuestionDialog`; pages without this initialized shop component use browser confirmation with the same explicit total. |
| Maximum slots | `docs/client-map.items.json` → `hangar_slot.maxSlots=200`; corroborated `decompiled/main/scripts/.../ItemDataProvider.as` catalogue entry. Captured original prices vary; 250k is a deliberate user override. Expanded header can scroll at the genuine 200-slot limit. |
| Inventory selector accepts array index | `decompiled/swf_global/inventory/scripts/net/bigpoint/darkorbit/equipment/model/managers/HangarManagerProxy.as:197–210`: slot ID is the zero-based position in `ret.hangars`. Its `hangarID` remains the actual owned ship ID. |
| Ready bridge | Same source, `:833–883`: SWF `isReady()` triggers global `flashInitFinished()` when ready; it is not a boolean-returning readiness check. `client/js/hangarSlots-jQuery3.6.0.js` supplies global JS `isReady()`. |
| View/activation separation | Native `ConnectionProxy.activateShip` uses `flashAPI/inventory.php` and the existing `inventory.activate` ownership/offline guard. SWF suspension completion calls `setHangarBarActive(true)`; the adapter refreshes the active-ship label after this signal. |

An independent read-only source worker checked header resources and SWF selection/ready contracts separately from implementation, as required by RE skill §6. No REA configuration changes, decompiler installation or executable acquisition were needed; the existing extracted sources answered these questions.

`hangarPage` is parsed by the SWF, but a consuming selection path was not established in the inspected source. It is therefore not used as evidence that a FlashVar selects an owned ship. Empty slots are not inserted into native `ret.hangars`: the current SWF skips entries lacking an owned `ShipInfoVO`. Instead, its existing list/IDs remain stable and the header adapter calls `inventory.changeHangarSlot(existingShipsArrayIndex)`.

## Persistence and behavior

Migration `025-hangars.sql` adds three separate tables: purchased slots, the selected header view and purchase receipts. Existing accounts get only their legacy slot 1 mapped to their existing active ship. Other owned ships remain owned and available; ownership never creates free additional hangar slots. New accounts receive the same legacy mapping on first state access.

The header arrow exposes a small attached chooser for an owned, currently unassigned ship or the ship already in that slot. Assigning a ship invokes the original offline activation guard. Replacing a slot assignment leaves its previous ship and equipment owned and unassigned. Selecting an empty slot preserves the active gameplay ship; its unrelated inventory display is hidden until an owned ship is assigned. The header labels the **viewed hangar** and **active ship** separately. Activating another ship from the native inventory browser does not fabricate a paid slot; an unassigned active ship is identified as such.

`POST /ajax/hangar.php` accepts `purchase`, `select`, `assign` and `state`; authenticated GET only reads state and cannot perform a purchase even with mutation query parameters. Mutation requests require the native XHR header. Price and player identity are never taken from request fields. A purchase checks the expected next slot and uses a per-player receipt token; duplicate/retried requests return the same purchase without another debit. Reusing a token for a different slot, a stale next-slot request, insufficient money or a receipt-storage failure cannot partially debit or create a slot. Live purchases preserve the current in-memory wallet and send the resulting balance; failed writes leave it unchanged.

## Validation

- `tests/hangars.test.js`: legacy mapping/no free expansion, exact 250k charge, persistent empty slots, replay and stale token handling, rollback on insufficient funds/receipt failure, two-config preservation, replacement, foreign-account and online guards, live wallet, cap 200, native activation/view separation and unchanged Flash inventory IDs.
- `tests/hangar-client.test.js`: actual shipped adapter in a VM, original popup callback and request contract, double click/network retry token stability, SWF readiness/index semantics, empty-slot display/assignment and native active-label completion signal.
- `tests/hangar-http.test.js`: actual HTTP handler invoked in-process, authentication/XHR/GET boundaries, purchase/replay and rendered header. A real ephemeral-loopback HTTP attempt was denied by the execution sandbox (`EACCES`); it was replaced with this fixture, not skipped or treated as a passing socket test.

All **19 new tests** pass (`logs/hangar-tests.log`). A further **42 portal/payment/fuel/inventory regressions** pass (`logs/hangar-portal-regression.log`). These tests use in-memory databases. Actual Flash rendering and real TCP behavior are not established by the VM/in-process checks; the parent deployment/network pass supplies separate validation. No production purchase, account grant or server restart was performed by this implementation worker.
