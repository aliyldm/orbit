'use strict';
// ShipInitialization.galaxyGatesDone is the native completion-icon bitmask,
// never a total number of completions. Rebuild it from actual run/claim history
// so imported counts and repeat wins cannot award unrelated rings.
// Native builder ID12 is the playable Kronos gate; bit64 selects its crown.
const GATE_BITS=Object.freeze({1:1,2:2,3:4,4:8,5:16,6:32,12:64});
function derive(db,playerId){
 const rows=db.prepare(`SELECT DISTINCT r.gate_id FROM galaxy_gate_runs r
  WHERE r.player_id=? AND (r.state='won' OR EXISTS(
   SELECT 1 FROM galaxy_gate_completion_claims c WHERE c.run_id=r.id))`).all(playerId);
 return rows.reduce((mask,row)=>mask|(GATE_BITS[row.gate_id]||0),0);
}
function sync(db,playerId){
 const mask=derive(db,playerId);
 db.prepare('UPDATE players SET galaxy_gates_done=? WHERE id=? AND galaxy_gates_done<>?').run(mask,playerId,mask);
 return mask;
}
function backfill(db){
 // Only the cached native icon field changes. All history and game progress
 // remain intact; an account with no completion evidence starts with no rings.
 for(const row of db.prepare('SELECT id FROM players').all())sync(db,row.id);
}
module.exports={GATE_BITS,derive,sync,backfill};
