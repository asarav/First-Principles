# AI Development

## Before code changes

1. Read the relevant implementation and tests.
2. Confirm what is already working.
3. Make the smallest root-cause fix.
4. Re-run the affected tests.
5. Re-check the game scene or relevant script path.

## Core rules

- Do not duplicate logic that already exists in the simulation or session layers.
- Prefer small changes that preserve the architecture instead of broad rewrites.
- Keep the simulation independent from Godot UI nodes.
- Preserve data-driven puzzle definitions and serialization behavior.
- Update the docs when an architectural decision materially changes.

## Verification

The project should be checked with the Godot console runner and the smoke flow whenever a meaningful feature is changed.
