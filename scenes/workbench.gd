extends Control

signal puzzle_solved(puzzle_id: String, result: Dictionary)

const FLOW_OVERLAY_SCRIPT = preload("res://scenes/signal_flow_overlay.gd")
const PAN_SPEED := 520.0
const SIGNAL_ON := Color(0.38, 0.95, 0.78)
const SIGNAL_OFF := Color(0.28, 0.38, 0.45)
const SIGNAL_UNSET := Color(0.95, 0.67, 0.28)
const PANEL_BG := Color(0.06, 0.09, 0.12)
const PANEL_LINE := Color(0.18, 0.28, 0.34)
const UI_MUTED := Color(0.72, 0.82, 0.88)
const FEEDBACK_AUDIO_SCRIPT = preload("res://scenes/feedback_audio.gd")

var puzzle: PuzzleDefinition
var graph: GraphEdit
var result_label: Label
var title_label: Label
var live_inputs: Dictionary = {}
var machine: Machine
var status_label: Label
var signal_board: VBoxContainer
var signal_status_label: Label
var machine_readout: Label
var signal_rows: Dictionary = {}
var palette_box: VBoxContainer
var flow_overlay
var guide_label: Label
var truth_table_box: VBoxContainer
var last_test_results: Dictionary = {}
var feedback_audio
var action_help: Label
var flow_button: Button
var flow_is_playing := false
var tutorial_popup: PopupPanel
var palette_hint: Label


func _ready() -> void:
	set_anchors_preset(PRESET_FULL_RECT)
	_build_ui()


func _process(delta: float) -> void:
	if graph == null or not is_instance_valid(graph):
		return
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1.0
	if direction != Vector2.ZERO:
		graph.scroll_offset += direction.normalized() * PAN_SPEED * delta


func load_puzzle(puzzle_id: String) -> void:
	puzzle = PuzzleLibrary.load_id(puzzle_id)
	if puzzle == null:
		result_label.text = "Could not load puzzle %s" % puzzle_id
		return
	last_test_results.clear()
	title_label.text = "%s\n%s" % [puzzle.title, puzzle.description]
	graph.scroll_offset = Vector2.ZERO
	graph.zoom = 1.0
	await _rebuild_graph(GameSession.load_construction(puzzle.id))
	_center_graph_on_nodes()
	_clear_live_inputs()
	_rebuild_live_input_controls()
	_rebuild_palette()
	_rebuild_signal_board()
	_sync_machine()
	_refresh_guidance()
	_refresh_truth_table()
	_refresh_monitor("Loaded %s." % puzzle.id)


