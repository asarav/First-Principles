class_name Construction
extends RefCounted

## Player-built machine, independent of scene nodes. Positions are presentation
## metadata stored here so save/load can restore the editor without the sim
## needing to know about UI.

var puzzle_id: String = ""
var components: Array = []
var connections: Array = []


func to_dict() -> Dictionary:
	return {
		"puzzle_id": puzzle_id,
		"components": components.duplicate(true),
		"connections": connections.duplicate(true),
	}


static func from_dict(data: Dictionary) -> Construction:
	var construction := Construction.new()
	if data.is_empty():
		return construction
	construction.puzzle_id = str(data.get("puzzle_id", ""))
	construction.components = data.get("components", [])
	construction.connections = data.get("connections", [])
	return construction


static func load_path(path: String) -> Construction:
	var parsed = JsonUtil.load_file(path)
	if typeof(parsed) != TYPE_DICTIONARY:
		return Construction.new()
	return from_dict(parsed)


func save_path(path: String) -> bool:
	return JsonUtil.save_file(path, to_dict())


func next_component_id(type_id: String) -> String:
	var prefix := type_id.to_lower()
	var used := {}
	for item in components:
		used[str(item.get("id", ""))] = true
	var index := 1
	while used.has("%s_%d" % [prefix, index]):
		index += 1
	return "%s_%d" % [prefix, index]
