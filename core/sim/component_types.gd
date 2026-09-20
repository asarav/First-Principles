class_name ComponentTypes
extends RefCounted

const AND := "AND"
const OR := "OR"
const NOT := "NOT"
const XOR := "XOR"
const CONST := "CONST"
const INPUT := "INPUT"
const OUTPUT := "OUTPUT"

static func player_types() -> PackedStringArray:
	return PackedStringArray([AND, OR, NOT, XOR, CONST])


static func create(type_id: String, id: String, config: Dictionary = {}) -> SimComponent:
	match type_id:
		AND:
			return CompAnd.new(id, config)
		OR:
			return CompOr.new(id, config)
		NOT:
			return CompNot.new(id, config)
		XOR:
			return CompXor.new(id, config)
		CONST:
			return CompConst.new(id, config)
		INPUT:
			return CompInput.new(id, config)
		OUTPUT:
			return CompOutput.new(id, config)
		_:
			return null


static func is_player_placeable(type_id: String) -> bool:
	return player_types().has(type_id)


static func display_name(type_id: String) -> String:
	return type_id


static func input_port_names(type_id: String) -> PackedStringArray:
	var sample := create(type_id, "_probe")
	if sample == null:
		return PackedStringArray()
	return sample.input_ports


static func output_port_names(type_id: String) -> PackedStringArray:
	var sample := create(type_id, "_probe")
	if sample == null:
		return PackedStringArray()
	return sample.output_ports
