CREATE TABLE skylab_accounts (
  player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
  last_update INTEGER NOT NULL,
  reload_token TEXT NOT NULL
);
CREATE TABLE skylab_modules (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  level INTEGER NOT NULL CHECK(level BETWEEN 0 AND 20),
  active INTEGER NOT NULL DEFAULT 1 CHECK(active IN (0,1)),
  upgrade_until INTEGER,
  target_level INTEGER,
  PRIMARY KEY(player_id,name)
);
CREATE TABLE skylab_resources (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  ore_type INTEGER NOT NULL CHECK(ore_type BETWEEN 0 AND 7),
  amount REAL NOT NULL DEFAULT 0 CHECK(amount>=0),
  PRIMARY KEY(player_id,ore_type)
);
CREATE TABLE skylab_transports (
  id INTEGER PRIMARY KEY,
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  payload_json TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  arrive_at INTEGER NOT NULL,
  state TEXT NOT NULL CHECK(state IN ('pending','delivered')),
  delivered_at INTEGER
);
CREATE UNIQUE INDEX skylab_one_transport ON skylab_transports(player_id) WHERE state='pending';
CREATE TABLE player_ore_buffs (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  item_type INTEGER NOT NULL CHECK(item_type BETWEEN 0 AND 3),
  ore_type INTEGER NOT NULL,
  remaining INTEGER NOT NULL DEFAULT 0 CHECK(remaining BETWEEN 0 AND 1000000),
  expires_at INTEGER,
  PRIMARY KEY(player_id,item_type)
);
