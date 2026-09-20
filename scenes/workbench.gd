extends Control

signal puzzle_solved(puzzle_id: String, result: Dictionary)

var puzzle: PuzzleDefinition
var graph: GraphEdit
var inspect_label: Label
var result_label: Label
var title_label: Label
var live_inputs: Dictionary = {}
var machine: Machine
var status_label: Label


func _ready() -> void:
	set_anchors_preset(PRESET_FULL_RECT)
	_build_ui()


func load_puzzle(puzzle_id: String) -> void:
	puzzle = PuzzleLibrary.load_id(puzzle_id)
	if puzzle == null:
		result_label.text = "Could not load puzzle %s" % puzzle_id
		return
	title_label.text = "%s\n%s" % [puzzle.title, puzzle.description]
	await _rebuild_graph(GameSession.load_construction(puzzle.id))
	_clear_live_inputs()
	_rebuild_live_input_controls()
	_sync_machine()
	_refresh_inspect("Loaded %s." % puzzle.id)


func _build_ui() -> void:
	var root := HBoxContainer.new()
	root.set_anchors_preset(PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 8)
	add_child(root)

	root.add_child(_build_palette())

	var center := VBoxContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(center)

	title_label = Label.new()
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.text = "No puzzle loaded"
	center.add_child(title_label)

	graph = GraphEdit.new()
	graph.size_flags_vertical = Control.SIZE_EXPAND_FILL
	graph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	graph.right_disconnects = true
	graph.connection_request.connect(_on_connection_request)
	graph.disconnection_request.connect(_on_disconnection_request)
	graph.delete_nodes_request.connect(_on_delete_nodes_request)
	center.add_child(graph)

	var controls := HBoxContainer.new()
	center.add_child(controls)
	_add_button(controls, "Reset", _on_reset)
	_add_button(controls, "Step", _on_step)
	_add_button(controls, "Settle", _on_settle)
	_add_button(controls, "Run Tests", _on_run_tests)
	_add_button(controls, "Save", _on_save)
	_add_button(controls, "Reload", _on_reload)
	if OS.is_debug_build():
		_add_button(controls, "Load Sample", _on_load_sample)

	status_label = Label.new()
	status_label.text = "Ready."
	center.add_child(status_label)

	var right := VBoxContainer.new()
	right.custom_minimum_size = Vector2(340, 0)
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(right)

	var live_title := Label.new()
	live_title.text = "Stimulus"
	right.add_child(live_title)
	var live_box := VBoxContainer.new()
	live_box.name = "LiveInputs"
	right.add_child(live_box)

	result_label = Label.new()
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_label.text = "Tests have not been run."
	right.add_child(result_label)

	var inspect_title := Label.new()
	inspect_title.text = "Inspection"
	right.add_child(inspect_title)

	var inspect_scroll := ScrollContainer.new()
	inspect_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(inspect_scroll)
	inspect_label = Label.new()
	inspect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inspect_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inspect_scroll.add_child(inspect_label)


func _build_palette() -> VBoxContainer:
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(150, 0)
	var label := Label.new()
	label.text = "Palette"
	box.add_child(label)
	for type_id in ComponentTypes.player_types():
		_add_button(box, type_id, func() -> void: _add_player_component(type_id))
	return box


func _add_button(parent: Node, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)


func _rebuild_graph(construction: Construction) -> void:
	for child in graph.get_children():
		if child is GraphElement:
			child.queue_free()
	graph.clear_connections()
	if puzzle == null:
		return

	var index := 0
	for item in puzzle.inputs:
		var io_id := puzzle.io_component_id("in", str(item.get("id", "")))
		_make_node(io_id, ComponentTypes.INPUT, Vector2(40, 80 + index * 140), {}, true, str(item.get("label", item.get("id", ""))))
		index += 1
	index = 0
	for item in puzzle.outputs:
		var io_id := puzzle.io_component_id("out", str(item.get("id", "")))
		_make_node(io_id, ComponentTypes.OUTPUT, Vector2(760, 80 + index * 140), {}, true, str(item.get("label", item.get("id", ""))))
		index += 1

	for item in construction.components:
		var pos_data: Dictionary = item.get("position", {})
		var position := Vector2(float(pos_data.get("x", 320)), float(pos_data.get("y", 160)))
		_make_node(str(item.get("id", "")), str(item.get("type", "")), position, item.get("config", {}), false, "")

	await get_tree().process_frame
	for item in construction.connections:
		graph.connect_node(str(item.get("from", "")), _output_slot(str(item.get("from", "")), str(item.get("from_port", ""))), str(item.get("to", "")), _input_slot(str(item.get("to", "")), str(item.get("to_port", ""))))


