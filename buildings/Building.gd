extends StaticBody2D
class_name Building

signal activated(type: String, disabled: bool)
signal deactivated(type: String, disabled: bool)

@export var disabled: bool = true:
	set(value):
		if disabled == value:
			return
		disabled = value
		
		if disabled:
			deactivated.emit(building_type, disabled)
		else:
			activated.emit(building_type, disabled)
			
@export var is_hq: bool = false
@export var building_type: String = ""

@onready var map: Map = $"/root/Scene/%TileMap"
@onready var resource_manager: ResourceManager = $"/root/Scene/%ResourceManager"
@onready var disabled_overlay: AnimatedSprite2D = $"DisabledOverlay";
@onready var world_2d: World2D


func _ready():
	world_2d = get_viewport().find_world_2d()

	connect("activated", resource_manager.on_building_state_changed)
	connect("deactivated", resource_manager.on_building_state_changed)

	if is_hq:
		disabled_overlay.stop()
		disabled_overlay.visible = false


func get_tile_position():
	var map_local = map.to_local(global_position)
	return map.local_to_map(map_local)


func _is_valid_pipe(first: Building, other: Building):
	if not other is Pipe:
		return false
	
	var first_tile_position = first.get_tile_position()
	var other_tile_position = other.get_tile_position()
		
	if (
		first_tile_position.x != other_tile_position.x &&
		first_tile_position.y == other_tile_position.y &&
		other.variant == Pipe.PipeVariant.HORIZONTAL
	):
		return true
	elif (
		first_tile_position.x == other_tile_position.x &&
		first_tile_position.y != other_tile_position.y &&
		other.variant == Pipe.PipeVariant.VERTICAL
	):
		return true
	
	return false


func find_neighbouring_buildings(current: Building):
	var neighbouring_buildings = [
		Buildings.query_building(current.global_position + Vector2(-Map.TILE_SIZE, 0), world_2d),
		Buildings.query_building(current.global_position + Vector2(Map.TILE_SIZE, 0), world_2d),
		Buildings.query_building(current.global_position + Vector2(0, -Map.TILE_SIZE), world_2d),
		Buildings.query_building(current.global_position + Vector2(0, Map.TILE_SIZE), world_2d),
	]
	var actual_buildings: Array[Building] = []
	var allow_only_pipes = true if (not current is Pipe) else false
	
	for building in neighbouring_buildings:
		if current == null || building == null:
			continue
		if allow_only_pipes && not building is Pipe:
			continue
		if building is Pipe && !_is_valid_pipe(current, building):
			continue
		if current is Pipe && building is Pipe:
			if (current as Pipe).variant != (building as Pipe).variant:
				continue
		if current is Pipe && not building is Pipe && !_is_valid_pipe(building, current):
			continue
		
		actual_buildings.append(building as Building)
	
	return actual_buildings


func update_connections(start_tile_position: Vector2i, new_state: bool):
	var open: Array[Building] = find_neighbouring_buildings(self)
	var closed: Dictionary = {start_tile_position: true}
	var closed_array: Array[Vector2i] = []
	
	while open.size() > 0:
		var current = open[0]
		open.remove_at(0)
		
		if closed.has(current.get_tile_position()):
			continue
		
		closed[current.get_tile_position()] = true
		closed_array.append(current.get_tile_position())
		
		if current.disabled != new_state:
			current.disabled = new_state
		
		var neighbours = find_neighbouring_buildings(current)
		for neighbour in neighbours:
			if closed.has(neighbour.get_tile_position()):
				continue
			
			open.append(neighbour)
	
	return closed_array


func restart_animations():
	if !disabled:
		return

	disabled_overlay.stop()
	disabled_overlay.play("default")


func enable_building():
	if !disabled:
		return
	disabled = false
	disabled_overlay.stop()
	disabled_overlay.visible = false


func disable_building():
	if disabled:
		return
	disabled = true
	disabled_overlay.stop()
	disabled_overlay.play("default")
	disabled_overlay.visible = true
