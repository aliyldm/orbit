'use strict';
// Official P.E.T. Level Up Table1226 / Level Update120879 and DE PET FAQ118714.
// Absolute accumulated PET experience, not EP per level or owner experience.
const EXPERIENCE=Object.freeze([0,8000,64000,216000,512000,1000000,1728000,2744000,4096000,5832000,8000000,10648000,13824000,17576000,21952000,27000000,39000000,50000000,70000000,100000000,150000000]);
const DAMAGE=Object.freeze([0,0,.02,.02,.02,.04,.04,.06,.06,.06,.08,.08,.1,.1,.12,.12,.14,.14,.16,.16,.16]);
const SHIELD=Object.freeze([0,.02,.02,.04,.04,.04,.06,.06,.06,.08,.08,.1,.1,.12,.12,.15,.15,.16,.16,.18,.18]);
function valid(level){return Number.isInteger(level)&&level>=0&&level<=20;}
function next(level){if(!valid(level))throw new RangeError('Invalid PET level');return level===20?0:EXPERIENCE[level+1];}
function bonuses(level){if(!valid(level))throw new RangeError('Invalid PET level');return{damageMultiplier:1+DAMAGE[level],shieldMultiplier:1+SHIELD[level]};}
function levelFor(experience){if(!Number.isFinite(experience)||experience<0)throw new RangeError('Invalid PET experience');let level=0;while(level<20&&experience>=EXPERIENCE[level+1])level++;return level;}
module.exports={EXPERIENCE,DAMAGE,SHIELD,next,bonuses,levelFor};
