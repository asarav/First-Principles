class_name CompOutput
extends SimComponent


func _init(p_id: String = "", p_config: Dictionary = {}) -> void:
	super._init(p_id, ComponentTypes.OUTPUT, p_config)


func _setup_ports() -> void:
	input_ports = PackedStringArray(["in"])
	output_ports = PackedStringArray()


func evaluate() -> void:
	pass
