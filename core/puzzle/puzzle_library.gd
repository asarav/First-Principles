class_name PuzzleLibrary
extends RefCounted

const PUZZLE_DIR := "res://data/puzzles"


static func load_all() -> Dictionary:
	var puzzles := {}
	var dir := DirAccess.open(PUZZLE_DIR)
	if dir == null:
		return puzzles
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var path := PUZZLE_DIR.path_join(file_name)
			var puzzle := PuzzleDefinition.load_path(path)
			if puzzle and puzzle.id != "":
				puzzles[puzzle.id] = puzzle
		file_name = dir.get_next()
	dir.list_dir_end()
	return puzzles


static func load_id(puzzle_id: String) -> PuzzleDefinition:
	var puzzles := load_all()
	return puzzles.get(puzzle_id, null)
