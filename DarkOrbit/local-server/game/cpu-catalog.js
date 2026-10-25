'use strict';
// Explicit complete audit inventory. A catalog label is never evidence that its
// private-server consumer exists; unsupported rows remain visible here.
const META=require('../docs/client-map.items.json').items,PREFIX='equipment_extra_cpu_';
const GROUPS={
 implemented:['jp-01','jp-02','ajp-01','cl04k-m','cl04k-xl','cl04k-xs','arol-x','rllb-x','alb-x','rb-x','fb-x','nc-rrb-x','nc-awb-x','nc-awr-x','nc-awl-x','nc-agb-x','rok-t01','min-t01','min-t02','sle-01','sle-02','sle-03','sle-04','dr-01','dr-02','aim-01','aim-02','smb-01','ish-01','g3x-crgo-x','rg-sl','ags-x'],
 partial:['rd-x'],
 unsupported:['anti-z1','anti-z1-xl','pa-x'],
 unboundedAmmoModel:['g3x-amry-s','g3x-amry-m','g3x-amry-l']
};
const rows=Object.entries(GROUPS).flatMap(([status,ids])=>ids.map(id=>({lootId:PREFIX+id,status}))).concat({lootId:'equipment_extra_hmd-07',status:'implemented'});
const CATALOG=Object.freeze(Object.fromEntries(rows.map(row=>[row.lootId,Object.freeze({...row,typeClass:META[row.lootId].typeClass,typeValue:META[row.lootId].typeValue,docs:'docs/cpu-local.md'})])));
module.exports={CATALOG};