func _build_ui() -> void:
	feedback_audio = FEEDBACK_AUDIO_SCRIPT.new()
	add_child(feedback_audio)
	var root := HBoxContainer.new()
	root.set_anchors_preset(PRESET_FULL_RECT)
	root.offset_left = 12
	root.offset_right = -12
	root.offset_bottom = -10
	root.offset_top = 58
	root.add_theme_constant_override("separation", 14)
	add_child(root)

	var palette_frame := PanelContainer.new()
	palette_frame.custom_minimum_size = Vector2(170, 0)
	var palette_style := StyleBoxFlat.new()
	palette_style.bg_color = Color(0.04, 0.07, 0.09)
	palette_style.border_color = Color(0.20, 0.34, 0.38)
	palette_style.set_border_width_all(1)
	palette_style.set_corner_radius_all(6)
	palette_frame.add_theme_stylebox_override("panel", palette_style)
	palette_box = _build_palette()
	palette_frame.add_child(palette_box)
	root.add_child(palette_frame)

	var center := VBoxContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(center)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	center.add_child(header)
	title_label = Label.new()
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.text = "No puzzle loaded"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.custom_minimum_size = Vector2(0, 42)
	header.add_child(title_label)
	var help_button := Button.new()
	help_button.text = "? Help"
	help_button.tooltip_text = "Open the tutorial and action explanations."
	help_button.custom_minimum_size = Vector2(92, 34)
	help_button.pressed.connect(func() -> void:
		_play_feedback("click")
		tutorial_popup.popup_centered()
	)
	header.add_child(help_button)
	guide_label = Label.new()
	guide_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	guide_label.add_theme_font_size_override("font_size", 16)
	guide_label.add_theme_color_override("font_color", Color(0.78, 0.88, 0.92))

	graph = GraphEdit.new()
	graph.size_flags_vertical = Control.SIZE_EXPAND_FILL
	graph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	graph.right_disconnects = true
	graph.minimap_enabled = true
	graph.minimap_size = Vector2(180, 120)
	graph.show_zoom_label = true
	graph.snapping_distance = 20.0
	graph.zoom = 1.0
	graph.connection_request.connect(_on_connection_request)
	graph.disconnection_request.connect(_on_disconnection_request)
	graph.delete_nodes_request.connect(_on_delete_nodes_request)
	graph.gui_input.connect(_on_graph_gui_input)
	center.add_child(graph)
	flow_overlay = FLOW_OVERLAY_SCRIPT.new()
	flow_overlay.graph = graph
	flow_overlay.set_anchors_preset(PRESET_FULL_RECT)
	graph.add_child(flow_overlay)

	action_help = Label.new()
	action_help.text = "Step: run once · Settle: repeat until stable · Run Tests: check every case"
	action_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	action_help.add_theme_font_size_override("font_size", 14)
	action_help.add_theme_color_override("font_color", UI_MUTED)
	center.add_child(action_help)

	var controls := HFlowContainer.new()
	controls.add_theme_constant_override("h_separation", 6)
	controls.add_theme_constant_override("v_separation", 6)
	controls.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.add_child(controls)
	_add_button(controls, "↺ Reset Signals", _on_reset, "Reset signal values without changing the circuit you built.")
	_add_button(controls, "▶ Step", _on_step, "Run the circuit once. Some circuits need several runs before the output is complete.")
	_add_button(controls, "◆ Settle", _on_settle, "Keep running the circuit until the outputs stop changing.")
	_add_button(controls, "✓ Run Tests", _on_run_tests, "Try the circuit against every required input case.")
	_add_button(controls, "⇩ Save", _on_save, "Save the current circuit for this puzzle.")
	_add_button(controls, "↶ Revert Circuit", _on_reload, "Discard unsaved circuit edits and restore the last saved circuit.")
	_add_button(controls, "⌗ Frame Graph", _center_graph_on_nodes, "Center the view on all nodes in the circuit.")
	flow_button = Button.new()
	flow_button.text = "Ⅱ Pause Flow"
	flow_button.tooltip_text = "Pause the moving signal indicators."
	flow_button.custom_minimum_size = Vector2(154, 36)
	flow_button.pressed.connect(func() -> void:
		_play_feedback("click")
		_toggle_flow()
	)
	controls.add_child(flow_button)
	var stop_flow := Button.new()
	stop_flow.text = "■ Stop Flow"
	stop_flow.tooltip_text = "Stop the moving signal indicators and return them to the start."
	stop_flow.custom_minimum_size = Vector2(154, 36)
	stop_flow.pressed.connect(func() -> void:
		_play_feedback("click")
		_stop_flow()
	)
	controls.add_child(stop_flow)
	if OS.is_debug_build():
		_add_button(controls, "▣ Load Sample", _on_load_sample, "Load the example solution for this puzzle.")

	status_label = Label.new()
	status_label.text = "Ready."
	center.add_child(status_label)
	tutorial_popup = _build_tutorial_popup()
	add_child(tutorial_popup)

	var right := VBoxContainer.new()
	right.custom_minimum_size = Vector2(320, 0)
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 8)
	root.add_child(right)

	var live_title := Label.new()
	live_title.text = "STIMULUS CONTROL"
	right.add_child(live_title)
	var live_box := VBoxContainer.new()
	live_box.name = "LiveInputs"
	right.add_child(live_box)

	var monitor_title := Label.new()
	monitor_title.text = "SIGNAL MONITOR"
	right.add_child(monitor_title)
	signal_status_label = Label.new()
	signal_status_label.text = "Waiting for a machine."
	right.add_child(signal_status_label)
	signal_board = VBoxContainer.new()
	signal_board.add_theme_constant_override("separation", 6)
	right.add_child(signal_board)

	var truth_title := Label.new()
	truth_title.text = "EXPERIMENT TABLE"
	right.add_child(truth_title)
	truth_table_box = VBoxContainer.new()
	truth_table_box.add_theme_constant_override("separation", 4)
	right.add_child(truth_table_box)

	result_label = Label.new()
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_label.text = "Tests have not been run."
	right.add_child(result_label)

	var readout_title := Label.new()
	readout_title.text = "MACHINE READOUT"
	right.add_child(readout_title)
	machine_readout = Label.new()
	machine_readout.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right.add_child(machine_readout)


