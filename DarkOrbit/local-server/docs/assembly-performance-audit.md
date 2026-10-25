# Assembly request performance audit — 22 October 2026

23 October fixes implemented and tested: `logs/assembly-benchmark-after.json`. With the same1,000-item fixture, init SQL5,307→75; filter5,307SQL/205KB→1SQL/0packets; collect10 76,762SQL/1,600commands/4,299,473bytes/1,192ms→451SQL/13commands/68,202bytes/65ms. The native wrong recipeRemoved subscription and per-row repeated sort were also corrected. Full result and scope: [bulk upgrade validation](bulk-upgrade-validation.md). Timing is an example local measurement, not a Flash render guarantee.

Read-only source audit and memory-only benchmark. No production accounts or
database were modified. Command encoding used the actual game codec, including
the three-byte frame overhead; this does not measure Flash rendering or TCP time.

Reproduce: `node tools/benchmark-assembly.js 1000`.
Baseline report: `logs/assembly-benchmark-before.json`.
The report records the source hashes so subsequent fixes can be compared.

Fixture: 1,000 LF3/LF4 items, one stack of each local module, 672 recipe
definitions, 592 visible ordinary craft recipes, 2,617 emitted recipe states
(generic states plus individual upgrade/disassembly targets), 1,020 inventory
entries including the starter items and synthetic currency/resource rows.

| Request | Synchronous server time | SQL calls | Commands | Framed bytes |
|---|---:|---:|---:|---:|
| Initial full catalog and inventory | 81.18 ms | 5,307 | 5 | 204,837 |
| Select one recipe | 0.20 ms | 2 | 1 | 58 |
| Save filter | 74.73 ms | 5,307 | 5 | 204,737 |
| Invalid build and error refresh | 69.51 ms | 5,324 | 6 | 204,778 |
| Collect ten finished jobs | 1,192.25 ms | 76,762 | 1,600 | 4,299,473 |

Times are one local run, not stable latency guarantees. The query and response
amplification is deterministic for this fixture and these source versions.

The full initialization calls `status()` twice per emitted recipe state: 2,617
job lookups and 2,617 usage lookups. Batch reading jobs and usage once eliminates
this database amplification. Owned item targets can likewise be indexed by loot
ID before walking recipe classes.

Filter saving currently retransmits the entire catalog and inventory. Recipe
selection already sends only a status update. Each individual successful build,
skip or collection calls the full notification path; collect-all calls it once
per job. Ten collections transmit ten complete recipe catalogs, ten inventories,
thirty filter settings, and 1,510 menu item status commands. The additional
`inventory.buildInit()` path also performs item-by-item drone and PET ownership
lookups: 10,040 queries of each kind for ten collections in this fixture.

Recommended responses are a single status update for a changed recipe, a single
inventory/resource refresh per completed request or batch, and no full catalog
refresh for filters, invalid requests, or recipe selection. Collect-all should
validate its bounded list and apply its mutations together before one refresh.
Only initial login or genuine newly available recipe definitions need catalog
content. The native `AssemblyRecipeStatusUpdateHandler` updates a single item;
`AssemblyRecipeContentHandler` invokes assembly initialization and processes all
received recipe rows, adding client work to the server amplification above.

The native filter protocol also contains two filter types. The SaveUpgrade and
SaveDisassembly commands set the **top-level** request `filterType` to 1 or 2,
while the nested settings module retains its default 0. Reading only the nested
value incorrectly overwrites the ordinary Assembly filter. Use the outer type;
the nested value can be retained only as a compatibility fallback for callers
that do not supply the outer field. The filter is applied locally in Flash, so
persisting it does not require returning catalog content.

Source evidence is in `game/assembly.js`, `game/handlers/assembly.js`, and:

- `decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/upgrade/control/SaveUpgradeFilterSettingsCommand.as`
- `decompiled/main/scripts/net/bigpoint/darkorbit/mvc/crafting/disassembly/control/SaveDisassemblyFilterSettingsCommand.as`
- `decompiled/main/scripts/net/bigpoint/darkorbit/com/module/AssemblySetFilterRequest.as`
- `decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AssemblyRecipeStatusUpdateHandler.as`
- `decompiled/main/scripts/net/bigpoint/darkorbit/net/netty/handlers/AssemblyRecipeContentHandler.as`
