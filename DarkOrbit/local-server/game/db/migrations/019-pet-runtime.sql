-- Preserve existing PETs/equipment while expanding fuel and protocol support.
ALTER TABLE items ADD COLUMN pet_level INTEGER NOT NULL DEFAULT 1 CHECK(pet_level BETWEEN 1 AND 4);
CREATE TABLE pet_equipment_copy AS SELECT * FROM pet_equipment;
DROP TABLE pet_equipment;
CREATE TABLE pets_new (
 player_id INTEGER PRIMARY KEY REFERENCES players(id),
 name TEXT NOT NULL DEFAULT 'P.E.T.',
 level INTEGER NOT NULL DEFAULT 1 CHECK(level BETWEEN 1 AND 15),
 experience REAL NOT NULL DEFAULT 0 CHECK(experience>=0),
 hitpoints INTEGER NOT NULL DEFAULT 10000 CHECK(hitpoints>=0),
 shield INTEGER NOT NULL DEFAULT 0 CHECK(shield>=0),
 fuel INTEGER NOT NULL DEFAULT 0 CHECK(fuel BETWEEN 0 AND 100000),
 gear INTEGER NOT NULL DEFAULT 1,
 created_at INTEGER NOT NULL,
 fuel_fraction REAL NOT NULL DEFAULT 0 CHECK(fuel_fraction>=0 AND fuel_fraction<1)
);
INSERT INTO pets_new(player_id,name,level,experience,hitpoints,shield,fuel,gear,created_at)
 SELECT player_id,name,level,experience,hitpoints,shield,fuel,gear,created_at FROM pets;
DROP TABLE pets;
ALTER TABLE pets_new RENAME TO pets;
CREATE TABLE pet_equipment (
 player_id INTEGER NOT NULL REFERENCES pets(player_id) ON DELETE CASCADE,
 ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
 config_id INTEGER NOT NULL CHECK(config_id IN (1,2)),
 slot TEXT NOT NULL CHECK(slot IN ('laser','generator','gear','protocol')),
 slot_index INTEGER NOT NULL CHECK(slot_index>=0),
 item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
 PRIMARY KEY(item_id,config_id),
 UNIQUE(player_id,ship_id,config_id,slot,slot_index)
);
INSERT INTO pet_equipment SELECT * FROM pet_equipment_copy;
DROP TABLE pet_equipment_copy;
CREATE INDEX pet_equipment_player ON pet_equipment(player_id,ship_id,config_id);
CREATE TABLE pet_gear_state (
 player_id INTEGER NOT NULL REFERENCES pets(player_id) ON DELETE CASCADE,
 gear_type INTEGER NOT NULL,
 cooldown_until INTEGER NOT NULL DEFAULT 0 CHECK(cooldown_until>=0),
 PRIMARY KEY(player_id,gear_type)
);
