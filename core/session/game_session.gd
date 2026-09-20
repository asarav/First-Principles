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
var intro_seen: bool = false


func _ready() -> void:
	timeline = _load_json_array("res://data/timeline/timeline.json")
	scenes = _load_json_dict("res://data/narrative/scenes.json")
	load_session()
	_repair_progression()


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
	intro_seen = bool(data.get("intro_seen", intro_seen))
	session_changed.emit()


func save_session() -> void:
	JsonUtil.save_file(SESSION_PATH, {
		"year": year,
		"completed_puzzles": Array(completed_puzzles),
		"unlocked_puzzles": Array(unlocked_puzzles),
		"current_puzzle_id": current_puzzle_id,
		"last_event_id": last_event_id,
		"intro_seen": intro_seen,
	})


func reset_session() -> void:
	year = 2034
	completed_puzzles = PackedStringArray()
	unlocked_puzzles = PackedStringArray(["tx001_conjunction"])
	current_puzzle_id = "tx001_conjunction"
	last_event_id = "tx001"
	intro_seen = false
	save_session()
	session_changed.emit()


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
		_repair_progression()
		save_session()
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


func _repair_progression() -> void:
	for event in timeline:
		if event.get("type", "") != "transmission":
			continue
		var required := str(event.get("unlock_after", ""))
		var next_puzzle := str(event.get("puzzle_id", ""))
		if required != "" and completed_puzzles.has(required) and next_puzzle != "" and not unlocked_puzzles.has(next_puzzle):
			unlocked_puzzles.append(next_puzzle)
	if current_puzzle_id == "" or completed_puzzles.has(current_puzzle_id):
		for event in timeline:
			var candidate := str(event.get("puzzle_id", ""))
			if candidate != "" and unlocked_puzzles.has(candidate) and not completed_puzzles.has(candidate):
				current_puzzle_id = candidate
				break


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
