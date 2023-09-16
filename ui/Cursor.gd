extends Node2D

@onready var map: Map = $"%TileMap"

signal construct_building
signal demolish_building

func _process(delta):
	# Movement
	var bounds: Rect2 = get_viewport_rect()
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_just_pressed("Up"):
		direction.y = -1
	elif Input.is_action_just_pressed("Down"):
		direction.y = 1
	elif Input.is_action_just_pressed("Left"):
		direction.x = -1
	elif Input.is_action_just_pressed("Right"):
		direction.x = 1
		
	if bounds.has_point(global_position + direction * Map.TILE_SIZE):
		global_position += direction * Map.TILE_SIZE
	
	# Building
	if Input.is_action_just_pressed("Confirm"):
		var tile = map.local_to_map(map.to_local(global_position))
		var is_building = map.get_cell_tile_data(1, tile) != null
		
		if is_building:
			demolish_building.emit()
			print("demolish_building")
		else:
			construct_building.emit()
			print("construct_building")
