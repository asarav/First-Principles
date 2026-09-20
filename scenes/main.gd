extends Control

const ACCENT := Color(0.42, 0.78, 0.92)
const PANEL_BG := Color(0.08, 0.11, 0.15)
const PANEL_ALT := Color(0.12, 0.16, 0.21)
const TEXT_MAIN := Color(0.94, 0.97, 1.0)
const TEXT_MUTED := Color(0.72, 0.82, 0.88)

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
	back.position = Vector2(18, 16)
	back.custom_minimum_size = Vector2(120, 32)
	back.pressed.connect(_show_hub)
	_style_button(back, ACCENT, Color(0.18, 0.38, 0.46), true)
	add_child(back)


func _build_hub() -> Control:
	var panel := MarginContainer.new()
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.add_theme_constant_override("margin_left", 48)
	panel.add_theme_constant_override("margin_top", 72)
	panel.add_theme_constant_override("margin_right", 48)
	panel.add_theme_constant_override("margin_bottom", 48)
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.03, 0.05, 0.07)
	panel.add_theme_stylebox_override("panel", panel_style)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	panel.add_child(box)

	var title := Label.new()
	title.text = "FIRST PRINCIPLES"
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", TEXT_MAIN)
	box.add_child(title)

	year_label = Label.new()
	year_label.add_theme_color_override("font_color", TEXT_MUTED)
	year_label.add_theme_font_size_override("font_size", 20)
	box.add_child(year_label)

	body_label = Label.new()
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_label.add_theme_color_override("font_color", TEXT_MAIN)
	body_label.add_theme_font_size_override("font_size", 18)
	box.add_child(body_label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	_add_button(row, "Investigate Artifact", _open_transmission)
	_add_button(row, "Open Workbench", _open_workbench)

	var puzzle_list := VBoxContainer.new()
	puzzle_list.add_theme_constant_override("separation", 10)
	box.add_child(puzzle_list)
	var puzzle_title := Label.new()
	puzzle_title.text = "Unlocked transmissions"
	puzzle_title.add_theme_color_override("font_color", TEXT_MUTED)
	puzzle_title.add_theme_font_size_override("font_size", 18)
	puzzle_list.add_child(puzzle_title)
	for puzzle_id in GameSession.available_puzzle_ids():
		var puzzle := PuzzleLibrary.load_id(puzzle_id)
		var label := str(puzzle.title) if puzzle else puzzle_id
		var btn := Button.new()
		btn.text = "%s%s" % [label, " (current)" if puzzle_id == GameSession.current_puzzle_id else ""]
		btn.pressed.connect(func() -> void:
			GameSession.current_puzzle_id = puzzle_id
			GameSession.save_session()
			_show_hub()
		)
		btn.custom_minimum_size = Vector2(0, 42)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var selected := puzzle_id == GameSession.current_puzzle_id
		_style_button(btn, ACCENT if selected else PANEL_ALT, Color(0.14, 0.27, 0.36) if selected else Color(0.18, 0.24, 0.30), false)
		puzzle_list.add_child(btn)
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
	narrative_label.add_theme_color_override("font_color", TEXT_MAIN)
	narrative_label.add_theme_font_size_override("font_size", 18)
	box.add_child(narrative_label)
	var continue_button := Button.new()
	continue_button.text = "Continue"
	continue_button.pressed.connect(_on_narrative_continue)
	continue_button.custom_minimum_size = Vector2(160, 40)
	_style_button(continue_button, ACCENT, Color(0.2, 0.42, 0.5), true)
	box.add_child(continue_button)
	return panel


func _add_button(parent: Node, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	button.custom_minimum_size = Vector2(180, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_style_button(button, ACCENT, Color(0.2, 0.42, 0.5), false)
	parent.add_child(button)


func _style_button(button: Button, base: Color, border: Color, is_secondary: bool) -> void:
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_color_override("font_color", TEXT_MAIN)
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_stylebox_override("normal", _button_style(base, border, 1.0, is_secondary))
	button.add_theme_stylebox_override("hover", _button_style(base.lerp(Color(1.0, 1.0, 1.0), 0.12), border, 1.0, is_secondary))
	button.add_theme_stylebox_override("pressed", _button_style(base.lerp(Color(0.0, 0.0, 0.0), 0.2), border, 1.0, is_secondary))
	button.add_theme_stylebox_override("focus", _button_style(base, border, 1.2, is_secondary))


func _button_style(base: Color, border: Color, glow: float, is_secondary: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = base
	style.border_color = border
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 2
	style.corner_radius_top_left = 9
	style.corner_radius_top_right = 9
	style.corner_radius_bottom_left = 9
	style.corner_radius_bottom_right = 9
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	style.shadow_color = base * glow
	style.shadow_size = 0 if not is_secondary else 4
	return style


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
