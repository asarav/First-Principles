# Architecture

The runtime and editor share one simulation stack. Visual nodes never own puzzle truth.

## Layers

- **Puzzle definitions** (`data/puzzles/*.json`) describe IO, available components, constraints, test cases, and narrative references.
- **Construction** is the player machine: component instances, config, connections, editor positions.
- **Simulation** (`core/sim`) is `RefCounted` data: `SignalValue`, `SimComponent`, `SimConnection`, `Machine`. No `Node` types.
- **Validation** builds a `Machine` from puzzle + construction and executes every test case.
- **Presentation** (`scenes/`) is a hub, lightweight narrative viewer, and GraphEdit workbench.
- **Session / timeline** (`core/session`, `data/timeline`) store year, unlocks, completions. Transmission intervals live in data.

## Simulation

`Machine.settle()` resets, then evaluates connection propagation + component `evaluate()` in sorted-id order until outputs stop changing. Identical puzzle, construction, and inputs produce identical `inspect()` snapshots.

Current vocabulary: AND, OR, NOT, XOR, CONST, INPUT, OUTPUT. Values are typed (`SignalValue`) so later puzzles are not forced to stay boolean.

## Editor

`scenes/workbench.gd` maps GraphEdit to `Construction` and calls `Validator` / `Machine`. It does not reimplement gates.
