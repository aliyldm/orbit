CREATE TABLE drones (
 id INTEGER PRIMARY KEY,
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 loot_id TEXT NOT NULL REFERENCES item_types(loot_id),
 level INTEGER NOT NULL DEFAULT 0 CHECK(level BETWEEN 0 AND 5),
 experience INTEGER NOT NULL DEFAULT 0 CHECK(experience>=0),
 damage REAL NOT NULL DEFAULT 0 CHECK(damage BETWEEN 0 AND 100)
);
CREATE INDEX drones_owner ON drones(player_id);
CREATE TABLE drone_equipment (
 drone_id INTEGER NOT NULL REFERENCES drones(id) ON DELETE CASCADE,
 ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
 config_id INTEGER NOT NULL CHECK(config_id IN(1,2)),
 slot TEXT NOT NULL CHECK(slot IN('default','design','visual')),
 slot_index INTEGER NOT NULL CHECK(slot_index>=0),
 item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
 PRIMARY KEY(item_id,config_id),
 UNIQUE(drone_id,ship_id,config_id,slot,slot_index)
);
CREATE TABLE drone_settings (
 player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
 formation_id INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE ship_config_shields (
 ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
 config_id INTEGER NOT NULL CHECK(config_id IN(1,2)),
 shield REAL NOT NULL DEFAULT 0 CHECK(shield>=0),
 PRIMARY KEY(ship_id,config_id)
);
