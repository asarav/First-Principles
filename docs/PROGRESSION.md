# First Principles Progression

## Purpose

This document defines the long-term progression for First Principles. It is a design direction, not an implementation plan. It does not add gameplay systems, lock down alien motives, or require every listed puzzle to ship unchanged.

The central progression is:

> computation -> space -> time -> information -> emergence -> physical systems -> spacetime and causality -> alien understanding -> contact

The player should not feel educated through a computer-science curriculum. They should feel that each solved artifact changes the question being asked.

The governing rhythm is:

1. The player forms a reasonable model.
2. The artifact behaves in a way that supports that model.
3. A later experiment breaks the model.
4. A new mechanic gives the player a better model.
5. Humanity changes because the new model is useful, dangerous, or both.

The first three implemented puzzles are the opening of this progression:

- `tx001_conjunction`: AND, the first repeatable relation.
- `tx002_negation`: NOT, the first transformation.
- `tx003_selective_inversion`: composition of AND and NOT.

They should remain small, but they must be treated as evidence in a much larger mystery rather than as the beginning of a gate-by-gate course.

---

## Design Rules

### Every landmark puzzle has three layers

- **Mechanical:** what the player physically constructs or manipulates.
- **Computational:** the abstract behavior demonstrated by the solution.
- **Physical or cosmological:** what the artifact might be describing in the universe.

The third layer is often uncertain. The game should distinguish observation, model, and interpretation.

### New mechanics arrive because the artifact requires them

Do not introduce a counter because counters are the next lesson. Introduce one because a transmission cannot be understood by a memoryless circuit. Do not introduce distance as a cosmetic property. Introduce it because moving two identical structures changes the result.

### Most eras contain 3-5 landmark puzzles

The outline below contains 36 major concepts across ten eras. Some are short experiments. Others are chapter-scale investigations with multiple stages, failed hypotheses, or optional solutions.

### Space and time arrive early

State and feedback establish the player's initial assumption that computation is input -> operation -> output over time. Spatial computation begins before that assumption has become comfortable. Time becomes a first-class puzzle language soon afterward.

### The alien interpretation stays open

The transmissions may be gifts, tests, warnings, invitations, experiments, or something else. The progression should support all of these possibilities until late in the story.

---

# Era I - Logic: What Is This Machine?

**Approximate period:** 2034-2044

**Purpose:** Establish signal, transformation, composition, feedback, and the first suspicion that simple rules are deliberately chosen. The player should discover the primitives experimentally, not collect a list of familiar gates.

**Humanity believes before this era:** The artifact is probably a communication device with a hidden encoding.

**Humanity believes after this era:** It is an executable structure. The message may be the behavior itself.

**Gameplay evolution:** Small boolean circuits, truth tables, construction, observation, deliberate counterexamples, limited feedback.

**Scientific interpretation:** Logic is not yet presented as computer science. It is treated as a set of experimentally confirmed relationships between signals.

### Landmark puzzles

1. **First Structure** - The player reconstructs the AND-like response currently represented by `tx001_conjunction`. Mechanical: connect two stimuli to one response. Computational: conjunction. Deeper question: why would an unknown civilization choose a relation so basic?

2. **Inverted Return** - The player reconstructs NOT, currently `tx002_negation`. Mechanical: one input, opposite response. Computational: transformation. Deeper question: is the artifact answering, correcting, or negating the question?

3. **Selective Inversion** - The player combines AND and NOT, currently `tx003_selective_inversion`. Mechanical: construct A AND NOT B. Computational: composition. Deeper question: are the primitives vocabulary, or are they physical constraints presented as logic?

4. **The Loop That Does Not Settle** - A feedback construction produces a response that never becomes stable. Mechanical: identify and constrain a feedback loop. Computational: oscillation and state. Deeper question: did the player build a broken machine, or an instrument for measuring time?

5. **The Quiet Memory** - A circuit must preserve a change after the initiating signal disappears. Mechanical: build a latch-like state using the available primitives. Computational: memory from feedback. Deeper question: the artifact stores history without a storage component.

**Era consequence:** A public dispute begins over whether the Array is decoding a message or reproducing an alien process. Governments fund competing interpretations. The player becomes a participant in a scientific argument, not a lone solver.

