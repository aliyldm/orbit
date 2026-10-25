using Npgsql;

namespace DarkOrbit.Server.Storage;

internal static class CombatSchema
{
    internal static async Task Create(NpgsqlConnection connection, NpgsqlTransaction transaction, string schema, string legacy)
    {
        await using var command = new NpgsqlCommand($"""
        CREATE TABLE {schema}.player_economy (
          player_id bigint PRIMARY KEY REFERENCES {schema}.players(id),credits numeric NOT NULL CHECK(credits>=0),uridium numeric NOT NULL CHECK(uridium>=0),
          ep numeric NOT NULL CHECK(ep>=0),honour numeric NOT NULL,level integer NOT NULL CHECK(level BETWEEN 1 AND 32));
        INSERT INTO {schema}.player_economy SELECT id,credits::numeric,uridium::numeric,ep::numeric,honour::numeric,level::integer FROM {legacy}.players;
        CREATE TABLE {schema}.player_combat (
          player_id bigint PRIMARY KEY REFERENCES {schema}.players(id),laser_ready_at timestamptz NOT NULL DEFAULT '-infinity',rsb_ready_at timestamptz NOT NULL DEFAULT '-infinity');
        INSERT INTO {schema}.player_combat(player_id) SELECT id FROM {schema}.players;
        CREATE TABLE {schema}.owned_ships (id bigint PRIMARY KEY,player_id bigint NOT NULL REFERENCES {schema}.players(id),loot_id text NOT NULL);
        INSERT INTO {schema}.owned_ships SELECT id,player_id,loot_id FROM {legacy}.ships;
        CREATE TABLE {schema}.active_boosters (player_id bigint NOT NULL REFERENCES {schema}.players(id),loot_id text NOT NULL,expires_at bigint NOT NULL,PRIMARY KEY(player_id,loot_id));
        INSERT INTO {schema}.active_boosters SELECT player_id,loot_id,expires_at FROM {legacy}.player_boosters;
        CREATE TABLE {schema}.inventory_items (
          id bigint PRIMARY KEY,player_id bigint NOT NULL REFERENCES {schema}.players(id),loot_id text NOT NULL,amount bigint NOT NULL CHECK(amount>=0),
          ship_id bigint,slot text,slot_index integer,upgrade_level integer NOT NULL CHECK(upgrade_level>=0));
        INSERT INTO {schema}.inventory_items SELECT id,player_id,loot_id,amount,ship_id,slot,slot_index::integer,upgrade_level::integer FROM {legacy}.items;
        CREATE INDEX inventory_ammo ON {schema}.inventory_items(player_id,loot_id,id) WHERE ship_id IS NULL;
        CREATE TABLE {schema}.world_authority (
          server_id integer PRIMARY KEY CHECK(server_id>0),owner uuid NOT NULL,fence bigint NOT NULL CHECK(fence>0),expires_at timestamptz NOT NULL);
        CREATE TABLE {schema}.world_checkpoints (
          server_id integer NOT NULL,map_id integer NOT NULL REFERENCES {schema}.maps(id),instance uuid NOT NULL,revision bigint NOT NULL CHECK(revision>=0),
          state jsonb NOT NULL,PRIMARY KEY(server_id,map_id,instance));
        CREATE TABLE {schema}.combat_receipts (
          id uuid PRIMARY KEY,player_id bigint NOT NULL REFERENCES {schema}.players(id),fingerprint text NOT NULL,result jsonb NOT NULL,created_at timestamptz NOT NULL DEFAULT clock_timestamp());
        CREATE TABLE {schema}.npc_reward_claims (
          server_id integer NOT NULL,map_id integer NOT NULL,instance uuid NOT NULL,claim_id text NOT NULL,
          player_id bigint NOT NULL REFERENCES {schema}.players(id),receipt_id uuid NOT NULL UNIQUE REFERENCES {schema}.combat_receipts(id) DEFERRABLE INITIALLY DEFERRED,
          PRIMARY KEY(server_id,map_id,instance,claim_id));
        """, connection, transaction);
        await command.ExecuteNonQueryAsync();
    }
}
