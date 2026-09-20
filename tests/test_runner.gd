extends SceneTree

func _initialize() -> void:
	var runner := TestRunner.new()
	var code := runner.run()
	if code == 0:
		code = await _smoke_main_scene()
	quit(code)


func _smoke_main_scene() -> int:
	print("=== Scene smoke ===")
	var packed := load("res://scenes/main.tscn")
	if packed == null:
		print("FAIL scene smoke :: main.tscn failed to load")
		return 1
	var scene: Node = packed.instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	if scene.has_method("_open_workbench"):
		scene.call("_open_workbench")
		await process_frame
		await process_frame
		await process_frame
	if scene == null or not is_instance_valid(scene):
		print("FAIL scene smoke :: instance vanished")
		return 1
	print("scene smoke: passed")
	if is_instance_valid(scene):
		for child in root.get_children():
			if is_instance_valid(child):
				root.remove_child(child)
				child.free()
		scene = null
		await process_frame
		await process_frame
	return 0


class TestRunner:
	func run() -> int:
		var suites: Array = [
			preload("res://tests/suite_simulation.gd").new(),
			preload("res://tests/suite_validator.gd").new(),
			preload("res://tests/suite_serialize.gd").new(),
			preload("res://tests/suite_session.gd").new(),
			preload("res://tests/suite_smoke.gd").new(),
		]
		var failed := 0
		var passed := 0
		print("=== First Principles tests ===")
		for suite in suites:
			var ctx := TestContext.new(suite.get_script().resource_path.get_file())
			suite.run(ctx)
			passed += ctx.passed
			failed += ctx.failed
			ctx.print_summary()
		print("TOTAL passed=%d failed=%d" % [passed, failed])
		return 1 if failed > 0 else 0


class TestContext:
	var suite_name: String = ""
	var passed: int = 0
	var failed: int = 0
	var current: String = ""

	func _init(p_suite_name: String) -> void:
		suite_name = p_suite_name

	func case(name: String) -> void:
		current = name

	func eq(actual: Variant, expected: Variant, message: String = "") -> void:
		if _equals(actual, expected):
			passed += 1
			return
		failed += 1
		print("FAIL %s :: %s expected=%s actual=%s %s" % [suite_name, current, str(expected), str(actual), message])

	func is_true(actual: bool, message: String = "") -> void:
		eq(actual, true, message)

	func is_false(actual: bool, message: String = "") -> void:
		eq(actual, false, message)

	func contains(text: String, needle: String, message: String = "") -> void:
		is_true(text.contains(needle), message if message != "" else "missing '%s' in '%s'" % [needle, text])

	func print_summary() -> void:
		print("%s: passed=%d failed=%d" % [suite_name, passed, failed])

	func _equals(a: Variant, b: Variant) -> bool:
		if a is SignalValue and b is SignalValue:
			return (a as SignalValue).equals(b)
		return a == b
