extends Control

const ACCENT := Color(0.42, 0.78, 0.92)
const PRIMARY := Color(0.22, 0.62, 0.66)
const NAV_BG := Color(0.12, 0.16, 0.19)
const NAV_BORDER := Color(0.30, 0.40, 0.44)
const PANEL_BG := Color(0.08, 0.11, 0.15)
const PANEL_ALT := Color(0.12, 0.16, 0.21)
const TEXT_MAIN := Color(0.94, 0.97, 1.0)
const TEXT_MUTED := Color(0.72, 0.82, 0.88)
const FEEDBACK_AUDIO_SCRIPT = preload("res://scenes/feedback_audio.gd")

var hub: Control
var start_screen: Control
var narrative: Control
var workbench: Control
var back_button: Button
var year_label: Label
var body_label: Label
var narrative_title: Label
var narrative_speaker: Label
var narrative_dialogue: Label
var narrative_progress: Label
var narrative_lines: Array = []
var narrative_line_index: int = 0
var pending_events: Array = []
var puzzle_buttons: Dictionary = {}
var feedback_audio


func _ready() -> void:
	set_anchors_preset(PRESET_FULL_RECT)
	_build()
	if GameSession.intro_seen:
		_show_hub()
	else:
		_show_start_screen()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo or key_event.keycode != KEY_ESCAPE:
		return
	if narrative.visible or workbench.visible:
		_play_feedback("click")
		_show_hub()
		get_viewport().set_input_as_handled()


func _build() -> void:
	feedback_audio = FEEDBACK_AUDIO_SCRIPT.new()
	add_child(feedback_audio)
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.07, 0.09)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	add_child(bg)

	start_screen = _build_start_screen()
	add_child(start_screen)

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

	back_button = Button.new()
	back_button.text = "Back to Hub"
	back_button.set_anchors_preset(PRESET_TOP_LEFT)
	back_button.position = Vector2(18, 16)
	back_button.custom_minimum_size = Vector2(142, 34)
	back_button.pressed.connect(func() -> void:
		_play_feedback("click")
		_show_hub()
	)
	_style_button(back_button, NAV_BG, NAV_BORDER, true)
	back_button.tooltip_text = "Leave this scene and return to the campaign hub."
	back_button.visible = false
	add_child(back_button)


func _build_start_screen() -> Control:
	var panel := MarginContainer.new()
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.add_theme_constant_override("margin_left", 96)
	panel.add_theme_constant_override("margin_top", 92)
	panel.add_theme_constant_override("margin_right", 96)
	panel.add_theme_constant_override("margin_bottom", 72)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 22)
	panel.add_child(box)
	var mark := Label.new()
	mark.text = "DEEP SPACE ARRAY  /  FIELD LOG 001"
	mark.add_theme_color_override("font_color", TEXT_MUTED)
	mark.add_theme_font_size_override("font_size", 15)
	box.add_child(mark)
	var title := Label.new()
	title.text = "FIRST PRINCIPLES"
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", TEXT_MAIN)
	box.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "A puzzle about learning to understand the universe."
	subtitle.add_theme_font_size_override("font_size", 24)
	subtitle.add_theme_color_override("font_color", ACCENT)
	box.add_child(subtitle)
	var premise := Label.new()
	premise.text = "Humanity has received a message from an unknown civilization.\nIt is not language. It is a machine.\n\nYou are Dr. Imane Kessler, part of the Deep Space Array.\nYour first assignment is to reconstruct the artifact's operation, one experiment at a time."
	premise.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	premise.add_theme_font_size_override("font_size", 20)
	premise.add_theme_color_override("font_color", TEXT_MAIN)
	box.add_child(premise)
	var begin := Button.new()
	begin.text = "Begin Investigation"
	begin.custom_minimum_size = Vector2(260, 48)
	begin.pressed.connect(func() -> void:
		_play_feedback("success")
		_begin_investigation()
	)
	_style_button(begin, PRIMARY, Color(0.34, 0.78, 0.78), false)
	box.add_child(begin)
	var quit := Button.new()
	quit.text = "Exit Game"
	quit.custom_minimum_size = Vector2(150, 36)
	quit.pressed.connect(func() -> void:
		_play_feedback("click")
		_quit_game()
	)
	_style_button(quit, NAV_BG, NAV_BORDER, true)
	box.add_child(quit)
	return panel


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
	puzzle_title.text = "TRANSMISSION SELECTOR  /  choose an active artifact"
	puzzle_title.add_theme_color_override("font_color", TEXT_MUTED)
	puzzle_title.add_theme_font_size_override("font_size", 18)
	puzzle_list.add_child(puzzle_title)
	for puzzle_id in GameSession.available_puzzle_ids():
		var puzzle := PuzzleLibrary.load_id(puzzle_id)
		var label := str(puzzle.title) if puzzle else puzzle_id
		var btn := Button.new()
		btn.set_meta("puzzle_title", label)
		btn.pressed.connect(func() -> void:
			_play_feedback("click")
			GameSession.current_puzzle_id = puzzle_id
			GameSession.save_session()
			_refresh_puzzle_selection()
			_show_hub()
		)
		btn.custom_minimum_size = Vector2(0, 42)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		puzzle_buttons[puzzle_id] = btn
		puzzle_list.add_child(btn)
	_refresh_puzzle_selection()
	var restart := Button.new()
	restart.text = "Restart Tutorial"
	restart.custom_minimum_size = Vector2(190, 36)
	restart.pressed.connect(func() -> void:
		_play_feedback("click")
		GameSession.reset_session()
		_show_start_screen()
	)
	_style_button(restart, NAV_BG, NAV_BORDER, true)
	restart.tooltip_text = "Clear campaign progress and replay the first-contact tutorial."
	box.add_child(restart)
	return panel