func _build_palette() -> VBoxContainer:
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(154, 0)
	box.add_theme_constant_override("separation", 8)
	var title := Label.new()
	title.text = "COMPONENTS"
	box.add_child(title)
	var label := Label.new()
	label.text = "Click to add a gate"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.tooltip_text = "Only components allowed by the current puzzle appear here."
	box.add_child(label)
	palette_hint = Label.new()
	palette_hint.text = "Available gates appear below. Hover a gate for its explanation."
	palette_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	palette_hint.tooltip_text = "Only components allowed by the current puzzle are shown."
	box.add_child(palette_hint)
	return box


func _build_tutorial_popup() -> PopupPanel:
	var popup := PopupPanel.new()
	popup.size = Vector2(520, 360)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_bottom", 20)
	popup.add_child(margin)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	margin.add_child(box)
	var title := Label.new()
	title.text = "HOW TO PLAY"
	title.add_theme_font_size_override("font_size", 24)
	box.add_child(title)
	var fixed := Label.new()
	fixed.text = "Move gates. Drag ports to connect. Right-click a connection to remove it.\n\nStep runs the circuit once. Settle repeats it until outputs stop changing.\nRun Tests checks every required input combination."
	fixed.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(fixed)
	box.add_child(HSeparator.new())
	box.add_child(guide_label)
	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(110, 36)
	close.pressed.connect(func() -> void:
		_play_feedback("click")
		tutorial_popup.hide()
	)
	box.add_child(close)
	return popup


func _rebuild_palette() -> void:
	if palette_box == null:
		return
	while palette_box.get_child_count() > 3:
		var child := palette_box.get_child(3)
		palette_box.remove_child(child)
		child.queue_free()
	if puzzle == null:
		return
	palette_hint.text = "Available for this puzzle:"
	for type_id in puzzle.available_components:
		var component_id := str(type_id)
		var button_text := "%s  %s" % [ComponentTypes.symbol(component_id), ComponentTypes.display_name(component_id)]
		_add_button(palette_box, button_text, func() -> void: _add_player_component(component_id), ComponentTypes.beginner_description(component_id) + " Drag the new node into position.")


func _refresh_guidance() -> void:
	if guide_label == null or puzzle == null:
		return
	var gate_type := str(puzzle.available_components[0]) if not puzzle.available_components.is_empty() else ""
	var gate_text := ComponentTypes.beginner_description(gate_type)
	var component_count := _construction_from_graph().components.size()
	var connection_count := graph.get_connection_list().size()
	var required_connections := puzzle.inputs.size() + puzzle.outputs.size()
	if component_count == 0:
		guide_label.text = "TUTORIAL 1 / 4  ·  Click %s %s in Components." % [ComponentTypes.symbol(gate_type), gate_type]
	elif connection_count < required_connections:
		guide_label.text = "TUTORIAL 2 / 4  ·  Connect both inputs to the gate, then connect its output to Response."
	else:
		guide_label.text = "TUTORIAL 3 / 4  ·  Toggle the inputs, press ◆ Settle, then press ✓ Run Tests."


func _refresh_truth_table() -> void:
	if truth_table_box == null or puzzle == null:
		return
	for child in truth_table_box.get_children():
		child.queue_free()
	for test_case in puzzle.test_cases:
		var case_id := str(test_case.get("id", "?"))
		var inputs: Dictionary = test_case.get("inputs", {})
		var expected: Dictionary = test_case.get("expected", {})
		var input_text := _format_case_values(puzzle.inputs, inputs)
		var output_text := _format_case_values(puzzle.outputs, expected)
		var result_text := ""
		if last_test_results.has(case_id):
			var case_result: Dictionary = last_test_results[case_id]
			result_text = "✓ PASS" if case_result.get("passed", false) else "✗ FAIL"
		elif _case_matches_live_inputs(inputs):
			result_text = "CURRENT"
		var row := Label.new()
		row.text = "%s   %s  →  %s  %s" % [case_id, input_text, output_text, result_text]
		row.tooltip_text = "Inputs: %s\nExpected response: %s" % [input_text, output_text]
		truth_table_box.add_child(row)


