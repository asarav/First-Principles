# Decisions

## Keep simulation presentation-free

The machine layer stays in `core/sim` and uses plain `RefCounted` objects instead of Godot scene nodes. This keeps puzzle truth in one place and prevents the editor from creating a second simulation source of truth.

## Prefer data-driven puzzle definitions

Puzzle JSON files define IO, available components, constraints, and tests. This keeps authoring in data rather than requiring engine edits for each new puzzle.

## Save and validate the construction graph

The workbench converts GraphEdit state into a `Construction` object before running validation. This makes the editor and automated tests execute the same logic path.

## Treat Godot warnings as evidence

The project only treats a feature as complete if the actual scene and script pipeline run successfully under headless verification. Non-fatal warnings are tracked but not ignored.
