extends GridContainer
class_name BuildingPanel

@onready var indicator: Label = $"H Pipe/Indicator"

signal construction_confirmed(building: String)
signal construction_canceled

var buildings: Array[Node] = []
var building_index: int = 0
var max_index: int = -1
var building_name: String = ""

func _ready():
	buildings = get_children()
	max_index = buildings.size()
	_update_building_name()


func _update_building_name():
	var building = buildings[building_index]
	building_name = building.name as String
	indicator.reparent(building, false)


func _process(_delta):
	if !visible:
		return

	var current_building_index = building_index

	if Input.is_action_just_pressed("Left"):
		building_index -= 1
	elif Input.is_action_just_pressed("Right"):
		building_index += 1
	elif Input.is_action_just_pressed("Up"):
		building_index -= columns
	elif Input.is_action_just_pressed("Down"):
		building_index += columns

	if building_index != current_building_index:
		building_index = wrapi(building_index, 0, max_index)
		_update_building_name()

	if Input.is_action_just_pressed("Confirm"):
		construction_confirmed.emit(building_name)
	elif Input.is_action_just_pressed("Cancel"):
		construction_canceled.emit()
