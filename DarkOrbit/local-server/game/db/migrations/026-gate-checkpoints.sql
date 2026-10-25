-- Persist the choice between the next major wave and a trip home.
ALTER TABLE galaxy_gate_runs ADD COLUMN waiting_next_wave INTEGER NOT NULL DEFAULT 0 CHECK(waiting_next_wave IN (0,1));
