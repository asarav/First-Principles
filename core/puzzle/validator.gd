class_name Validator
extends RefCounted


static func validate(puzzle: PuzzleDefinition, construction: Construction) -> Dictionary:
	var result := {
		"passed": false,
		"errors": [],
		"constraint_errors": [],
		"tests": [],
		"stats": {},
		"inspect": {},
	}
	if puzzle == null:
		result.errors.append("Puzzle definition is missing.")
		return result

	var definition_problems := puzzle.problems()
	for problem in definition_problems:
		result.errors.append(problem)
	if not definition_problems.is_empty():
		return result

	var constraint_errors := _constraint_errors(puzzle, construction)
	result.constraint_errors = constraint_errors
	result.errors.append_array(constraint_errors)

	var machine := MachineBuilder.build(puzzle, construction)
	for error in machine.errors:
		result.errors.append(error)
	result.stats = {
		"component_count": construction.components.size() if construction else 0,
		"connection_count": construction.connections.size() if construction else 0,
	}

	if not result.errors.is_empty():
		result.inspect = machine.inspect()
		return result

	var tests: Array = []
	var all_passed := true
	for case in puzzle.test_cases:
		var case_result := _run_case(puzzle, machine, case)
		tests.append(case_result)
		if not case_result.passed:
			all_passed = false
	result.tests = tests
	result.passed = all_passed
	result.inspect = machine.inspect()
	if not all_passed:
		result.errors.append("One or more test cases failed.")
	return result


static func _constraint_errors(puzzle: PuzzleDefinition, construction: Construction) -> Array:
	var errors: Array = []
	if construction == null:
		errors.append("Construction is missing.")
		return errors
	if construction.puzzle_id != "" and construction.puzzle_id != puzzle.id:
		errors.append("Construction puzzle_id %s does not match %s." % [construction.puzzle_id, puzzle.id])

	var max_components := int(puzzle.constraints.get("max_components", 64))
	if construction.components.size() > max_components:
		errors.append("Too many components (%d > %d)." % [construction.components.size(), max_components])

	var banned: Array = puzzle.constraints.get("banned", [])
	var allowed := {}
	for type_id in puzzle.available_components:
		allowed[type_id] = true
	for item in construction.components:
		var type_id := str(item.get("type", ""))
		if banned.has(type_id):
			errors.append("Banned component type: %s" % type_id)
		elif not allowed.has(type_id):
			errors.append("Component type is not available in this puzzle: %s" % type_id)
		if not ComponentTypes.is_player_placeable(type_id):
			errors.append("Component type cannot be placed by the player: %s" % type_id)
	return errors


static func _run_case(puzzle: PuzzleDefinition, machine: Machine, case: Dictionary) -> Dictionary:
	var case_id := str(case.get("id", "unnamed"))
	machine.errors = PackedStringArray()
	var inputs: Dictionary = case.get("inputs", {})
	for io in puzzle.inputs:
		var io_id := str(io.get("id", ""))
		var component_id := puzzle.io_component_id("in", io_id)
		if not inputs.has(io_id):
			return {
				"id": case_id,
				"passed": false,
				"reason": "Test case is missing input '%s'." % io_id,
				"outputs": {},
			}
		machine.set_input(component_id, SignalValue.from_variant(inputs[io_id]))

	var settled := machine.settle()
	var outputs := {}
	var expected: Dictionary = case.get("expected", {})
	var failed := false
	var reasons: PackedStringArray = PackedStringArray()
	if not settled:
		failed = true
		reasons.append("Machine did not settle.")
	for io in puzzle.outputs:
		var io_id := str(io.get("id", ""))
		var component_id := puzzle.io_component_id("out", io_id)
		var actual := machine.get_output(component_id)
		outputs[io_id] = actual.to_debug_string()
		if not expected.has(io_id):
			failed = true
			reasons.append("Test case is missing expected output '%s'." % io_id)
			continue
		var want := SignalValue.from_variant(expected[io_id])
		if not actual.equals(want):
			failed = true
			reasons.append("Output %s was %s, expected %s." % [io_id, actual.to_debug_string(), want.to_debug_string()])
	return {
		"id": case_id,
		"passed": not failed,
		"reason": " ".join(reasons),
		"outputs": outputs,
		"settle_iterations": machine.last_settle_iterations,
	}
