extends RefCounted


func run(t) -> void:
	var puzzle := PuzzleDefinition.load_path("res://data/puzzles/tx001_conjunction.json")
	t.case("puzzle definition loads")
	t.is_true(puzzle != null)
	t.eq(puzzle.id, "tx001_conjunction")
	t.eq(puzzle.test_cases.size(), 4)

	t.case("correct AND solution passes")
	var good := Construction.load_path("res://data/constructions/tx001_conjunction_sample.json")
	var result := Validator.validate(puzzle, good)
	t.is_true(result.passed, str(result.errors))

	t.case("OR solution fails AND puzzle")
	var wrong := Construction.from_dict({
		"puzzle_id": "tx001_conjunction",
		"components": [{"id": "or_1", "type": "OR", "config": {}}],
		"connections": [
			{"from": "in_a", "from_port": "out", "to": "or_1", "to_port": "a"},
			{"from": "in_b", "from_port": "out", "to": "or_1", "to_port": "b"},
			{"from": "or_1", "from_port": "out", "to": "out_y", "to_port": "in"},
		],
	})
	var wrong_result := Validator.validate(puzzle, wrong)
	t.is_false(wrong_result.passed)

	t.case("missing connections fail")
	var empty := Construction.from_dict({"puzzle_id": "tx001_conjunction", "components": [], "connections": []})
	var empty_result := Validator.validate(puzzle, empty)
	t.is_false(empty_result.passed)

	t.case("unknown component type is invalid")
	var bogus := Construction.from_dict({
		"puzzle_id": "tx001_conjunction",
		"components": [{"id": "x", "type": "WORMHOLE", "config": {}}],
		"connections": [],
	})
	var bogus_result := Validator.validate(puzzle, bogus)
	t.is_false(bogus_result.passed)
	t.is_true(str(bogus_result.errors).contains("Unknown") or str(bogus_result.errors).contains("not available"))

	t.case("max component constraint")
	var tight := puzzle
	tight.constraints = {"max_components": 0, "banned": []}
	var over := Validator.validate(tight, good)
	t.is_false(over.passed)

	t.case("banned component")
	puzzle.constraints = {"max_components": 8, "banned": ["AND"]}
	var banned := Validator.validate(puzzle, good)
	t.is_false(banned.passed)
	puzzle.constraints = {"max_components": 8, "banned": []}

	t.case("correct NOT solution passes second puzzle")
	var not_puzzle := PuzzleDefinition.load_path("res://data/puzzles/tx002_negation.json")
	var not_solution := Construction.load_path("res://data/constructions/tx002_negation_sample.json")
	t.eq(not_puzzle.available_components, PackedStringArray(["NOT"]))
	var not_result := Validator.validate(not_puzzle, not_solution)
	t.is_true(not_result.passed, str(not_result.errors))
	t.eq(not_result.tests.size(), 2)

	t.case("composition puzzle accepts combined primitives")
	var composition := PuzzleDefinition.load_path("res://data/puzzles/tx003_selective_inversion.json")
	var composition_solution := Construction.load_path("res://data/constructions/tx003_selective_inversion_sample.json")
	t.eq(composition.available_components, PackedStringArray(["AND", "NOT"]))
	t.is_true(Validator.validate(composition, composition_solution).passed)

	t.case("multiple test cases reported")
	t.eq(result.tests.size(), 4)
	for case_result in result.tests:
		t.is_true(case_result.passed, str(case_result))
