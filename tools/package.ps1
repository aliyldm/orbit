$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
& (Join-Path $PSScriptRoot 'verify-package.ps1') -HashAll
New-Item -ItemType Directory -Force -Path (Join-Path $root 'releases') | Out-Null
$manifest = Get-Content -LiteralPath (Join-Path $root 'package-manifest.json') -Raw | ConvertFrom-Json
foreach ($role in @('client','server','db')) {
    $output = Join-Path $root "releases/Orbit-$role-Windows-Development.zip"
    $file = [IO.File]::Open($output,[IO.FileMode]::Create,[IO.FileAccess]::Write,[IO.FileShare]::None)
    $zip = [IO.Compression.ZipArchive]::new($file,[IO.Compression.ZipArchiveMode]::Create,$false)
    try {
        foreach ($entry in $manifest.files | Where-Object { $_.path.StartsWith($role + '/') -or $_.path -in @('README.md','MIGRATION.md') }) {
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip,(Join-Path $root $entry.path),$entry.path,[IO.Compression.CompressionLevel]::Fastest) | Out-Null
        }
    } finally { $zip.Dispose();$file.Dispose() }
    Write-Output "$role archive: $((Get-Item -LiteralPath $output).Length) bytes"
}
Get-ChildItem -LiteralPath (Join-Path $root 'releases') -Filter '*.zip' | ForEach-Object { "$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant())  $($_.Name)" } | Set-Content -LiteralPath (Join-Path $root 'releases/SHA256SUMS.txt') -Encoding utf8