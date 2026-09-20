class_name CompInput
extends SimComponent

var forced: SignalValue = SignalValue.unset()


func _init(p_id: String = "", p_config: Dictionary = {}) -> void:
	super._init(p_id, ComponentTypes.INPUT, p_config)


func _setup_ports() -> void:
	input_ports = PackedStringArray()
	output_ports = PackedStringArray(["out"])


func set_forced(value: SignalValue) -> void:
	forced = value.duplicate_value() if value else SignalValue.unset()


func reset() -> void:
	super.reset()
	# Forced stimulus is part of the experiment setup, not component memory.
	if forced.is_set():
		output_values["out"] = forced.duplicate_value()


func evaluate() -> void:
	output_values["out"] = forced.duplicate_value() if forced else SignalValue.unset()