func _refresh_puzzle_selection() -> void:
	for puzzle_id in puzzle_buttons.keys():
		var btn: Button = puzzle_buttons[puzzle_id]
		var selected := str(puzzle_id) == GameSession.current_puzzle_id
		var marker := "●" if selected else "○"
		var suffix := "  /  SELECTED" if selected else ""
		btn.text = "%s  %s%s" % [marker, str(btn.get_meta("puzzle_title", puzzle_id)), suffix]
		btn.tooltip_text = "Selected transmission." if selected else "Select this transmission as the active investigation."
		_style_button(btn, PRIMARY if selected else PANEL_ALT, Color(0.34, 0.78, 0.78) if selected else Color(0.18, 0.24, 0.30), false)


func _build_narrative() -> Control:
	var panel := MarginContainer.new()
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.add_theme_constant_override("margin_left", 96)
	panel.add_theme_constant_override("margin_top", 92)
	panel.add_theme_constant_override("margin_right", 96)
	panel.add_theme_constant_override("margin_bottom", 72)
	panel.visible = false
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)
	narrative_progress = Label.new()
	narrative_progress.add_theme_color_override("font_color", TEXT_MUTED)
	box.add_child(narrative_progress)
	narrative_title = Label.new()
	narrative_title.add_theme_font_size_override("font_size", 32)
	narrative_title.add_theme_color_override("font_color", TEXT_MAIN)
	box.add_child(narrative_title)
	var separator := HSeparator.new()
	box.add_child(separator)
	narrative_speaker = Label.new()
	narrative_speaker.add_theme_color_override("font_color", ACCENT)
	narrative_speaker.add_theme_font_size_override("font_size", 16)
	box.add_child(narrative_speaker)
	narrative_dialogue = Label.new()
	narrative_dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	narrative_dialogue.add_theme_color_override("font_color", TEXT_MAIN)
	narrative_dialogue.add_theme_font_size_override("font_size", 24)
	narrative_dialogue.custom_minimum_size = Vector2(0, 180)
	box.add_child(narrative_dialogue)
	var continue_button := Button.new()
	continue_button.text = "Continue"
	continue_button.pressed.connect(func() -> void:
		_play_feedback("click")
		_on_narrative_continue()
	)
	continue_button.custom_minimum_size = Vector2(220, 44)
	_style_button(continue_button, PRIMARY, Color(0.34, 0.78, 0.78), false)
	box.add_child(continue_button)
	return panel


func _add_button(parent: Node, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(func() -> void:
		_play_feedback("click")
		callback.call()
	)
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
	button.mouse_entered.connect(func() -> void: _play_feedback("toggle"))


func _play_feedback(kind: String) -> void:
	if feedback_audio != null:
		feedback_audio.play_feedback(kind)


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
	start_screen.visible = false
	hub.visible = true
	narrative.visible = false
	workbench.visible = false
	back_button.visible = false
	_refresh_puzzle_selection()
	year_label.text = "Year %d" % GameSession.year
	var tx := GameSession.current_transmission()
	var puzzle := PuzzleLibrary.load_id(GameSession.current_puzzle_id)
	var title := puzzle.title if puzzle else GameSession.current_puzzle_id
	body_label.text = "You are Dr. Imane Kessler, working with the Deep Space Array.\nYour task is to turn an unknown transmission into a testable machine.\n\nCurrent artifact: %s\nUnlocked: %s\nCompleted: %s\n\n%s" % [
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
	start_screen.visible = false
	hub.visible = false
	narrative.visible = false
	workbench.visible = true
	back_button.visible = true
	workbench.load_puzzle(GameSession.current_puzzle_id)


func _show_scene(scene_id: String, afterward: Callable) -> void:
	var scene: Dictionary = GameSession.scene_for(scene_id)
	start_screen.visible = false
	hub.visible = false
	workbench.visible = false
	narrative.visible = true
	back_button.visible = true
	narrative.set_meta("afterward", afterward)
	if scene.is_empty():
		narrative_title.text = "No record"
		narrative_speaker.text = "ARCHIVE"
		narrative_dialogue.text = "This transmission has not been catalogued."
		return
	narrative_title.text = str(scene.get("title", scene_id))
	narrative_lines = scene.get("lines", [])
	narrative_line_index = 0
	_render_narrative_line()


func _render_narrative_line() -> void:
	if narrative_lines.is_empty():
		narrative_speaker.text = "ARCHIVE"
		narrative_dialogue.text = "No text has been recorded."
		narrative_progress.text = "TRANSMISSION"
		return
	var line: Dictionary = narrative_lines[narrative_line_index]
	narrative_speaker.text = str(line.get("speaker", ""))
	narrative_dialogue.text = str(line.get("text", ""))
	narrative_progress.text = "TRANSMISSION  %d / %d" % [narrative_line_index + 1, narrative_lines.size()]


func _on_narrative_continue() -> void:
	if narrative_line_index < narrative_lines.size() - 1:
		narrative_line_index += 1
		_render_narrative_line()
		return
	var afterward: Callable = narrative.get_meta("afterward", Callable())
	if afterward.is_valid():
		afterward.call()
	else:
		_show_hub()


func _show_start_screen() -> void:
	start_screen.visible = true
	hub.visible = false
	narrative.visible = false
	workbench.visible = false
	back_button.visible = false


func _begin_investigation() -> void:
	GameSession.intro_seen = true
	GameSession.save_session()
	_show_hub()


func _quit_game() -> void:
	get_tree().quit()


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
