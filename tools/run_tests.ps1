param(
	[switch]$ImportOnly
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$godot = "godot"

Set-Location $root
Write-Host "Importing project..."
& $godot --headless --path $root --import --quit
if ($LASTEXITCODE -ne 0) {
	Write-Host "Import failed with code $LASTEXITCODE"
	exit $LASTEXITCODE
}
if ($ImportOnly) {
	exit 0
}

Write-Host "Running automated tests..."
& $godot --headless --path $root -s res://tests/test_runner.gd
exit $LASTEXITCODE
