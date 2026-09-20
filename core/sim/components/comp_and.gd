class_name CompAnd
extends SimComponent


func _init(p_id: String = "", p_config: Dictionary = {}) -> void:
	super._init(p_id, ComponentTypes.AND, p_config)


func _setup_ports() -> void:
	input_ports = PackedStringArray(["a", "b"])
	output_ports = PackedStringArray(["out"])


func evaluate() -> void:
	var a: SignalValue = get_input("a")
	var b: SignalValue = get_input("b")
	if a.is_set() and b.is_set() and a.kind == SignalValue.Kind.BOOL and b.kind == SignalValue.Kind.BOOL:
		output_values["out"] = SignalValue.from_bool(a.bool_value and b.bool_value)
	else:
		output_values["out"] = SignalValue.unset()
