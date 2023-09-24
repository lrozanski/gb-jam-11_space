extends TextureRect
class_name OptionsScreen

@onready var jukebox: Jukebox = $"/root/Jukebox"
@onready var indicator: Label = $"CenterContainer/VBoxContainer/VBoxContainer/Sound/Indicator"
@onready var sound_volume_label: Label = $"CenterContainer/VBoxContainer/VBoxContainer/Sound/HBoxContainer/Percent"
@onready var music_volume_label: Label = $"CenterContainer/VBoxContainer/VBoxContainer/Music/HBoxContainer/Percent"

var menu_items: Array[Node]
var menu_index: int = 0
var max_menu_index: int = -1

const VOLUME_INCREMENT = 4


func _ready():
	menu_items = $"CenterContainer/VBoxContainer/VBoxContainer".get_children()
	max_menu_index = menu_items.size() - 1
	_update_volumes()


func _update_volumes():
	sound_volume_label.text = "%s%s" % [Jukebox.get_volume_percent(Jukebox.VolumeType.SOUND), "%"]
	music_volume_label.text = "%s%s" % [Jukebox.get_volume_percent(Jukebox.VolumeType.MUSIC), "%"]


func _reset():
	menu_index = 0
	indicator.reparent(menu_items[menu_index], false)


func _process(_delta):
	if !visible:
		return
	
	var current_menu_index = menu_index

	if Input.is_action_just_pressed("Up"):
		menu_index -= 1
	elif Input.is_action_just_pressed("Down"):
		menu_index += 1
	elif Input.is_action_just_pressed("Left"):
		var option = menu_items[menu_index].name as String
		var volume_type = Jukebox.VolumeType.SOUND if option == "Sound" else Jukebox.VolumeType.MUSIC

		jukebox.update_volume(volume_type, -VOLUME_INCREMENT)
		_update_volumes()
	elif Input.is_action_just_pressed("Right"):
		var option = menu_items[menu_index].name
		var volume_type = Jukebox.VolumeType.SOUND if option == "Sound" else Jukebox.VolumeType.MUSIC

		jukebox.update_volume(volume_type, VOLUME_INCREMENT)
		_update_volumes()

	if menu_index != current_menu_index:
		menu_index = wrapi(menu_index, 0, max_menu_index + 1)
		indicator.reparent(menu_items[menu_index], false)
		jukebox.menu_sound_player.play()
