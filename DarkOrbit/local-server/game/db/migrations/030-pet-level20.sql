-- Extend only the PET level bound. Preserve both equipment configurations,
-- every cooldown and all original PET values; no retroactive EP, levels or HP.
CREATE TABLE pet_equipment_before20 AS SELECT * FROM pet_equipment;
CREATE TABLE pet_gear_before20 AS SELECT * FROM pet_gear_state;
DROP TABLE pet_equipment;
DROP TABLE pet_gear_state;
CREATE TABLE pets_level20 (
 player_id INTEGER PRIMARY KEY REFERENCES players(id),
 name TEXT NOT NULL DEFAULT 'P.E.T.',
 level INTEGER NOT NULL DEFAULT 1 CHECK(level BETWEEN 0 AND 20),
 experience REAL NOT NULL DEFAULT 0 CHECK(experience>=0),
 hitpoints INTEGER NOT NULL DEFAULT 10000 CHECK(hitpoints>=0),
 shield INTEGER NOT NULL DEFAULT 0 CHECK(shield>=0),
 fuel INTEGER NOT NULL DEFAULT 0 CHECK(fuel BETWEEN 0 AND 100000),
 gear INTEGER NOT NULL DEFAULT 1,
 created_at INTEGER NOT NULL,
 fuel_fraction REAL NOT NULL DEFAULT 0 CHECK(fuel_fraction>=0 AND fuel_fraction<1)
);
INSERT INTO pets_level20 SELECT * FROM pets;
DROP TABLE pets;
ALTER TABLE pets_level20 RENAME TO pets;
CREATE TABLE pet_equipment (
 player_id INTEGER NOT NULL REFERENCES pets(player_id) ON DELETE CASCADE,
 ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
 config_id INTEGER NOT NULL CHECK(config_id IN (1,2)),
 slot TEXT NOT NULL CHECK(slot IN ('laser','generator','gear','protocol','visual')),
 slot_index INTEGER NOT NULL CHECK(slot_index>=0),
 item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
 PRIMARY KEY(item_id,config_id),
 UNIQUE(player_id,ship_id,config_id,slot,slot_index)
);
INSERT INTO pet_equipment SELECT * FROM pet_equipment_before20;
DROP TABLE pet_equipment_before20;
CREATE INDEX pet_equipment_player ON pet_equipment(player_id,ship_id,config_id);
CREATE TABLE pet_gear_state (
 player_id INTEGER NOT NULL REFERENCES pets(player_id) ON DELETE CASCADE,
 gear_type INTEGER NOT NULL,
 cooldown_until INTEGER NOT NULL DEFAULT 0 CHECK(cooldown_until>=0),
 PRIMARY KEY(player_id,gear_type)
);
INSERT INTO pet_gear_state SELECT * FROM pet_gear_before20;
DROP TABLE pet_gear_before20;
