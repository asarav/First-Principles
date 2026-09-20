extends RefCounted


func run(t) -> void:
	t.case("main scene exists")
	t.is_true(ResourceLoader.exists("res://scenes/main.tscn"))

	t.case("main scene instantiates")
	var packed := load("res://scenes/main.tscn")
	t.is_true(packed is PackedScene)
	var scene: Node = packed.instantiate()
	t.is_true(scene != null)
	t.eq(scene.name, "Main")
	scene.free()

	t.case("puzzle library loads campaign puzzles")
	var puzzles := PuzzleLibrary.load_all()
	t.is_true(puzzles.has("tx001_conjunction"))
	t.is_true(puzzles.has("tx002_negation"))

	t.case("timeline and narrative data exist")
	var timeline = JsonUtil.load_file("res://data/timeline/timeline.json")
	t.is_true(typeof(timeline) == TYPE_DICTIONARY)
	t.is_true(timeline.events.size() >= 4)
	var scenes = JsonUtil.load_file("res://data/narrative/scenes.json")
	t.is_true(scenes.has("nv_tx001"))
