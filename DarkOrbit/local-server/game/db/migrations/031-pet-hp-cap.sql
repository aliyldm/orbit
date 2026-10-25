-- HP capacity upgrades are separate from XP. Retain existing current health;
-- no automatic heal or upgrade purchase is applied to existing PETs.
ALTER TABLE pets ADD COLUMN hp_upgrade_level INTEGER NOT NULL DEFAULT 0 CHECK(hp_upgrade_level BETWEEN 0 AND 20);
