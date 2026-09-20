class_name CompNot
extends SimComponent


func _init(p_id: String = "", p_config: Dictionary = {}) -> void:
	super._init(p_id, ComponentTypes.NOT, p_config)


func _setup_ports() -> void:
	input_ports = PackedStringArray(["in"])
	output_ports = PackedStringArray(["out"])


func evaluate() -> void:
	var a: SignalValue = get_input("in")
	if a.is_set() and a.kind == SignalValue.Kind.BOOL:
		output_values["out"] = SignalValue.from_bool(not a.bool_value)
	else:
		output_values["out"] = SignalValue.unset()
