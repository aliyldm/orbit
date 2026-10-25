'use strict';
const fs=require('fs'),crypto=require('crypto'),path=require('path');
const root=path.join(__dirname,'..'),missions=require('../game/payment-events').MISSIONS;
const xmlPath=path.join(root,'client/spacemap/graphics/ui/windows/battlePass/externals/pass_local.xml');
const xml=`<?xml version="1.0" encoding="UTF-8"?>\n<battlePass><objectiveList>\n${missions.map((m,i)=>`<objective questId="${930001+i}"><questReward lootid="resource_season-pass-point" amount="${m.points}"/><bpReward lootid="resource_battle-pass-key" amount="${m.period==='daily'?1:m.period==='weekly'?2:5}"/></objective>`).join('\n')}\n</objectiveList><flvDisplayLootId>ship_goliath</flvDisplayLootId><titleKeyBeforePurchase>window_objectives_bp_title</titleKeyBeforePurchase><descriptionKeyBeforePurchase>window_objectives_bp_promo_desc</descriptionKeyBeforePurchase><descriptionKeyCollect>window_objectives_bp_collect_desc</descriptionKeyCollect><titleKeyAfterPurchase>window_objectives_bp_highlight_title</titleKeyAfterPurchase><descriptionKeyAfterPurchase>window_objectives_bp_highlight_desc</descriptionKeyAfterPurchase></battlePass>\n`;
fs.writeFileSync(xmlPath,xml);
const questPath=path.join(root,'client/spacemap/templates/tr/resource_quest.xml');let quest=fs.readFileSync(questPath,'utf8');
const esc=s=>s.replaceAll('&','&amp;').replaceAll('<','&lt;');
for(let i=0;i<missions.length;i++){const id=930001+i;for(const [key,text]of [[`quest_title_${id}`,missions[i].label],[`quest_description_${id}`,`${missions[i].label}. Yerel sezon görevi; ilerleme hesabına kaydedilir.`]]){
 const tag=`<item name="${key}">${esc(text)}</item>`;
 const re=new RegExp('<item\\s+(?:id|name)="'+key+'"[^>]*>[\\s\\S]*?<\\/item>');quest=re.test(quest)?quest.replace(re,tag):quest.replace(/<\/(?:category|resource|root)>\s*$/,m=>tag+'\n'+m);
}}
fs.writeFileSync(questPath,quest);
for(const q of require('../game/quests-content').missions.filter(q=>q.provenance.kind==='reconstructed-nyx')){
 for(const [key,text]of [[`quest_title_${q.definition.id}`,q.title],[`quest_description_${q.definition.id}`,q.description]]){
  const tag=`<item name="${key}">${esc(text)}</item>`,re=new RegExp('<item\\s+name="'+key+'"[^>]*>[\\s\\S]*?<\\/item>');quest=re.test(quest)?quest.replace(re,tag):quest.replace('</resource>',tag+'\n</resource>');
 }
}
fs.writeFileSync(questPath,quest);
const resourcesPath=path.join(root,'client/spacemap/xml/resources.xml');let resources=fs.readFileSync(resourcesPath,'utf8');
const hash=crypto.createHash('md5').update(xml).digest('hex'),entry=`<file debugView="false" hash="${hash}" id="pass_local" location="graphics_ui_windows_battlePass_externals" name="pass_local" type="xml" version="1"/>`;
const re=/<file\b[^>]*\bid="pass_local"[^>]*\/>/;
resources=re.test(resources)?resources.replace(re,entry):resources.replace(/(<file\b[^>]*\bid="pass_galacticStrife"[^>]*\/>)/,entry+'\n   $1');
if(!resources.includes('id="pass_local"'))throw Error('BattlePass manifest anchor absent');
fs.writeFileSync(resourcesPath,resources);console.log(JSON.stringify({missions:missions.length,hash,xmlPath}));