func _format_case_values(definitions: Array, values: Dictionary) -> String:
	var parts := PackedStringArray()
	for definition in definitions:
		var io_id := str(definition.get("id", ""))
		var value := bool(values.get(io_id, false))
		parts.append("%s:%s" % [io_id.to_upper(), "1" if value else "0"])
	return " ".join(parts)


func _case_matches_live_inputs(inputs: Dictionary) -> bool:
	for io_id in puzzle.input_ids():
		if bool(inputs.get(io_id, false)) != bool(live_inputs.get(io_id, false)):
			return false
	return true


func _add_button(parent: Node, text: String, callback: Callable, hint: String = "") -> void:
	var button := Button.new()
	button.text = text
	button.tooltip_text = hint
	button.pressed.connect(func() -> void:
		_play_feedback("click")
		callback.call()
	)
	button.mouse_entered.connect(func() -> void:
		if action_help != null and hint != "":
			action_help.text = hint
	)
	button.mouse_exited.connect(func() -> void:
		if action_help != null:
			action_help.text = "Step: run once · Settle: repeat until stable · Run Tests: check every case"
	)
	button.custom_minimum_size = Vector2(118, 34)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	parent.add_child(button)


func _play_feedback(kind: String) -> void:
	if feedback_audio != null:
		feedback_audio.play_feedback(kind)


func _free_graph_children() -> void:
	for child in graph.get_children():
		if child is GraphElement:
			graph.remove_child(child)
			child.free()
	graph.clear_connections()


func _rebuild_graph(construction: Construction) -> void:
	_free_graph_children()
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


func _center_graph_on_nodes() -> void:
	if graph == null:
		return
	var nodes: Array[GraphNode] = []
	for child in graph.get_children():
		if child is GraphNode:
			nodes.append(child as GraphNode)
	if nodes.is_empty():
		return
	var bounds := Rect2(nodes[0].position_offset, nodes[0].size)
	for node in nodes.slice(1):
		bounds = bounds.merge(Rect2(node.position_offset, node.size))
	graph.scroll_offset = bounds.get_center()


func _make_node(id: String, type_id: String, position: Vector2, config: Dictionary, locked: bool, label_override: String) -> void:
	var node := GraphNode.new()
	node.name = id
	if label_override != "":
		node.title = "%s %s" % [ComponentTypes.symbol(type_id), label_override]
	else:
		node.title = "%s  %s %s" % [ComponentTypes.symbol(type_id), ComponentTypes.display_name(type_id), id]
	node.tooltip_text = ComponentTypes.beginner_description(type_id)
	node.position_offset = position
	node.set_meta("type_id", type_id)
	node.set_meta("locked", locked)
	node.set_meta("config", config.duplicate(true))
	if locked:
		node.selectable = true
	node.draggable = not locked

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
			_play_feedback("toggle")
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
		_play_feedback("error")
		return
	_play_feedback("click")
	var construction := _construction_from_graph()
	var id := construction.next_component_id(type_id)
	_make_node(id, type_id, Vector2(320, 180), {}, false, "")
	_sync_machine()
	_refresh_guidance()


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	_play_feedback("toggle")
	graph.connect_node(from_node, from_port, to_node, to_port)
	_sync_machine()
	_refresh_guidance()


