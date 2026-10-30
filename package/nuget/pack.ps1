# Assembles and packs MediaPortal.libbluray from two finished Meson builds (x64 and x86).
# -X64Build / -X86Build point at the 'src' folder of each Meson build directory.
param(
  [Parameter(Mandatory = $true)][string]$X64Build,
  [Parameter(Mandatory = $true)][string]$X86Build,
  [Parameter(Mandatory = $true)][string]$Version,
  [string]$Out = 'nupkg'
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
Copy-Item "$PSScriptRoot\MediaPortal.libbluray.nuspec" $stage

nuget pack "$stage\MediaPortal.libbluray.nuspec" -Version $Version -OutputDirectory $Out -NoPackageAnalysis
if ($LASTEXITCODE -ne 0) { throw 'nuget pack failed' }
