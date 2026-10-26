$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
$skipDirs = @('.git','.local','bin','obj','logs','releases','node_modules','decompiled','backups','certs')
$skipFiles = @('package-manifest.json','connection.json','reference.local.json','.export-source-marker.json')
$files = [Collections.Generic.List[IO.FileInfo]]::new()
function Collect([string]$directory) {
    foreach ($entry in Get-ChildItem -LiteralPath $directory -Force) {
        if ($entry.PSIsContainer) { if ($entry.Name -notin $skipDirs) { Collect $entry.FullName } }
        elseif ($entry.Name -notin $skipFiles -and $entry.Extension -notin @('.pdb','.db','.sqlite','.log','.key','.pem','.har','.saz','.orig','.bak','.as') -and ($entry.Extension -ne '.env' -or $entry.Name.EndsWith('.example.env'))) { $files.Add($entry) }
    }
}
Collect $root
$records = foreach ($file in ($files | Sort-Object FullName)) {
    [ordered]@{path=[IO.Path]::GetRelativePath($root,$file.FullName).Replace('\','/');bytes=$file.Length;sha256=(Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()}
}
$manifest = [ordered]@{
    format=1;layout='separated-client-server-db';createdAt=[DateTimeOffset]::UtcNow.ToString('o');files=$records
    decompiledIncluded=$false;accountsIncluded=$false;credentialsIncluded=$false;multiplayerReady=$false
    checks=[ordered]@{standaloneServerBuild=$true;clientHttpTcpBridge=$true;localerOriginForwarding=$true;compiledInventorySelectionPolicies=$true;nativeVisualAcceptance=$false;fullMigration=$false}
}
[IO.File]::WriteAllText((Join-Path $root 'package-manifest.json'),($manifest | ConvertTo-Json -Depth 8),[Text.UTF8Encoding]::new($false))
Write-Output "Manifest updated: $($files.Count) files. Personal state and analysis outputs excluded."
