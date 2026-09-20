class_name SimComponent
extends RefCounted

var id: String = ""
var type_id: String = ""
var config: Dictionary = {}
var input_ports: PackedStringArray = PackedStringArray()
var output_ports: PackedStringArray = PackedStringArray()
var input_values: Dictionary = {}
var output_values: Dictionary = {}


func _init(p_id: String = "", p_type_id: String = "", p_config: Dictionary = {}) -> void:
	id = p_id
	type_id = p_type_id
	config = p_config.duplicate(true)
	_setup_ports()
	reset()


func _setup_ports() -> void:
	pass


func reset() -> void:
	input_values.clear()
	output_values.clear()
	for port in input_ports:
		input_values[port] = SignalValue.unset()
	for port in output_ports:
		output_values[port] = SignalValue.unset()


func evaluate() -> void:
	pass


func set_input(port: String, value: SignalValue) -> void:
	if not input_ports.has(port):
		return
	input_values[port] = value.duplicate_value() if value else SignalValue.unset()


func get_input(port: String) -> SignalValue:
	return input_values.get(port, SignalValue.unset())


func get_output(port: String) -> SignalValue:
	return output_values.get(port, SignalValue.unset())


func has_input_port(port: String) -> bool:
	return input_ports.has(port)


func has_output_port(port: String) -> bool:
	return output_ports.has(port)


func inspect() -> Dictionary:
	var inputs := {}
	var outputs := {}
	for port in input_ports:
		inputs[port] = get_input(port).to_debug_string()
	for port in output_ports:
		outputs[port] = get_output(port).to_debug_string()
	return {
		"id": id,
		"type": type_id,
		"config": config.duplicate(true),
		"inputs": inputs,
		"outputs": outputs,
	}
