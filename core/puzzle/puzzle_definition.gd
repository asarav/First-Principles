class_name PuzzleDefinition
extends RefCounted

var id: String = ""
var title: String = ""
var description: String = ""
var available_components: PackedStringArray = PackedStringArray()
var inputs: Array = []
var outputs: Array = []
var test_cases: Array = []
var constraints: Dictionary = {}
var scoring: Dictionary = {}
var narrative: Dictionary = {}
var unlock: Dictionary = {}
var source_path: String = ""


static func from_dict(data: Dictionary, path: String = "") -> PuzzleDefinition:
	var puzzle := PuzzleDefinition.new()
	puzzle.id = str(data.get("id", ""))
	puzzle.title = str(data.get("title", puzzle.id))
	puzzle.description = str(data.get("description", ""))
	puzzle.available_components = PackedStringArray(data.get("available_components", []))
	puzzle.inputs = data.get("inputs", [])
	puzzle.outputs = data.get("outputs", [])
	puzzle.test_cases = data.get("test_cases", [])
	puzzle.constraints = data.get("constraints", {})
	puzzle.scoring = data.get("scoring", {"mode": "pass_fail"})
	puzzle.narrative = data.get("narrative", {})
	puzzle.unlock = data.get("unlock", {})
	puzzle.source_path = path
	return puzzle


static func load_path(path: String) -> PuzzleDefinition:
	var parsed = JsonUtil.load_file(path)
	if typeof(parsed) != TYPE_DICTIONARY:
		return null
	return from_dict(parsed, path)


func input_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for item in inputs:
		ids.append(str(item.get("id", "")))
	return ids


func output_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for item in outputs:
		ids.append(str(item.get("id", "")))
	return ids


func io_component_id(kind: String, io_id: String) -> String:
	return "%s_%s" % [kind, io_id]


func problems() -> PackedStringArray:
	var issues := PackedStringArray()
	if id.is_empty():
		issues.append("Puzzle is missing an id.")
	if inputs.is_empty():
		issues.append("Puzzle has no inputs.")
	if outputs.is_empty():
		issues.append("Puzzle has no outputs.")
	if test_cases.is_empty():
		issues.append("Puzzle has no test cases.")
	return issues
