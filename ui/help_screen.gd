extends TextureRect
class_name HelpScreen

@onready var menu_sound: AudioStreamPlayer = $"Audio/Menu"
@onready var denied_sound: AudioStreamPlayer = $"Audio/Denied"
@onready var up_arrow: Control = $"VBoxContainer/Top/UpArrow"
@onready var down_arrow: Control = $"VBoxContainer/Bottom/DownArrow"

var page: int = 0
var max_page_index: int = -1
var pages: Array[Node]


func _ready():
	connect("visibility_changed", _reset)

	pages = get_node("VBoxContainer/Content").get_children()
	max_page_index = pages.size() - 1
	_update_arrows()


func _reset():
	pages[page].visible = false
	pages[0].visible = true

	page = 0
	_update_arrows()


func _update_arrows():
	up_arrow.visible = page > 0
	down_arrow.visible = page < max_page_index


func _previous_page():
	pages[page].visible = false
	pages[page - 1].visible = true

	page -= 1
	menu_sound.play()
	_update_arrows()


func _next_page():
	pages[page].visible = false
	pages[page + 1].visible = true

	page += 1
	menu_sound.play()
	_update_arrows()


func _process(_delta):
	if !visible:
		return

	if Input.is_action_just_pressed("Up"):
		if page > 0:
			_previous_page()
		else:
			denied_sound.play()
	elif Input.is_action_just_pressed("Down"):
		if page < max_page_index:
			_next_page()
		else:
			denied_sound.play()
