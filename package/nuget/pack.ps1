# Assembles and packs MediaPortal.libbluray from two finished Meson builds (x64 and x86).
# -X64Build / -X86Build point at the 'src' folder of each Meson build directory.
param(
  [Parameter(Mandatory = $true)][string]$X64Build,
  [Parameter(Mandatory = $true)][string]$X86Build,
  [Parameter(Mandatory = $true)][string]$Version,
  [string]$Out = 'nupkg',
  [switch]$RequireNotes
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$stage = Join-Path $repo 'nuget-stage'
if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }

$inc = "$stage\build\lib\libbluray"
$rt = "$stage\references\runtimes"
New-Item -ItemType Directory -Force "$inc\decoders", "$stage\build\lib\includes\util", "$rt\x64", "$rt\x86" | Out-Null

foreach ($f in 'bluray.h', 'keys.h', 'player_settings.h') { Copy-Item "$repo\src\libbluray\$f" $inc }
Copy-Item "$repo\src\libbluray\decoders\overlay.h" "$inc\decoders"
Copy-Item "$repo\src\util\attributes.h" "$stage\build\lib\includes\util"
Copy-Item "$X64Build\libbluray\bluray-version.h" $inc

foreach ($a in @(@('x64', $X64Build), @('x86', $X86Build))) {
  Copy-Item (Get-ChildItem "$($a[1])\bluray-*.dll").FullName "$rt\$($a[0])\bluray.dll"
}
Copy-Item "$X64Build\libbluray\bdj\libbluray-*.jar" $rt

Copy-Item "$PSScriptRoot\MediaPortal.libbluray.props", "$PSScriptRoot\MediaPortal.libbluray.targets" "$stage\build"
Copy-Item "$repo\COPYING" $stage
New-Item -ItemType Directory -Force "$stage\docs" | Out-Null
Copy-Item "$repo\docs\ATTRIBUTION.md" "$stage\docs"

# Release notes: the '## [<Version>]' section of docs/RELEASE-NOTES.md, or '## [Unreleased]' for CI builds.
$notes = New-Object System.Collections.Generic.List[string]
$inside = $false
foreach ($line in Get-Content "$repo\docs\RELEASE-NOTES.md") {
  if ($line -match '^## \[(.+?)\]') {
    if ($inside) { break }
    $inside = ($Matches[1] -eq $Version)
    continue
  }
  if ($inside) { $notes.Add($line) }
}
$text = ($notes -join "`n").Trim()
if (-not $text -and $RequireNotes) { throw "docs/RELEASE-NOTES.md has no section '## [$Version]'" }
New-Item -ItemType Directory -Force $Out | Out-Null
Set-Content -LiteralPath "$Out\release-notes.md" -Value $text -Encoding utf8

$nuspec = [xml](Get-Content -Raw "$PSScriptRoot\MediaPortal.libbluray.nuspec")
if ($text) {
  $el = $nuspec.CreateElement('releaseNotes', $nuspec.DocumentElement.NamespaceURI)
  $el.InnerText = $text
  $nuspec.package.metadata.AppendChild($el) | Out-Null
}
$nuspec.Save("$stage\MediaPortal.libbluray.nuspec")

nuget pack "$stage\MediaPortal.libbluray.nuspec" -Version $Version -OutputDirectory $Out -NoPackageAnalysis
if ($LASTEXITCODE -ne 0) { throw 'nuget pack failed' }
