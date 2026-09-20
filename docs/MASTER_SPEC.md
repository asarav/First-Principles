# First Principles

## 1. Core Concept

**First Principles** is a science-fiction computational puzzle game about humanity learning to understand the universe through messages received from an alien civilization.

The alien civilization does not initially communicate through language, images, or recognizable symbols. It sends computational and mathematical artifacts.

Humanity must reconstruct, understand, and solve these artifacts.

Each breakthrough teaches humanity something new.

The player is a scientist participating in this process.

The game takes place across enormous spans of time. Early transmissions may arrive roughly once per decade, but the interval can change as the story progresses. The player may enter cryosleep and awaken decades, centuries, or eventually much longer periods later.

The player therefore experiences not only technological progression, but civilization itself changing as a consequence of what humanity learns.

The ultimate subject of the game is not simply extraterrestrial contact.

It is **comprehension**.

The central question is:

> What happens when humanity learns to understand the universe the way another civilization does?

---

## 2. Design Philosophy

The game should create the feeling that the player is discovering something that nobody has understood before.

A puzzle is not merely a challenge created by a game designer.

It should feel like a scientific mystery.

A solution is an experiment that worked.

A new mechanic represents a newly discovered principle.

A new computational primitive represents a technological breakthrough.

A new era represents the consequences of understanding the previous one.

The progression should feel like:

**familiar → strange → incomprehensible → understood → profoundly strange again**

The player should frequently have moments of:

> "Wait. That's what this actually is?"

---

## 3. Puzzle Philosophy

The puzzles are the heart of the game.

They should be computationally rigorous, mechanically interesting, and conceptually meaningful.

The ideal puzzle has two layers:

1. A computational problem the player must solve.
2. A deeper physical, mathematical, or cosmological interpretation that becomes apparent through solving it.

The player may initially believe they are manipulating an abstract computational system.

Later they discover that the system corresponds to something physical.

Eventually the distinction between "simulation" and "reality" may itself become questionable.

Puzzle progression should eventually explore concepts such as:

* logic
* algorithms
* computation
* information
* state
* systems
* emergence
* physical processes
* matter
* energy
* space
* topology
* time
* causality
* information as a physical quantity
* increasingly abstract mathematical descriptions of reality

This does **not** mean the game should immediately implement advanced physics.

The early game should be understandable and mechanically grounded.

The architecture should simply avoid assumptions that prevent later systems from becoming radically different.

---

## 4. Narrative Influences

The intended tonal and thematic influences include:

* *Contact*
* *Arrival*
* *The Three-Body Problem*
* *Project Hail Mary*

These are influences, not templates.

### Contact

Use as inspiration for:

* scientific realism
* institutional responses to first contact
* extraterrestrial intelligence as a scientific event
* the tension between discovery and uncertainty

### Arrival

Use as inspiration for:

* communication as mystery
* alien conceptual frameworks
* the possibility that understanding changes how humans conceptualize reality

### Project Hail Mary

Use as inspiration for:

* joy of scientific problem-solving
* experimentation
* forming hypotheses
* testing hypotheses
* collaborative reasoning
* scientific breakthroughs feeling exciting rather than purely expositional

### The Three-Body Problem

Use as inspiration for:

* enormous timescales
* civilization-level consequences
* unsettling implications of extraterrestrial intelligence
* uncertainty about humanity's place in the universe

The game should not copy characters, plots, settings, technologies, terminology, or specific story events from these works.

---

## 5. Tone

The tone should be:

* intellectually curious
* scientifically grounded
* mysterious
* contemplative
* occasionally frightening
* emotionally human
* awe-inspiring
* increasingly uncanny

Avoid:

* generic alien invasions
* superhero-style science
* military power fantasies
* excessive exposition
* constant action
* aliens that immediately behave like humans
* technobabble used to disguise weak ideas

Fear should primarily come from implications and discovery rather than monsters.

---

## 6. Scientific Method as Narrative

Scientific reasoning should be part of the storytelling.

Characters should:

* propose hypotheses
* disagree
* make incorrect assumptions
* design experiments
* observe results
* revise models
* argue about interpretations
* distinguish evidence from speculation

The player should sometimes solve a puzzle while the surrounding narrative is still uncertain about what the solution means.

A correct solution does not necessarily mean humanity understands its significance.

