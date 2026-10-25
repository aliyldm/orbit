-- Every existing ship starts with its previous zero NanoHull; no free charge.
ALTER TABLE ships ADD COLUMN nano_hull INTEGER NOT NULL DEFAULT 0 CHECK(nano_hull>=0 AND nano_hull<=2147483647);