func _on_graph_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if not mouse_event.pressed or mouse_event.button_index != MOUSE_BUTTON_RIGHT:
		return
	var connection: Dictionary = flow_overlay.connection_at_point(mouse_event.position)
	if connection.is_empty():
		return
	graph.disconnect_node(
		StringName(str(connection.get("from_node", connection.get("from", "")))),
		int(connection.get("from_port", 0)),
		StringName(str(connection.get("to_node", connection.get("to", "")))),
		int(connection.get("to_port", 0))
	)
	_play_feedback("click")
	_sync_machine()
	_refresh_guidance()
	_refresh_monitor("Connection removed.", true)
	get_viewport().set_input_as_handled()


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	_play_feedback("click")
	graph.disconnect_node(from_node, from_port, to_node, to_port)
	_sync_machine()
	_refresh_guidance()


func _on_delete_nodes_request(nodes: Array) -> void:
	_play_feedback("click")
	for node_name in nodes:
		var node := graph.get_node_or_null(NodePath(str(node_name)))
		if node == null:
			continue
		if bool(node.get_meta("locked", false)):
			continue
		graph.remove_child(node)
		node.free()
	_sync_machine()
	_refresh_guidance()


func _toggle_flow() -> void:
	flow_is_playing = not flow_is_playing
	flow_overlay.set_playing(flow_is_playing)
	_update_flow_button()
	status_label.text = "Signal animation resumed." if flow_is_playing else "Signal animation paused."


func _stop_flow() -> void:
	flow_is_playing = false
	flow_overlay.stop_playing()
	_update_flow_button()
	status_label.text = "Signal animation stopped."


func _update_flow_button() -> void:
	if flow_button == null:
		return
	flow_button.text = "Ⅱ Pause Flow" if flow_is_playing else "▶ Resume Flow"


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
			_refresh_truth_table()
			_refresh_monitor("Stimulus changed.", true)
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
	_refresh_monitor("Reset.", true)


func _on_step() -> void:
	if machine == null:
		_sync_machine()
	if machine:
		machine.step()
		_refresh_monitor("One circuit run completed. Press Step again if an output is still changing.", true)


func _on_settle() -> void:
	if machine == null:
		_sync_machine()
	if machine:
		machine.settle()
		_refresh_monitor("Outputs are stable after %d circuit runs." % machine.last_settle_iterations, true)


func _on_run_tests() -> void:
	if puzzle == null:
		return
	var construction := _construction_from_graph()
	GameSession.save_construction(construction)
	var result := Validator.validate(puzzle, construction)
	last_test_results.clear()
	for case_result in result.get("tests", []):
		last_test_results[str(case_result.get("id", ""))] = case_result
	result_label.text = _format_result(result)
	status_label.text = "PASSED" if result.passed else "FAILED"
	_play_feedback("success" if result.passed else "error")
	_refresh_monitor("TUTORIAL 4 / 4  ·  TESTS COMPLETE." if result.passed else "Tests executed.", true)
	_animate_signal_change(result.passed)
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
	_refresh_monitor("Loaded sample construction.", true)


func _format_result(result: Dictionary) -> String:
	var lines: PackedStringArray = PackedStringArray()
	lines.append("✓ ALL EXPERIMENTS PASSED" if result.get("passed", false) else "✗ EXPERIMENT FAILED")
	lines.append("Components: %s" % str(result.get("stats", {}).get("component_count", 0)))
	for error in result.get("errors", []):
		lines.append("Error: %s" % str(error))
	for case_result in result.get("tests", []):
		var mark := "✓" if case_result.get("passed", false) else "✗"
		var reason := str(case_result.get("reason", ""))
		var detail := reason if reason != "" else "response matched"
		lines.append("%s case %s: %s" % [mark, str(case_result.get("id", "")), detail])
	return "\n".join(lines)


func _refresh_monitor(status: String, animate: bool = false) -> void:
	status_label.text = status
	if machine == null or puzzle == null:
		signal_status_label.text = "Waiting for a machine."
		machine_readout.text = "No signal data yet."
		return
	flow_is_playing = animate
	flow_overlay.set_machine(machine, flow_is_playing)
	_update_flow_button()
	signal_status_label.text = "STABLE" if machine.last_settled else "CHANGING"
	var rows := PackedStringArray()
	rows.append("runs %d" % machine.tick)
	rows.append("last stable after %d runs" % machine.last_settle_iterations)
	if not machine.errors.is_empty():
		rows.append("errors %d" % machine.errors.size())
	machine_readout.text = "  ".join(rows)
	_refresh_signal_rows()
	_refresh_truth_table()
	_refresh_node_feedback(animate)
	if animate:
		_animate_signal_change(false)


