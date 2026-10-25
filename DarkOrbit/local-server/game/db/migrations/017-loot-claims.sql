-- One durable receipt for each reward box. Key consumption and all rewards
-- commit with this receipt; replay cannot award the same box twice.
CREATE TABLE loot_claims (
  box_hash TEXT PRIMARY KEY,
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  map_id INTEGER NOT NULL,
  box_type TEXT NOT NULL,
  key_loot_id TEXT,
  profile TEXT NOT NULL,
  reward_json TEXT NOT NULL,
  claimed_at INTEGER NOT NULL
);
CREATE INDEX loot_claims_player ON loot_claims(player_id,claimed_at);
