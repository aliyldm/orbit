$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$privateDirectory = Join-Path $root '.local'
foreach ($directory in @($privateDirectory, (Join-Path $root 'artifacts/private'))) {
New-Item -ItemType Directory -Force -Path $directory | Out-Null
if ($IsWindows -or $env:OS -eq 'Windows_NT') {
    # Write only the DACL; copying an existing full descriptor can request
    # SeSecurityPrivilege on repeat runs even though no audit rule is needed.
    $acl = [System.Security.AccessControl.DirectorySecurity]::new()
    $acl.SetAccessRuleProtection($true, $false)
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $rule = [System.Security.AccessControl.FileSystemAccessRule]::new($user, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
    $acl.SetAccessRule($rule)
    [System.IO.FileSystemAclExtensions]::SetAccessControl([System.IO.DirectoryInfo]::new($directory), $acl)
}
}
$credentials = Join-Path $privateDirectory 'development.env'
if (-not (Test-Path -LiteralPath $credentials)) {
    $postgres = [Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    $redis = [Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    [IO.File]::WriteAllText($credentials, "POSTGRES_PASSWORD=$postgres`nREDIS_PASSWORD=$redis`n")
}
$docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
if (-not (Test-Path -LiteralPath $docker)) { $docker = 'docker' }
& $docker compose --env-file $credentials -f (Join-Path $root 'infra/compose.yaml') up -d --wait --wait-timeout 90
if ($LASTEXITCODE -ne 0) { throw 'Development infrastructure startup failed' }
Write-Output 'Development PostgreSQL 127.0.0.1:55432 / Redis 127.0.0.1:56379; existing game and native PostgreSQL unchanged.'
