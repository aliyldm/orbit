param(
    [Parameter(Mandatory)][string]$VirtualIP,
    [switch]$BindAny,
    [switch]$ApplyFirewall,
    [string]$LocalerSubnet
)
$ErrorActionPreference = 'Stop'
$parsed = [Net.IPAddress]::Parse($VirtualIP)
if ($parsed.AddressFamily -ne [Net.Sockets.AddressFamily]::InterNetwork -or [Net.IPAddress]::IsLoopback($parsed) -or $VirtualIP -eq '0.0.0.0') { throw 'Localer tarafindan verilen IPv4 adresini belirtin.' }
if (-not (Get-NetIPAddress -IPAddress $VirtualIP -ErrorAction SilentlyContinue)) { throw 'Bu sanal IP bu bilgisayarin ag arabiriminde bulunamadi.' }
$root = Split-Path $PSScriptRoot -Parent
if ($ApplyFirewall) {
    if (-not $LocalerSubnet -or $LocalerSubnet -notmatch '^\d{1,3}(\.\d{1,3}){3}/([0-9]|[12][0-9]|3[0-2])$') { throw '-ApplyFirewall icin LocalerSubnet CIDR araligini acikca belirtin.' }
    [void][Net.IPAddress]::Parse($LocalerSubnet.Split('/')[0])
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not ([Security.Principal.WindowsPrincipal]::new($identity)).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'Guvenlik duvari adimini yonetici PowerShell ile calistirin.' }
    $ruleName = 'Orbit-Localer-' + $VirtualIP.Replace('.','-')
    if (Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue) { throw 'Bu adda kural zaten var; mevcut adres/port kisitlarini inceleyin. Otomatik ustune yazilmaz.' }
    New-NetFirewallRule -Name $ruleName -DisplayName "Orbit Localer $VirtualIP" -Direction Inbound -Action Allow -Protocol TCP -LocalAddress $VirtualIP -RemoteAddress $LocalerSubnet -LocalPort 18095,18096 -Profile Any | Out-Null
}
$values = @{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $root '.local/development.env'))) { $p = $line.Split('=',2); if ($p.Length -eq 2) { $values[$p[0]] = $p[1] } }
$names = @('DARKORBIT_POSTGRES','DARKORBIT_REDIS','DARKORBIT_NATIVE_SCHEMA','DARKORBIT_WEB_BIND','DARKORBIT_GAME_BIND','DARKORBIT_GAME_HOST')
$previous = @{}; foreach ($name in $names) { $previous[$name] = [Environment]::GetEnvironmentVariable($name,'Process') }
try {
    $env:DARKORBIT_POSTGRES="Host=127.0.0.1;Port=55432;Database=darkorbit_development;Username=darkorbit_dev;Password=$($values['POSTGRES_PASSWORD']);Maximum Pool Size=20;Include Error Detail=false"
    $env:DARKORBIT_REDIS="127.0.0.1:56379,password=$($values['REDIS_PASSWORD']),abortConnect=true"
    $env:DARKORBIT_NATIVE_SCHEMA=(Get-Content (Join-Path $root 'artifacts/native-bootstrap.json') -Raw | ConvertFrom-Json).schema
    $env:DARKORBIT_GAME_HOST=$VirtualIP
    $env:DARKORBIT_WEB_BIND=if($BindAny){'0.0.0.0'}else{$VirtualIP}
    $env:DARKORBIT_GAME_BIND=$env:DARKORBIT_WEB_BIND
    Write-Output "Gelistirme web: http://${VirtualIP}:18095 ; TCP: ${VirtualIP}:18096 . /ready 503; tam oyun henuz tasinmadi."
    Push-Location $root
    try { & 'C:\Program Files\dotnet\dotnet.exe' run --project src/DarkOrbit.Host --no-build } finally { Pop-Location }
} finally { foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name,$previous[$name],'Process') } }
