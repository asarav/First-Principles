# Puzzle Design

## Goals

- The player should reconstruct the alien logic from data and trial.
- Puzzle success should be testable and deterministic.
- Each puzzle should express one conceptual primitive: AND, NOT, or another simple operation.

## Rules

- Puzzle definitions stay JSON-driven and machine-validated.
- A puzzle must include inputs, outputs, and one or more test cases.
- The editor and runtime consume the same simulation stack.
- Constraints remain explicit and inspectable for valid-configuration checks.

## Future direction

The early architecture deliberately leaves room for non-boolean or non-circuit computational paradigms without redesigning the whole engine.
