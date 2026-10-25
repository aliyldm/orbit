-- IDs/names come from client/spacemap/graphics/maps-config.xml.
INSERT OR IGNORE INTO maps(id,name,width,height,start_x,start_y) VALUES
 (51,'GG Alpha',21000,13100,10500,6550),
 (52,'GG Beta',21000,13100,10500,6550),
 (53,'GG Gamma',21000,13100,10500,6550),
 (55,'GG Delta',21000,13100,10500,6550),
 (70,'GG Epsilon',21000,13100,10500,6550),
 (73,'GG Zeta',21000,13100,10500,6550),
 (74,'GG Kappa',21000,13100,10500,6550),
 (75,'GG Lambda',21000,13100,10500,6550),
 (203,'GG Hades',21000,13100,10500,6550),
 (300,'GG Kuiper',21000,13100,10500,6550);
CREATE TABLE galaxy_gate_runs (
  id INTEGER PRIMARY KEY,
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  gate_id INTEGER NOT NULL,
  map_id INTEGER NOT NULL REFERENCES maps(id),
  home_map INTEGER NOT NULL REFERENCES maps(id),
  state TEXT NOT NULL CHECK(state IN ('active','won','failed')),
  lives INTEGER NOT NULL DEFAULT 3 CHECK(lives BETWEEN 0 AND 10),
  wave INTEGER NOT NULL DEFAULT 1 CHECK(wave >= 1),
  wave_count INTEGER NOT NULL CHECK(wave_count BETWEEN 1 AND 100),
  remaining_json TEXT,
  death_pending INTEGER NOT NULL DEFAULT 0 CHECK(death_pending IN (0,1)),
  rewards_json TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  finished_at INTEGER
);
CREATE UNIQUE INDEX galaxy_gate_active_run ON galaxy_gate_runs(player_id,gate_id) WHERE state='active';
CREATE INDEX galaxy_gate_run_owner_map ON galaxy_gate_runs(player_id,map_id,state);
