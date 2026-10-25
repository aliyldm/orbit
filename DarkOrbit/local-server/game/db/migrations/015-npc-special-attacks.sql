-- Keep an armed Barracuda's deadline when its map is unloaded or reconnected.
ALTER TABLE normal_spawn_state ADD COLUMN self_destruct_at INTEGER NOT NULL DEFAULT 0;