---

# Era II - State and Computation: How Does the Machine Behave?

**Approximate period:** 2044-2055

**Purpose:** Establish state, sequencing, conditional behavior, and compact computation quickly. This era exists to create an assumption that computation is a sequence of operations. That assumption must be ready to break by the end of the era.

**Humanity believes before this era:** A machine computes by applying operations to inputs over successive moments.

**Humanity believes after this era:** That model works, but only for a restricted class of artifacts.

**Gameplay evolution:** Explicit state, clocks or pulses, run history, counters, branching behavior, and short temporal experiments.

**Scientific interpretation:** The Array moves from static circuit reconstruction to behavioral modeling. Scientists disagree about whether state is an internal object or a property of an interaction.

### Landmark puzzles

6. **The Second Question** - The same input produces different output depending on what happened previously. Mechanical: construct a memory-dependent response. Computational: state. Deeper question: is history an input that was not shown to us?

7. **The Delayed Agreement** - Two signals must be accepted only if they arrive in a particular order. Mechanical: sequence and delay. Computational: temporal ordering. Deeper question: does the artifact care about events or only their final values?

8. **The Counterfeit Clock** - A repeating signal appears to be a clock, but changing its phase changes the artifact's interpretation. Mechanical: build a counter or divider. Computational: periodic state. Deeper question: is time intrinsic to the artifact or supplied by the observer?

9. **The Conditional Path** - One result selects which later experiment becomes relevant. Mechanical: conditional routing. Computational: branching. Deeper question: the machine appears to choose what question will be asked next.

10. **The Smallest Program** - Multiple constructions work, but only one survives a constraint that changes between tests. Mechanical: find a compact stateful construction. Computational: representation and algorithmic economy. Deeper question: the constraint may be communicating a preference rather than enforcing a limit.

**Era consequence:** The Array develops reliable alien-derived control systems. The first generation of scientists who solved the opening artifacts begins to retire or enter cryosleep. Their language survives in archives, while later institutions reinterpret their findings.

---

# Era III - Space: Where Does Computation Happen?

**Approximate period:** 2055-2080

**Purpose:** Introduce spatial structure before conventional computing feels complete. Geometry stops being a layout concern and becomes part of the rule.

**Humanity believes before this era:** A circuit's geometry is an engineering convenience. Only connections and component behavior matter.

**Humanity believes after this era:** Position, adjacency, path, and topology can be computational primitives.

**Gameplay evolution:** Spatial coordinates, neighborhoods, paths, crossings, distance, topology, and geometric constraints. These puzzles should not be solved by merely drawing familiar gates in a new arrangement.

**Scientific interpretation:** The alien artifact may describe processes that happen in space rather than calculations represented on a diagram.

### Landmark puzzles

11. **The Long Way Round** - A response changes when a signal takes a longer route, even though the logical endpoints are identical. Mechanical: route signals through paths with distance-dependent behavior. Computational: distance as a parameter. Deeper question: is the diagram a map of a physical medium?

12. **Neighbors** - A component responds only to what is adjacent, not to what is directly connected. Mechanical: place objects into neighborhoods. Computational: local spatial relation. Deeper question: connection may be less fundamental than proximity.

13. **The Crossing** - Two paths cross without interacting in one arrangement and interact in another. Mechanical: solve an intersection/topology puzzle. Computational: crossings and topology. Deeper question: what does it mean for two processes to occupy the same place?

14. **The Shortest Explanation** - The artifact accepts only a shortest or equal-length path. Mechanical: optimize a spatial construction under changing obstacles. Computational: geometry as selection. Deeper question: the artifact may be measuring an extremum, not executing instructions.

**Era consequence:** Alien-derived routing improves communications and navigation. A new school of science argues that geometry should be treated as executable law. The next transmissions arrive with fewer recognizable component boundaries.

---

# Era IV - Time: When Does Computation Happen?

**Approximate period:** 2080-2140

**Purpose:** Make time a first-class computational dimension. Begin with familiar delay and synchronization, then shift toward relationships between events rather than a single sequence.

**Humanity believes before this era:** Time is a clock attached to computation.

**Humanity believes after this era:** Temporal order may be part of what the artifact computes.

