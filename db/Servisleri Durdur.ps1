$ErrorActionPreference = 'Stop'
$file = Join-Path $PSScriptRoot '.local/services.env'
if (-not (Test-Path -LiteralPath $file)) { throw 'Bu paketin servisleri henuz kurulmamis.' }
$docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
if (-not (Test-Path -LiteralPath $docker)) { $docker = 'docker' }
& $docker compose --env-file $file -f (Join-Path $PSScriptRoot 'compose.yaml') stop
if ($LASTEXITCODE -ne 0) { throw 'Servisler durdurulamadi.' }
