using System.Buffers.Binary;

namespace DarkOrbit.Server.Protocol;

// Identical wire contract to local-server/game/protocol.js. No SWF changes.
public sealed class NativeFrames(bool clientInput = true)
{
    public const int MaxFrame = 1024 * 1024;
    public const int MaxPending = 2 * MaxFrame;
    private byte[] pending = [];
    private bool first = clientInput;

    public IReadOnlyList<byte[]> Push(ReadOnlySpan<byte> bytes)
    {
        if (pending.Length + bytes.Length > MaxPending) throw new InvalidDataException("Pending frame limit");
        var data = new byte[pending.Length + bytes.Length];
        pending.CopyTo(data, 0); bytes.CopyTo(data.AsSpan(pending.Length));
        List<byte[]> result = []; int offset = 0;
        while (true)
        {
            int prefix = first ? 4 : 3;
            if (data.Length - offset < prefix) break;
            var source = data.AsSpan(offset);
            uint size = prefix == 4 ? BinaryPrimitives.ReadUInt32BigEndian(source) :
                (uint)((source[0] << 16) | (source[1] << 8) | source[2]);
            if (size < 2 || size > MaxFrame) throw new InvalidDataException("Invalid native frame length");
            if (source.Length - prefix < size) break;
            result.Add(source.Slice(prefix, (int)size).ToArray());
            offset += prefix + (int)size; first = false;
        }
        pending = data.AsSpan(offset).ToArray(); return result;
    }

    public void Complete()
    {
        if (pending.Length != 0) throw new EndOfStreamException("Truncated native frame");
    }

    public static byte[] Frame(ReadOnlySpan<byte> body, bool firstClientFrame = false)
    {
        if (body.Length < 2 || body.Length > MaxFrame) throw new InvalidDataException("Invalid native body length");
        int prefix = firstClientFrame ? 4 : 3; var output = new byte[prefix + body.Length];
        if (firstClientFrame) BinaryPrimitives.WriteUInt32BigEndian(output, (uint)body.Length);
        else { output[0] = (byte)(body.Length >> 16); output[1] = (byte)(body.Length >> 8); output[2] = (byte)body.Length; }
        body.CopyTo(output.AsSpan(prefix)); return output;
    }
}
