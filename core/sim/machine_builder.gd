class_name MachineBuilder
extends RefCounted


static func build(puzzle: PuzzleDefinition, construction: Construction) -> Machine:
	var machine := Machine.new()
	if puzzle == null:
		machine.errors.append("No puzzle definition.")
		return machine

	for item in puzzle.inputs:
		var io_id := str(item.get("id", ""))
		var component := ComponentTypes.create(ComponentTypes.INPUT, puzzle.io_component_id("in", io_id), item)
		machine.add_component(component)
	for item in puzzle.outputs:
		var io_id := str(item.get("id", ""))
		var component := ComponentTypes.create(ComponentTypes.OUTPUT, puzzle.io_component_id("out", io_id), item)
		machine.add_component(component)

	if construction == null:
		return machine

	for item in construction.components:
		var type_id := str(item.get("type", ""))
		var component_id := str(item.get("id", ""))
		var config: Dictionary = item.get("config", {})
		var component := ComponentTypes.create(type_id, component_id, config)
		if component == null:
			machine.errors.append("Unknown component type: %s" % type_id)
			continue
		machine.add_component(component)

	for item in construction.connections:
		machine.add_connection(SimConnection.from_dict(item))

	return machine