---

## 7. Humanity

Humanity should never be treated as a single unified character.

Different groups may respond differently to the transmissions:

* scientists
* governments
* corporations
* philosophers
* religious groups
* ordinary citizens
* competing scientific institutions
* later generations

People may disagree about:

* whether the transmissions are safe
* whether humanity should continue solving them
* whether they are gifts, tests, warnings, or something else
* whether humanity should reproduce alien technology
* whether understanding something gives humanity the right to use it
* whether some knowledge should remain unknown

These disagreements should emerge naturally from discoveries rather than existing merely to create drama.

---

## 8. The Alien Civilization

The aliens should remain poorly defined early in the game.

The player should infer their nature from:

* mathematical structures
* computational artifacts
* design choices
* constraints
* discoveries
* increasingly strange conceptual frameworks

The aliens should not initially be presented as humans with different biology.

Their worldview should become apparent through what they consider fundamental.

The form of their communication should itself become part of the mystery.

---

## 9. Time

Time is a major gameplay and narrative system.

The game should span enormous periods.

Early:

* transmissions might arrive approximately every decade

Later:

* decades
* centuries
* millennia
* potentially much larger intervals

These intervals must be data-driven rather than hard-coded.

The player may enter cryosleep between important events.

When the player awakens, the world should have changed.

Changes may include:

* technology
* cities
* institutions
* scientific terminology
* social structures
* relationships
* generations
* humanity's understanding of previous discoveries

The passage of time should communicate that the player's discoveries had consequences.

---

## 10. Player Role

The player is a scientist.

They are not:

* a chosen hero
* a military commander
* a superhero
* the sole person capable of solving everything

Their tools are:

* observation
* experimentation
* computation
* mathematical reasoning
* hypothesis formation
* persistence

The player should feel like a participant in a scientific process.

---

## 11. Core Gameplay Loop

The broad loop is:

1. Receive a transmission.
2. Investigate it.
3. Form hypotheses about its structure.
4. Construct computational experiments.
5. Solve the underlying problem.
6. Verify the solution.
7. Understand what the solution represents.
8. Humanity develops new knowledge or technology.
9. Narrative consequences unfold.
10. Time advances.
11. Eventually receive another transmission.

The exact structure can evolve significantly later.

---

## 12. Initial Puzzle System

The first computational system may resemble digital logic.

Possible initial primitives:

* AND
* OR
* NOT
* XOR
* constants
* inputs
* outputs
* wires/connections

The initial system should be deliberately small.

The architecture must not assume that the entire game will always be:

* boolean
* grid-based
* composed of logic gates
* tick-based
* two-dimensional
* circuit-based

These are merely the first computational vocabulary.

Later puzzle systems may be graph-based, spatial, temporal, cellular, causal, multidimensional, or based on entirely different computational abstractions.

---

## 13. Puzzle Experience

The game should prioritize:

* discovery
* experimentation
* elegant solutions
* conceptual breakthroughs
* genuine problem-solving
* meaningful constraints
* understanding why a solution works

Avoid turning the game into a conventional checklist of increasingly difficult programming exercises.

The player should not simply feel:

> "Level 14 is harder than Level 13."

They should increasingly feel:

> "I didn't realize this was even possible."

---

## 14. Simulation

The simulation is the foundation of the puzzle system.

It must be:

* deterministic
* reproducible
* testable
* independent of visual presentation

Given the same:

* puzzle definition
* player construction
* initial state
* inputs

the simulation should produce the same result.

It should eventually support:

* run
* pause
* reset
* single-step execution
* deterministic replay
* state inspection
* input/output inspection
* validation

The simulation should be testable without running the visual game.

---

## 15. Puzzle Definitions

Normal puzzles should be data-driven.

Creating a normal puzzle should not require modifying engine source code.

A puzzle definition should be able to describe things such as:

* ID
* title
* description
* available components
* inputs
* outputs
* initial state
* test cases
* constraints
* scoring rules
* narrative references
* unlock requirements

The exact format is an engineering decision.

---

## 16. First-Class Puzzle Editor

The game should eventually contain a first-class puzzle editor.

The editor should use the exact same simulation engine as the game.

The editor should eventually support:

* component palette
* canvas
* component placement
* movement
* deletion
* connections
* configuration
* inputs
* outputs
* test cases
* constraints
* simulation
* pause
* reset
* step
* state inspection
* save/load

