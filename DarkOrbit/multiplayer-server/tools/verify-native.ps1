param([ValidateSet('native','combat')][string]$Mode = 'native')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$values = @{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $root '.local/development.env'))) { $p = $line.Split('=',2); if ($p.Length -eq 2) { $values[$p[0]] = $p[1] } }
$oldPg=$env:DARKORBIT_POSTGRES; $oldRedis=$env:DARKORBIT_REDIS
try {
    $env:DARKORBIT_POSTGRES="Host=127.0.0.1;Port=55432;Database=darkorbit_development;Username=darkorbit_dev;Password=$($values['POSTGRES_PASSWORD']);Maximum Pool Size=20;Command Timeout=60;Include Error Detail=false"
    $env:DARKORBIT_REDIS="127.0.0.1:56379,password=$($values['REDIS_PASSWORD']),abortConnect=true"
    Push-Location $root
    try { & 'C:\Program Files\dotnet\dotnet.exe' run --project tools/DarkOrbit.Verify --no-build -- $Mode; if ($LASTEXITCODE -ne 0) { throw 'Native/combat integration failed' } }
    finally { Pop-Location }
} finally { $env:DARKORBIT_POSTGRES=$oldPg; $env:DARKORBIT_REDIS=$oldRedis }
