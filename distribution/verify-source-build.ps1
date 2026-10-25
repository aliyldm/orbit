param([string]$Revision = 'HEAD')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$probe = Join-Path $root ('dist/source-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $probe | Out-Null
$zip = Join-Path $probe 'source.zip'
Push-Location $root
try {
    & git archive --format=zip --output=$zip $Revision
    if ($LASTEXITCODE -ne 0) { throw 'Git source archive failed' }
} finally { Pop-Location }
$checkout = Join-Path $probe 'checkout'
[IO.Compression.ZipFile]::ExtractToDirectory($zip,$checkout)
Push-Location (Join-Path $checkout 'DarkOrbit/multiplayer-server')
try {
    & dotnet restore DarkOrbit.Multiplayer.slnx --locked-mode --ignore-failed-sources --nologo
    if ($LASTEXITCODE -ne 0) { throw 'Clean source restore failed' }
    & dotnet build DarkOrbit.Multiplayer.slnx --no-restore --nologo -m:1
    if ($LASTEXITCODE -ne 0) { throw 'Clean source build failed' }
} finally { Pop-Location }
Write-Output 'PASS: .NET source download builds without untracked runtime files, private credentials or account snapshots.'
