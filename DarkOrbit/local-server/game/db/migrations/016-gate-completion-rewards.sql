-- Atomic audit trail for actual completion outcomes. Existing won/entered
-- snapshots remain unchanged; no historical random reward is fabricated.
CREATE TABLE galaxy_gate_completion_claims (
 run_id INTEGER PRIMARY KEY REFERENCES galaxy_gate_runs(id) ON DELETE CASCADE,
 reward_json TEXT NOT NULL,
 claimed_at INTEGER NOT NULL
);
