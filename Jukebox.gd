extends Node


var theme: AudioStream = preload("res://music/theme.ogg") as AudioStream
var music_player: AudioStreamPlayer


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_player = AudioStreamPlayer.new()
	music_player.stream = theme
	music_player.volume_db = -5.0

	add_child(music_player)
	music_player.play()
