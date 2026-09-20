extends RefCounted


func run(t) -> void:
	var session := preload("res://core/session/game_session.gd").new()
	session.timeline = session._load_json_array("res://data/timeline/timeline.json")
	session.scenes = session._load_json_dict("res://data/narrative/scenes.json")
	var original_year := int(session.year)
	var original_completed := session.completed_puzzles.duplicate()
	var original_unlocked := session.unlocked_puzzles.duplicate()
	var original_current := session.current_puzzle_id

	session.year = 2034
	session.completed_puzzles = PackedStringArray()
	session.unlocked_puzzles = PackedStringArray(["tx001_conjunction"])
	session.current_puzzle_id = "tx001_conjunction"

	t.case("completion unlocks next puzzle")
	var result := session.complete_puzzle("tx001_conjunction")
	t.is_true(session.unlocked_puzzles.has("tx002_negation"))
	t.eq(session.current_puzzle_id, "tx002_negation")
	t.eq(session.available_puzzle_ids().size(), 2)
	t.is_true(result.events.size() >= 3)

	session.year = original_year
	session.completed_puzzles = original_completed
	session.unlocked_puzzles = original_unlocked
	session.current_puzzle_id = original_current
