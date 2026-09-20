class_name Machine
extends RefCounted

## Deterministic combinational machine. Presentation-free: no Node types.

var components: Dictionary = {}
var connections: Array[SimConnection] = []
var tick: int = 0
var last_settle_iterations: int = 0
var last_settled: bool = true
var errors: PackedStringArray = PackedStringArray()


func clear() -> void:
	components.clear()
	connections.clear()
	tick = 0
	last_settle_iterations = 0
	last_settled = true
	errors = PackedStringArray()


func add_component(component: SimComponent) -> bool:
	if component == null or component.id.is_empty():
		_add_error("Component is missing an id.")
		return false
	if components.has(component.id):
		_add_error("Duplicate component id: %s" % component.id)
		return false
	components[component.id] = component
	return true


func add_connection(connection: SimConnection) -> bool:
	var problem := _connection_problem(connection)
	if problem != "":
		_add_error(problem)
		return false
	connections.append(connection)
	return true


func reset() -> void:
	tick = 0
	last_settle_iterations = 0
	last_settled = true
	var ids := _sorted_ids()
	for id in ids:
		(components[id] as SimComponent).reset()


func set_input(input_id: String, value: SignalValue) -> bool:
	if not components.has(input_id):
		_add_error("Unknown input: %s" % input_id)
		return false
	var component: SimComponent = components[input_id]
	if component is CompInput:
		(component as CompInput).set_forced(value)
		component.evaluate()
		return true
	_add_error("Component is not an input: %s" % input_id)
	return false


func get_output(output_id: String) -> SignalValue:
	if not components.has(output_id):
		return SignalValue.unset()
	var component: SimComponent = components[output_id]
	return component.get_input("in")


func step() -> bool:
	tick += 1
	return _evaluate_wave()


func settle(max_iterations: int = 32) -> bool:
	reset()
	var changed := true
	var iterations := 0
	while changed and iterations < max_iterations:
		changed = _evaluate_wave()
		iterations += 1
		tick = iterations
	last_settle_iterations = iterations
	last_settled = not changed
	if changed:
		_add_error("Machine did not settle after %d iterations." % max_iterations)
	return last_settled


func inspect() -> Dictionary:
	var comps := {}
	for id in _sorted_ids():
		comps[id] = (components[id] as SimComponent).inspect()
	var conns: Array = []
	for connection in connections:
		conns.append(connection.to_dict())
	return {
		"tick": tick,
		"settled": last_settled,
		"settle_iterations": last_settle_iterations,
		"components": comps,
		"connections": conns,
		"errors": Array(errors),
	}


func _evaluate_wave() -> bool:
	var before := _snapshot_outputs()
	_propagate_connections()
	for id in _sorted_ids():
		(components[id] as SimComponent).evaluate()
	var after := _snapshot_outputs()
	return before != after


func _propagate_connections() -> void:
	var ordered := connections.duplicate()
	ordered.sort_custom(func(a: SimConnection, b: SimConnection) -> bool: return a.key() < b.key())
	for connection in ordered:
		if not components.has(connection.from_id) or not components.has(connection.to_id):
			continue
		var src: SimComponent = components[connection.from_id]
		var dst: SimComponent = components[connection.to_id]
		dst.set_input(connection.to_port, src.get_output(connection.from_port))


func _snapshot_outputs() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for id in _sorted_ids():
		var component: SimComponent = components[id]
		for port in component.output_ports:
			parts.append("%s.%s=%s" % [id, port, component.get_output(port).to_debug_string()])
		if component is CompOutput:
			parts.append("%s.in=%s" % [id, component.get_input("in").to_debug_string()])
	return "|".join(parts)


func _sorted_ids() -> PackedStringArray:
	var ids := PackedStringArray(components.keys())
	ids.sort()
	return ids


func _connection_problem(connection: SimConnection) -> String:
	if connection == null:
		return "Connection is null."
	if not components.has(connection.from_id):
		return "Connection source missing: %s" % connection.from_id
	if not components.has(connection.to_id):
		return "Connection destination missing: %s" % connection.to_id
	var src: SimComponent = components[connection.from_id]
	var dst: SimComponent = components[connection.to_id]
	if not src.has_output_port(connection.from_port):
		return "Unknown output port %s on %s" % [connection.from_port, connection.from_id]
	if not dst.has_input_port(connection.to_port):
		return "Unknown input port %s on %s" % [connection.to_port, connection.to_id]
	for existing in connections:
		if existing.to_id == connection.to_id and existing.to_port == connection.to_port:
			return "Input port %s.%s already has a driver." % [connection.to_id, connection.to_port]
	return ""


func _add_error(message: String) -> void:
	if not errors.has(message):
		errors.append(message)
