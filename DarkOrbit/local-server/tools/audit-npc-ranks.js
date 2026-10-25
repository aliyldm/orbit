'use strict';
// Catalogue audit only. Never opens a production database or grants points.
const fs=require('node:fs'),path=require('node:path'),ranks=require('../game/ranks'),catalog=require('../game/npc-catalog'),kronos=require('../game/kronos');
const rows=[...Object.values(catalog.definitions),...Object.keys(kronos.STATS).map(key=>kronos.definition(key))].map(n=>({name:n.name,...ranks.npcPoints(n)}));
const report={sources:['https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/','https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2','https://board-en.darkorbit.com/threads/gi-kronos-gate.121147/'],
 total:rows.length,verified:rows.filter(r=>r.known).length,unverified:rows.filter(r=>!r.known).map(r=>r.key),rows};
if(require.main===module){fs.writeFileSync(path.join(__dirname,'../docs/npc-rank-audit.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({total:report.total,verified:report.verified,unverified:report.unverified}));}
module.exports=report;
