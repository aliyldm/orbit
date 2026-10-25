CREATE TABLE player_boosters (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  loot_id TEXT NOT NULL REFERENCES item_types(loot_id),
  expires_at INTEGER NOT NULL CHECK(expires_at>=0),
  PRIMARY KEY(player_id,loot_id)
);
CREATE INDEX player_boosters_expiry ON player_boosters(player_id,expires_at);
