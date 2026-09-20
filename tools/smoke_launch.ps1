$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
godot --headless --path $root --quit-after 2
