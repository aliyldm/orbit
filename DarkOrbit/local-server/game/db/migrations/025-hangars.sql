-- Purchased header hangars are separate from native inventory ship ids.
-- Keep every existing ship/config/item untouched. Legacy accounts retain slot1.
CREATE TABLE player_hangar_slots (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 slot_no INTEGER NOT NULL CHECK(slot_no BETWEEN 1 AND 200),
 ship_id INTEGER REFERENCES ships(id) ON DELETE SET NULL,
 purchased_at INTEGER NOT NULL DEFAULT 0,
 PRIMARY KEY(player_id,slot_no),
 UNIQUE(ship_id)
);
CREATE TABLE player_hangar_accounts (
 player_id INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
 selected_slot INTEGER NOT NULL DEFAULT 1 CHECK(selected_slot BETWEEN 1 AND 200)
);
CREATE TABLE player_hangar_purchases (
 player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
 request_id TEXT NOT NULL,
 slot_no INTEGER NOT NULL,
 price INTEGER NOT NULL CHECK(price=250000),
 purchased_at INTEGER NOT NULL,
 PRIMARY KEY(player_id,request_id),
 UNIQUE(player_id,slot_no)
);
INSERT INTO player_hangar_slots(player_id,slot_no,ship_id) SELECT id,1,active_ship_id FROM players;
INSERT INTO player_hangar_accounts(player_id) SELECT id FROM players;