Editor functionality is more important than editor polish during development.

---

## 17. Debugging

The development tools should make the simulation understandable.

Useful debugging features include:

* component state inspection
* connection inspection
* input/output inspection
* current tick/cycle
* test execution
* validation failure information
* deterministic reproduction of failures

The goal is to make puzzle development fast and reliable.

---

## 18. Narrative System

The narrative system should be lightweight and data-driven.

It should support concepts such as:

* dialogue
* characters
* scenes
* choices where appropriate
* discoveries
* puzzle completion events
* scientific breakthroughs
* time jumps
* cryosleep
* civilization changes

Narrative content should be able to reference puzzle IDs.

Do not build a giant general-purpose visual-novel engine unless it becomes necessary.

---

## 19. Timeline

The timeline should be data-driven.

A timeline event may contain:

* year
* event type
* transmission
* narrative events
* scientific discoveries
* civilization changes
* player status
* cryosleep duration
* unlocked content

Transmission intervals must not be hard-coded.

---

## 20. Presentation

Presentation should support the feeling of scientific discovery.

Prioritize:

* excellent typography
* strong UI hierarchy
* atmospheric sound
* memorable music
* restrained visual effects
* meaningful transitions
* changing environments across eras

The game does not need expensive 3D graphics to achieve its core experience.

The computational systems and presentation should carry much of the game's identity.

---

## 21. Technical Direction

Recommended technology:

* Godot 4.x
* GDScript
* Git
* GitHub

The game is primarily 2D/UI-oriented initially.

The software should be modular and data-driven without becoming unnecessarily abstract.

Avoid premature overengineering.

The complexity should live in the puzzle systems, not in an elaborate software architecture.

---

## 22. Architectural Principles

The most important architectural principle is:

> The game runtime and puzzle editor must use the same underlying simulation engine.

Other principles:

* separate simulation state from Godot scene nodes
* keep puzzle definitions data-driven
* keep simulation deterministic
* make core systems testable
* avoid duplicated logic
* avoid unnecessary dependencies
* avoid hard-coded puzzle content
* make future puzzle paradigms possible
* prefer simple modular systems
* document important architectural decisions

---

## 23. Development Philosophy

AI coding assistants should be used aggressively for implementation.

AI should handle as much of the following as practical:

* engine code
* UI
* editor implementation
* serialization
* tests
* debugging
* refactoring
* documentation
* tooling
* boilerplate
* project configuration

The human creator should primarily own:

* game vision
* puzzle concepts
* puzzle design
* narrative direction
* major conceptual discoveries
* artistic direction
* final design decisions

AI should **not** mass-generate dozens of shallow puzzles simply to fill content.

Puzzle quality and conceptual originality are more important than content volume.

---

## 24. Initial Vertical Slice

The first meaningful milestone should be a tiny but genuinely playable slice.

It should contain:

* one alien transmission
* a small computational vocabulary
* a puzzle canvas
* component placement
* connections
* deterministic simulation
* inputs
* outputs
* test cases
* success/failure validation
* run
* pause
* reset
* step
* basic solution statistics
* serialization
* minimal puzzle editor

Then connect it to a minimal narrative loop:

**transmission → investigation → puzzle → discovery → scientific reaction → time advancement → next transmission**

Do not build the entire game before proving this loop works.

---

## 25. Long-Term Vision

The eventual game should progressively challenge the player's assumptions about what they are solving.

The player might begin by manipulating:

**logic**

then discover:

**computation**

then:

**information**

then:

**systems and emergence**

then:

**physical processes**

then:

**matter**

then:

**space**

then:

**time**

then:

**causality**

and eventually encounter increasingly alien mathematical descriptions of reality.

The exact progression is intentionally undefined.

The discoveries should emerge from good puzzle design rather than from a predetermined list of gimmicks.

The ultimate narrative explanation for:

* who sent the transmissions
* why they chose this form
* why they arrive progressively
* why humanity receives them
* whether they are gifts, tests, warnings, experiments, or something else

should remain open during early development.

Earlier puzzles should eventually acquire new meaning when viewed in light of later discoveries.

The final experience should leave the player with the feeling that they have not merely completed a puzzle game.

They have learned to see reality differently.