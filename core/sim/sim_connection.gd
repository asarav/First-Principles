class_name SimConnection
extends RefCounted

var from_id: String = ""
var from_port: String = ""
var to_id: String = ""
var to_port: String = ""


func _init(p_from_id: String = "", p_from_port: String = "", p_to_id: String = "", p_to_port: String = "") -> void:
	from_id = p_from_id
	from_port = p_from_port
	to_id = p_to_id
	to_port = p_to_port


func key() -> String:
	return "%s.%s->%s.%s" % [from_id, from_port, to_id, to_port]


func to_dict() -> Dictionary:
	return {
		"from": from_id,
		"from_port": from_port,
		"to": to_id,
		"to_port": to_port,
	}


static func from_dict(data: Dictionary) -> SimConnection:
	return SimConnection.new(
		str(data.get("from", "")),
		str(data.get("from_port", "")),
		str(data.get("to", "")),
		str(data.get("to_port", ""))
	)
