using Npgsql;

namespace DarkOrbit.Server.Storage;

internal static class EquipmentSchema
{
    internal static async Task Create(NpgsqlConnection connection, NpgsqlTransaction transaction, string schema, string legacy)
    {
        await using var command = new NpgsqlCommand($"""
        ALTER TABLE {schema}.owned_ships ADD COLUMN record jsonb NOT NULL DEFAULT jsonb_build_object();
        ALTER TABLE {schema}.owned_ships ADD CONSTRAINT ship_owner_key UNIQUE(id,player_id);
        UPDATE {schema}.owned_ships s SET record=to_jsonb(old) FROM {legacy}.ships old WHERE old.id=s.id AND old.player_id=s.player_id;
        ALTER TABLE {schema}.players ADD COLUMN active_ship_id bigint;
        ALTER TABLE {schema}.players ADD COLUMN equipment_revision bigint NOT NULL DEFAULT 0 CHECK(equipment_revision>=0);
        UPDATE {schema}.players p SET active_ship_id=old.active_ship_id FROM {legacy}.players old WHERE old.id=p.id;
        ALTER TABLE {schema}.players ADD FOREIGN KEY(active_ship_id,id) REFERENCES {schema}.owned_ships(id,player_id);
        ALTER TABLE {schema}.inventory_items ADD COLUMN pet_level integer NOT NULL DEFAULT 1 CHECK(pet_level BETWEEN 1 AND 4);
        UPDATE {schema}.inventory_items i SET pet_level=old.pet_level::integer FROM {legacy}.items old WHERE old.id=i.id;
        ALTER TABLE {schema}.inventory_items ADD CONSTRAINT item_owner_key UNIQUE(id,player_id);
        CREATE TABLE {schema}.equipment_item_types(loot_id text PRIMARY KEY,record jsonb NOT NULL);
        INSERT INTO {schema}.equipment_item_types SELECT loot_id,to_jsonb(t) FROM {legacy}.item_types t;
        CREATE TABLE {schema}.equipment_ship_types(loot_id text PRIMARY KEY,record jsonb NOT NULL);
        INSERT INTO {schema}.equipment_ship_types SELECT loot_id,to_jsonb(t) FROM {legacy}.ship_types t;
        CREATE TABLE {schema}.equipment_drones(id bigint PRIMARY KEY,player_id bigint NOT NULL REFERENCES {schema}.players(id),record jsonb NOT NULL,UNIQUE(id,player_id));
        INSERT INTO {schema}.equipment_drones SELECT id,player_id,to_jsonb(d) FROM {legacy}.drones d;
        CREATE TABLE {schema}.equipment_mounts (
          player_id bigint NOT NULL REFERENCES {schema}.players(id),ship_id bigint NOT NULL,config_id integer NOT NULL CHECK(config_id IN(1,2)),
          target text NOT NULL CHECK(target IN('ship','drone','pet')),target_id bigint NOT NULL DEFAULT 0,drone_id bigint,
          slot text NOT NULL,slot_index integer NOT NULL CHECK(slot_index>=0),item_id bigint NOT NULL,
          PRIMARY KEY(item_id,config_id),UNIQUE(ship_id,config_id,target,target_id,slot,slot_index),
          FOREIGN KEY(ship_id,player_id) REFERENCES {schema}.owned_ships(id,player_id) ON DELETE CASCADE,
          FOREIGN KEY(item_id,player_id) REFERENCES {schema}.inventory_items(id,player_id) ON DELETE CASCADE,
          FOREIGN KEY(drone_id,player_id) REFERENCES {schema}.equipment_drones(id,player_id) ON DELETE CASCADE,
          CHECK((target='drone' AND drone_id IS NOT NULL AND target_id=drone_id) OR (target IN('ship','pet') AND drone_id IS NULL AND target_id=0)));
        INSERT INTO {schema}.equipment_mounts(player_id,ship_id,config_id,target,slot,slot_index,item_id)
          SELECT player_id,ship_id,1,'ship',slot,slot_index::integer,id FROM {legacy}.items WHERE ship_id IS NOT NULL AND slot IS NOT NULL;
        INSERT INTO {schema}.equipment_mounts(player_id,ship_id,config_id,target,slot,slot_index,item_id)
          SELECT i.player_id,e.ship_id,2,'ship',e.slot,e.slot_index::integer,e.item_id FROM {legacy}.equipment_config2 e JOIN {legacy}.items i ON i.id=e.item_id;
        INSERT INTO {schema}.equipment_mounts SELECT i.player_id,e.ship_id,e.config_id::integer,'drone',e.drone_id,e.drone_id,e.slot,e.slot_index::integer,e.item_id FROM {legacy}.drone_equipment e JOIN {legacy}.items i ON i.id=e.item_id;
        INSERT INTO {schema}.equipment_mounts(player_id,ship_id,config_id,target,slot,slot_index,item_id)
          SELECT e.player_id,e.ship_id,e.config_id::integer,'pet',e.slot,e.slot_index::integer,e.item_id FROM {legacy}.pet_equipment e;
        CREATE INDEX equipment_ship ON {schema}.equipment_mounts(ship_id,config_id);
        CREATE TABLE {schema}.equipment_skill_levels(player_id bigint NOT NULL REFERENCES {schema}.players(id),skill_id text NOT NULL,level integer NOT NULL CHECK(level BETWEEN 1 AND 5),PRIMARY KEY(player_id,skill_id));
        INSERT INTO {schema}.equipment_skill_levels SELECT player_id,skill_id,level::integer FROM {legacy}.player_skills;
        CREATE TABLE {schema}.equipment_ore_buffs(player_id bigint NOT NULL REFERENCES {schema}.players(id),item_type integer NOT NULL,ore_type integer NOT NULL,remaining bigint NOT NULL,expires_at bigint,PRIMARY KEY(player_id,item_type));
        INSERT INTO {schema}.equipment_ore_buffs SELECT player_id,item_type::integer,ore_type::integer,remaining,expires_at FROM {legacy}.player_ore_buffs;
        CREATE TABLE {schema}.equipment_resources(player_id bigint NOT NULL REFERENCES {schema}.players(id),ore_type integer NOT NULL,amount bigint NOT NULL CHECK(amount>=0),PRIMARY KEY(player_id,ore_type));
        INSERT INTO {schema}.equipment_resources SELECT player_id,ore_type::integer,amount FROM {legacy}.player_resources;
        CREATE TABLE {schema}.equipment_formations(player_id bigint PRIMARY KEY REFERENCES {schema}.players(id),formation_id integer NOT NULL);
        INSERT INTO {schema}.equipment_formations SELECT player_id,formation_id::integer FROM {legacy}.drone_settings;
        CREATE TABLE {schema}.equipment_config_shields(ship_id bigint NOT NULL REFERENCES {schema}.owned_ships(id),config_id integer NOT NULL CHECK(config_id IN(1,2)),shield double precision NOT NULL CHECK(shield>=0),PRIMARY KEY(ship_id,config_id));
        INSERT INTO {schema}.equipment_config_shields SELECT ship_id,config_id::integer,shield::double precision FROM {legacy}.ship_config_shields;
        CREATE TABLE {schema}.equipment_designs(player_id bigint NOT NULL REFERENCES {schema}.players(id),loot_id text NOT NULL,PRIMARY KEY(player_id,loot_id));
        INSERT INTO {schema}.equipment_designs SELECT player_id,loot_id FROM {legacy}.ship_designs;
        CREATE TABLE {schema}.equipment_saved(ship_id bigint PRIMARY KEY REFERENCES {schema}.owned_ships(id),layout jsonb NOT NULL);
        INSERT INTO {schema}.equipment_saved SELECT ship_id,layout::jsonb FROM {legacy}.equipment_saved;
        CREATE TABLE {schema}.equipment_pets(player_id bigint PRIMARY KEY REFERENCES {schema}.players(id),record jsonb NOT NULL);
        INSERT INTO {schema}.equipment_pets SELECT player_id,to_jsonb(p) FROM {legacy}.pets p;
        CREATE TABLE {schema}.equipment_pet_slots(player_id bigint PRIMARY KEY REFERENCES {schema}.players(id),record jsonb NOT NULL);
        INSERT INTO {schema}.equipment_pet_slots SELECT player_id,value::jsonb FROM {legacy}.settings WHERE key='pet.unlockedSlots';
        CREATE TABLE {schema}.equipment_jobs(player_id bigint NOT NULL REFERENCES {schema}.players(id),recipe_loot_id text NOT NULL,target_id bigint NOT NULL,record jsonb NOT NULL,PRIMARY KEY(player_id,recipe_loot_id,target_id));
        INSERT INTO {schema}.equipment_jobs SELECT player_id,recipe_loot_id,target_id,to_jsonb(j) FROM {legacy}.assembly_jobs j;
        """, connection, transaction);
        await command.ExecuteNonQueryAsync();
    }
}
