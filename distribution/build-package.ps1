$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$output = Join-Path $root 'dist'
New-Item -ItemType Directory -Force -Path $output | Out-Null
$entries = @{}
function Add-PackageFile([string]$file, [string]$name = '') {
    if (Test-Path -LiteralPath $file -PathType Leaf) {
        if (-not $name) { $name = [IO.Path]::GetRelativePath($root,$file).Replace('\','/') }
        $entries[$name] = $file
    }
}
Push-Location $root
try {
    foreach ($name in (git -c core.quotepath=false ls-files)) { if ($name -and -not $name.StartsWith('.git')) { Add-PackageFile (Join-Path $root $name) $name } }
} finally { Pop-Location }
$client = Join-Path $root 'DarkOrbit'
foreach ($file in Get-ChildItem -LiteralPath $client -File) {
    if ($file.Extension -in @('.dll','.orig','.ico') -or $file.Name -in @('DarkOrbit.exe','QtWebEngineProcess.exe','qt.conf')) { Add-PackageFile $file.FullName }
}
foreach ($folder in @('resources','platforms','bearer','iconengines','imageformats','position','printsupport','translations','dependencies','local-server/client')) {
    foreach ($file in Get-ChildItem -LiteralPath (Join-Path $client $folder) -File -Recurse) { Add-PackageFile $file.FullName }
}
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $client 'local-server/decompiled') -File -Recurse) {
    if ($file.Extension -in @('.as','.swf','.xml','.png') -or $file.Name -eq 'evidence.json' -or $file.Name.EndsWith('.source.json')) { Add-PackageFile $file.FullName }
}
Add-PackageFile (Get-Command node.exe).Source 'runtime/node.exe'
Add-PackageFile (Join-Path $PSScriptRoot 'NODE-LICENSE.txt') 'runtime/LICENSE'
foreach ($name in $entries.Keys) {
    # ActionScript packages legitimately contain folders named data. Reject
    # runtime state at its actual roots instead of rejecting source namespaces.
    if ($name -match '^DarkOrbit/(local-server/(data|backups|logs|certs)|multiplayer-server/(\.local|artifacts))/' -or $name -match '(^|/)(\.local|node_modules|bin|obj|setup-installers)/' -or $name -match '\.(db(-[a-z]+)?|pem|key|pfx|har|saz)$') { throw "Private path in package: $name" }
}
$target = Join-Path $output 'Orbit-Local-Preview-Windows.zip'
$fileStream = [IO.File]::Open($target,[IO.FileMode]::Create,[IO.FileAccess]::Write,[IO.FileShare]::None)
$archive = [IO.Compression.ZipArchive]::new($fileStream,[IO.Compression.ZipArchiveMode]::Create,$false)
try {
    $index = 0
    foreach ($name in ($entries.Keys | Sort-Object)) {
        $entry = $archive.CreateEntry('Orbit/' + $name,[IO.Compression.CompressionLevel]::Fastest)
        $stream = $entry.Open()
        try {
            if ($name.EndsWith('.cmd')) {
                $text = [IO.File]::ReadAllText($entries[$name]).Replace("`r`n","`n").Replace("`n","`r`n")
                $bytes = [Text.UTF8Encoding]::new($false).GetBytes($text); $stream.Write($bytes,0,$bytes.Length)
            } else {
                $inputFile = [IO.File]::OpenRead($entries[$name])
                try { $inputFile.CopyTo($stream) } finally { $inputFile.Dispose() }
            }
        } finally { $stream.Dispose() }
        if ($index % 4000 -eq 0) { Write-Output "Packaged $index/$($entries.Count) files" }
        $index++
    }
} finally { $archive.Dispose(); $fileStream.Dispose() }
$digest = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
$manifest = [ordered]@{file=[IO.Path]::GetFileName($target);bytes=(Get-Item -LiteralPath $target).Length;sha256=$digest;files=$entries.Count;accountsIncluded=$false;credentialsIncluded=$false;mode='local-preview';multiplayerReady=$false}
$manifest | ConvertTo-Json | Set-Content (Join-Path $output 'release-manifest.json') -Encoding utf8
"$digest  $([IO.Path]::GetFileName($target))" | Set-Content (Join-Path $output 'SHA256SUMS.txt') -Encoding utf8
$manifest | ConvertTo-Json -Compress
