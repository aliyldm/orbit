-- Real per-player receipts replace the captured account's daily booked flags.
CREATE TABLE daily_login_claims (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 period TEXT NOT NULL,
 month TEXT NOT NULL,
 reward_day INTEGER NOT NULL CHECK(reward_day BETWEEN 1 AND 25),
 premium INTEGER NOT NULL CHECK(premium IN(0,1)),
 reward_json TEXT NOT NULL,
 claimed_at INTEGER NOT NULL,
 PRIMARY KEY(player_id,period),
 UNIQUE(player_id,month,reward_day)
);
CREATE TABLE payment_event_exchanges (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 recipe TEXT NOT NULL,
 claim_count INTEGER NOT NULL DEFAULT 0 CHECK(claim_count>=0),
 PRIMARY KEY(player_id,recipe)
);
