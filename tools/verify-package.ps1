param([switch]$HashAll)
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
$manifest = Get-Content -LiteralPath (Join-Path $root 'package-manifest.json') -Raw | ConvertFrom-Json
foreach ($entry in $manifest.files) {
    $file = [IO.Path]::GetFullPath((Join-Path $root $entry.path))
    if (-not $file.StartsWith($root + '\',[StringComparison]::OrdinalIgnoreCase)) { throw 'Manifest entry escapes package.' }
    if ($entry.path -match '(^|/)(decompiled|\.local|backups|logs)(/|$)' -or $entry.path -match '\.(as|orig|bak|db|har|saz|pem|key)$') { throw "Forbidden entry: $($entry.path)" }
    if (-not (Test-Path -LiteralPath $file -PathType Leaf) -or (Get-Item -LiteralPath $file).Length -ne $entry.bytes) { throw "Missing or changed file: $($entry.path)" }
    if ($HashAll -and (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant() -ne $entry.sha256) { throw "Digest mismatch: $($entry.path)" }
}
Write-Output "PASS: $($manifest.files.Count) separated package files; no decompiled files or private state in the manifest."