CREATE TABLE assembly_jobs (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 recipe_loot_id TEXT NOT NULL,
 target_id INTEGER NOT NULL DEFAULT 0,
 amount INTEGER NOT NULL CHECK(amount>0),
 started_at INTEGER NOT NULL,
 due_at INTEGER NOT NULL,
 result_json TEXT NOT NULL,
 skip_json TEXT NOT NULL DEFAULT '[]',
 notified INTEGER NOT NULL DEFAULT 0,
 PRIMARY KEY(player_id,recipe_loot_id,target_id)
);
CREATE TABLE assembly_usage (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 recipe_loot_id TEXT NOT NULL,
 uses INTEGER NOT NULL DEFAULT 0 CHECK(uses>=0),
 PRIMARY KEY(player_id,recipe_loot_id)
);
ALTER TABLE items ADD COLUMN upgrade_level INTEGER NOT NULL DEFAULT 0 CHECK(upgrade_level>=0);
ALTER TABLE drones ADD COLUMN upgrade_level INTEGER NOT NULL DEFAULT 0 CHECK(upgrade_level>=0);
