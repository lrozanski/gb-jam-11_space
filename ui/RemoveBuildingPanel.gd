extends GridContainer
class_name RemoveBuildingPanel

@onready var indicator: Label = $"Cancel/Indicator"

static var CHOICE: bool = false

signal removal_confirmed
signal removal_canceled

var choices: Array[Node] = []
var index: int = 1
var max_index: int = -1


func _ready():
	choices = get_children()
	max_index = choices.size()
	_update_indicator()
	_update_choice()


func _update_indicator():
	var choice = choices[index]
	indicator.reparent(choice, false)


func _update_choice():
	CHOICE = true if index == 2 else false


func _process(_delta):
	if !visible:
		return

	var current_index = index

	if Input.is_action_just_pressed("Left"):
		index -= 1
	elif Input.is_action_just_pressed("Right"):
		index += 1
	elif Input.is_action_just_pressed("Up"):
		index -= columns
	elif Input.is_action_just_pressed("Down"):
		index += columns

	if index != current_index:
		index = wrapi(index, 1, max_index)
		_update_indicator()
		_update_choice()

	if Input.is_action_just_pressed("Confirm"):
		removal_confirmed.emit()
		index = 1
		_update_indicator()
	elif Input.is_action_just_pressed("Cancel"):
		removal_canceled.emit()
		index = 1
		_update_indicator()
