-- Configuration 1 keeps its original items columns for existing accounts and game saves.
-- The same item may also be used in configuration 2 of the same ship.
CREATE TABLE equipment_config2 (
  item_id INTEGER PRIMARY KEY REFERENCES items(id) ON DELETE CASCADE,
  ship_id INTEGER NOT NULL REFERENCES ships(id) ON DELETE CASCADE,
  slot TEXT NOT NULL CHECK(slot IN ('laser', 'generator', 'extra')),
  slot_index INTEGER NOT NULL CHECK(slot_index >= 0),
  UNIQUE(ship_id, slot, slot_index)
);
CREATE TABLE equipment_saved (
  ship_id INTEGER PRIMARY KEY REFERENCES ships(id) ON DELETE CASCADE,
  layout TEXT NOT NULL
);
CREATE INDEX items_equipment ON items(ship_id, slot, slot_index);
ALTER TABLE ships ADD COLUMN active_config INTEGER NOT NULL DEFAULT 1 CHECK(active_config IN (1,2));
