using System.Collections.Concurrent;
using System.Net;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.Json.Nodes;
using DarkOrbit.Host;
using DarkOrbit.Server.Protocol;
using DarkOrbit.Server.Runtime;
using DarkOrbit.Server.Storage;
using DarkOrbit.Server.Transport;
using DarkOrbit.Server.World;
using Npgsql;
using NpgsqlTypes;

internal static class NativeVerification
{
    public static async Task Run()
    {
        int assertions = 0; void Check(bool ok, string message) { assertions++; if (!ok) throw new InvalidOperationException(message); }
        string pg = Environment.GetEnvironmentVariable("DARKORBIT_POSTGRES") ?? throw new InvalidOperationException("DARKORBIT_POSTGRES required");
        var settings = new NpgsqlConnectionStringBuilder(pg);
        if (settings.Database != "darkorbit_development" || settings.Host != "127.0.0.1" || settings.Port != 55432) throw new InvalidOperationException("Only isolated development database is permitted");
        var passwordCases = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/password-contract.json"))!["cases"]!.AsArray();
        foreach (var sample in passwordCases)
        {
            string password = sample!["password"]!.GetValue<string>(), stored = sample["stored"]!.GetValue<string>();
            Check(LegacyPasswords.Verify(password,stored),"Node/.NET scrypt password compatibility");
            Check(!LegacyPasswords.Verify(password+"x",stored),"Incorrect password rejected");
        }
        Check(!LegacyPasswords.Verify("pilot-qa-pass","bad"),"Malformed stored hash rejected");
        string schema = "mp_"+Convert.ToHexStringLower(RandomNumberGenerator.GetBytes(8));
        var archive = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/postgresql-rehearsal.json"))!;
        await using var source = NpgsqlDataSource.Create(pg);
        await NativeBootstrap.Create(source,archive["schema"]!.GetValue<string>(),schema,"artifacts/private/native-profiles.json",archive["snapshotSha256"]!.GetValue<string>());
        try
        {
        string q = '"'+schema+'"';
        var document = JsonNode.Parse(await File.ReadAllTextAsync("artifacts/private/native-profiles.json"))!;
        var originalHero = document["profiles"]![0]!["commands"]!.AsArray().First(c=>c!["_"]!.GetValue<string>()=="ShipInitializationCommand")!;
        var mapDefinitions = await new NativePlayerRepository(source,schema).Maps();
        int privateMap = mapDefinitions.Values.First(m=>m.Private).Id;
        string fixturePassword = passwordCases[0]!["password"]!.GetValue<string>(), hash = passwordCases[0]!["stored"]!.GetValue<string>();
        var jumpPortal = WorldContent.Default.Maps[4].Portals.Single(p => p.Target == 13);
        for (int index=1;index<=9;index++)
        {
            long id=900000+index; int mapId=index>=8?3:index==6?4:index==7?13:index==3?2:index>=4?privateMap:1;
            int x=index==6?jumpPortal.X:1000,y=index==6?jumpPortal.Y:1000;
            var hero = originalHero.DeepClone().AsObject(); hero["userId"]=id;hero["userName"]="Native QA "+index;hero["x"]=x;hero["y"]=y;hero["mapId"]=mapId;hero["speed"]=500;hero["cloaked"]=false;hero["level"]=18;hero["factionId"]=1;
            var profile=hero.DeepClone();
            if(index>=8)
            {
                profile["speed"]=50000;
                profile["stats"]=JsonNode.Parse("""{"laserCount":1,"laserDamage":200,"npcLaserMultiplier":1,"laserProfiles":[{"id":1,"lootId":"equipment_weapon_laser_lf-4","ship":true,"damage":200}],"skills":{"laserAccuracy":0.2}}""");
                if(index==9)profile["stats"]!["laserDamage"]=1000000; // Synthetic lethal-hit fixture, not a production balance change.
            }
            var commands=new JsonArray(hero,new JsonObject{["_"]="DroneFormationChangeCommand",["uid"]=id,["selectedFormationId"]=0});
            await using(var account=source.CreateCommand($"INSERT INTO {q}.accounts VALUES($1,$2,$3,0)"))
            { account.Parameters.AddWithValue(id);account.Parameters.AddWithValue("nativeqa"+index);account.Parameters.AddWithValue(hash);await account.ExecuteNonQueryAsync(); }
            await using var command=source.CreateCommand($"INSERT INTO {q}.players(id,account_id,server_id,map_id,x,y,profile,initial_commands) VALUES($1,$1,1,$2,$3,$4,$5,$6)");
            command.Parameters.AddWithValue(id);command.Parameters.AddWithValue(mapId);command.Parameters.AddWithValue(x);command.Parameters.AddWithValue(y);command.Parameters.AddWithValue(NpgsqlDbType.Jsonb,profile.ToJsonString());command.Parameters.AddWithValue(NpgsqlDbType.Jsonb,commands.ToJsonString());await command.ExecuteNonQueryAsync();
            if(index>=8)
            {
                await using var economy=source.CreateCommand($"INSERT INTO {q}.player_economy VALUES({id},100,1000,0,0,18); INSERT INTO {q}.player_combat(player_id) VALUES({id}); INSERT INTO {q}.inventory_items VALUES({id * 10},{id},'ammunition_laser_lcb-10',500,NULL,NULL,NULL,0),({id * 10+1},{id},'ammunition_laser_ucb-100',500,NULL,NULL,NULL,0),({id * 10+2},{id},'ammunition_laser_rsb-75',100,NULL,NULL,NULL,0)");await economy.ExecuteNonQueryAsync();
            }
        }
            await using var runtime=await NativeDevelopmentRuntime.Create(pg,Environment.GetEnvironmentVariable("DARKORBIT_REDIS")!,schema,new NativeGameOptions{Port=0,BindAddress="0.0.0.0",AdvertisedHost="10.42.0.1",AdvertisedPort=34567,HeartbeatInterval=TimeSpan.FromMilliseconds(250),AuthenticationTimeout=TimeSpan.FromSeconds(3)});
            runtime.Game.Start(); await using var app=NativeApplication.Build(runtime,0);await app.StartAsync();
            Check(runtime.Game.BindAddress.Equals(IPAddress.Any),"Native TCP supports non-loopback binding");
            try
            {
                var baseUri=new Uri(app.Urls.Single());
                HttpClient Client() => new(new HttpClientHandler{AllowAutoRedirect=false,UseCookies=true}){BaseAddress=baseUri};
                using var alice=Client();using var bob=Client();using var other=Client();using var gateA=Client();using var gateB=Client();
                var page=await alice.GetStringAsync("/login");Check(page.Contains("bgcdw_login_form_username")&&page.Contains("Hangarına dön."),"Original launcher selectors and redesigned login served");
                foreach(string asset in new[]{"/mini-jquery.js","/client/do_img/global/bg_standard_mmo.jpg","/client/_host/do_img/global/companyChoose/gamelogo.png"})Check((await alice.GetAsync(asset)).StatusCode==HttpStatusCode.OK,"Login asset available");
                Check((await alice.GetAsync("/api/game-session")).StatusCode==HttpStatusCode.Unauthorized,"Unauthenticated HTTP denied");
                Check((await alice.PostAsync("/login",new FormUrlEncodedContent(new Dictionary<string,string>{{"username","nativeqa1"},{"password","wrong"}}))).Headers.Location!.ToString()=="/login?error=password","Wrong HTTP password denied");
                async Task<JsonObject> Login(HttpClient client,int index)
                {
                    var response=await client.PostAsync("/login",new FormUrlEncodedContent(new Dictionary<string,string>{{"username","nativeqa"+index},{"password",fixturePassword}}));
                    Check(response.StatusCode==HttpStatusCode.Found,"Compatible form login redirect");Check(response.Headers.GetValues("Set-Cookie").Single().Contains("httponly",StringComparison.OrdinalIgnoreCase),"HttpOnly login cookie");
                    return JsonNode.Parse(await client.GetStringAsync("/api/game-session"))!.AsObject();
                }
                var a=await Login(alice,1);var b=await Login(bob,2);var c=await Login(other,3);var g1=await Login(gateA,4);var g2=await Login(gateB,5);
                Check(a["gameHost"]!.GetValue<string>()=="10.42.0.1"&&a["gamePort"]!.GetValue<int>()==34567,"Advertised overlay/proxy endpoint differs from listen address");
                await using var pa=new Probe();await pa.Connect(runtime.Game.Port,a);Check((await pa.Wait(c=>c["_"]!.GetValue<string>()=="ShipInitializationCommand"))["userId"]!.GetValue<int>()==900001,"Own pilot loaded from PostgreSQL");
                await using var pb=new Probe();await pb.Connect(runtime.Game.Port,b);await pb.Wait(c=>c["_"]!.GetValue<string>()=="ShipInitializationCommand");
                await pa.Wait(Is("ShipCreateCommand",900002));await pb.Wait(Is("ShipCreateCommand",900001));Check(runtime.Hub.OnlineCount==2,"Second login retains first");
                var shared = (await runtime.Hub.Snapshot(new MapKey(1,1,Guid.Empty)))!;
                Check(shared.Npcs.Length==20,"One shared 1-1 population, not twenty NPCs per pilot");
                await pb.Wait(Is("ShipCreateCommand",shared.Npcs[0].Id));
                Check(pa.Commands.Where(x=>x["_"]!.GetValue<string>()=="ShipCreateCommand"&&x["npc"]!.GetValue<bool>()).Select(x=>x["userId"]!.GetValue<int>()).Order().SequenceEqual(pb.Commands.Where(x=>x["_"]!.GetValue<string>()=="ShipCreateCommand"&&x["npc"]!.GetValue<bool>()).Select(x=>x["userId"]!.GetValue<int>()).Order()),"Both TCP clients receive the same NPC identities");
                await pa.Send(new JsonObject{["_"]="ShipSelectRequest",["targetId"]=shared.Npcs[0].Id});
                var selection=await pa.Wait(Is("ShipSelectionCommand",shared.Npcs[0].Id));Check(selection["hitpoints"]!.GetValue<double>()==shared.Npcs[0].Hp,"Selection reads authoritative shared NPC health");
                Check(pa.Commands.Where(Is("ShipCreateCommand",900002)).Last()["npc"]!.GetValue<bool>()==false,"Other pilot is not an NPC");
                await using var pc=new Probe();await pc.Connect(runtime.Game.Port,c);await pc.Wait(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand");
                await using var pg1=new Probe();await pg1.Connect(runtime.Game.Port,g1);await pg1.Wait(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand");
                await using var pg2=new Probe();await pg2.Connect(runtime.Game.Port,g2);await pg2.Wait(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand");
                Check(!pc.Commands.Any(x=>x["_"]!.GetValue<string>()=="ShipCreateCommand"&&!x["npc"]!.GetValue<bool>()),"Different map receives no other-map pilots");
                Check(!pg1.Commands.Any(Is("ShipCreateCommand",900005))&&!pg2.Commands.Any(Is("ShipCreateCommand",900004)),"Native private gate sessions isolated");
                int mark=pb.Commands.Length;
                await pa.Send(new JsonObject{["_"]="MoveRequest",["positionX"]=999999,["positionY"]=999999,["targetX"]=3000,["targetY"]=1000});
                var move=await pb.Wait(Is("MoveCommand",900001),mark);
                Check(move["x"]!.GetValue<int>()==3000&&move["timeToTarget"]!.GetValue<int>() is >3900 and <=4000,"Movement duration uses authoritative position/speed");
                Check(!pc.Commands.Any(Is("MoveCommand",900001)),"Movement stays inside map");
                // Joining while someone moves receives their remaining route.
                await using var replacement=new Probe();await replacement.Connect(runtime.Game.Port,a);await replacement.Wait(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand");await pa.Closed.WaitAsync(TimeSpan.FromSeconds(4));
                Check(runtime.Hub.OnlineCount==5,"Reconnect only replaces its own pilot");
                var snapshot=(await runtime.Hub.Snapshot(new MapKey(1,1,Guid.Empty)))!;Check(snapshot.Pilots.Length==2,"Old socket cleanup retains replacement and other pilot");
                Check(snapshot.Pilots.Single(p=>p.Lease.PlayerId==900001).X<3000,"Reconnect preserves current position rather than spoofed origin");
                var oldFence=await runtime.Tickets.Acquire(900099,1,TimeSpan.FromSeconds(30));var newerFence=await runtime.Tickets.Acquire(900099,1,TimeSpan.FromSeconds(30));Check(newerFence.Fence>oldFence.Fence&&!await runtime.Tickets.Release(900099,1,oldFence),"Fenced stale ownership rejected");await runtime.Tickets.Release(900099,1,newerFence);
                await using(var forged=new Probe()){var wrong=a.DeepClone().AsObject();wrong["userID"]=900002;await forged.Connect(runtime.Game.Port,wrong,false);await forged.Closed.WaitAsync(TimeSpan.FromSeconds(4));Check(!forged.Commands.Any(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand"),"Forged user ID cannot load another account");}
                await using(var invalid=new Probe()){var wrong=a.DeepClone().AsObject();wrong["instanceId"]=2;await invalid.Connect(runtime.Game.Port,wrong,false);await invalid.Closed.WaitAsync(TimeSpan.FromSeconds(4));Check(!invalid.Commands.Any(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand"),"Wrong server instance rejected");}
                int logoutMark=replacement.Commands.Length;await bob.GetAsync("/logout");await pb.Closed.WaitAsync(TimeSpan.FromSeconds(4));await replacement.Wait(Is("ShipRemoveCommand",900002),logoutMark);Check((await bob.GetAsync("/api/game-session")).StatusCode==HttpStatusCode.Unauthorized,"Logout revokes web and active TCP");
                await runtime.Tickets.Revoke(a["sessionID"]!.GetValue<string>());await replacement.Send(new JsonObject{["_"]="KeepAlive",["MouseClick"]=false});await replacement.Closed.WaitAsync(TimeSpan.FromSeconds(4));
                var persisted=await runtime.Players.Load(900001);Check(persisted!.X is >=1000 and <3000,"Position saved to fenced development row");
                using var traveler=Client();using var destination=Client();
                var travelTicket=await Login(traveler,6);var destinationTicket=await Login(destination,7);
                await using var pt=new Probe();await pt.Connect(runtime.Game.Port,travelTicket);
                await using var pd=new Probe();await pd.Connect(runtime.Game.Port,destinationTicket);
                int travelMark=pt.Commands.Length;
                await pt.Send(new JsonObject{["_"]="JumpRequest"});
                await pt.Wait(x=>x["_"]!.GetValue<string>()=="JumpInitiatedCommand"&&x["mapId"]!.GetValue<int>()==13,travelMark);
                await pt.Send(new JsonObject{["_"]="MoveRequest",["positionX"]=0,["positionY"]=0,["targetX"]=0,["targetY"]=0});
                await pt.Send(new JsonObject{["_"]="JumpRequest"});
                var arrival=await pt.Wait(x=>x["_"]!.GetValue<string>()=="ShipInitializationCommand"&&x["mapId"]!.GetValue<int>()==13,travelMark);
                await pd.Wait(Is("ShipCreateCommand",900006));
                Check(arrival["x"]!.GetValue<int>()==jumpPortal.TargetX&&arrival["y"]!.GetValue<int>()==jumpPortal.TargetY,"1-4 to 4-1 jump ignores movement/duplicate requests during transition and uses the original arrival");
                Check(!(await runtime.Hub.Snapshot(new MapKey(1,4,Guid.Empty)))!.Pilots.Any(p=>p.Lease.PlayerId==900006)&&(await runtime.Hub.Snapshot(new MapKey(1,13,Guid.Empty)))!.Pilots.Any(p=>p.Lease.PlayerId==900006),"Portal retires origin and joins the destination shared world");
                Check((await runtime.Players.Load(900006))!.MapId==13,"Portal position is persisted under the current PostgreSQL connection fence");
                Check(pt.Commands.Skip(travelMark).Count(x=>x["_"]!.GetValue<string>()=="JumpInitiatedCommand")==1,"Repeated jump requests produce one transition");
                await pd.Send(new JsonObject{["_"]="MapAssetActivationRequest",["mapAssetId"]=jumpPortal.Id});
                await pd.Send(new JsonObject{["_"]="VersionRequest",["version"]="after-invalid-gate"});await pd.Wait(x=>x["_"]!.GetValue<string>()=="VersionCommand"&&x["version"]!.GetValue<string>()=="after-invalid-gate");
                Check(!(await runtime.Hub.Snapshot(new MapKey(1,13,Guid.Empty)))!.Pilots.Single(p=>p.Lease.PlayerId==900007).Jumping,"A distant or wrong-map portal cannot be activated");
                int pendingMark=pt.Commands.Length;await pt.Send(new JsonObject{["_"]="JumpRequest"});await pt.Wait(x=>x["_"]!.GetValue<string>()=="JumpInitiatedCommand",pendingMark);
                int departureMark=pd.Commands.Length;await traveler.GetAsync("/logout");await pt.Closed.WaitAsync(TimeSpan.FromSeconds(4));await pd.Wait(Is("ShipRemoveCommand",900006),departureMark);
                await Task.Delay(2200);Check((await runtime.Players.Load(900006))!.MapId==13,"Logout cancels a pending return jump without changing the saved map");
                Check((await alice.GetAsync("/ready")).StatusCode==HttpStatusCode.ServiceUnavailable,"Partial gameplay never advertised ready");
                using(var policy=new TcpClient()){await policy.ConnectAsync(IPAddress.Loopback,runtime.Game.Port);var stream=policy.GetStream();await stream.WriteAsync("<policy-"u8.ToArray());await stream.WriteAsync("file-request/>\0"u8.ToArray());byte[] bytes=new byte[512];int length=await stream.ReadAsync(bytes).AsTask().WaitAsync(TimeSpan.FromSeconds(3));Check(System.Text.Encoding.UTF8.GetString(bytes,0,length).Contains("cross-domain-policy"),"Fragmented Flash policy handled");}
                int beforeUnauthorized=runtime.Hub.OnlineCount;
                await using(var unauthorized=new Probe()){await unauthorized.Open(runtime.Game.Port);await unauthorized.Send(new JsonObject{["_"]="MoveRequest",["targetX"]=1,["targetY"]=1});await unauthorized.Closed.WaitAsync(TimeSpan.FromSeconds(4));Check(runtime.Hub.OnlineCount==beforeUnauthorized,"Pre-login action cannot create a pilot");}
                using var fighter=Client();using var finisher=Client();var f1=await Login(fighter,8);var f2=await Login(finisher,9);
                await using var pf=new Probe();await pf.Connect(runtime.Game.Port,f1);await using var pk=new Probe();await pk.Connect(runtime.Game.Port,f2);
                var combatMap=new MapKey(1,3,Guid.Empty);var contentMap=WorldContent.Default.Maps[3];
                var target=(await runtime.Hub.Snapshot(combatMap))!.Npcs.First(n=>n.Key=="devolarium"&&!contentMap.Peace(n.X+200,n.Y,1));
                async Task Approach(Probe probe,long player)
                {
                    var current=(await runtime.Hub.Snapshot(combatMap))!.Npcs.Single(n=>n.Id==target.Id);
                    await probe.Send(new JsonObject{["_"]="MoveRequest",["positionX"]=999999,["positionY"]=999999,["targetX"]=(int)current.X+200,["targetY"]=(int)current.Y});
                    using var timeout=new CancellationTokenSource(TimeSpan.FromSeconds(5));
                    while(true){var state=(await runtime.Hub.Snapshot(combatMap))!;var p=state.Pilots.Single(p=>p.Lease.PlayerId==player);var n=state.Npcs.Single(n=>n.Id==target.Id);if(double.Hypot(p.X-n.X,p.Y-n.Y)<500)break;await Task.Delay(25,timeout.Token);}
                }
                await Approach(pf,900008);await Approach(pk,900009);
                int combatMark=pf.Commands.Length,peerMark=pk.Commands.Length;
                await pf.Send(new JsonObject{["_"]="ShipSelectRequest",["targetId"]=target.Id});await pf.Wait(Is("ShipSelectionCommand",target.Id),combatMark);
                await pf.Send(new JsonObject{["_"]="MenuActionRequest",["menuItemId"]="ammunition_laser_ucb-100",["actionType"]=0});
                await pf.Send(new JsonObject{["_"]="AttackLaserRequest",["targetId"]=target.Id});
                await pf.Wait(x=>x["_"]!.GetValue<string>()=="AttackHitCommand"&&x["attackerId"]!.GetValue<int>()==900008,combatMark);
                await pk.Wait(x=>x["_"]!.GetValue<string>()=="AttackHitCommand"&&x["attackerId"]!.GetValue<int>()==900008,peerMark);
                Check((await runtime.Players.Ammo(900008))["ammunition_laser_ucb-100"]==499,"Native fire consumes PG ammunition and both TCP clients see the same hit");
                int rsbMark=pf.Commands.Length;
                await pf.Send(new JsonObject{["_"]="MenuActionRequest",["menuItemId"]="ammunition_laser_rsb-75",["actionType"]=1});
                await pf.Wait(x=>x["_"]!.GetValue<string>()=="AttackLaserRunCommand"&&x["attackerId"]!.GetValue<int>()==900008&&x["laserColor"]!.GetValue<int>()==6,rsbMark);
                await pf.Wait(x=>x["_"]!.GetValue<string>()=="AttackLaserRunCommand"&&x["attackerId"]!.GetValue<int>()==900008&&x["laserColor"]!.GetValue<int>()==3,rsbMark);
                await pf.Send(new JsonObject{["_"]="AttackAbortLaserRequest"});await pf.Send(new JsonObject{["_"]="VersionRequest",["version"]="after-fire-stop"});await pf.Wait(x=>x["_"]!.GetValue<string>()=="VersionCommand"&&x["version"]!.GetValue<string>()=="after-fire-stop");
                var ammunition=await runtime.Players.Ammo(900008);Check(ammunition["ammunition_laser_rsb-75"]==99&&ammunition["ammunition_laser_ucb-100"]==498,"RSB fires one salvo and automatically resumes the previous x4 selection");
                int killMark=pk.Commands.Length,observerMark=pf.Commands.Length;
                await pk.Send(new JsonObject{["_"]="AttackLaserRequest",["targetId"]=target.Id});await pk.Wait(x=>x["_"]!.GetValue<string>()=="ShipDestroyedCommand"&&x["destroyedUserId"]!.GetValue<int>()==target.Id,killMark);await pf.Wait(x=>x["_"]!.GetValue<string>()=="ShipDestroyedCommand"&&x["destroyedUserId"]!.GetValue<int>()==target.Id,observerMark);
                await pk.Wait(x=>x["_"]!.GetValue<string>()=="LegacyModule"&&x["message"]!.GetValue<string>().StartsWith("0|LM|ST|URI|"),killMark);
                var rewarded=await runtime.Players.Load(900009);Check(rewarded!.Profile["uridium"]!.GetValue<decimal>()==1016&&rewarded.Profile["credits"]!.GetValue<decimal>()==51300,"Native kill announces the committed original Devolarium reward");
                Check(!(await runtime.Hub.Snapshot(combatMap))!.Npcs.Any(n=>n.Id==target.Id),"Killed shared NPC disappears for all pilots");
            }
            finally { await app.StopAsync(); }
            Console.WriteLine(JsonSerializer.Serialize(new{status="PASS",nativeAssertions=assertions,realNativeClients=9,webLogin=true,postgresPlayerLoad=true,mapVisibility=true,movement=true,reconnect=true,logout=true,privateGates=true,sharedNpcs=true,normalPortalTransfer=true,classicNativeCombat=true,rsbReturn=true,atomicNativeReward=true,sourceAccountsUntouched=true,fullGameplayReady=false}));
        }
        finally
        {
            // Only the fresh random test schema is removed, never source/archive.
            await using var command=source.CreateCommand($"DROP SCHEMA \"{schema}\" CASCADE");await command.ExecuteNonQueryAsync();
        }
    }
    private static Func<JsonObject,bool> Is(string name,int id)=>c=>c["_"]!.GetValue<string>()==name&&c["userId"]?.GetValue<int>()==id;
    private sealed class Probe : IAsyncDisposable
    {
        private readonly TcpClient client=new();private readonly LegacyCodec codec=new();private readonly ConcurrentQueue<JsonObject> commands=new();private readonly SemaphoreSlim changed=new(0);private bool first=true;private Task? reading;
        private readonly TaskCompletionSource closed=new(TaskCreationOptions.RunContinuationsAsynchronously);public Task Closed=>closed.Task;public JsonObject[] Commands=>commands.ToArray();
        public async Task Open(int port)
        {
            await client.ConnectAsync(IPAddress.Loopback,port);
            reading=Task.Run(async()=>{var parser=new NativeFrames(false);byte[] buffer=new byte[32768];try{while(true){int count=await client.GetStream().ReadAsync(buffer);if(count==0)break;foreach(var body in parser.Push(buffer.AsSpan(0,count))){commands.Enqueue(codec.Decode(body)!);changed.Release();}}}catch(Exception e)when(e is IOException or SocketException or ObjectDisposedException){}finally{closed.TrySetResult();changed.Release();}});
        }
        public async Task Connect(int port,JsonObject session,bool wait=true)
        {
            await Open(port);await Send(new JsonObject{["_"]="VersionRequest",["version"]="native-stage2"});await Wait(c=>c["_"]!.GetValue<string>()=="VersionCommand");
            await Send(new JsonObject{["_"]="LoginRequest",["userID"]=session["userID"]!.DeepClone(),["sessionID"]=session["sessionID"]!.DeepClone(),["instanceId"]=session["instanceId"]!.DeepClone(),["factionID"]=999,["version"]="do-lz4-block-v3",["isMiniClient"]=true});
            if(wait)await Wait(c=>c["_"]!.GetValue<string>()=="ShipInitializationCommand");
        }
        public async Task Send(JsonObject command){var bytes=NativeFrames.Frame(codec.Encode(command),first);first=false;await client.GetStream().WriteAsync(bytes.AsMemory(0,2));await client.GetStream().WriteAsync(bytes.AsMemory(2));}
        public async Task<JsonObject> Wait(Func<JsonObject,bool> predicate,int mark=0)
        {
            using var timeout=new CancellationTokenSource(TimeSpan.FromSeconds(5));
            while(true){var match=Commands.Skip(mark).FirstOrDefault(predicate);if(match is not null)return match;if(Closed.IsCompleted)throw new EndOfStreamException("Native connection closed before expected command");await changed.WaitAsync(timeout.Token);}
        }
        public async ValueTask DisposeAsync(){client.Dispose();if(reading is not null)await reading;changed.Dispose();}
    }
}
