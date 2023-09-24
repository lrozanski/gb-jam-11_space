extends TextureRect
class_name TitleScreen

@onready var menu_sound: AudioStreamPlayer = $"Audio/Menu"
@onready var grid_container: GridContainer = $"GridContainer"
@onready var indicator: Label = $"GridContainer/NewGame/Indicator"
@onready var help_screen: HelpScreen = $"%HelpScreen"

var menu_items: Array[Node]
var menu_index: int = 0
var max_menu_index: int = -1


func _ready():
	menu_items = $"GridContainer".get_children()
	max_menu_index = menu_items.size() - 1


func _reset():
	menu_index = 0
	indicator.reparent(menu_items[menu_index], false)


func _process(_delta):
	if get_tree().paused:
		if Input.is_action_just_pressed("Cancel"):
			help_screen.visible = false
			get_tree().paused = false
		return
	
	var current_menu_index = menu_index

	if Input.is_action_just_pressed("Left"):
		menu_index -= 1
	elif Input.is_action_just_pressed("Right"):
		menu_index += 1
	elif Input.is_action_just_pressed("Up"):
		menu_index -= grid_container.columns
	elif Input.is_action_just_pressed("Down"):
		menu_index += grid_container.columns

	if menu_index != current_menu_index:
		menu_index = wrapi(menu_index, 0, max_menu_index + 1)
		indicator.reparent(menu_items[menu_index], false)
		menu_sound.play()

	if Input.is_action_just_pressed("Confirm"):
		var text = menu_items[menu_index].name
		
		match text:
			"NewGame":
				get_tree().change_scene_to_file("res://scenes/main.tscn")
			"HowToPlay":
				help_screen.visible = true
				_reset()
				get_tree().paused = true
			"Options":
				pass
			"Exit":
				get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
				get_tree().quit()
