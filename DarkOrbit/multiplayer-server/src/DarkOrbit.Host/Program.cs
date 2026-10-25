using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Transport;
using DarkOrbit.Host;

string? nativeSchema = Environment.GetEnvironmentVariable("DARKORBIT_NATIVE_SCHEMA");
if (!string.IsNullOrEmpty(nativeSchema))
{
    string gameHost = Environment.GetEnvironmentVariable("DARKORBIT_GAME_HOST") ?? throw new InvalidOperationException("DARKORBIT_GAME_HOST must be the Localer/proxy address reachable by clients.");
    string gameBind = Environment.GetEnvironmentVariable("DARKORBIT_GAME_BIND") ?? "0.0.0.0";
    string webBind = Environment.GetEnvironmentVariable("DARKORBIT_WEB_BIND") ?? "0.0.0.0";
    if ((gameBind != "127.0.0.1" || webBind != "127.0.0.1") && (gameHost is "localhost" or "127.0.0.1" or "0.0.0.0")) throw new InvalidOperationException("External binding requires a reachable Localer/proxy host, not localhost or 0.0.0.0.");
    await using var runtime = await NativeDevelopmentRuntime.Create(
        Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES") ?? throw new InvalidOperationException("DARKORBIT_POSTGRES required"),
        Environment.GetEnvironmentVariable("DARKORBIT_REDIS") ?? throw new InvalidOperationException("DARKORBIT_REDIS required"),
        nativeSchema,new NativeGameOptions {
            BindAddress=gameBind,
            AdvertisedHost=gameHost,
            AdvertisedPort=int.TryParse(Environment.GetEnvironmentVariable("DARKORBIT_GAME_PUBLIC_PORT"),out var publicPort)?publicPort:null });
    runtime.Game.Start(); await using var native = NativeApplication.Build(runtime,18095,webBind); await native.RunAsync(); return;
}

bool verify = args.Contains("--verify");
var builder = WebApplication.CreateBuilder(args.Where(a => a != "--verify").ToArray());
// Separate loopback-only control host until gameplay parity gates are passed.
builder.WebHost.UseUrls(verify ? "http://127.0.0.1:0" : "http://127.0.0.1:18095");
var app = builder.Build(); var codec = new LegacyCodec();
app.MapGet("/health", () => Results.Ok(new { service = "darkorbit-multiplayer", status = "ok", stage = "foundation", protocolClasses = codec.ClassCount }));
app.MapGet("/ready", () => Results.Json(new { ready = false, reason = "Gameplay and authenticated client cutover pending; use the existing game server." }, statusCode: 503));
if (!verify) app.Run();
else
{
    await app.StartAsync();
    try
    {
        using var http = new HttpClient { BaseAddress = new Uri(app.Urls.Single()) };
        var health = await http.GetAsync("/health"); var ready = await http.GetAsync("/ready");
        if (!health.IsSuccessStatusCode || ready.StatusCode != System.Net.HttpStatusCode.ServiceUnavailable) throw new InvalidOperationException("Foundation host readiness contract failed");
        Console.WriteLine("PASS isolated .NET HTTP host: health 200, gameplay readiness 503, production ports untouched");
    }
    finally { await app.StopAsync(); await app.DisposeAsync(); }
}
