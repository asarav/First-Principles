class_name CompConst
extends SimComponent


func _init(p_id: String = "", p_config: Dictionary = {}) -> void:
	super._init(p_id, ComponentTypes.CONST, p_config)


func _setup_ports() -> void:
	input_ports = PackedStringArray()
	output_ports = PackedStringArray(["out"])


func evaluate() -> void:
	output_values["out"] = SignalValue.from_bool(bool(config.get("value", false)))