**Gameplay evolution:** Delay, synchronization, race conditions, cycles, reversible operations, event graphs, and eventually partial ordering.

**Scientific interpretation:** The Array cannot safely describe an artifact with a single global clock. Different observers may record compatible but non-identical sequences.

### Landmark puzzles

15. **The Late Arrival** - A correct signal is rejected if it arrives too early or too late. Mechanical: construct a delay and timing window. Computational: temporal tolerance. Deeper question: is timing data or merely a physical side effect?

16. **The Race** - Two valid paths compete, and the winner determines the response. Mechanical: tune delays and race conditions. Computational: ordering by arrival. Deeper question: the artifact may be using uncertainty rather than eliminating it.

17. **The Reversible Door** - A machine must be run forward and backward without losing a distinguishable state. Mechanical: reversible construction. Computational: reversible computation. Deeper question: what is preserved when a process is undone?

18. **The Event Lattice** - No single sequence satisfies all observations, but a partial ordering does. Mechanical: arrange events so required relations hold without choosing one universal order. Computational: event relationships. Deeper question: perhaps there is no privileged present.

**Era consequence:** Cryosleep becomes a practical scientific tool rather than an emergency interval. The Array's institutions diverge: some preserve continuity across centuries, while others treat each awakening as a new civilization inheriting old evidence.

---

# Era V - Information: What Is Actually Preserved?

**Approximate period:** 2140-2250

**Purpose:** Introduce encoding, redundancy, compression, error correction, entropy, and preservation only after space and time have made information feel physical.

**Humanity believes before this era:** Information is a description carried by a machine.

**Humanity believes after this era:** Information may be a conserved property of a process, and preservation may have a cost.

**Gameplay evolution:** Encodings, noisy channels, redundancy, reconstruction, compression, irreversible loss, and reversible representations.

**Scientific interpretation:** A transmission can remain intelligible even when its physical carrier is damaged. This suggests that the artifact is designed around invariants rather than objects.

### Landmark puzzles

19. **The Damaged Sentence** - Recover a signal after controlled corruption. Mechanical: build redundancy and correction. Computational: error correction. Deeper question: is the message defined by its symbols or by what survives damage?

20. **The Folded Archive** - Compress a large state space without losing the distinctions the next artifact tests. Mechanical: construct a reversible encoding. Computational: compression and representation. Deeper question: what counts as the same state?

21. **The One-Way Cabinet** - A machine can produce a result but cannot reconstruct its input unless an auxiliary trace is preserved. Mechanical: manage information loss. Computational: irreversibility. Deeper question: is entropy an accounting rule or a physical direction?

22. **The Redundant World** - Several different local descriptions decode to one global artifact, while one missing relation makes reconstruction impossible. Mechanical: distributed redundancy. Computational: error-tolerant representation. Deeper question: the whole may contain information that no part possesses.

**Era consequence:** Civilizations disagree over whether alien artifacts should be copied, compressed, or left untouched. Long-term archives become political institutions. Human culture begins to change as people live across discontinuous periods through stored records and revived identities.

---

# Era VI - Emergence: What If We Do Not Specify the Result?

**Approximate period:** 2250-2500

**Purpose:** Shift the player's role from constructing a result to constructing local rules that produce a result. This is the first major change in authorship.

**Humanity believes before this era:** A machine is understandable if every meaningful operation can be named.

**Humanity believes after this era:** A system can be understood through stable global behavior even when no local part contains that behavior.

**Gameplay evolution:** Cellular systems, local rules, synchronization, distributed computation, self-organization, and emergent structures.

**Scientific interpretation:** The alien civilization may not think in terms of programs at all. It may specify conditions under which behavior becomes inevitable.

### Landmark puzzles

23. **The Pattern Without a Center** - Produce a target pattern using only local neighbor rules. Mechanical: tune local interactions. Computational: distributed computation. Deeper question: where is the computation happening if no component knows the answer?

24. **The Self-Sorting Field** - A disordered system must settle into a meaningful arrangement without a central controller. Mechanical: choose local rules and initial conditions. Computational: self-organization. Deeper question: order may be an attractor, not an instruction.

25. **The Synchrony Trap** - A rule set that synchronizes a small system fails at larger scale. Mechanical: solve scale-dependent synchronization. Computational: distributed coordination. Deeper question: the artifact may be teaching a limit rather than a technique.

