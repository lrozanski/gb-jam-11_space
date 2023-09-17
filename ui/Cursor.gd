extends Node2D
class_name Cursor

@onready var map: Map = $"%TileMap"

signal construct_building
signal demolish_building

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

func _process(delta):
	if !UI_Manager.CURSOR_MOVEABLE || UI_Manager.BUILDING_PANEL_OPEN:
		return
	
	# Movement
	var bounds: Vector2 = get_viewport_rect().size
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_just_pressed("Up"):
		direction.y = -1
	elif Input.is_action_just_pressed("Down"):
		direction.y = 1
	elif Input.is_action_just_pressed("Left"):
		direction.x = -1
	elif Input.is_action_just_pressed("Right"):
		direction.x = 1
	
	var new_position = global_position + direction * Map.TILE_SIZE
	
	if (
			new_position.x >= 0 && new_position.x < bounds.x && 
			new_position.y >= Map.TILE_SIZE && new_position.y < bounds.y - Map.TILE_SIZE
		):
		global_position += direction * Map.TILE_SIZE
	
	# Building
	if Input.is_action_just_pressed("Confirm"):
		var tile_center = global_position + Vector2(Map.TILE_SIZE / 2.0, Map.TILE_SIZE / 2.0)
		
		var params = PhysicsPointQueryParameters2D.new()
		params.collision_mask = 0x2
		params.position = tile_center
		
		var intersection = get_world_2d().direct_space_state.intersect_point(params)
		var collider = intersection[0].get("collider") if intersection.size() > 0 else null
		
		if collider != null:
			demolish_building.emit()
			print("demolish_building")
		else:
			construct_building.emit()
			print("construct_building")
