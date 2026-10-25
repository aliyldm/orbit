-- Local, auditable rank inputs. Captured account statistics are never imported.
CREATE TABLE rank_npc_claims (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 event_key TEXT NOT NULL,
 npc_key TEXT NOT NULL,
 raw_points REAL NOT NULL CHECK(raw_points>=0),
 known INTEGER NOT NULL CHECK(known IN(0,1)),
 claimed_at INTEGER NOT NULL,
 PRIMARY KEY(player_id,event_key)
);
CREATE TABLE rank_counters (
 player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
 player_kill_points REAL NOT NULL DEFAULT 0,
 friendly_kills INTEGER NOT NULL DEFAULT 0,
 enemy_deaths INTEGER NOT NULL DEFAULT 0,
 radiation_deaths INTEGER NOT NULL DEFAULT 0,
 phoenix_kills INTEGER NOT NULL DEFAULT 0,
 npc_deaths INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE rank_daily (
 day TEXT NOT NULL,
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 faction_id INTEGER NOT NULL,
 badge INTEGER NOT NULL,
 points REAL NOT NULL,
 eligible INTEGER NOT NULL,
 breakdown_json TEXT NOT NULL,
 PRIMARY KEY(day,player_id)
);
