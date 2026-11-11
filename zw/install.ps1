<#
.SYNOPSIS
    Install this library into the ZW_3rdLibs_VC14 layout described by zw/zw.json.
.DESCRIPTION
    Header-only library: copies the files listed in zw.json "install.copy" into
    <ZwRoot>/<install.zw_dir>/. Never touches anything outside that directory.
.EXAMPLE
    .\zw\install.ps1 -ZwRoot C:\path\to\ZW_3rdLibs_VC14
#>
param(
    [Parameter(Mandatory = $true)][string]$ZwRoot
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$m    = Get-Content (Join-Path $PSScriptRoot 'zw.json') -Raw | ConvertFrom-Json
$dest = Join-Path $ZwRoot $m.install.zw_dir

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
New-Item -ItemType Directory -Force $dest | Out-Null

foreach ($c in $m.install.copy) {
    $src = Join-Path $repo $c.from
    $dst = Join-Path $dest $c.to
    New-Item -ItemType Directory -Force $dst | Out-Null
    Get-ChildItem $src -File -Filter $c.include | Copy-Item -Destination $dst
}
Write-Host "installed $($m.name) $($m.version) -> $dest"