26. **The Living Boundary** - A boundary condition causes structures inside a field to persist, migrate, or reproduce. Mechanical: shape a field rather than wire a circuit. Computational: emergent stability. Deeper question: the machine begins to resemble a physical system more than a diagram.

**Era consequence:** Human institutions copy the artifacts into infrastructure. Some communities treat the systems as tools; others treat them as artificial organisms or models of life. The Array cannot agree whether emergence is a property of the artifact or of the observer's description.

---

# Era VII - Physical Systems: Are These Models of Reality?

**Approximate period:** 2500-4000

**Purpose:** Connect computational behavior to matter, fields, energy, probability, symmetry, and conservation without presenting a textbook chapter called Physics.

**Humanity believes before this era:** The artifacts are abstract machines that happen to resemble physical processes.

**Humanity believes after this era:** Some artifacts may be executable descriptions of possible physical systems.

**Gameplay evolution:** Continuous or quantized values, fields, particles, conservation constraints, probability, symmetry, and interaction. The interface may stop looking like a circuit editor.

**Scientific interpretation:** A successful construction predicts observations in laboratories, but the player cannot tell whether the artifact models nature or changes what nature can do.

### Landmark puzzles

27. **The Conserved Difference** - Transform a distribution while preserving a hidden quantity. Mechanical: manipulate states under a conservation law. Computational: invariant. Deeper question: the machine's "score" is a physical quantity.

28. **The Field That Remembers** - A local disturbance produces a global pattern that can be read later. Mechanical: shape a field and recover a trace. Computational: distributed memory. Deeper question: memory may be geometry or energy, not storage.

29. **The Symmetry Break** - Symmetric inputs produce asymmetric outcomes only after a small perturbation. Mechanical: control instability and probability. Computational: symmetry and selection. Deeper question: did the artifact choose, or did the player merely expose a choice already present?

30. **The Impossible Reservoir** - A construction appears to produce more usable energy than it consumes until a hidden boundary condition is modeled. Mechanical: find the missing constraint. Computational: conservation and measurement. Deeper question: the artifact may be warning against a category error in human physics.

**Era consequence:** Human technology becomes radically more capable but less culturally unified. Some civilizations use the artifacts for energy and materials; others impose knowledge quarantines. The transmissions become a source of law, religion, and economic conflict without revealing an alien face.

---

# Era VIII - Spacetime and Causality: What If the Dimensions Are the Computation?

**Approximate period:** 4000-10000

**Purpose:** Combine space, time, state, and information. The interface should change enough to make the player feel that the original workbench was a special case, while the conceptual lineage remains visible.

**Humanity believes before this era:** Space and time are the stage on which computation occurs.

**Humanity believes after this era:** The stage may be part of the computation, and causality may be a relation that can be constructed.

**Gameplay evolution:** Reference frames, event graphs, causal constraints, spacetime geometry, propagation limits, reversible processes, and information horizons.

**Scientific interpretation:** Human observers can agree on local results while disagreeing about global event order. The alien artifacts may be defining allowable causal structures rather than simulating them.

### Landmark puzzles

31. **The Two Observers** - Satisfy two observers whose measurements use different spatial and temporal coordinates. Mechanical: construct a relation invariant under a transformation. Computational: reference frames. Deeper question: which description is the machine's true one?

32. **The Closed Cause** - A set of events can only be made consistent by allowing a cycle of influence. Mechanical: solve a causal event graph. Computational: causal loops and consistency. Deeper question: explanation may not have a first event.

33. **The Horizon** - Information can cross some boundaries but not others. Mechanical: route information under a causal limit. Computational: reachability and horizon. Deeper question: an inaccessible region may still determine what can be known.

34. **The Rewritten Experiment** - Changing a late condition changes which earlier histories remain valid, without allowing a simple contradiction. Mechanical: manipulate a space of histories. Computational: counterfactual and reversible causal structure. Deeper question: the artifact may compute over possibilities, not one timeline.

**Era consequence:** Human civilization fragments across time scales and causal access. A political decision in one era may be experienced as an inherited physical fact in another. The player is no longer solving a machine so much as negotiating a consistent world description.

---

