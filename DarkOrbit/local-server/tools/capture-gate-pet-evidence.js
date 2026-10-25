'use strict';
// Read-only official forum capture; no account or server writes.
const fs=require('node:fs'),path=require('node:path');
const sources={
 'npc-de-1':'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/',
 'npc-de-2':'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2',
 'gg-de':'https://board-de.darkorbit.com/threads/faq-galaxy-gates.2848/',
 'kronos-rank':'https://board-en.darkorbit.com/threads/gi-kronos-gate.121147/',
 'npc-es':'https://board-es.darkorbit.com/threads/faqs-aliens.135697/',
 'pet-de':'https://board-de.darkorbit.com/threads/faq-p-e-t-und-ausruestung.118714/',
 'pet-levels':'https://board-en.darkorbit.com/threads/p-e-t-level-up-table.1226/',
 'pet-level-update':'https://board-en.darkorbit.com/threads/p-e-t-level-update.120879/',
 'pet-heat':'https://board-en.darkorbit.com/threads/p-e-t-expansion-faq.126477/',
 'pet-overheat':'https://board-en.darkorbit.com/threads/p-e-t-expansion-overheat-faq.128144/',
 'hades-fr':'https://board-fr.darkorbit.com/threads/guide-hades-fonctionnement-general.137511/',
 'gg-new-rewards':'https://board-en.darkorbit.com/threads/galaxy-gates-new-rewards-faq.127345/'
};
function plain(html){return html.replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi,'').replace(/<style\b[^>]*>[\s\S]*?<\/style>/gi,'').replace(/<(?:br|\/p|\/div|\/tr|\/li|\/h\d)\b[^>]*>/gi,'\n').replace(/<[^>]*>/g,' ').replace(/&nbsp;/g,' ').replace(/&amp;/g,'&').replace(/&#(\d+);/g,(_,n)=>String.fromCodePoint(Number(n))).replace(/[ \t]+/g,' ').replace(/\n\s*\n/g,'\n').trim();}
(async()=>{for(const [name,url]of Object.entries(sources)){const response=await fetch(url);if(!response.ok)throw new Error(`${name}: ${response.status}`);const content=plain(await response.text());fs.writeFileSync(path.join(__dirname,'../docs/evidence',`${name}.txt`),`Source: ${url}\nCaptured: ${new Date().toISOString()}\n${content}\n`);console.log(`${name}: ${content.length} characters`);}})().catch(e=>{console.error(e);process.exitCode=1;});
