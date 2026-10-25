-- A catalogue key separates normal-map stats from older generic npc_types rows
-- and from gate-specific variants sharing a client visual type.
ALTER TABLE map_spawns ADD COLUMN catalog_key TEXT;
ALTER TABLE map_spawns ADD COLUMN behavior_json TEXT;
CREATE TABLE normal_world_versions (
  version TEXT PRIMARY KEY,
  installed_at INTEGER NOT NULL,
  previous_content_json TEXT NOT NULL
);
-- Normal worlds are private to the pilot in solo mode. A stable population slot
-- retains damage and the real respawn deadline across map changes/restarts.
CREATE TABLE normal_spawn_state (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  map_id INTEGER NOT NULL REFERENCES maps(id),
  spawn_id INTEGER NOT NULL REFERENCES map_spawns(id) ON DELETE CASCADE,
  slot INTEGER NOT NULL CHECK(slot>=0),
  generation INTEGER NOT NULL DEFAULT 1 CHECK(generation>0),
  hp INTEGER NOT NULL CHECK(hp>=0),
  shield INTEGER NOT NULL CHECK(shield>=0),
  x REAL NOT NULL,
  y REAL NOT NULL,
  respawn_at INTEGER NOT NULL DEFAULT 0,
  saved_at INTEGER NOT NULL,
  last_hit INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY(player_id,spawn_id,slot)
);
