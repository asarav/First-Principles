class_name SignalFlowOverlay
extends Control

const HIGH := Color(0.38, 0.95, 0.78)
const LOW := Color(0.30, 0.42, 0.48)
const UNSET := Color(0.95, 0.67, 0.28)

var graph: GraphEdit
var machine: Machine
var playing := false
var elapsed := 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_machine(value: Machine, animate: bool) -> void:
	machine = value
	playing = animate
	queue_redraw()


func set_playing(value: bool) -> void:
	playing = value
	queue_redraw()


func stop_playing() -> void:
	playing = false
	elapsed = 0.0
	queue_redraw()


func connection_at_point(point: Vector2, tolerance: float = 14.0) -> Dictionary:
	if graph == null:
		return {}
	for item in graph.get_connection_list():
		var from_id := str(item.get("from_node", item.get("from", "")))
		var to_id := str(item.get("to_node", item.get("to", "")))
		var start_value: Variant = _port_position(from_id, int(item.get("from_port", 0)), true)
		var finish_value: Variant = _port_position(to_id, int(item.get("to_port", 0)), false)
		if start_value == null or finish_value == null:
			continue
		var start: Vector2 = start_value
		var finish: Vector2 = finish_value
		if _distance_to_segment(point, start, finish) <= tolerance:
			return item
	return {}


func _distance_to_segment(point: Vector2, start: Vector2, finish: Vector2) -> float:
	var segment := finish - start
	if segment.length_squared() == 0.0:
		return point.distance_to(start)
	var amount := clampf((point - start).dot(segment) / segment.length_squared(), 0.0, 1.0)
	return point.distance_to(start + segment * amount)


func _process(delta: float) -> void:
	if playing:
		elapsed += delta
	queue_redraw()


func _draw() -> void:
	if graph == null or machine == null:
		return
	var connections: Array = graph.get_connection_list()
	for index in connections.size():
		var item: Dictionary = connections[index]
		var from_id := str(item.get("from_node", item.get("from", "")))
		var to_id := str(item.get("to_node", item.get("to", "")))
		var from_port := int(item.get("from_port", 0))
		var to_port := int(item.get("to_port", 0))
		var start_value: Variant = _port_position(from_id, from_port, true)
		var finish_value: Variant = _port_position(to_id, to_port, false)
		if start_value == null or finish_value == null:
			continue
		var start: Vector2 = start_value
		var finish: Vector2 = finish_value
		var value := _connection_value(from_id, to_id, from_port, to_port)
		var color := UNSET
		if value != null and value.is_set():
			color = HIGH if value.bool_value else LOW
		draw_line(start, finish, Color(color, 0.72), 3.0, true)
		if playing and value != null and value.is_set():
			var progress := fmod(elapsed * 0.85 + float(index) * 0.19, 1.0)
			var pulse: Vector2 = start.lerp(finish, progress)
			draw_circle(pulse, 5.0, Color(color, 0.98))


func _port_position(node_id: String, port: int, output: bool) -> Variant:
	var node := graph.get_node_or_null(NodePath(node_id)) as GraphNode
	if node == null:
		return null
	var row: Control
	var row_index := 0
	for child in node.get_children():
		if not (child is HBoxContainer):
			continue
		if row_index == port:
			row = child as Control
			break
		row_index += 1
	if row == null:
		return null
	var local_position: Vector2 = node.get_output_port_position(port) if output else node.get_input_port_position(port)
	return (node.position_offset + local_position - graph.scroll_offset) * graph.zoom + graph.size * 0.5


func _connection_value(from_id: String, to_id: String, from_port: int, to_port: int) -> SignalValue:
	if not machine.components.has(from_id) or not machine.components.has(to_id):
		return SignalValue.unset()
	var from_component: SimComponent = machine.components[from_id]
	var to_component: SimComponent = machine.components[to_id]
	var from_ports := from_component.output_ports
	var to_ports := to_component.input_ports
	if from_port < 0 or from_port >= from_ports.size() or to_port < 0 or to_port >= to_ports.size():
		return SignalValue.unset()
	return from_component.get_output(from_ports[from_port])