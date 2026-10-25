$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$values = @{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $root '.local/development.env'))) {
    $pair = $line.Split('=', 2)
    if ($pair.Length -eq 2) { $values[$pair[0]] = $pair[1] }
}
$previousPg = $env:DARKORBIT_POSTGRES
$previousRedis = $env:DARKORBIT_REDIS
try {
    $env:DARKORBIT_POSTGRES = "Host=127.0.0.1;Port=55432;Database=darkorbit_development;Username=darkorbit_dev;Password=$($values['POSTGRES_PASSWORD']);Maximum Pool Size=20;Timeout=10;Command Timeout=60;Include Error Detail=false"
    $env:DARKORBIT_REDIS = "127.0.0.1:56379,password=$($values['REDIS_PASSWORD']),abortConnect=true"
    Push-Location $root
    try {
        & 'C:\Program Files\dotnet\dotnet.exe' run --project tools/DarkOrbit.Verify --no-build -- storage
        if ($LASTEXITCODE -ne 0) { throw 'Storage integration verification failed' }
    } finally { Pop-Location }
} finally { $env:DARKORBIT_POSTGRES = $previousPg; $env:DARKORBIT_REDIS = $previousRedis }
