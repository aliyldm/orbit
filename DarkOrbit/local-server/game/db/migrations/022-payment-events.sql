-- Local permanent season/event progression; no existing inventory is consumed by migration.
CREATE TABLE payment_purchase_receipts (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 sku TEXT NOT NULL,
 purchased_at INTEGER NOT NULL,
 PRIMARY KEY(player_id,sku)
);
CREATE TABLE payment_event_accounts (
 player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
 season_points INTEGER NOT NULL DEFAULT 0 CHECK(season_points BETWEEN 0 AND 9000),
 gold INTEGER NOT NULL DEFAULT 0 CHECK(gold IN(0,1)),
 extra INTEGER NOT NULL DEFAULT 0 CHECK(extra IN(0,1) AND extra<=gold),
 trinity INTEGER NOT NULL DEFAULT 0 CHECK(trinity IN(0,1)),
 voyagers INTEGER NOT NULL DEFAULT 0 CHECK(voyagers IN(0,1)),
 battlepass INTEGER NOT NULL DEFAULT 0 CHECK(battlepass IN(0,1)),
 trinity_points INTEGER NOT NULL DEFAULT 0 CHECK(trinity_points BETWEEN 0 AND 10900),
 voyagers_points INTEGER NOT NULL DEFAULT 0 CHECK(voyagers_points BETWEEN 0 AND 7600)
);
CREATE TABLE payment_event_claims (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 track TEXT NOT NULL,
 level INTEGER NOT NULL CHECK(level BETWEEN 1 AND 90),
 reward_json TEXT NOT NULL,
 claimed_at INTEGER NOT NULL,
 PRIMARY KEY(player_id,track,level)
);
CREATE TABLE payment_event_progress (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 mission TEXT NOT NULL,
 period TEXT NOT NULL,
 progress INTEGER NOT NULL DEFAULT 0 CHECK(progress>=0),
 awarded INTEGER NOT NULL DEFAULT 0 CHECK(awarded IN(0,1)),
 battle_claimed INTEGER NOT NULL DEFAULT 0 CHECK(battle_claimed IN(0,1)),
 PRIMARY KEY(player_id,mission,period)
);
CREATE TABLE payment_event_receipts (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 event_type TEXT NOT NULL,
 event_id TEXT NOT NULL,
 recorded_at INTEGER NOT NULL,
 PRIMARY KEY(player_id,event_type,event_id)
);
