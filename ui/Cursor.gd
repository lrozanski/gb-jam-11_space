extends Node2D
class_name Cursor

@onready var map: Map = $"%TileMap"
@onready var buildings: Buildings = $"%Buildings"

signal construct_building
signal demolish_building

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

func _process(_delta):
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
		var building = buildings.query_building(global_position, get_world_2d())
		
		if building != null:
			demolish_building.emit()
			print("demolish_building")
		else:
			construct_building.emit()
			print("construct_building")