# Era IX - Alien Computation: Have We Misunderstood Everything?

**Approximate period:** 10000-50000

**Purpose:** Reinterpret the accumulated vocabulary. The player discovers that human names such as AND, memory, space, and time are translations that may have discarded the alien concepts' essential relationships.

**Humanity believes before this era:** Humanity has gradually learned the alien language of computation.

**Humanity believes after this era:** Humanity has built a useful but lossy translation layer. The alien artifacts were not a linear curriculum.

**Gameplay evolution:** Multiple valid formalisms for one artifact, translation between puzzle paradigms, ambiguity, model comparison, and deliberate underdetermination.

**Scientific interpretation:** Early primitives may be projections of a deeper operation. The same artifact may appear as a gate, a field, or an event relation depending on the observer's chosen representation.

### Landmark puzzles

35. **The Same Machine, Three Descriptions** - Solve one artifact as a circuit, a spatial field, and an event graph. Mechanical: prove equivalence across representations. Computational: abstraction and translation. Deeper question: which description belongs to the alien?

36. **The Primitive Revisited** - The original NOT/AND artifact returns with a new test that exposes a spatial or temporal property invisible in 2034. Mechanical: revisit an early construction under a new vocabulary. Computational: reinterpretation. Deeper question: the first "logic gate" may have been a boundary condition.

**Era consequence:** Human institutions stop claiming that each solved artifact is a lesson in a known sequence. The transmission archive is reclassified as a set of partial views into an unknown ontology.

---

# Era X - Contact: What Were They Trying to Communicate?

**Approximate period:** 50000 and beyond

**Purpose:** Make contact the consequence of comprehension. The player does not win because aliens arrive. Humanity becomes able to understand a previously inaccessible exchange.

**Humanity believes before this era:** Contact is a message, location, or event waiting to happen.

**Humanity believes after this era:** Contact is a mutual change in what each civilization can recognize as a question.

**Gameplay evolution:** The final artifacts may combine representations, require collaborative interpretation, or allow the player to choose what model to send back. The final interface may be unlike the opening workbench.

**Scientific interpretation:** The transmissions may have been an invitation, an experiment, a warning, a preservation system, or communication between physical processes rather than biological speakers.

### Landmark puzzles

37. **The Unaskable Question** - Construct a query that cannot be represented in the human vocabulary built so far. Mechanical: identify and bridge a missing abstraction. Computational: meta-computation and expressiveness. Deeper question: what does it mean to ask a machine for a concept it cannot name?

38. **The Reply** - Use the accumulated translations to produce a response that is recognizable across incompatible representations. Mechanical: preserve meaning while changing formalism. Computational: communication across ontologies. Deeper question: the reply is not a sentence but a shared operation.

39. **The First Recognition** - The final artifact changes when humanity demonstrates not a correct output but an understanding of why multiple descriptions agree. Mechanical: construct a self-describing or mutually interpretable system. Computational: semantic equivalence. Deeper question: is recognition the actual contact event?

---

# Timeline and Civilization

The dates are approximate anchors, not a promise that every chapter occurs on a fixed schedule.

| Period | Story state | Civilization consequence |
|---|---|---|
| 2034-2044 | First primitives and feedback | Deep Space Array becomes a permanent international institution. |
| 2044-2055 | State and sequencing | Alien-derived control systems enter research infrastructure. |
| 2055-2080 | Spatial computation | Navigation, routing, and architecture change. Geometry becomes an engineering discipline with computational status. |
| 2080-2140 | Temporal relations | Cryosleep becomes routine for long investigations. Institutions begin to span generations. |
| 2140-2250 | Information and preservation | Archives, identity records, and data continuity become political questions. |
| 2250-2500 | Emergence | Distributed systems reshape governance and infrastructure. Local decisions have civilization-scale effects. |
| 2500-4000 | Physical systems | Energy, materials, and probability technologies produce divergent human futures. |
| 4000-10000 | Spacetime and causality | Humanity fragments across causal and temporal contexts. Shared history becomes less obvious. |
| 10000-50000 | Alien computation | Human scientific vocabulary is revised; old discoveries are reinterpreted. |
| 50000+ | Contact | Contact occurs through mutual intelligibility, not a simple arrival. |

Every major time jump should show concrete changes in at least three categories:

