'use strict';
// Generates a reviewable account-independent dispatcher matrix, no database open.
const fs=require('node:fs'),path=require('node:path'),rows=require('../game/menu-capabilities').entries();
const categories=Object.fromEntries([...new Set(rows.map(r=>r.category))].map(category=>[category,rows.filter(r=>r.category===category).reduce((out,r)=>(out[r.status]=(out[r.status]||0)+1,out),{})]));
const target=path.join(__dirname,'../docs/action-menu-audit.json');
fs.writeFileSync(target,JSON.stringify({source:'game/templates/init.json + real local dispatcher modules',total:rows.length,categories,rows:rows.map(r=>({...r,...(/^ammunition_(?:firework|specialammo_(?:emote|spray))_/.test(r.id)?{scope:'cosmetic-use',note:'Savaş mekaniği değil; kozmetik gösterim kullanımı henüz yok.'}:{})}))},null,2));
console.log(JSON.stringify({total:rows.length,categories,target}));
