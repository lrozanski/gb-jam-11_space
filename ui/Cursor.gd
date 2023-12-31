extends Node2D
class_name Cursor

@onready var map: Map = $"%TileMap"
@onready var buildings: Buildings = $"%Buildings"
@onready var sprite: AnimatedSprite2D = $"AnimatedSprite2D"

signal construct_building(is_ore_patch: bool)
signal demolish_building

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass


func get_tile_position():
	var map_local = map.to_local(global_position)
	return map.local_to_map(map_local)


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
		var hq_placed = get_tree().get_nodes_in_group("hq").size() > 0
		var building = Buildings.query_building(global_position, get_world_2d())
		
		if is_instance_valid(building) && building != null:
			if building.is_hq:
				return
			demolish_building.emit()
		else:
			var tile_data = map.get_cell_tile_data(0, get_tile_position())
			var is_terraformed = tile_data.get_custom_data("is_terraformed") as bool
			var is_ore_patch = tile_data.get_custom_data("is_ore_patch") as bool

			if hq_placed && !is_terraformed:
				return

			construct_building.emit(is_ore_patch)


func restart_animation():
	sprite.stop()
	sprite.play("default")
