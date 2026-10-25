-- Persist only supported gameplay definitions; captured metadata is not player state.
CREATE TABLE quest_definitions (
  id INTEGER PRIMARY KEY,
  min_level INTEGER NOT NULL DEFAULT 0 CHECK (min_level >= 0),
  prerequisite INTEGER REFERENCES quest_definitions(id),
  enabled INTEGER NOT NULL DEFAULT 1 CHECK (enabled IN (0, 1)),
  definition_json TEXT NOT NULL,
  slim_json TEXT NOT NULL
);
CREATE TABLE player_quests (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  quest_id INTEGER NOT NULL REFERENCES quest_definitions(id),
  status TEXT NOT NULL CHECK (status IN ('running', 'completed', 'cancelled')),
  progress_json TEXT NOT NULL DEFAULT '{}',
  accepted_at INTEGER NOT NULL,
  completed_at INTEGER,
  PRIMARY KEY (player_id, quest_id)
);
CREATE TABLE galaxy_gate_accounts (
  player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
  energy INTEGER NOT NULL DEFAULT 0 CHECK (energy >= 0),
  spin_amount INTEGER NOT NULL DEFAULT 1 CHECK (spin_amount IN (1, 5, 10, 100))
);
CREATE TABLE galaxy_gate_progress (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  gate_id INTEGER NOT NULL,
  parts_json TEXT NOT NULL DEFAULT '[]',
  multiplier INTEGER NOT NULL DEFAULT 0 CHECK (multiplier BETWEEN 0 AND 5),
  lives INTEGER NOT NULL DEFAULT -1,
  wave INTEGER NOT NULL DEFAULT 0 CHECK (wave >= 0),
  active INTEGER NOT NULL DEFAULT 0 CHECK (active IN (0, 1)),
  PRIMARY KEY (player_id, gate_id)
);
