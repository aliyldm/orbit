using System.Security.Cryptography;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using DarkOrbit.Server.Protocol;
using Npgsql;
using NpgsqlTypes;

namespace DarkOrbit.Server.Storage;

public static partial class NativeBootstrap
{
    [GeneratedRegex("^mp_[a-f0-9]{16}$")] private static partial Regex TargetPattern();
    [GeneratedRegex("^legacy_[a-f0-9]{16}$")] private static partial Regex ArchivePattern();
    public static async Task<object> Create(NpgsqlDataSource source, string archive, string target, string file, string expectedSnapshotHash)
    {
        if (!TargetPattern().IsMatch(target) || !ArchivePattern().IsMatch(archive)) throw new ArgumentException("Only fresh development schemas are supported");
        byte[] bytes = await File.ReadAllBytesAsync(file); var document = JsonNode.Parse(bytes)!;
        if (document["format"]!.GetValue<int>() != 1 || document["sourceSnapshotSha256"]!.GetValue<string>() != expectedSnapshotHash) throw new InvalidDataException("Projection/archive snapshot mismatch");
        var codec = new LegacyCodec(); var profiles = document["profiles"]!.AsArray();
        int verifiedCommands = 0;
        foreach (var entry in profiles)
        {
            var commands = entry!["commands"]!.AsArray(); var bodies = entry["bodies"]!.AsArray();
            if (commands.Count != bodies.Count || commands.Count == 0) throw new InvalidDataException("Missing initialization contract");
            for (int i = 0; i < commands.Count; i++)
            {
                if (!codec.Encode(commands[i]!.AsObject()).SequenceEqual(Convert.FromBase64String(bodies[i]!.GetValue<string>()))) throw new InvalidDataException("Native initialization differs from legacy output");
                verifiedCommands++;
            }
        }
        await using var connection = await source.OpenConnectionAsync(); await using var transaction = await connection.BeginTransactionAsync();
        async Task Execute(string sql) { await using var cmd = new NpgsqlCommand(sql, connection, transaction); await cmd.ExecuteNonQueryAsync(); }
        string schema = '"' + target + '"', legacy = '"' + archive + '"';
        await Execute($"""
        CREATE SCHEMA {schema};
        CREATE TABLE {schema}.metadata (source_snapshot_hash text NOT NULL, projections_hash text NOT NULL,runtime_schema_version integer NOT NULL DEFAULT 2);
        CREATE TABLE {schema}.accounts (id bigint PRIMARY KEY CHECK(id>0), username text COLLATE "C" NOT NULL UNIQUE, password_hash text NOT NULL, created_at bigint NOT NULL);
        INSERT INTO {schema}.accounts SELECT id,username,password_hash,created_at FROM {legacy}.accounts;
        CREATE TABLE {schema}.maps (id integer PRIMARY KEY, width integer NOT NULL CHECK(width>0),height integer NOT NULL CHECK(height>0),private boolean NOT NULL DEFAULT false);
        INSERT INTO {schema}.maps(id,width,height) SELECT id::integer,width::integer,height::integer FROM {legacy}.maps;
        CREATE TABLE {schema}.players (
          id bigint PRIMARY KEY CHECK(id>0 AND id<=2147483647),account_id bigint NOT NULL UNIQUE REFERENCES {schema}.accounts(id),server_id integer NOT NULL CHECK(server_id>0),
          map_id integer NOT NULL REFERENCES {schema}.maps(id),x double precision NOT NULL,y double precision NOT NULL,
          profile jsonb NOT NULL,initial_commands jsonb NOT NULL,connection_fence bigint NOT NULL DEFAULT 0 CHECK(connection_fence>=0),connection_owner text);
        CREATE INDEX players_map ON {schema}.players(server_id,map_id);
        """);
        foreach (var id in document["privateMapIds"]!.AsArray())
        {
            await using var cmd = new NpgsqlCommand($"UPDATE {schema}.maps SET private=true WHERE id=$1", connection, transaction); cmd.Parameters.AddWithValue(id!.GetValue<int>());
            if (await cmd.ExecuteNonQueryAsync() != 1) throw new InvalidDataException("Private gate map missing from archive");
        }
        foreach (var entry in profiles)
        {
            var p = entry!["profile"]!; long id = entry["playerId"]!.GetValue<long>(), account = entry["accountId"]!.GetValue<long>();
            if (p["userId"]!.GetValue<long>() != id) throw new InvalidDataException("Profile owner mismatch");
            await using var cmd = new NpgsqlCommand($"INSERT INTO {schema}.players(id,account_id,server_id,map_id,x,y,profile,initial_commands) SELECT $1,$2,1,$3,$4,$5,$6,$7 FROM {legacy}.players WHERE id=$1 AND account_id=$2", connection, transaction);
            cmd.Parameters.AddWithValue(id); cmd.Parameters.AddWithValue(account); cmd.Parameters.AddWithValue(p["mapId"]!.GetValue<int>()); cmd.Parameters.AddWithValue(p["x"]!.GetValue<double>()); cmd.Parameters.AddWithValue(p["y"]!.GetValue<double>());
            cmd.Parameters.AddWithValue(NpgsqlDbType.Jsonb, p.ToJsonString()); cmd.Parameters.AddWithValue(NpgsqlDbType.Jsonb, entry["commands"]!.ToJsonString());
            if (await cmd.ExecuteNonQueryAsync() != 1) throw new InvalidDataException("Projection owner is absent from archive");
        }
        await CombatSchema.Create(connection, transaction, schema, legacy);
        await using (var cmd = new NpgsqlCommand($"INSERT INTO {schema}.metadata(source_snapshot_hash,projections_hash) VALUES($1,$2)", connection, transaction))
        {
            cmd.Parameters.AddWithValue(expectedSnapshotHash); cmd.Parameters.AddWithValue(Convert.ToHexStringLower(SHA256.HashData(bytes))); await cmd.ExecuteNonQueryAsync();
        }
        await transaction.CommitAsync();
        return new { schema = target, archive, runtimeSchemaVersion = 2, players = profiles.Count, verifiedInitializationCommands = verifiedCommands, legacyPasswordHashesPreserved = true, derivedStatsPorted = false, gameplayReady = false };
    }
}
