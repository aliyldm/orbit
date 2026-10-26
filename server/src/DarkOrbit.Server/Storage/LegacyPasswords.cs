using System.Security.Cryptography;
using System.Text;
using Org.BouncyCastle.Crypto.Generators;

namespace DarkOrbit.Server.Storage;

public static class LegacyPasswords
{
    // Node crypto.scryptSync(password, salt-as-UTF8-string, 32) defaults.
    public static bool Verify(string password, string stored)
    {
        if (password.Length is < 4 or > 256) return false;
        string[] parts = stored.Split(':');
        if (parts.Length != 2 || parts[0].Length != 32 || parts[1].Length != 64 || !parts.All(p => p.All(char.IsAsciiHexDigit))) return false;
        byte[] input = Encoding.UTF8.GetBytes(password), salt = Encoding.UTF8.GetBytes(parts[0]);
        byte[] derived = SCrypt.Generate(input, salt, 16384, 8, 1, 32);
        try { return CryptographicOperations.FixedTimeEquals(derived, Convert.FromHexString(parts[1])); }
        finally { CryptographicOperations.ZeroMemory(input); CryptographicOperations.ZeroMemory(derived); }
    }
}
