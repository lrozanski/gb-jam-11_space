extends GridContainer
class_name BuildingPanel

signal construction_confirmed(building: String)
signal construction_canceled
signal cursor_moved
signal cannot_build

@onready var indicator: Label = $"HQ/Indicator"

@export var enabled_color: Color
@export var disabled_color: Color

var buildings: Array[Node] = []
var building_index: int = 0
var max_index: int = -1
var building_name: String = ""

func _ready():
	buildings = get_children().filter(func(child): return child.visible)
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
		cursor_moved.emit()

	if Input.is_action_just_pressed("Confirm"):
		if !buildings[building_index].disabled:
			construction_confirmed.emit(building_name)

			if building_name == "HQ":
				_switch_layout()
		else:
			cannot_build.emit()
	elif Input.is_action_just_pressed("Cancel"):
		construction_canceled.emit()


func _switch_layout():
	for child: Label in get_children():
		child.visible = child.name != "HQ"
	
	indicator.reparent(get_child(0))
	buildings = get_children().filter(func(child): return child.visible)
	max_index = buildings.size()
	building_index = 0
	_update_building_name()
