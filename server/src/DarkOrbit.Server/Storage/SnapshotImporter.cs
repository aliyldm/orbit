using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using Npgsql;
using NpgsqlTypes;

namespace DarkOrbit.Server.Storage;

// Rehearsal archive, never a drop-in runtime schema. Source DDL/defaults/indexes
// are retained in metadata; engine-specific constraints need explicit porting.
// An import either verifies every value and commits, or rolls back entirely.
public static partial class SnapshotImporter
{
    [GeneratedRegex("^legacy_[a-f0-9]{16}$")]
    private static partial Regex SafeSchema();
    private static string Q(string value) => '"' + value.Replace("\"", "\"\"") + '"';
    public static async Task<object> Import(NpgsqlDataSource source, string snapshotPath, string schema, CancellationToken cancellation = default)
    {
        if (!SafeSchema().IsMatch(schema)) throw new ArgumentException("Only a fresh legacy_<16 hex> rehearsal schema is permitted");
        byte[] bytes = await File.ReadAllBytesAsync(snapshotPath, cancellation);
        var snapshot = JsonNode.Parse(bytes)!; if (snapshot["format"]!.GetValue<int>() != 1) throw new InvalidDataException("Unsupported snapshot format");
        var tables = snapshot["tables"]!.AsArray();
        await using var connection = await source.OpenConnectionAsync(cancellation);
        await using var transaction = await connection.BeginTransactionAsync(cancellation);
        async Task Execute(string sql)
        {
            await using var cmd = new NpgsqlCommand(sql, connection, transaction); await cmd.ExecuteNonQueryAsync(cancellation);
        }
        // CREATE deliberately fails on replay. Never delete an existing schema.
        await Execute($"CREATE SCHEMA {Q(schema)}");
        await Execute($"CREATE TABLE {Q(schema)}.\"_snapshot_metadata\" (name text PRIMARY KEY, metadata jsonb NOT NULL)");
        int rowCount = 0; var reports = new List<object>();
        foreach (var table in tables)
        {
            string name = table!["name"]!.GetValue<string>(); var columns = table["columns"]!.AsArray(); var rows = table["rows"]!.AsArray();
            if (name == "_snapshot_metadata") throw new InvalidDataException("Reserved table name");
            var types = columns.Select((c, i) =>
            {
                var declared = ColumnType(c!["type"]!.GetValue<string>());
                var kinds = rows.Select(r => r![i]!["kind"]!.GetValue<string>()).Where(k => k != "null").Distinct().ToArray();
                // SQLite INTEGER affinity allows fractional prices. Preserve them
                // exactly as numeric instead of truncating them into bigint.
                return declared.Kind == "integer" && kinds.Contains("real") && kinds.All(k => k is "integer" or "real")
                    ? (Sql: "numeric", Kind: "numeric") : declared;
            }).ToArray();
            string target = Q(schema) + "." + Q(name);
            await Execute($"CREATE TABLE {target} ({string.Join(',', columns.Select((c, i) => Q(c!["name"]!.GetValue<string>()) + " " + types[i].Sql))})");
            await using (var meta = new NpgsqlCommand($"INSERT INTO {Q(schema)}.\"_snapshot_metadata\" VALUES ($1,$2)", connection, transaction))
            {
                meta.Parameters.AddWithValue(name); var metadata = table.DeepClone().AsObject(); metadata.Remove("rows");
                meta.Parameters.AddWithValue(NpgsqlDbType.Jsonb, metadata.ToJsonString()); await meta.ExecuteNonQueryAsync(cancellation);
            }
            await using (var writer = await connection.BeginBinaryImportAsync($"COPY {target} FROM STDIN (FORMAT BINARY)", cancellation))
            {
                foreach (var row in rows)
                {
                    if (row!.AsArray().Count != columns.Count) throw new InvalidDataException("Snapshot row width mismatch");
                    await writer.StartRowAsync(cancellation);
                    for (int i = 0; i < columns.Count; i++)
                    {
                        var cell = row[i]!; string kind = cell["kind"]!.GetValue<string>();
                        if (kind == "null") { await writer.WriteNullAsync(cancellation); continue; }
                        string text = cell["value"]!.GetValue<string>();
                        // Do not silently coerce SQLite's dynamic storage classes.
                        if (kind != types[i].Kind && !(types[i].Kind == "numeric" && kind is "integer" or "real")) throw new InvalidDataException($"Storage class mismatch: {name}/{i}");
                        switch (types[i].Kind)
                        {
                            case "integer": await writer.WriteAsync(long.Parse(text, CultureInfo.InvariantCulture), NpgsqlDbType.Bigint, cancellation); break;
                            case "real": await writer.WriteAsync(double.Parse(text, CultureInfo.InvariantCulture), NpgsqlDbType.Double, cancellation); break;
                            case "text": await writer.WriteAsync(text, NpgsqlDbType.Text, cancellation); break;
                            case "blob": await writer.WriteAsync(Convert.FromBase64String(text), NpgsqlDbType.Bytea, cancellation); break;
                            case "numeric": await writer.WriteAsync(decimal.Parse(text, NumberStyles.Float, CultureInfo.InvariantCulture), NpgsqlDbType.Numeric, cancellation); break;
                            default: throw new InvalidDataException("Unknown snapshot cell kind");
                        }
                    }
                }
                await writer.CompleteAsync(cancellation);
            }
            // Compare unordered multisets of complete typed rows, not counts alone.
            var expected = rows.Select(r => Canonical(r!.AsArray(), types.Select(t => t.Kind).ToArray())).Order(StringComparer.Ordinal).ToArray(); var actual = new List<string>();
            await using (var cmd = new NpgsqlCommand($"SELECT * FROM {target}", connection, transaction))
            await using (var reader = await cmd.ExecuteReaderAsync(cancellation))
            {
                while (await reader.ReadAsync(cancellation))
                {
                    var row = new JsonArray();
                    for (int i = 0; i < columns.Count; i++)
                    {
                        if (reader.IsDBNull(i)) { row.Add(new JsonObject { ["kind"] = "null" }); continue; }
                        string value = types[i].Kind switch
                        {
                            "integer" => reader.GetInt64(i).ToString(CultureInfo.InvariantCulture),
                            "real" => reader.GetDouble(i).ToString("R", CultureInfo.InvariantCulture),
                            "blob" => Convert.ToBase64String(reader.GetFieldValue<byte[]>(i)),
                            "numeric" => reader.GetDecimal(i).ToString(CultureInfo.InvariantCulture),
                            _ => reader.GetString(i)
                        };
                        row.Add(new JsonObject { ["kind"] = types[i].Kind, ["value"] = value });
                    }
                    actual.Add(Canonical(row, types.Select(t => t.Kind).ToArray()));
                }
            }
            actual.Sort(StringComparer.Ordinal);
            if (!expected.SequenceEqual(actual)) throw new InvalidDataException($"PostgreSQL row verification failed: {name}");
            rowCount += rows.Count; reports.Add(new { name, rows = rows.Count, allValuesEqual = true, numericColumns = columns.Where((c, i) => types[i].Kind == "numeric").Select(c => c!["name"]!.GetValue<string>()).ToArray() });
        }
        await transaction.CommitAsync(cancellation);
        return new { schema, snapshotSha256 = Convert.ToHexStringLower(SHA256.HashData(bytes)), tables = reports.Count, rows = rowCount, allValuesEqual = true, runtimeSchemaReady = false, report = reports };
    }
    private static (string Sql, string Kind) ColumnType(string declared) => declared.ToUpperInvariant() switch
    {
        "INTEGER" or "INT" => ("bigint", "integer"), "REAL" or "FLOAT" or "DOUBLE" => ("double precision", "real"),
        "TEXT" => ("text", "text"), "BLOB" => ("bytea", "blob"), _ => throw new InvalidDataException("Unmapped SQLite declared type: " + declared)
    };
    private static string Canonical(JsonArray row, string[] kinds) => JsonSerializer.Serialize(row.Select((cell, i) =>
    {
        string kind = cell!["kind"]!.GetValue<string>(), value = cell["value"]?.GetValue<string>() ?? "";
        if (kind == "real") value = double.Parse(value, CultureInfo.InvariantCulture).ToString("R", CultureInfo.InvariantCulture);
        if (kind != "null" && kinds[i] == "numeric") { kind = "numeric"; value = decimal.Parse(value, NumberStyles.Float, CultureInfo.InvariantCulture).ToString("G29", CultureInfo.InvariantCulture); }
        return new[] { kind, value };
    }).ToArray());
}
