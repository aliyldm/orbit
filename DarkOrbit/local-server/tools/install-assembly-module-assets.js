'use strict';
const fs=require('node:fs'),path=require('node:path');
const root=path.resolve(__dirname,'..'),policy=require('../game/module-policy');
const dir=path.join(root,'client/do_img/global/items/resource'),manifestFile=path.join(root,'client/do_img/global/xml/resource_items.xml'),localeFile=path.join(root,'client/spacemap/templates/tr/resource_items.xml');
let manifest=fs.readFileSync(manifestFile,'utf8'),locale=fs.readFileSync(localeFile,'utf8');
const sources={[policy.UPGRADE]:'nano-condenser',[policy.CONVERT]:'micro-transistors'};
for(const d of policy.DEFINITIONS){
 const name=d.id.slice('resource_'.length),source=sources[d.id];
 for(const size of ['30x30','100x100','icon']){
  const sourceSize=size==='icon'?'30x30':size;
  const from=path.join(dir,source+'_'+sourceSize+'.png'),to=path.join(dir,name+'_'+size+'.png');
  fs.copyFileSync(from,to);
  const entry=manifest.split(/\r?\n/).find(l=>l.includes('id="'+source+'_'+sourceSize+'"')&&l.includes('location="items_resource"'));
  if(!entry)throw Error('Missing source image manifest '+source+'_'+sourceSize);
  if(!manifest.includes('id="'+name+'_'+size+'"'))manifest=manifest.replace('</filecollection>',entry.replaceAll(source+'_'+sourceSize,name+'_'+size)+'\n</filecollection>');
 }
 const texts={fullname:d.name,short:'Modül',code:d.id===policy.UPGRADE?'UP-M':'CV-M',description:d.description,sources:'Dükkan > Ekstralar: 10.000 Uridium / adet.'};
 for(const[key,value]of Object.entries(texts)){
  const id='items_'+d.id+'_'+key;
  if(!locale.includes('name="'+id+'"'))locale=locale.replace('</resource>',' <item name="'+id+'"><![CDATA['+value+']]></item>\n</resource>');
 }
}
fs.writeFileSync(manifestFile,manifest);fs.writeFileSync(localeFile,locale);
console.log('Installed two native module definitions: six original-art image aliases, ten locale labels, six resource manifest entries.');
