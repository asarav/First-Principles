extends Control

var hub: Control
var narrative: Control
var workbench: Control
var year_label: Label
var body_label: Label
var narrative_label: Label
var pending_events: Array = []


func _ready() -> void:
	set_anchors_preset(PRESET_FULL_RECT)
	_build()
	_show_hub()


func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.07, 0.09)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	add_child(bg)

	hub = _build_hub()
	add_child(hub)

	narrative = _build_narrative()
	add_child(narrative)

	var workbench_script = load("res://scenes/workbench.gd")
	workbench = workbench_script.new()
	workbench.set_anchors_preset(PRESET_FULL_RECT)
	workbench.visible = false
	workbench.puzzle_solved.connect(_on_puzzle_solved)
	add_child(workbench)

	var back := Button.new()
	back.text = "Return"
	back.set_anchors_preset(PRESET_TOP_LEFT)
	back.position = Vector2(12, 8)
	back.pressed.connect(_show_hub)
	add_child(back)


func _build_hub() -> Control:
	var panel := MarginContainer.new()
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.add_theme_constant_override("margin_left", 48)
	panel.add_theme_constant_override("margin_top", 48)
	panel.add_theme_constant_override("margin_right", 48)
	panel.add_theme_constant_override("margin_bottom", 48)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)

	var title := Label.new()
	title.text = "FIRST PRINCIPLES"
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	year_label = Label.new()
	box.add_child(year_label)

	body_label = Label.new()
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(body_label)

	var row := HBoxContainer.new()
	box.add_child(row)
	_add_button(row, "Investigate Artifact", _open_transmission)
	_add_button(row, "Open Workbench", _open_workbench)
	return panel


func _build_narrative() -> Control:
	var panel := MarginContainer.new()
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.add_theme_constant_override("margin_left", 72)
	panel.add_theme_constant_override("margin_top", 72)
	panel.add_theme_constant_override("margin_right", 72)
	panel.add_theme_constant_override("margin_bottom", 72)
	panel.visible = false
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	panel.add_child(box)
	narrative_label = Label.new()
	narrative_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(narrative_label)
	_add_button(box, "Continue", _on_narrative_continue)
	return panel


func _add_button(parent: Node, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	parent.add_child(button)


func _show_hub() -> void:
	hub.visible = true
	narrative.visible = false
	workbench.visible = false
	year_label.text = "Year %d" % GameSession.year
	var tx := GameSession.current_transmission()
	var puzzle := PuzzleLibrary.load_id(GameSession.current_puzzle_id)
	var title := puzzle.title if puzzle else GameSession.current_puzzle_id
	body_label.text = "Current artifact: %s\nUnlocked: %s\nCompleted: %s\n\n%s" % [
		title,
		", ".join(GameSession.unlocked_puzzles),
		", ".join(GameSession.completed_puzzles) if GameSession.completed_puzzles.size() > 0 else "(none)",
		"A structured transmission is waiting in the workbench." if tx else "No transmission is currently queued."
	]


func _open_transmission() -> void:
	var tx := GameSession.current_transmission()
	var scene_id := str(tx.get("narrative_id", ""))
	_show_scene(scene_id, func() -> void: _open_workbench())


func _open_workbench() -> void:
	hub.visible = false
	narrative.visible = false
	workbench.visible = true
	workbench.load_puzzle(GameSession.current_puzzle_id)


func _show_scene(scene_id: String, afterward: Callable) -> void:
	var scene: Dictionary = GameSession.scene_for(scene_id)
	hub.visible = false
	workbench.visible = false
	narrative.visible = true
	narrative.set_meta("afterward", afterward)
	if scene.is_empty():
		narrative_label.text = "No record."
		return
	var lines: PackedStringArray = PackedStringArray()
	lines.append(str(scene.get("title", scene_id)))
	lines.append("")
	for line in scene.get("lines", []):
		lines.append("%s\n%s\n" % [str(line.get("speaker", "")), str(line.get("text", ""))])
	narrative_label.text = "\n".join(lines)


func _on_narrative_continue() -> void:
	var afterward: Callable = narrative.get_meta("afterward", Callable())
	if afterward.is_valid():
		afterward.call()
	else:
		_show_hub()


func _on_puzzle_solved(puzzle_id: String, result: Dictionary) -> void:
	var follow := GameSession.complete_puzzle(puzzle_id)
	pending_events = follow.get("events", [])
	_advance_pending(result)


func _advance_pending(result: Dictionary = {}) -> void:
	if pending_events.is_empty():
		_show_hub()
		return
	var event: Dictionary = pending_events.pop_front()
	var scene_id := str(event.get("narrative_id", ""))
	if scene_id == "":
		_advance_pending(result)
		return
	_show_scene(scene_id, func() -> void: _advance_pending(result))