- infrastructure and technology
- institutions and scientific language
- relationships, culture, or attitudes toward the transmissions

A cryosleep transition should never be only a year label. It should make the player feel that the world continued without them.

---

# Candidate Conceptual Reversals

These are mechanics-first reversals, not merely plot twists.

1. **The first gate is a boundary condition.** The opening AND behavior was not a logical primitive in isolation; it was the visible edge of a spatial or physical process.
2. **The unstable circuit is an instrument.** The player initially treats feedback as failure, then learns that oscillation is the artifact's clock or measurement channel.
3. **Distance is not delay.** A spatial puzzle that resembles signal latency turns out to compute with geometry itself.
4. **The shortest path is a selection rule.** Optimization is not a convenience; the artifact is evaluating possible worlds by an extremal relation.
5. **There is no universal clock.** A timing puzzle becomes consistent only when events are partially ordered rather than placed in one sequence.
6. **Error correction preserves identity, not symbols.** Damaged transmissions remain meaningful because the invariant is distributed across the system.
7. **The result is nowhere local.** An emergent pattern cannot be found inside any component, forcing a new idea of where computation happens.
8. **A conservation law is a memory.** A physical quantity carries history through a system without a storage register.
9. **The observer is part of the artifact.** Two valid descriptions disagree until the player's measurement context is included.
10. **The same primitive changes meaning.** AND and NOT later appear as projections of a deeper relation, not as alien equivalents of human gates.
11. **The transmissions are not ordered lessons.** Their apparent sequence was imposed by human archive conventions and survival bias.
12. **Contact is recognition.** The final exchange becomes possible when two systems can preserve a relation across incompatible descriptions.

---

# Early Foreshadowing

Space and time should be present before their eras arrive, but not explained prematurely.

- The first puzzle's node positions should be saved and restored, hinting that geometry may matter later.
- Feedback should produce visible timing behavior before the game calls it a clock.
- The first artifacts can contain unused spacing, repeated distances, or unexplained timing tolerances.
- A connection that is logically redundant in Era I can later be recognized as a geometric or causal marker.
- The opening AND/NOT vocabulary should recur in later artifacts as a special case of a broader operation.
- Early narrative characters should disagree about whether the diagram is a representation or the artifact itself.

---

# Engine Evolution Required

The current architecture is appropriate for the opening, but these future mechanics require real extensions.

## Manageable extensions

- typed values beyond booleans
- explicit component state and clocks
- deterministic event scheduling
- puzzle-defined constraints and scoring
- alternate graph-based puzzle families sharing validation interfaces
- data-driven timeline and civilization state
- replayable experiments and deterministic traces

## Substantial extensions

- spatial rules where distance and adjacency affect simulation
- non-circuit boards or fields with spatial neighborhoods
- continuous or probabilistic values with reproducible seeds
- temporal puzzles with delays, race conditions, and partial orders
- reversible execution and branching histories
- cellular or distributed simulations at useful scale
- multiple equivalent representations of one artifact
- causal graphs and consistency checking
- large-timescale persistence and civilization snapshots
- presentation that can change paradigms without pretending every system is a GraphEdit

The engine should preserve a shared conceptual contract rather than force every future puzzle into the current `Machine` API. A future puzzle family should expose deterministic setup, run, inspect, validate, and replay behavior even if its internal representation is not a circuit.

---

# Intentionally Unresolved

Do not decide these early:

- the aliens' biology, identity, or physical location
- whether the transmissions are benevolent, adversarial, or indifferent
- whether they are a curriculum, test, warning, invitation, or byproduct
- whether the alien civilization still exists
- whether the artifacts alter reality or only model it
- whether human interpretation is converging or merely becoming more sophisticated
- whether contact requires sending a reply, changing humanity, or recognizing an existing relation
- whether the final contact is singular, distributed, or impossible to localize

The unresolved questions should create pressure on interpretation without replacing puzzle design with mystery-box narration.

---

# Self-Critique and Revision

The first draft of this progression was deliberately comprehensive, but it still contained risks.

## Where it could feel like a CS textbook

- Era II can become a lesson plan if counters, branching, and sequencing arrive as isolated feature unlocks.
- Era V can become an information-theory glossary if compression and error correction are named before the player feels the loss.
- The list of 39 concepts can encourage a level-by-level checklist mentality.

