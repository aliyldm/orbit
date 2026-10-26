$ErrorActionPreference = 'Stop'
$file = Join-Path $PSScriptRoot '.local/server.env'
if (-not (Test-Path -LiteralPath $file)) { throw 'Sunucu veritabani kurulumu ve ozel server.env henuz hazir degil. MIGRATION.md devam adimlarini gosterir; mevcut hesabin ustune eski snapshot yazmayin.' }
$names = @('DARKORBIT_NATIVE_SCHEMA','DARKORBIT_POSTGRES','DARKORBIT_REDIS','DARKORBIT_GAME_HOST','DARKORBIT_GAME_BIND','DARKORBIT_WEB_BIND','DARKORBIT_GAME_PUBLIC_PORT')
foreach ($line in [IO.File]::ReadAllLines($file)) {
    $parts = $line.Split('=',2)
    if ($parts.Length -eq 2 -and $parts[0] -in $names) { [Environment]::SetEnvironmentVariable($parts[0],$parts[1],'Process') }
}
foreach ($name in @('DARKORBIT_NATIVE_SCHEMA','DARKORBIT_POSTGRES','DARKORBIT_REDIS','DARKORBIT_GAME_HOST')) {
    if (-not [Environment]::GetEnvironmentVariable($name,'Process')) { throw "$name eksik. Sunucu ayarini tamamlayin." }
}
$dll = Join-Path $PSScriptRoot 'runtime/DarkOrbit.Host.dll'
if (-not (Test-Path -LiteralPath $dll)) { throw 'Once Derle.ps1 ile sunucuyu derleyin.' }
& dotnet $dll
if ($LASTEXITCODE -ne 0) { throw 'Oyun sunucusu hata ile durdu.' }
