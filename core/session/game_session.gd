extends Node

signal session_changed

const SESSION_PATH := "user://session.json"
const CONSTRUCTION_DIR := "user://constructions"

var year: int = 2034
var completed_puzzles: PackedStringArray = PackedStringArray()
var unlocked_puzzles: PackedStringArray = PackedStringArray(["tx001_conjunction"])
var current_puzzle_id: String = "tx001_conjunction"
var timeline: Array = []
var scenes: Dictionary = {}
var last_event_id: String = "tx001"


func _ready() -> void:
	timeline = _load_json_array("res://data/timeline/timeline.json")
	scenes = _load_json_dict("res://data/narrative/scenes.json")
	load_session()


func load_session() -> void:
	var data = JsonUtil.load_file(SESSION_PATH)
	if typeof(data) != TYPE_DICTIONARY:
		save_session()
		return
	year = int(data.get("year", year))
	completed_puzzles = PackedStringArray(data.get("completed_puzzles", Array(completed_puzzles)))
	unlocked_puzzles = PackedStringArray(data.get("unlocked_puzzles", Array(unlocked_puzzles)))
	current_puzzle_id = str(data.get("current_puzzle_id", current_puzzle_id))
	last_event_id = str(data.get("last_event_id", last_event_id))
	session_changed.emit()


func save_session() -> void:
	JsonUtil.save_file(SESSION_PATH, {
		"year": year,
		"completed_puzzles": Array(completed_puzzles),
		"unlocked_puzzles": Array(unlocked_puzzles),
		"current_puzzle_id": current_puzzle_id,
		"last_event_id": last_event_id,
	})


func construction_path(puzzle_id: String) -> String:
	return CONSTRUCTION_DIR.path_join("%s.json" % puzzle_id)


func save_construction(construction: Construction) -> bool:
	return construction.save_path(construction_path(construction.puzzle_id))


func load_construction(puzzle_id: String) -> Construction:
	var path := construction_path(puzzle_id)
	if FileAccess.file_exists(path):
		return Construction.load_path(path)
	var construction := Construction.new()
	construction.puzzle_id = puzzle_id
	return construction


func complete_puzzle(puzzle_id: String) -> Dictionary:
	if completed_puzzles.has(puzzle_id):
		return {"year": year, "events": []}
	completed_puzzles.append(puzzle_id)
	var follow := _events_after_puzzle(puzzle_id)
	for event in follow:
		if event.get("type", "") == "cryosleep":
			year += int(event.get("years", 0))
			last_event_id = str(event.get("id", last_event_id))
		elif event.get("type", "") == "transmission":
			var next_puzzle := str(event.get("puzzle_id", ""))
			if next_puzzle != "" and not unlocked_puzzles.has(next_puzzle):
				unlocked_puzzles.append(next_puzzle)
			current_puzzle_id = next_puzzle
			last_event_id = str(event.get("id", last_event_id))
		elif event.get("type", "") == "discovery":
			last_event_id = str(event.get("id", last_event_id))
	save_session()
	session_changed.emit()
	return {"year": year, "events": follow}


func scene_for(scene_id: String) -> Dictionary:
	return scenes.get(scene_id, {})


func current_transmission() -> Dictionary:
	for event in timeline:
		if str(event.get("puzzle_id", "")) == current_puzzle_id:
			return event
	return {}


func available_puzzle_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for event in timeline:
		var puzzle_id := str(event.get("puzzle_id", ""))
		if puzzle_id != "" and unlocked_puzzles.has(puzzle_id):
			ids.append(puzzle_id)
	return ids


func _events_after_puzzle(puzzle_id: String) -> Array:
	var follow: Array = []
	var take := false
	for event in timeline:
		if str(event.get("requires_puzzle", "")) == puzzle_id or str(event.get("puzzle_id", "")) == puzzle_id and event.get("type", "") == "discovery":
			take = true
		if take and str(event.get("id", "")) != "tx001":
			if event.get("type", "") == "transmission" and str(event.get("puzzle_id", "")) == puzzle_id:
				continue
			follow.append(event)
			if event.get("type", "") == "transmission" and str(event.get("puzzle_id", "")) != puzzle_id:
				break
	return follow


func _load_json_array(path: String) -> Array:
	var parsed = JsonUtil.load_file(path)
	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed.get("events", [])
	if typeof(parsed) == TYPE_ARRAY:
		return parsed
	return []


func _load_json_dict(path: String) -> Dictionary:
	var parsed = JsonUtil.load_file(path)
	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed
	return {}
