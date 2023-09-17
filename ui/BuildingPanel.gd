extends GridContainer
class_name BuildingPanel

@onready var indicator: Label = $"Pipe/Indicator"

static var BUILDING_NAME: String = ""

signal construction_confirmed
signal construction_canceled

var building_buttons: Array[Node] = []
var building_index: int = 0
var max_index: int = -1

var paused = false

func _ready():
	building_buttons = get_children()
	max_index = building_buttons.size()
	_update_building_name(building_buttons[building_index].name as String)


func _update_building_name(name: String):
	BUILDING_NAME = name
	

func _process(_delta):
	if !visible:
		return

	var current_building_index = building_index

	if Input.is_action_just_pressed("Left"):
		building_index -= 1
	elif Input.is_action_just_pressed("Right"):
		building_index += 1

	if building_index != current_building_index:
		building_index = wrapi(building_index, 0, max_index)
		_update_building_name(building_buttons[building_index].name as String)

	if Input.is_action_just_pressed("Confirm"):
		construction_confirmed.emit()
	elif Input.is_action_just_pressed("Cancel"):
		construction_canceled.emit()
