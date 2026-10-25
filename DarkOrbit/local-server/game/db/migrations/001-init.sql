-- İlk şema: hesaplar, oyuncular, gemiler, envanter, katalog, haritalar ve NPC'ler.

CREATE TABLE accounts (
  id            INTEGER PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE COLLATE NOCASE,
  password_hash TEXT NOT NULL,           -- scrypt: "salt:hash" (hex)
  created_at    INTEGER NOT NULL
);

-- ShipInitializationCommand alanlarıyla aynı adlar (camelCase değil, snake_case).
CREATE TABLE players (
  id               INTEGER PRIMARY KEY,  -- oyun içi userId
  account_id       INTEGER NOT NULL UNIQUE REFERENCES accounts(id),
  name             TEXT NOT NULL,
  faction_id       INTEGER NOT NULL,     -- 1 MMO, 2 EIC, 3 VRU
  level            INTEGER NOT NULL DEFAULT 1,
  ep               REAL NOT NULL DEFAULT 0,
  honour           REAL NOT NULL DEFAULT 0,
  credits          REAL NOT NULL DEFAULT 0,
  uridium          REAL NOT NULL DEFAULT 0,
  jackpot          REAL NOT NULL DEFAULT 0,
  map_id           INTEGER NOT NULL,
  x                INTEGER NOT NULL,
  y                INTEGER NOT NULL,
  premium          INTEGER NOT NULL DEFAULT 0,
  galaxy_gates_done INTEGER NOT NULL DEFAULT 0,
  active_ship_id   INTEGER,
  created_at       INTEGER NOT NULL
);

-- Gemi türleri (taban değerler). Değerler düzenlenebilir.
CREATE TABLE ship_types (
  loot_id        TEXT PRIMARY KEY,        -- ör. ship_phoenix
  name           TEXT NOT NULL,
  hitpoints      INTEGER NOT NULL,
  speed          INTEGER NOT NULL,
  cargo          INTEGER NOT NULL,
  laser_slots    INTEGER NOT NULL,
  generator_slots INTEGER NOT NULL,
  extra_slots    INTEGER NOT NULL DEFAULT 1,
  price_credits  INTEGER NOT NULL DEFAULT 0,
  price_uridium  INTEGER NOT NULL DEFAULT 0
);

-- Eşya kataloğu: lazer, jeneratör (kalkan/hız), cephane, ekstra.
CREATE TABLE item_types (
  loot_id        TEXT PRIMARY KEY,        -- ör. equipment_weapon_laser_lf-1
  name           TEXT NOT NULL,
  category       TEXT NOT NULL,           -- laser | shield_generator | speed_generator | ammo_laser | ammo_rocket | extra | resource
  damage         INTEGER NOT NULL DEFAULT 0,  -- lazer: atış başına hasar
  shield         INTEGER NOT NULL DEFAULT 0,  -- kalkan jeneratörü: kalkan puanı
  shield_absorb  REAL NOT NULL DEFAULT 0,     -- kalkan jeneratörü: emilim oranı
  speed          INTEGER NOT NULL DEFAULT 0,  -- hız jeneratörü
  multiplier     REAL NOT NULL DEFAULT 1,     -- cephane hasar çarpanı
  price_credits  INTEGER NOT NULL DEFAULT 0,
  price_uridium  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE ships (
  id         INTEGER PRIMARY KEY,
  player_id  INTEGER NOT NULL REFERENCES players(id),
  loot_id    TEXT NOT NULL REFERENCES ship_types(loot_id),
  hitpoints  INTEGER NOT NULL,           -- güncel can
  shield     INTEGER NOT NULL DEFAULT 0, -- güncel kalkan
  favorite   INTEGER NOT NULL DEFAULT 0
);

-- Envanter. slot: NULL = depoda; değilse takılı olduğu yer.
CREATE TABLE items (
  id         INTEGER PRIMARY KEY,
  player_id  INTEGER NOT NULL REFERENCES players(id),
  loot_id    TEXT NOT NULL REFERENCES item_types(loot_id),
  amount     INTEGER NOT NULL DEFAULT 1, -- cephane/kaynak sayısı
  ship_id    INTEGER REFERENCES ships(id),
  slot       TEXT,                       -- laser | generator | extra
  slot_index INTEGER
);
CREATE INDEX items_player ON items(player_id);

CREATE TABLE maps (
  id            INTEGER PRIMARY KEY,
  name          TEXT NOT NULL,           -- ör. 1-1
  faction_id    INTEGER NOT NULL DEFAULT 0,
  is_start      INTEGER NOT NULL DEFAULT 0,
  width         INTEGER NOT NULL DEFAULT 21000,
  height        INTEGER NOT NULL DEFAULT 13100,
  start_x       INTEGER NOT NULL DEFAULT 1000,
  start_y       INTEGER NOT NULL DEFAULT 1000
);

CREATE TABLE portals (
  id         INTEGER PRIMARY KEY,
  map_id     INTEGER NOT NULL REFERENCES maps(id),
  x          INTEGER NOT NULL,
  y          INTEGER NOT NULL,
  target_map INTEGER NOT NULL REFERENCES maps(id),
  target_x   INTEGER NOT NULL,
  target_y   INTEGER NOT NULL
);

CREATE TABLE npc_types (
  type_id     INTEGER PRIMARY KEY,       -- istemcideki gemi tipi (ShipCreateCommand.typeId)
  name        TEXT NOT NULL,
  hitpoints   INTEGER NOT NULL,
  shield      INTEGER NOT NULL,
  speed       INTEGER NOT NULL,
  damage_min  INTEGER NOT NULL,
  damage_max  INTEGER NOT NULL,
  reward_ep   INTEGER NOT NULL DEFAULT 0,
  reward_honour INTEGER NOT NULL DEFAULT 0,
  reward_credits INTEGER NOT NULL DEFAULT 0,
  reward_uridium INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE map_spawns (
  id          INTEGER PRIMARY KEY,
  map_id      INTEGER NOT NULL REFERENCES maps(id),
  npc_type    INTEGER NOT NULL REFERENCES npc_types(type_id),
  count       INTEGER NOT NULL,
  respawn_ms  INTEGER NOT NULL DEFAULT 5000
);

-- İstemci ayarları ve tuş atamaları (JSON).
CREATE TABLE settings (
  player_id  INTEGER NOT NULL REFERENCES players(id),
  key        TEXT NOT NULL,
  value      TEXT NOT NULL,
  PRIMARY KEY (player_id, key)
);
