$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$target = Join-Path $root 'dist/Orbit-Local-Preview-Windows.zip'
$testRoot = [IO.Path]::GetFullPath((Join-Path $root 'dist/smoke'))
$archive = [IO.Compression.ZipFile]::OpenRead($target)
try {
    $names = @{}
    foreach ($entry in $archive.Entries) {
        $name=$entry.FullName
        if ($name -match '^Orbit/DarkOrbit/(local-server/(data|backups|logs|certs)|multiplayer-server/(\.local|artifacts))/' -or $name -match '\.(db(-[a-z]+)?|pem|key|pfx|har|saz)$') { throw "Private file in archive: $name" }
        $names[$name]=$true
        if ($name -match '^Orbit/DarkOrbit/local-server/(game/|web/|docs/|tools/|client/.*\.xml$|config\.json$|server\.js$|package\.json$)' -or $name -eq 'Orbit/runtime/node.exe' -or $name -in @('Orbit/DarkOrbit/local-server/client/do_img/global/bg_standard_mmo.jpg','Orbit/DarkOrbit/local-server/client/_host/do_img/global/companyChoose/gamelogo.png')) {
            $destination=[IO.Path]::GetFullPath((Join-Path $testRoot $name))
            if (-not $destination.StartsWith($testRoot+[IO.Path]::DirectorySeparatorChar)) { throw 'Invalid archive path' }
            [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($destination)) | Out-Null
            [IO.Compression.ZipFileExtensions]::ExtractToFile($entry,$destination,$true)
        }
    }
    foreach ($required in @('Orbit/Orbit Baslat.cmd','Orbit/Orbit Sunucuyu Kapat.cmd','Orbit/runtime/LICENSE','Orbit/DarkOrbit/DarkOrbit.exe','Orbit/DarkOrbit/HCSFP32.dll','Orbit/DarkOrbit/Qt5WebEngineCore.dll','Orbit/DarkOrbit/platforms/qwindows.dll','Orbit/DarkOrbit/local-server/client/spacemap/main.swf','Orbit/DarkOrbit/local-server/client/spacemap/preloader.swf')) { if(-not $names.ContainsKey($required)){throw "Missing runtime file: $required"} }
    Write-Output "PASS archive inventory: $($archive.Entries.Count) entries; runtime present; no user database/credentials"
} finally { $archive.Dispose() }
@'
'use strict';
const fs=require('fs'),path=require('path'),assert=require('assert/strict');
const folder=path.join(__dirname,'Orbit/DarkOrbit/local-server');
(async()=>{const config=JSON.parse(fs.readFileSync(path.join(folder,'config.json')));config.http={host:'127.0.0.1',port:0};config.game={...config.game,host:'127.0.0.1',port:0,packetLog:false};config.policy.enabled=false;config.cdnCache.enabled=false;config.hostCache.enabled=false;delete config.https;
const runtime=await require(path.join(folder,'server')).start(config,{dbFile:':memory:',logDir:path.join(__dirname,'logs')});
try{const db=require(path.join(folder,'game/db')).open();assert.equal(db.prepare('SELECT COUNT(*) n FROM accounts').get().n,0);const base='http://127.0.0.1:'+config.http.port;assert.equal((await(await fetch(base+'/health')).json()).status,'ok');assert.ok((await(await fetch(base+'/login')).text()).includes('Hangarına dön.'));for(const asset of['/client/do_img/global/bg_standard_mmo.jpg','/client/_host/do_img/global/companyChoose/gamelogo.png'])assert.equal((await fetch(base+asset)).status,200);const login=await fetch(base+'/login',{method:'POST',body:new URLSearchParams({username:'packageqa',password:'fixture-only'}),redirect:'manual'});assert.equal(login.status,302);assert.match(login.headers.get('set-cookie'),/HttpOnly/);assert.equal(db.prepare('SELECT COUNT(*) n FROM accounts').get().n,1);console.log('PASS fresh packaged Node runtime: empty accounts, migrations, health, redesigned login/assets and first account creation; native GUI not launched');}finally{await runtime.close();}})().catch(e=>{console.error(e.stack);process.exitCode=1;});
'@ | Set-Content (Join-Path $testRoot 'verify.cjs') -Encoding utf8
& (Join-Path $testRoot 'Orbit/runtime/node.exe') (Join-Path $testRoot 'verify.cjs')
if($LASTEXITCODE -ne 0){throw 'Packaged runtime verification failed'}
