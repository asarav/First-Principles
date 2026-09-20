$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
godot --path $root
