extends RefCounted


func run(t) -> void:
	t.case("construction round-trip")
	var original := Construction.load_path("res://data/constructions/tx001_conjunction_sample.json")
	var path := "user://tests/roundtrip.json"
	t.is_true(original.save_path(path))
	var loaded := Construction.load_path(path)
	t.eq(loaded.puzzle_id, original.puzzle_id)
	t.eq(loaded.components.size(), original.components.size())
	t.eq(loaded.connections.size(), original.connections.size())
	t.eq(JSON.stringify(loaded.to_dict()), JSON.stringify(original.to_dict()))

	t.case("invalid json is empty construction")
	var missing := Construction.load_path("res://data/constructions/does_not_exist.json")
	t.eq(missing.puzzle_id, "")
	t.eq(missing.components.size(), 0)

	t.case("puzzle json round-trip fields")
	var puzzle := PuzzleDefinition.load_path("res://data/puzzles/tx002_negation.json")
	t.eq(puzzle.title, "Inverted Return")
	t.eq(puzzle.inputs.size(), 1)
	t.eq(puzzle.outputs.size(), 1)

	t.case("malformed file does not crash")
	var parsed = JsonUtil.load_file("res://data/puzzles/tx001_conjunction.json")
	t.is_true(typeof(parsed) == TYPE_DICTIONARY)
