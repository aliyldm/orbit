-- Preserve patrol anchors separately from the last combat/chase position.
-- NULL anchors on older saves are initialized lazily without resetting health,
-- death generations or respawn deadlines.
ALTER TABLE normal_spawn_state ADD COLUMN home_x REAL;
ALTER TABLE normal_spawn_state ADD COLUMN home_y REAL;
ALTER TABLE normal_spawn_state ADD COLUMN patrol_returning INTEGER NOT NULL DEFAULT 0 CHECK(patrol_returning IN(0,1));
