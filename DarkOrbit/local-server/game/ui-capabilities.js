'use strict';
// Toolbar visibility is a capability decision, not a captured account flag.
// A working client-only panel needs no server request handler; native event
// windows are separate from their supported local web reward ledgers.
const SUPPORTED=Object.freeze({
 user:'Native account attributes',ship:'Native ship attributes',minimap:'Native map display and navigation',
 spacemap:'Native star map; AJP target panel requires equipped AJP-01',
 quests:'Quest list/info/accept/cancel and station availability',refinement:'Lab refine and equipment enrichment',
 ore_trade:'Native station ore sale and pirate palladium exchange; HM7 enables remote sale',
 assembly:'Craft/upgrade/disassembly; restabilize and hyperforge remain explicitly unavailable',
 log:'Native standard messages',pet:'Native PET controls and equipped gear',booster:'Owned booster timers and stat bonuses',
 ggBuilder:'Owned parts, random spins, multipliers and setup',
 hangar:'Original portal inventory redirect',hangarCannons:'Native owned hangar list and equipment controls',
 pilotSheet:'Original portal skill tree and account profile',skylab:'Existing local Skylab portal; optional',
 seasonPass:'Native local season status, rewards, claim and level purchase',
 battle_pass:'Native objectives, owned pass and key exchange use the shared local season ledger',
 trinityTrials:'Native pass rewards; classic gate progression is local, original event gate remains unavailable',
 voyagers:'Native pass rewards; classic gate progression is local, original event gate remains unavailable',
 ship_warp:'Owned hangar ship warp with server-authoritative checks and timer',
 command_center:'Native local notices, portal links and saved inspection/news-click preferences',
 shop:'Original portal shop redirect',new_shop:'Original portal shop shortcut',settings:'Native settings and saved layout',
 help:'Native help',logout:'Native logout timer/cancel',fullscreen:'Client-only fullscreen toggle'
});
const REASONS=Object.freeze({
 chat:'Multiplayer/chat is outside the current solo scope.',group:'Multiplayer/group is outside the current solo scope.',
 contacts:'Contacts are outside the current solo scope.',clan:'Clans are outside the current solo scope.',auction:'Auction economy is outside the current solo scope.',
 dispatch:'Dispatch request family has no local handlers.',nova:'NOVA/captain request family has no local handlers.',
 assistant:'Assistant/NOVA runtime is not implemented.',synthesis:'SynthesisInventoryRequest and synthesis actions have no local handlers.',
 cli:'Debug console is not a player feature.'
});
function capability(id){
 return Object.hasOwn(SUPPORTED,id)?{supported:true,reason:SUPPORTED[id]}:
  {supported:false,reason:REASONS[id]||'No implemented local workflow is registered for this captured toolbar feature.'};
}
function apply(commands){
 return commands.map(command=>{
  if(command._==='UILayoutCommand')return {...command,featureBars:apply(command.featureBars)};
  if(command._==='UIFeatureBarCommand')return {...command,featureBarItems:command.featureBarItems.map(item=>{
   if(capability(item.itemId).supported)return item;
   return {...item,visible:false,...(item._==='WindowItemCommand'?{maximized:false}:{})};
  })};
  if(command._==='WindowItemCommand'&&!capability(command.itemId).supported)return {...command,visible:false,maximized:false};
  return command;
 });
}
module.exports={SUPPORTED,REASONS,capability,apply};
