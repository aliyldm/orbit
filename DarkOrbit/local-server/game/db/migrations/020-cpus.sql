-- Charges belong to the purchased physical item, shared across both configurations.
CREATE TABLE cpu_charges (
 item_id INTEGER PRIMARY KEY REFERENCES items(id) ON DELETE CASCADE,
 remaining INTEGER NOT NULL CHECK(remaining>=0)
);
