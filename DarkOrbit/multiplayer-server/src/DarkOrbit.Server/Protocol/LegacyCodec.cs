using System.Buffers.Binary;
using System.Text;
using System.Text.Json.Nodes;

namespace DarkOrbit.Server.Protocol;

// Consume the same audited schema, including native bit rotations/inheritance.
// JsonNodes returned to callers never share ownership with the schema.
public sealed class LegacyCodec
{
    private readonly JsonObject classes;
    private readonly Dictionary<short, JsonObject> ids = [];
    public int ClassCount => classes.Count;
    public string SchemaSha256 { get; }
    public LegacyCodec()
    {
        using var stream = typeof(LegacyCodec).Assembly.GetManifestResourceStream("LegacySchema.json")!;
        using var memory = new MemoryStream(); stream.CopyTo(memory); var bytes = memory.ToArray();
        SchemaSha256 = Convert.ToHexStringLower(System.Security.Cryptography.SHA256.HashData(bytes));
        classes = JsonNode.Parse(bytes)!["classes"]!.AsObject();
        foreach (var (_, value) in classes)
        {
            var cls = value!.AsObject();
            if (cls["id"] is { } id) ids[unchecked((short)id.GetValue<int>())] = cls;
        }
    }

    public JsonObject? Decode(byte[] body)
    {
        var reader = new Input(body); var result = ReadModule(reader);
        if (reader.Offset != body.Length) throw new InvalidDataException("Trailing protocol bytes");
        return result;
    }
    public byte[] Encode(JsonObject? obj)
    {
        using var stream = new MemoryStream(); WriteModule(stream, obj, 0); return stream.ToArray();
    }
    private JsonObject Class(string name) => classes[name]?.AsObject() ?? throw new InvalidDataException("Unknown protocol class");
    private static double Number(JsonNode? node) => node is null ? 0 : double.Parse(node.ToJsonString(), System.Globalization.CultureInfo.InvariantCulture);
    private static long Integer(JsonNode? node) => (long)Number(node);
    private static long Transform(long value, JsonArray? transforms, bool inverse = false)
    {
        if (transforms is null) return value;
        var sequence = inverse ? transforms.Reverse() : transforms;
        foreach (var node in sequence)
        {
            var tx = node!;
            if (tx["rot"] is { } direction)
            {
                int width = tx["w"]!.GetValue<int>(), n = tx["n"]!.GetValue<int>() % width;
                ulong mask = (1UL << width) - 1, v = (ulong)value & mask;
                bool left = direction.GetValue<string>() == "l"; if (inverse) left = !left;
                ulong rotated = n == 0 ? v : left ? ((v << n) | (v >> (width - n))) & mask : ((v >> n) | (v << (width - n))) & mask;
                value = width == 32 ? unchecked((int)rotated) : (long)rotated;
            }
            else if (tx["sign"] is { } sign)
            {
                int width = sign.GetValue<int>(); long mask = (1L << width) - 1;
                value = inverse ? value & mask : value > (mask >> 1) ? value - mask - 1 : value;
            }
        }
        return value;
    }
    private JsonObject? ReadModule(Input reader)
    {
        if (++reader.Depth > 64) throw new InvalidDataException("Protocol nesting limit");
        try
        {
            short id = BinaryPrimitives.ReadInt16BigEndian(reader.Take(2)); if (id == 0) return null;
            if (!ids.TryGetValue(id, out var cls)) throw new InvalidDataException("Unknown protocol ID");
            var result = new JsonObject { ["_"] = cls["name"]!.GetValue<string>() };
            ReadFields(reader, cls, result); return result;
        }
        finally { reader.Depth--; }
    }
    private void ReadFields(Input reader, JsonObject cls, JsonObject output)
    {
        foreach (var f in cls["fields"]!.AsArray())
        {
            string type = f!["type"]!.GetValue<string>();
            if (type == "skipShort") { reader.Take(2); continue; }
            if (type == "super") { ReadFields(reader, Class(f["cls"]!.GetValue<string>()), output); continue; }
            string name = f["name"]!.GetValue<string>();
            if (type == "module") { output[name] = ReadModule(reader); continue; }
            if (type == "vector")
            {
                long size = Transform(Integer(ReadPrimitive(reader, f["lenType"]!.GetValue<string>())), f["lenTx"]?.AsArray());
                if (size < 0 || size > 65536 || size > reader.Remaining) throw new InvalidDataException("Invalid vector length");
                var array = new JsonArray(); var elem = f["elem"]!; string elementType = elem["type"]!.GetValue<string>();
                for (long i = 0; i < size; i++) array.Add(elementType == "module" ? ReadModule(reader) : ReadTransformed(reader, elementType, elem["tx"]?.AsArray()));
                output[name] = array; continue;
            }
            output[name] = ReadTransformed(reader, type, f["tx"]?.AsArray());
        }
    }
    private static JsonNode ReadTransformed(Input input, string type, JsonArray? tx)
    {
        var value = ReadPrimitive(input, type);
        return tx is { Count: > 0 } ? JsonValue.Create(unchecked((int)Transform(Integer(value), tx)))! : value;
    }
    private static JsonNode ReadPrimitive(Input input, string type) => type switch
    {
        "int" => JsonValue.Create(BinaryPrimitives.ReadInt32BigEndian(input.Take(4)))!,
        "short" => JsonValue.Create(BinaryPrimitives.ReadInt16BigEndian(input.Take(2)))!,
        "byte" => JsonValue.Create(unchecked((sbyte)input.Take(1)[0]))!,
        "bool" => JsonValue.Create(input.Take(1)[0] != 0)!,
        "double" => JsonValue.Create(BinaryPrimitives.ReadDoubleBigEndian(input.Take(8)))!,
        "float" => JsonValue.Create(BinaryPrimitives.ReadSingleBigEndian(input.Take(4)))!,
        "utf" => JsonValue.Create(ReadUtf(input))!,
        _ => throw new InvalidDataException("Unknown protocol primitive")
    };
    private static string ReadUtf(Input input)
    {
        int size = BinaryPrimitives.ReadUInt16BigEndian(input.Take(2));
        return Encoding.UTF8.GetString(input.Take(size));
    }
    private void WriteModule(Stream stream, JsonObject? obj, int depth)
    {
        if (depth > 64) throw new InvalidDataException("Protocol nesting limit");
        if (obj is null) { WritePrimitive(stream, "short", JsonValue.Create(0)); return; }
        var cls = Class(obj["_"]!.GetValue<string>());
        WritePrimitive(stream, "short", cls["id"]); WriteFields(stream, cls, obj, depth + 1);
    }
    private void WriteFields(Stream stream, JsonObject cls, JsonObject obj, int depth)
    {
        foreach (var f in cls["fields"]!.AsArray())
        {
            string type = f!["type"]!.GetValue<string>();
            if (type == "skipShort") { WritePrimitive(stream, "short", Class(cls["parent"]!.GetValue<string>())["id"]); continue; }
            if (type == "super") { WriteFields(stream, Class(f["cls"]!.GetValue<string>()), obj, depth); continue; }
            var value = obj[f["name"]!.GetValue<string>()];
            if (type == "module") { WriteModule(stream, value?.AsObject(), depth); continue; }
            if (type == "vector")
            {
                var array = value?.AsArray() ?? []; var elem = f["elem"]!; string elementType = elem["type"]!.GetValue<string>();
                if (array.Count > 65536) throw new InvalidDataException("Vector length limit");
                WritePrimitive(stream, f["lenType"]!.GetValue<string>(), JsonValue.Create(Transform(array.Count, f["lenTx"]?.AsArray(), true)));
                foreach (var item in array)
                    if (elementType == "module") WriteModule(stream, item?.AsObject(), depth);
                    else WriteTransformed(stream, elementType, item, elem["tx"]?.AsArray());
                continue;
            }
            WriteTransformed(stream, type, value, f["tx"]?.AsArray());
        }
    }
    private static void WriteTransformed(Stream stream, string type, JsonNode? value, JsonArray? tx) =>
        WritePrimitive(stream, type, type is "int" or "short" or "byte" ? JsonValue.Create(Transform(Integer(value), tx, true)) : value);
    private static void WritePrimitive(Stream stream, string type, JsonNode? value)
    {
        Span<byte> bytes = stackalloc byte[8];
        switch (type)
        {
            case "int": BinaryPrimitives.WriteInt32BigEndian(bytes, unchecked((int)Integer(value))); stream.Write(bytes[..4]); break;
            case "short": BinaryPrimitives.WriteUInt16BigEndian(bytes, unchecked((ushort)Integer(value))); stream.Write(bytes[..2]); break;
            case "byte": stream.WriteByte(unchecked((byte)Integer(value))); break;
            case "bool": stream.WriteByte(value?.GetValue<bool>() == true ? (byte)1 : (byte)0); break;
            case "double": BinaryPrimitives.WriteDoubleBigEndian(bytes, Number(value)); stream.Write(bytes); break;
            case "float": BinaryPrimitives.WriteSingleBigEndian(bytes, (float)Number(value)); stream.Write(bytes[..4]); break;
            case "utf":
                var utf = Encoding.UTF8.GetBytes(value?.GetValue<string>() ?? "");
                if (utf.Length > ushort.MaxValue) throw new InvalidDataException("Native string length limit");
                BinaryPrimitives.WriteUInt16BigEndian(bytes, (ushort)utf.Length); stream.Write(bytes[..2]); stream.Write(utf); break;
            default: throw new InvalidDataException("Unknown protocol primitive");
        }
    }
    private sealed class Input(byte[] data)
    {
        public int Offset, Depth;
        public int Remaining => data.Length - Offset;
        public ReadOnlySpan<byte> Take(int count)
        {
            if (count < 0 || count > Remaining) throw new EndOfStreamException("Truncated protocol field");
            var result = data.AsSpan(Offset, count); Offset += count; return result;
        }
    }
}
