-- Null plans mark runs started with the old local content. They are snapshotted
-- lazily with their existing life/part/wave/reward state intact.
ALTER TABLE galaxy_gate_runs ADD COLUMN plan_json TEXT;
ALTER TABLE galaxy_gate_runs ADD COLUMN released_wave INTEGER NOT NULL DEFAULT 0;
CREATE TABLE galaxy_gate_kill_claims (
  run_id INTEGER NOT NULL REFERENCES galaxy_gate_runs(id) ON DELETE CASCADE,
  phase INTEGER NOT NULL,
  slot INTEGER NOT NULL,
  reward_json TEXT NOT NULL,
  claimed_at INTEGER NOT NULL,
  PRIMARY KEY (run_id, phase, slot)
);
