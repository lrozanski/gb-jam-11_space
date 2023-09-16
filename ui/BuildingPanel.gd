extends PanelContainer
class_name BuildingPanel

@onready var cursor: Cursor = $"%Cursor"
@onready var building_label: Label = $"MarginContainer/Rows/BuildingLabel"

static var BUILDING_NAME: String = ""

signal construction_confirmed
signal construction_canceled

var building_buttons: Array[Node] = []
var building_index: int = 0
var max_index: int = -1

var paused = false

func _ready():
	cursor.connect("construct_building", show_panel, CONNECT_DEFERRED)
	building_buttons = get_node("MarginContainer/Rows/Buildings").get_children()
	max_index = building_buttons.size() - 1


func show_panel():
	visible = true
	queue_redraw()


func hide_panel():
	visible = false
	paused = true


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
		(building_buttons[building_index] as Button).grab_focus()
		BUILDING_NAME = building_buttons[building_index].name as String
		building_label.text = BUILDING_NAME

	if Input.is_action_just_pressed("Confirm"):
		construction_confirmed.emit()
		hide_panel()
	elif Input.is_action_just_pressed("Cancel"):
		construction_canceled.emit()
		hide_panel()
