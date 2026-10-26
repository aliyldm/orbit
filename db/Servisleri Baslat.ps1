#requires -Version 7.0
$ErrorActionPreference = 'Stop'
$privatePath = Join-Path $PSScriptRoot '.local'
New-Item -ItemType Directory -Force -Path $privatePath | Out-Null
$acl = [Security.AccessControl.DirectorySecurity]::new()
$acl.SetAccessRuleProtection($true,$false)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent().Name
$acl.SetAccessRule([Security.AccessControl.FileSystemAccessRule]::new($identity,'FullControl','ContainerInherit,ObjectInherit','None','Allow'))
[IO.FileSystemAclExtensions]::SetAccessControl([IO.DirectoryInfo]::new($privatePath),$acl)
$file = Join-Path $privatePath 'services.env'
if (-not (Test-Path -LiteralPath $file)) {
    $pgSecret = [Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    $redisSecret = [Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    [IO.File]::WriteAllText($file,"POSTGRES_PASSWORD=$pgSecret`nREDIS_PASSWORD=$redisSecret`n")
}
$docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
if (-not (Test-Path -LiteralPath $docker)) { $docker = 'docker' }
& $docker compose --env-file $file -f (Join-Path $PSScriptRoot 'compose.yaml') up -d --wait --wait-timeout 90
if ($LASTEXITCODE -ne 0) { throw 'PostgreSQL/Redis servisleri baslatilamadi.' }
Write-Output 'PostgreSQL:127.0.0.1:55433 / Redis:127.0.0.1:56380. Bunlar yalniz sunucu bilgisayarinda calisir.'