func _make_node(id: String, type_id: String, position: Vector2, config: Dictionary, locked: bool, label_override: String) -> void:
	var node := GraphNode.new()
	node.name = id
	node.title = label_override if label_override != "" else "%s %s" % [type_id, id]
	node.position_offset = position
	node.set_meta("type_id", type_id)
	node.set_meta("locked", locked)
	node.set_meta("config", config.duplicate(true))
	if locked:
		node.selectable = true
		node.deletable = false

	var inputs := ComponentTypes.input_port_names(type_id)
	var outputs := ComponentTypes.output_port_names(type_id)
	var rows: int = max(inputs.size(), outputs.size())
	rows = max(rows, 1)
	for i in rows:
		var row := HBoxContainer.new()
		var left := Label.new()
		left.text = inputs[i] if i < inputs.size() else ""
		left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var right := Label.new()
		right.text = outputs[i] if i < outputs.size() else ""
		right.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(left)
		row.add_child(right)
		node.add_child(row)
		node.set_slot(i, i < inputs.size(), 0, Color(0.55, 0.82, 0.9), i < outputs.size(), 0, Color(0.93, 0.76, 0.38))

	if type_id == ComponentTypes.CONST:
		var check := CheckBox.new()
		check.text = "value"
		check.button_pressed = bool(config.get("value", false))
		check.toggled.connect(func(pressed: bool) -> void:
			var cfg: Dictionary = node.get_meta("config")
			cfg["value"] = pressed
			node.set_meta("config", cfg)
			_sync_machine()
		)
		node.add_child(check)

	graph.add_child(node)


func _add_player_component(type_id: String) -> void:
	if puzzle == null:
		return
	if not puzzle.available_components.has(type_id):
		status_label.text = "%s is not available in this puzzle." % type_id
		return
	var construction := _construction_from_graph()
	var id := construction.next_component_id(type_id)
	_make_node(id, type_id, Vector2(320, 180), {}, false, "")
	_sync_machine()


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.connect_node(from_node, from_port, to_node, to_port)
	_sync_machine()


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.disconnect_node(from_node, from_port, to_node, to_port)
	_sync_machine()


func _on_delete_nodes_request(nodes: Array) -> void:
	for node_name in nodes:
		var node := graph.get_node_or_null(NodePath(str(node_name)))
		if node == null:
			continue
		if bool(node.get_meta("locked", false)):
			continue
		graph.remove_child(node)
		node.queue_free()
	_sync_machine()


func _construction_from_graph() -> Construction:
	var construction := Construction.new()
	if puzzle:
		construction.puzzle_id = puzzle.id
	for child in graph.get_children():
		if not (child is GraphNode):
			continue
		var node := child as GraphNode
		var type_id := str(node.get_meta("type_id", ""))
		if type_id == ComponentTypes.INPUT or type_id == ComponentTypes.OUTPUT:
			continue
		construction.components.append({
			"id": node.name,
			"type": type_id,
			"config": node.get_meta("config", {}),
			"position": {"x": node.position_offset.x, "y": node.position_offset.y},
		})
	for item in graph.get_connection_list():
		var from_id := str(item.get("from_node", item.get("from", "")))
		var to_id := str(item.get("to_node", item.get("to", "")))
		var from_port_index := int(item.get("from_port", 0))
		var to_port_index := int(item.get("to_port", 0))
		construction.connections.append({
			"from": from_id,
			"from_port": _output_port_name(from_id, from_port_index),
			"to": to_id,
			"to_port": _input_port_name(to_id, to_port_index),
		})
	return construction


func _type_of(node_id: String) -> String:
	var node := graph.get_node_or_null(NodePath(node_id))
	if node == null:
		return ""
	return str(node.get_meta("type_id", ""))


func _output_port_name(node_id: String, slot: int) -> String:
	var ports := ComponentTypes.output_port_names(_type_of(node_id))
	if slot >= 0 and slot < ports.size():
		return ports[slot]
	return "out"