func _refresh_node_feedback(animate: bool = false) -> void:
	for child in graph.get_children():
		if not (child is GraphNode):
			continue
		var node := child as GraphNode
		var component_id := str(node.name)
		if machine == null or not machine.components.has(component_id):
			continue
		var component: SimComponent = machine.components[component_id]
		var active := false
		for port in component.output_ports:
			var value: SignalValue = component.get_output(port)
			if value.is_set() and value.bool_value:
				active = true
		var target := Color(0.72, 1.0, 0.88) if active else Color.WHITE
		if animate and active:
			node.modulate = Color.WHITE
			var tween := create_tween()
			tween.tween_property(node, "modulate", Color(1.35, 1.35, 1.35), 0.10)
			tween.tween_property(node, "modulate", target, 0.34)
		else:
			node.modulate = target


func _refresh_signal_rows() -> void:
	for io_id in puzzle.input_ids():
		_update_signal_row("in:%s" % io_id, machine.get_output(puzzle.io_component_id("in", io_id)))
	for io_id in puzzle.output_ids():
		_update_signal_row("out:%s" % io_id, machine.get_output(puzzle.io_component_id("out", io_id)))


func _update_signal_row(row_id: String, value: SignalValue) -> void:
	if not signal_rows.has(row_id):
		return
	var row: Dictionary = signal_rows[row_id]
	var indicator: ColorRect = row.get("indicator")
	var value_label: Label = row.get("value_label")
	var is_set := value != null and value.is_set()
	var is_on := is_set and value.bool_value
	indicator.color = SIGNAL_ON if is_on else SIGNAL_OFF if is_set else SIGNAL_UNSET
	value_label.text = "HIGH" if is_on else "LOW" if is_set else "UNSET"


func _animate_signal_change(success: bool) -> void:
	for row in signal_rows.values():
		var card: PanelContainer = row.get("card")
		var indicator: ColorRect = row.get("indicator")
		if card == null or indicator == null:
			continue
		card.modulate = Color.WHITE
		indicator.modulate = Color.WHITE
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(card, "modulate", Color(1.35, 1.35, 1.35), 0.10)
		tween.tween_property(indicator, "scale", Vector2(1.35, 1.35), 0.10)
		tween.chain().set_parallel(true)
		tween.tween_property(card, "modulate", Color.WHITE, 0.32)
		tween.tween_property(indicator, "scale", Vector2.ONE, 0.32)
	if success:
		var success_tween := create_tween()
		success_tween.tween_property(signal_status_label, "modulate", SIGNAL_ON, 0.12)
		success_tween.tween_property(signal_status_label, "modulate", Color.WHITE, 0.55)


func _rebuild_signal_board() -> void:
	if signal_board == null:
		return
	for child in signal_board.get_children():
		child.queue_free()
	signal_rows.clear()
	if puzzle == null:
		return
	for item in puzzle.inputs:
		_add_signal_row("in:%s" % str(item.get("id", "")), "IN", str(item.get("label", item.get("id", ""))))
	for item in puzzle.outputs:
		_add_signal_row("out:%s" % str(item.get("id", "")), "OUT", str(item.get("label", item.get("id", ""))))


func _add_signal_row(row_id: String, direction: String, label_text: String) -> void:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0, 34)
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL_BG
	style.border_color = PANEL_LINE
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	card.add_theme_stylebox_override("panel", style)
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 8)
	card.add_child(line)
	var indicator := ColorRect.new()
	indicator.custom_minimum_size = Vector2(8, 8)
	indicator.color = SIGNAL_UNSET
	line.add_child(indicator)
	var direction_label := Label.new()
	direction_label.text = direction
	direction_label.custom_minimum_size = Vector2(34, 0)
	line.add_child(direction_label)
	var name_label := Label.new()
	name_label.text = label_text
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.add_child(name_label)
	var value_label := Label.new()
	value_label.text = "UNSET"
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	line.add_child(value_label)
	signal_board.add_child(card)
	signal_rows[row_id] = {"card": card, "indicator": indicator, "value_label": value_label}
