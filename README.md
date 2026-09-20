# First Principles

A Godot 4 science-fiction computational puzzle game about humanity learning to understand the universe through alien artifacts.

## Current status

The project currently includes:

- a deterministic simulation layer for logic components
- data-driven puzzle definitions and validation
- construction save/load and puzzle round-tripping
- a main scene and workbench UI
- a campaign/session layer with timeline and narrative data
- headless automated tests covering simulation, validation, serialization, and smoke flow

The foundation has been verified with the Godot console runner:

- 67 automated tests passed
- 0 failed

## Run the game

From PowerShell:

```powershell
& "C:\Games\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64.exe" --path "C:\Users\User\Documents\Github\First-Principles"
```

## Run the tests

```powershell
& "C:\Games\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" --headless --path "C:\Users\User\Documents\Github\First-Principles" -s res://tests/test_runner.gd --quit
```

## Design direction

The design follows the vision in `docs/MASTER_SPEC.md`: a familiar-to-strange computational progression, a working puzzle foundation, and a narrative structure built around transmissions, discoveries, and time.

## Project structure

- `core/` — simulation, puzzle, serialization, construction, and session logic
- `data/` — JSON-driven puzzle, narrative, and timeline content
- `scenes/` — runtime scenes and editor workbench
- `tests/` — automated verification for the core systems
- `docs/` — architecture, roadmap, and project status
