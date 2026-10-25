-- Both ship configurations accept the slot names exported by main.swf.
ALTER TABLE equipment_config2 RENAME TO equipment_config2_old;
CREATE TABLE equipment_config2 (
 item_id INTEGER PRIMARY KEY REFERENCES items(id) ON DELETE CASCADE,
 ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
 slot TEXT NOT NULL CHECK(slot IN('laser','generator','extra','heavy_gun','cannon','drive','cannon_shield','lens','ship_upgrade','quantum_core')),
 slot_index INTEGER NOT NULL CHECK(slot_index>=0),
 UNIQUE(ship_id,slot,slot_index)
);
INSERT INTO equipment_config2 SELECT * FROM equipment_config2_old;
DROP TABLE equipment_config2_old;
CREATE TABLE ship_designs (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 loot_id TEXT NOT NULL,
 PRIMARY KEY(player_id,loot_id)
);
ALTER TABLE ships ADD COLUMN design_loot_id TEXT;
