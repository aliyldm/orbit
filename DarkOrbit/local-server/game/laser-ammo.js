'use strict';
// Exact multipliers/special target descriptions in shipped TR resource_items.xml.
const BASE={'lcb-10':1,'mcb-25':2,'mcb-50':3,'ucb-100':4,'sab-50':2,'rsb-75':6,'cbo-100':3,'job-100':3.5,'rb-214':4,'pib-100':4,'rcb-140':7,'a-bl':4,'sbl-100':4,'emaa-20':4,'vb-142':4,'idb-125':1};
const CUP={a:4,b:4,c:6.5,d:6,e:1,f:5.5,g:4,h:4};
function supported(id){const key=id?.replace('ammunition_laser_','');return key in BASE||/^spacecup_group-[a-h]$/.test(key);}
function multiplier(p,npc,now=Date.now()){
 const key=(p.ammo||'ammunition_laser_lcb-10').replace('ammunition_laser_',''),target=(npc?.def?.key||'')+' '+(npc?.def?.name||'');
 if(key.startsWith('spacecup_group-'))return CUP[key.at(-1)]||1;
 if(key==='rb-214'&&/demaner/i.test(target))return 8;
 if(key==='a-bl'&&/invoke|mindfire/i.test(target))return 8;
 if(key==='sbl-100'&&/sibelon/i.test(target))return 8;
 if(key==='emaa-20'&&/mimesis/i.test(target))return 7;
 if(key==='vb-142'&&/styxus|charopos|lanatum/i.test(target))return 7;
 if(key==='idb-125'){if(!p.idb||now-p.idb.last>=3000)p.idb={multiplier:1,last:now};return p.idb.multiplier;}
 return BASE[key]??p.ammoMultiplier??1;
}
function fired(p,hit,now=Date.now()){
 if(p.ammo!=='ammunition_laser_idb-125')return;
 multiplier(p,null,now);p.idb.last=now;if(hit)p.idb.multiplier=Math.min(6,p.idb.multiplier+1.25);
}
module.exports={BASE,CUP,supported,multiplier,fired};