func _input_port_name(node_id: String, slot: int) -> String:
	var ports := ComponentTypes.input_port_names(_type_of(node_id))
	if slot >= 0 and slot < ports.size():
		return ports[slot]
	return "in"


func _output_slot(node_id: String, port: String) -> int:
	var ports := ComponentTypes.output_port_names(_type_of(node_id))
	var idx := ports.find(port)
	return idx if idx >= 0 else 0


func _input_slot(node_id: String, port: String) -> int:
	var ports := ComponentTypes.input_port_names(_type_of(node_id))
	var idx := ports.find(port)
	return idx if idx >= 0 else 0


func _sync_machine() -> void:
	if puzzle == null:
		return
	machine = MachineBuilder.build(puzzle, _construction_from_graph())
	_apply_live_inputs()


func _clear_live_inputs() -> void:
	live_inputs.clear()
	if puzzle == null:
		return
	for item in puzzle.inputs:
		live_inputs[str(item.get("id", ""))] = false


func _rebuild_live_input_controls() -> void:
	var box := find_child("LiveInputs", true, false)
	if box == null:
		return
	for child in box.get_children():
		child.queue_free()
	if puzzle == null:
		return
	for item in puzzle.inputs:
		var io_id := str(item.get("id", ""))
		var check := CheckBox.new()
		check.text = str(item.get("label", io_id))
		check.button_pressed = bool(live_inputs.get(io_id, false))
		check.toggled.connect(func(pressed: bool) -> void:
			live_inputs[io_id] = pressed
			_apply_live_inputs()
			_refresh_inspect("Stimulus changed.")
		)
		box.add_child(check)


func _apply_live_inputs() -> void:
	if machine == null or puzzle == null:
		return
	for io_id in live_inputs.keys():
		machine.set_input(puzzle.io_component_id("in", io_id), SignalValue.from_bool(bool(live_inputs[io_id])))


func _on_reset() -> void:
	_sync_machine()
	if machine:
		machine.reset()
		_apply_live_inputs()
	_refresh_inspect("Reset.")


func _on_step() -> void:
	_sync_machine()
	if machine:
		machine.step()
	_refresh_inspect("Stepped.")


func _on_settle() -> void:
	_sync_machine()
	if machine:
		machine.settle()
	_refresh_inspect("Settled.")


func _on_run_tests() -> void:
	if puzzle == null:
		return
	var construction := _construction_from_graph()
	GameSession.save_construction(construction)
	var result := Validator.validate(puzzle, construction)
	result_label.text = _format_result(result)
	status_label.text = "PASSED" if result.passed else "FAILED"
	_refresh_inspect("Tests executed.", result.get("inspect", {}))
	if result.passed:
		puzzle_solved.emit(puzzle.id, result)


func _on_save() -> void:
	var construction := _construction_from_graph()
	if GameSession.save_construction(construction):
		status_label.text = "Saved construction."
	else:
		status_label.text = "Save failed."


func _on_reload() -> void:
	if puzzle:
		load_puzzle(puzzle.id)


func _on_load_sample() -> void:
	if puzzle == null:
		return
	var sample := Construction.load_path("res://data/constructions/%s_sample.json" % puzzle.id)
	if sample.puzzle_id != puzzle.id:
		status_label.text = "No sample construction for this puzzle."
		return
	await _rebuild_graph(sample)
	_sync_machine()
	_refresh_inspect("Loaded sample construction.")


func _format_result(result: Dictionary) -> String:
	var lines: PackedStringArray = PackedStringArray()
	lines.append("Passed: %s" % str(result.get("passed", false)))
	lines.append("Components: %s" % str(result.get("stats", {}).get("component_count", 0)))
	for error in result.get("errors", []):
		lines.append("Error: %s" % str(error))
	for case_result in result.get("tests", []):
		var mark := "ok" if case_result.get("passed", false) else "FAIL"
		lines.append("[%s] %s %s" % [mark, str(case_result.get("id", "")), str(case_result.get("reason", ""))])
	return "\n".join(lines)


func _refresh_inspect(status: String, inspect_override: Dictionary = {}) -> void:
	status_label.text = status
	var data: Dictionary = inspect_override
	if data.is_empty() and machine:
		data = machine.inspect()
	inspect_label.text = JSON.stringify(data, "  ")
