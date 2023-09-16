extends Node2D

@onready var map: Map = $"%TileMap"


func _ready():
	pass # Replace with function body.


func _process(delta):
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
