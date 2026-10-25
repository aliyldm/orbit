$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$values = @{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $root '.local/development.env'))) { $pair = $line.Split('=', 2); if ($pair.Length -eq 2) { $values[$pair[0]] = $pair[1] } }
$archive = Get-Content (Join-Path $root 'artifacts/postgresql-rehearsal.json') -Raw | ConvertFrom-Json
$previous = $env:DARKORBIT_POSTGRES
try {
    $env:DARKORBIT_POSTGRES = "Host=127.0.0.1;Port=55432;Database=darkorbit_development;Username=darkorbit_dev;Password=$($values['POSTGRES_PASSWORD']);Maximum Pool Size=20;Timeout=10;Command Timeout=60;Include Error Detail=false"
    $schema = 'mp_' + [Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(8)).ToLowerInvariant()
    Push-Location $root
    try {
        & 'C:\Program Files\dotnet\dotnet.exe' run --project tools/DarkOrbit.Verify --no-build -- bootstrap $archive.schema $schema (Join-Path $root 'artifacts/private/native-profiles.json') $archive.snapshotSha256
        if ($LASTEXITCODE -ne 0) { throw 'Native bootstrap failed; transaction rolled back' }
    } finally { Pop-Location }
} finally { $env:DARKORBIT_POSTGRES = $previous }
