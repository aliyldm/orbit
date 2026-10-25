-- Preserve each physical item and both configurations while unlocking the
-- cosmetic slot already present in HangarPetEquipmentMsg and the portal SWF.
CREATE TABLE pet_equipment_appearance_copy AS SELECT * FROM pet_equipment;
DROP TABLE pet_equipment;
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
INSERT INTO pet_equipment SELECT * FROM pet_equipment_appearance_copy;
DROP TABLE pet_equipment_appearance_copy;
CREATE INDEX pet_equipment_player ON pet_equipment(player_id,ship_id,config_id);