**Revision:** Treat the listed concepts as landmark investigations, not mandatory one-mechanic levels. Combine several concepts inside chapter-scale artifacts. Introduce terms only after the player has observed the behavior. Era II should end quickly, and Era V should begin with a damaged artifact rather than a lecture about encoding.

## Where the progression is too slow

- Five separate early logic puzzles would be too much if they only teach more gates.
- Four spatial puzzles could repeat pathfinding unless their rules genuinely change.
- Four physical-system puzzles could become a conventional physics survey.

**Revision:** Keep the implemented AND, NOT, and composition puzzles as the opening vocabulary, then make feedback, space, and timing appear in the next major artifact. Merge routine state/counter content into two or three larger investigations. Use spatial and temporal mechanics before the player feels they have mastered ordinary computing.

## Where concepts lack narrative justification

- Counters and reversible computation require a transmission whose behavior cannot be explained without them.
- Compression should arise from a damaged or bandwidth-limited artifact, not from a desire to teach compression.
- Physical systems need a laboratory consequence that forces competing interpretations.

**Revision:** Every landmark transmission should state the unresolved observation that makes the new mechanic necessary. A chapter cannot introduce a tool unless the previous model fails in a visible way.

## Where space and time should arrive earlier

- Spatial hints begin in Era I through positions, route lengths, and unexplained distances.
- Feedback in Era I is already a temporal phenomenon before it is named as state.
- The first clearly spatial puzzle should arrive at the end of Era II or the beginning of Era III.
- The first timing puzzle should arrive before the state era is complete.

**Revision:** Do not gate spatial computation behind a long memory curriculum. The transition should occur after roughly five to seven landmark investigations, not after an entire conventional computing arc.

## Eras that can be merged

- Era I and the first half of Era II are one opening investigation into behavior, memory, and composition.
- Era V and Era VII can share artifacts where information preservation is demonstrated through physical invariants.
- Era VIII and Era IX should overlap: reinterpretation should begin as soon as spacetime puzzles undermine a single representation.

**Revision:** The ten eras are presentation lenses, not hard chapter walls. A practical game could use seven or eight seasons while preserving all ten questions.

## Stronger possible reversals

- The first spatial puzzle should not merely say "distance matters." It should make a familiar logical solution fail because two equivalent diagrams have different topology.
- The first temporal puzzle should not merely add delay. It should allow two incompatible-looking event orders that both satisfy the artifact.
- The first emergent puzzle should show a global response that cannot be localized even with perfect inspection.
- The return to the opening primitive should invalidate a cherished human translation, not merely add a new feature.

## Repetition risks

- Repeatedly routing signals can become the same puzzle with different layouts.
- Repeated cryosleep scenes can turn time into a loading screen.
- Repeated debates about alien motives can become exposition without evidence.
- Repeated "this is stranger than we thought" scenes can flatten the impact of genuine reversals.

**Revision:** Each time jump must alter institutions, language, or social context, not only the year. Each era needs a different player action and a different kind of wrong assumption. At least one major puzzle per era should produce a useful result that is not a simple pass/fail.

## Narrative and gameplay connection risks

- A discovery scene that merely explains the completed truth table is not enough.
- A civilization consequence that does not affect later puzzle conditions is decoration.
- A puzzle mechanic with no character disagreement is technically interesting but narratively inert.

**Revision:** For every landmark puzzle, record the pre-solve belief, post-solve belief, technological consequence, civilization consequence, and new question. Later artifacts should refer back to earlier discoveries mechanically as well as in dialogue. The third puzzle's use of AND and NOT is the first small example of this rule.

## Final revised pacing

The recommended first act is:

- 3 small primitives/composition puzzles: AND, NOT, selective inversion.
- 2 feedback/state investigations.
- 1 early spatial or topology reversal.
- 1 timing investigation that breaks the single-clock assumption.

At that point the player has experienced logic, composition, feedback, state, space, and time without completing a conventional computer-science course. Information, emergence, and physical systems can then deepen the questions rather than delaying the identity of the game.

The progression should always return to the same promise:

> The player is not learning how to build computers.
> The player is learning why computation can exist at all.
