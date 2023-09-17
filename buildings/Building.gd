extends StaticBody2D
class_name Building

signal activated
signal deactivated

@export var disabled: bool = false:
	set(value):
		disabled = value
		if disabled:
			deactivated.emit()
		else:
			activated.emit()

@export var is_hq: bool = false

@onready var map: Map = $"/root/Scene/%TileMap"


func get_tile_position():
	var map_local = map.to_local(global_position)
	return map.local_to_map(map_local)


func _is_valid_pipe(first: Building, other: Building):
	if not other is Pipe:
		return false
		
	if (
		!is_equal_approx(first.global_position.x, other.global_position.x) &&
		other.variant == Pipe.PipeVariant.HORIZONTAL
	):
		return true
	elif (
		!is_equal_approx(first.global_position.y, other.global_position.y) &&
		other.variant == Pipe.PipeVariant.VERTICAL
	):
		return true
	
	return false


func find_neighbouring_buildings(current: Building):
	var world2d = get_world_2d()
	var neighbouring_buildings = [
		Buildings.query_building(global_position + Vector2(-Map.TILE_SIZE, 0), world2d),
		Buildings.query_building(global_position + Vector2(Map.TILE_SIZE, 0), world2d),
		Buildings.query_building(global_position + Vector2(0, -Map.TILE_SIZE), world2d),
		Buildings.query_building(global_position + Vector2(0, Map.TILE_SIZE), world2d),
	]
	var actual_buildings = []
	var allow_only_pipes = true if (not self is Pipe) else false
	
	for building in neighbouring_buildings:
		if building == null:
			continue
		if allow_only_pipes && not building is Pipe:
			continue
		if building is Pipe && !_is_valid_pipe(current, building):
			continue
		
		actual_buildings.append(building)
	
	return actual_buildings


func update_connections(connection_changed_tile_position: Vector2i, new_state: bool):
	var initial_connections = find_neighbouring_buildings(self)
	var open: Array[Building] = []
	var closed: Dictionary = {connection_changed_tile_position: null}
	
	open.append_array(initial_connections)
	
	while open.size() > 0:
		var current = open[0]
		open.remove_at(0)
		
		if current.disabled:
			current.disabled = new_state
		
		var neighbours = find_neighbouring_buildings(current)
		for neighbour in neighbours:
			if closed.has(neighbour.get_tile_position()):
				continue
			
			open.append(neighbour)

