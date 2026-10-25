using System.Text.RegularExpressions;
using DarkOrbit.Server.Storage;

namespace DarkOrbit.Host;

public static partial class NativeApplication
{
    [GeneratedRegex("^[\\p{L}\\p{N}_ .\\-]{3,20}$")]
    private static partial Regex UsernamePattern();
    public static WebApplication Build(NativeDevelopmentRuntime runtime, int httpPort = 18095, string httpBind = "127.0.0.1")
    {
        var builder = WebApplication.CreateBuilder(new WebApplicationOptions { Args = [], ApplicationName = typeof(NativeApplication).Assembly.FullName });
        builder.WebHost.UseUrls($"http://{httpBind}:{httpPort}");
        builder.WebHost.ConfigureKestrel(o => o.Limits.MaxRequestBodySize = 256 * 1024);
        var app = builder.Build();
        foreach (var asset in new[] { (Url:"/mini-jquery.js", Resource:"MiniJquery.js",Mime:"application/javascript"), (Url:"/client/do_img/global/bg_standard_mmo.jpg",Resource:"LoginBackground.jpg",Mime:"image/jpeg"), (Url:"/client/_host/do_img/global/companyChoose/gamelogo.png",Resource:"LoginLogo.png",Mime:"image/png") })
            app.MapGet(asset.Url, () => Results.Stream(typeof(NativeApplication).Assembly.GetManifestResourceStream(asset.Resource)!,asset.Mime));
        app.MapGet("/health", () => Results.Json(new { service = "darkorbit-multiplayer", status = runtime.Hub.WorldHealthy ? "ok" : "failed", stage = "durable-world-classic-laser-development", gamePort = runtime.Game.Port, online = runtime.Hub.OnlineCount }, statusCode: runtime.Hub.WorldHealthy ? 200 : 503));
        app.MapGet("/ready", () => Results.Json(new { ready = false, reason = "Durable normal worlds and outgoing classic lasers/RSB are verified in development. NPC retaliation, modern mechanics, live stat/equipment rebuilding, cargo and full portal remain incomplete." }, statusCode: 503));
        app.MapGet("/login", async context =>
        {
            context.Response.ContentType = "text/html; charset=utf-8";
            using var stream = typeof(NativeApplication).Assembly.GetManifestResourceStream("NativeLogin.html")!;
            await stream.CopyToAsync(context.Response.Body, context.RequestAborted);
        });
        app.MapPost("/login", async context =>
        {
            context.Response.Headers.CacheControl = "no-store";
            if (!context.Request.HasFormContentType) { context.Response.StatusCode = 400; return; }
            var form = await context.Request.ReadFormAsync(context.RequestAborted); string name = form["username"].ToString().Trim(), password = form["password"].ToString();
            if (!UsernamePattern().IsMatch(name) || password.Length is < 4 or > 256) { context.Response.Redirect("/login?error=invalid"); return; }
            if (!await runtime.PasswordSlots.WaitAsync(0, context.RequestAborted)) { context.Response.StatusCode = 429; return; }
            AccountLogin? account;
            try
            {
                account = await runtime.Players.FindAccount(name, context.RequestAborted);
                string stored = account?.PasswordHash ?? new string('0',32)+":"+new string('0',64);
                bool valid = await Task.Run(() => LegacyPasswords.Verify(password,stored), context.RequestAborted);
                if (!valid || account is null) { context.Response.Redirect("/login?error=password"); return; }
            }
            finally { runtime.PasswordSlots.Release(); }
            string sid = await runtime.Tickets.Issue(new(account.AccountId,account.PlayerId,runtime.Options.ServerId));
            if (context.Request.Cookies.TryGetValue("dosid",out var old)) { await runtime.Tickets.Revoke(old); runtime.Hub.RevokeConnections(old); }
            context.Response.Cookies.Append("dosid",sid,new CookieOptions { HttpOnly = true, SameSite = SameSiteMode.Lax, Path = "/", Secure = context.Request.IsHttps });
            context.Response.Redirect("/indexInternal.es?action=internalStart");
        });
        app.MapGet("/api/game-session", async context =>
        {
            context.Response.Headers.CacheControl = "no-store";
            var ticket = await runtime.Tickets.Read(context.Request.Cookies["dosid"] ?? "");
            if (ticket is null || ticket.ServerId != runtime.Options.ServerId) { context.Response.StatusCode = 401; return; }
            var pilot = await runtime.Players.Load(ticket.PlayerId,context.RequestAborted);
            if (pilot is null || pilot.AccountId != ticket.AccountId) { context.Response.StatusCode = 401; return; }
            await context.Response.WriteAsJsonAsync(new { userID = pilot.PlayerId, sessionID = context.Request.Cookies["dosid"], instanceId = runtime.Options.ServerId, mapID = pilot.MapId, gameHost = runtime.Options.AdvertisedHost, gamePort = runtime.Options.AdvertisedPort ?? runtime.Game.Port },context.RequestAborted);
        });
        app.MapGet("/logout", async context =>
        {
            string sid = context.Request.Cookies["dosid"] ?? ""; await runtime.Tickets.Revoke(sid); runtime.Hub.RevokeConnections(sid);
            context.Response.Cookies.Delete("dosid",new CookieOptions { Path = "/" }); context.Response.Redirect("/login");
        });
        // Do not send users into a partial portal or claim their purchase worked.
        app.MapGet("/indexInternal.es", () => Results.Text("Çok oyunculu geliştirme ortamı: portalın taşınması sürüyor. Mevcut oyuna kendi giriş ekranından devam edebilirsin.",statusCode:501));
        return app;
    }
}
