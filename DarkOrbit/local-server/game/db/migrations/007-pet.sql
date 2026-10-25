CREATE TABLE pets (
 player_id INTEGER PRIMARY KEY REFERENCES players(id),
 name TEXT NOT NULL DEFAULT 'P.E.T.',
 level INTEGER NOT NULL DEFAULT 1 CHECK(level BETWEEN 1 AND 15),
 experience REAL NOT NULL DEFAULT 0 CHECK(experience>=0),
 hitpoints INTEGER NOT NULL DEFAULT 10000 CHECK(hitpoints>=0),
 shield INTEGER NOT NULL DEFAULT 0 CHECK(shield>=0),
 fuel INTEGER NOT NULL DEFAULT 0 CHECK(fuel BETWEEN 0 AND 50000),
 gear INTEGER NOT NULL DEFAULT 1,
 created_at INTEGER NOT NULL
);
CREATE TABLE pet_equipment (
 player_id INTEGER NOT NULL REFERENCES pets(player_id) ON DELETE CASCADE,
 ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
 config_id INTEGER NOT NULL CHECK(config_id IN (1,2)),
 slot TEXT NOT NULL CHECK(slot IN ('laser','generator','gear')),
 slot_index INTEGER NOT NULL CHECK(slot_index>=0),
 item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
 PRIMARY KEY(item_id,config_id),
 UNIQUE(player_id,ship_id,config_id,slot,slot_index)
);
CREATE INDEX pet_equipment_player ON pet_equipment(player_id,ship_id,config_id);
-- Preserve pets bought by the older generic item store; no free PET is created.
INSERT INTO pets(player_id,created_at)
 SELECT DISTINCT player_id,0 FROM items WHERE loot_id='pet_pet10' AND amount>0;
