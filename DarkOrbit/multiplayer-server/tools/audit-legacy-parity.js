'use strict';
// Inventory executable legacy registrations against the .NET port. Source
// presence, archived data and implemented runtime behavior are distinct facts.
// Live DB access is schema-only/read-only; no packet/account values enter it.
process.env.DARKORBIT_DB=':memory:';
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const root=path.resolve(__dirname,'..'),legacy=path.resolve(root,'../local-server');
const read=p=>fs.readFileSync(p,'utf8').replace(/\r\n/g,'\n'),hash=s=>crypto.createHash('sha256').update(s).digest('hex');
const database=require(path.join(legacy,'game/db'));
const log=console.log;let db;
try {console.log=()=>{};db=database.open(':memory:');}finally{console.log=log;}
try {
 const commands=require(path.join(legacy,'game/protocol')).registeredCommands();
 const inventoryActions=require(path.join(legacy,'web/inventory-api')).actions;
 const tableQuery="SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name";
 const migratedTables=db.prepare(tableQuery).all().map(r=>r.name),schemaFile=path.join(root,'legacy-schema-tables.json'),liveFile=path.join(legacy,'data/darkorbit.db');
 let liveTables=null;
 if(fs.existsSync(liveFile)){
  const live=new(require('node:sqlite').DatabaseSync)(liveFile,{readOnly:true});
  try{liveTables=live.prepare(tableQuery).all().map(r=>r.name);}finally{live.close();}
 }
 if(process.argv.includes('--capture-schema')){
  if(!liveTables)throw Error('Read-only live schema is required to capture table names.');
  fs.writeFileSync(schemaFile,JSON.stringify({format:1,scope:'Table names only; no rows or account data.',tables:liveTables},null,2)+'\n');
 }
 const baseline=JSON.parse(read(schemaFile)).tables;
 if(liveTables&&JSON.stringify(liveTables)!==JSON.stringify(baseline))throw Error('Legacy live table inventory changed; inspect and recapture schema names.');
 const tables=[...new Set([...migratedTables,...baseline])].sort();
 const transport=path.join(root,'src/DarkOrbit.Server/Transport/NativeGameHub.cs');
 const host=path.join(root,'src/DarkOrbit.Host/NativeApplication.cs');
 const nativeSource=read(transport),hostSource=read(host);
 const nativeCommands=new Set([...nativeSource.matchAll(/name\s*==\s*"([^"]+)"/g)].map(m=>m[1]));
 const nativeHttp=new Set([...hostSource.matchAll(/app\.Map(?:Get|Post)\("([^"]+)"/g)].map(m=>m[1]));
 const httpSource=read(path.join(legacy,'web/http-server.js')),bootSource=read(path.join(legacy,'web/boot-api.js'));
 const paths=[...new Set([...httpSource.matchAll(/url\.pathname\s*===\s*'([^']+)'/g),...bootSource.matchAll(/'(\/[^']+)'\s*:/g)].map(m=>m[1]))].sort();
 const commandNotes={
  VersionRequest:['ported','Original version echo/accept contract.'],
  KeepAlive:['ported','Authenticated no-op plus independent session heartbeat.'],
  LoginRequest:['partial','Existing account/password/ticket and projected initialization; new account/feature repositories pending.'],
  MoveRequest:['partial','Authoritative shared motion; full dynamic speed and pirate field effects pending.'],
  ShipSelectRequest:['partial','Shared normal NPC state; special shields and full multiplayer targeting pending.'],
  JumpRequest:['partial','Normal portals verified; Galaxy Gate transition/rules pending.'],
  MapAssetActivationRequest:['partial','Normal jumpgates only; trade/quest/repair and other assets pending.'],
  AttackLaserRequest:['partial','Outgoing classic damage-only loadouts; modern procs/drains, NPC retaliation and live stats pending.'],
  AttackAbortLaserRequest:['partial','Outgoing classic laser loop only.'],
  MenuActionRequest:['partial','Five classic laser ammunition choices/RSB return; other menu actions pending.']
 };
 const commandCoverage=commands.map(name=>{
  const policy=commandNotes[name];const reached=nativeCommands.has(name)||name==='KeepAlive';
  return{name,status:reached?(policy?.[0]||'review_required'):'not_ported',note:reached?(policy?.[1]||'New dispatcher branch requires parity evidence.'):'No .NET dispatcher branch.',nativeBranch:reached};
 });
 const tablePolicy={
  accounts:['partial','accounts','Existing hashes copied; registration/account lifecycle pending.'],
  players:['partial','players + player_economy + profile projection','Identity/position/wallet live; other fields/repositories pending.'],
  items:['partial','inventory_items','All snapshot rows retained; ammunition debit live, equip/sell/upgrade and other mutations pending.'],
  ships:['partial','owned_ships + profile projection','Ownership/type and initial projection; live hull/config/vitals/equipment pending.'],
  maps:['partial','maps + WorldContent','Normal geometry/portals; private gate worlds pending.'],
  portals:['partial','WorldContent','Normal topology exported; dynamic player/group gate portals pending.'],
  player_boosters:['partial','active_boosters','Rows/expiry and reward effects live; full stat/activation lifecycle pending.'],
  normal_spawn_state:['partial','world_checkpoints + npc_reward_claims','New shared world lifecycle persists; per-pilot legacy NPC state needs cutover reconciliation.']
 };
 const tableCoverage=tables.map(name=>({name,status:tablePolicy[name]?.[0]||'archive_only',runtime:tablePolicy[name]?.[1]||null,note:tablePolicy[name]?.[2]||'Preserved in the exact-value archive; no authoritative .NET feature repository yet.'}));
 const features=[
  ['auth','Existing login/session/reconnect','partial','game/auth.js; game/db/players.js','New account/company selection and full lifecycle pending.'],
  ['world','Normal maps, shared NPCs and normal portals','partial','game/maps.js; game/combat.js; game/normal-map-runtime.js','Durable shared normal world implemented; special NPCs and full field effects pending.'],
  ['classic-lasers','Classic outgoing laser/RSB','partial','game/combat.js; game/ammo.js','75 formula cases and native fire verified; live stat rebuilding/CPU/skill effects incomplete.'],
  ['modern-lasers','Modern lasers, drains and proc effects','not_ported','game/modern-lasers.js; game/laser-ammo.js','Unsupported loadouts/ammo are rejected rather than silently using a classic fallback.'],
  ['retaliation','NPC retaliation, player death and paid respawn','not_ported','game/combat.js; game/respawn.js','Critical before shared play.'],
  ['rockets','Rockets, hellstorm launcher and advanced weapons','not_ported','game/hellstorm.js; game/advanced-weapons.js','Manual/automatic rockets, reload, charges and effects.'],
  ['cpu','Supported CPUs and automation','not_ported','game/cpu.js; game/automation.js','Preserve supported source behavior; seven previously disabled CPUs remain outside the required feature set.'],
  ['cargo','Cargo, ore/box collection and trade','not_ported','game/collectables.js; game/loot-rewards.js','Capacity, residual cargo, drop tables, stations/HM7/PET and claim ownership.'],
  ['equipment','Hangars, inventory, configurations and sales','not_ported','game/inventory.js; web/inventory-api.js; game/hangars.js','Snapshot rows exist; live UI/API/equipment operations are not ported.'],
  ['stats','Live bonuses and upgrade-derived stats','not_ported','game/stats.js; game/db/players.js','Frozen derived profile is not a live stat engine.'],
  ['drones','Drones, designs, formations and set bonuses','not_ported','game/drones.js; game/drone-designs.js','Opening decorations remain projected; behavior/equipment/UI pending.'],
  ['pet','PET modules, protocols, fuel and progression','not_ported','game/pet.js; game/pet-special.js','All source modes/activation/menu lifecycle need port and tests.'],
  ['skills','Research tree and reset','not_ported','game/skills.js; web/skills-api.js','Costs, bonuses and native/portal controls.'],
  ['lab','Ore enrichment and ammunition/time buffs','not_ported','game/handlers/lab.js','Quantities, bonus application and depletion.'],
  ['abilities','Ship abilities, passives, techs and utilities','not_ported','game/ship-abilities.js; game/ship-abilities-expanded.js; game/techs.js','Only hull reward bonuses have been wired into payouts.'],
  ['assembly','Assembly, repeat production and module currency','not_ported','game/assembly.js; web/assembly-api.js','CV-M/UP-M economy and all previously working native tabs.'],
  ['upgrade','Single/bulk upgrades and level bonuses','not_ported','game/upgrade-bulk.js; web/upgrade-api.js','Upgrade jobs, costs, quantities and native layout.'],
  ['shop','Shop/catalog/special offers and purchase restrictions','not_ported','game/economy.js; web/portal/shop-*.js','Prices, sorting, ownership and transaction effects must match the source.'],
  ['gates','All Galaxy Gates and opening/completion conditions','not_ported','game/galaxy-gates.js; game/kronos.js; game/hades-bosses.js','Private isolation exists; actual gate content/waves/requirements/rewards are not ported.'],
  ['progression','Quests, ranks, gate rings and NPC points','not_ported','game/ranks.js; game/handlers/systems.js; game/gate-rings.js','Wallet EP/level updates work; other progression ledgers and calculations pending.'],
  ['events','Daily login, campaigns and event windows','not_ported','game/native-rewards.js; game/payment-events.js','Repeat guards, original UI and portal synchronization.'],
  ['settings','Settings, hotkeys and graphics/drone visibility','not_ported','game/handlers/core.js; game/client-view.js','Original assets unchanged; persisted settings handlers are pending.'],
  ['portal','Original web/Flash API and game bootstrap','not_ported','web/http-server.js; web/boot-api.js','indexInternal remains501 and /ready503.'],
  ['pvp-group','Multiplayer reward ownership, PvP and groups','not_ported','new multiplayer semantics','Current classic prototype pays the finishing attacker; original claim/group rules are pending.'],
  ['maze','5-x maze','intentionally_off','game/pirate-maze.js','User explicitly requested it remain disabled.'],
  ['skylab','Skylab requirement','intentionally_off','game/skylab.js','User explicitly requested no Skylab requirement; source is retained.']
 ].map(([id,name,status,source,note])=>({id,name,status,source,note}));
 const count=list=>list.reduce((out,r)=>{out[r.status]=(out[r.status]||0)+1;return out;},{});
 const report={format:1,scope:'Source inventory and port evidence; not a claim that legacy templates or the new server are fully functional.',sourceFingerprint:hash([read(path.join(legacy,'game/protocol.js')),httpSource,bootSource,nativeSource,hostSource].join('\n')),
  fullGameplayReady:false,summary:{legacyNativeCommands:commands.length,nativeCoverage:count(commandCoverage),legacyTables:tables.length,tableCoverage:count(tableCoverage),legacyInventoryActions:inventoryActions.length,legacyLiteralHttpPaths:paths.length,featureCoverage:count(features)},
  commands:commandCoverage,tables:tableCoverage,inventoryActions:inventoryActions.map(name=>({name,status:'not_ported'})),httpPaths:paths.map(name=>({name,status:name==='/indexInternal.es'?'stub_501':nativeHttp.has(name)?'partial':'not_ported'})),
  portalPages:fs.readdirSync(path.join(legacy,'web/portal/pages')).filter(f=>f.endsWith('.html')).sort().map(name=>({name,status:'not_ported'})),features};
 const target=path.join(root,'legacy-parity-report.json'),json=JSON.stringify(report,null,2)+'\n';
 const labels={ported:'Taşındı',partial:'Kısmi',not_ported:'Eksik',intentionally_off:'Kullanıcı isteğiyle kapalı'};
 const markdown=['# Eski sunucu / .NET kapsam karşılaştırması','',
  '**Tam geçiş tamamlanmadı.** Eski Node/SQLite kaynakları korunuyor; dosyanın mevcut olması veya PG arşivine kopyalanması, aynı özelliğin yeni motorda çalıştığı anlamına gelmez. `/ready`503 kalır.','',
  `Kaynakta ${commands.length} kayıtlı native komut, ${tables.length} veri tablosu, ${inventoryActions.length} envanter API işlemi ve ${report.portalPages.length} portal şablonu bulundu. Bunlar aynı ağırlıkta özellikler değildir; bu sayılardan tamamlanma yüzdesi çıkarılmaz.`,'',
  '| Özellik | Durum | Kalan kapsam |','|---|---|---|',...features.map(f=>`| ${f.name} | ${labels[f.status]} | ${f.note} |`),'',
  'Komut/tablo/API işlemlerinin tamamı `legacy-parity-report.json` içinde adlarıyla bulunur. Bilinmeyen yeni dispatcher dalı `review_required` olur; sessizce tamamlandı sayılmaz.','',
  'Eski per-pilot NPC kayıtlarının tek paylaşılan dünyaya nasıl alınacağı son geçişte ayrıca uzlaştırılmalı. Mevcut oyuncu ilerlemesinin üstüne eski snapshot yazılmaz. Profil paketleri, rütbe/diroit/PET/arge verilerinin canlı repository yerine geçmez.','',
  'Yenilemek: `node tools/audit-legacy-parity.js`. Güncellik kontrolü: `node tools/audit-legacy-parity.js --check`. Araç test şemasını bellekte açar; canlı DB varsa yalnız salt okunur tablo adlarını karşılaştırır. Hesap/satır/paket içeriği rapora yazılmaz. `legacy-schema-tables.json` canlıda eklenmiş yardımcı tabloları da unutmamak için adlarıyla korur.',''].join('\n');
 if(process.argv.includes('--check')){if(read(target)!==json||read(path.join(root,'LEGACY-PARITY.md'))!==markdown)throw Error('Parity inventory is stale; regenerate and review source classifications.');}
 else {fs.writeFileSync(target,json);fs.writeFileSync(path.join(root,'LEGACY-PARITY.md'),markdown);}
 console.log(JSON.stringify({status:'PASS',...report.summary,fullGameplayReady:false}));
}finally{database.close();}
