$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    dotnet restore Orbit.Server.slnx --locked-mode --nologo
    if ($LASTEXITCODE -ne 0) { throw 'Paket geri yukleme basarisiz.' }
    dotnet publish src/DarkOrbit.Host/DarkOrbit.Host.csproj -c Release --no-restore -p:DebugType=None -p:DebugSymbols=false -o runtime --nologo
    if ($LASTEXITCODE -ne 0) { throw 'Sunucu derlenemedi.' }
} finally { Pop-Location }
