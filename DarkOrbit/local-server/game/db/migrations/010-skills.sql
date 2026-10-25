CREATE TABLE skill_accounts (
  player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
  earned_points INTEGER NOT NULL DEFAULT 0 CHECK(earned_points BETWEEN 0 AND 50),
  reset_count INTEGER NOT NULL DEFAULT 0 CHECK(reset_count>=0)
);
CREATE TABLE player_skills (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  skill_id TEXT NOT NULL,
  level INTEGER NOT NULL CHECK(level BETWEEN 1 AND 5),
  PRIMARY KEY(player_id,skill_id)
);
