class_name JsonUtil
extends RefCounted


static func load_file(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var text := file.get_as_text()
	var json := JSON.new()
	var err := json.parse(text)
	if err != OK:
		push_error("JSON parse error in %s: %s" % [path, json.get_error_message()])
		return null
	return json.data


static func save_file(path: String, data: Variant) -> bool:
	var dir_path := path.get_base_dir()
	if dir_path != "":
		var abs_dir := ProjectSettings.globalize_path(dir_path)
		if not DirAccess.dir_exists_absolute(abs_dir):
			var make_err := DirAccess.make_dir_recursive_absolute(abs_dir)
			if make_err != OK:
				push_error("Could not create directory %s" % abs_dir)
				return false
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not write %s" % path)
		return false
	file.store_string(JSON.stringify(data, "\t"))
	return true
