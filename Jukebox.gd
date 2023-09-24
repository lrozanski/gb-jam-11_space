extends Node

var menu_sound_stream: AudioStream = preload("res://sounds/Menu.wav") as AudioStream
var invalid_sound_stream: AudioStream = preload("res://sounds/Not_Allowed.wav") as AudioStream
var building_built_stream: AudioStream = preload("res://sounds/Built.wav") as AudioStream
var building_removed_stream: AudioStream = preload("res://sounds/Demolished.wav") as AudioStream
var theme: AudioStream = preload("res://music/theme.ogg") as AudioStream

var menu_sound_player: AudioStreamPlayer
var invalid_sound_player: AudioStreamPlayer
var building_built_player: AudioStreamPlayer
var building_removed_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

enum VolumeType {
	SOUND,
	MUSIC
}

var volume_ranges = {
	VolumeType.SOUND: [-20.0, 0.0],
	VolumeType.MUSIC: [-20.0, 0.0],
}
var volume_offets = {
	"menu": -5.0,
	"invalid": -5.0,
	"building_built": 0.0,
	"building_removed": 0.0,
	"theme": -5.0,
}


func get_volume_percent(volume_type: VolumeType):
	var min_volume = volume_ranges[volume_type][0]
	var max_volume = volume_ranges[volume_type][1]
	var player = building_built_player if volume_type == VolumeType.SOUND else music_player
	var offset = volume_offets["building_built"] if volume_type == VolumeType.SOUND else volume_offets["theme"]

	return inverse_lerp(min_volume + offset, max_volume + offset, player.volume_db) * 100.0


func _create_audio_stream_player(new_name: String, stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0):
	var player = AudioStreamPlayer.new()
	player.name = new_name
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale

	add_child(player)
	return player


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	menu_sound_player = _create_audio_stream_player("menu", menu_sound_stream, -5.0, 1.2)
	invalid_sound_player = _create_audio_stream_player("invalid", invalid_sound_stream, -5.0, 1.2)
	building_built_player = _create_audio_stream_player("building_built", building_built_stream)
	building_removed_player = _create_audio_stream_player("building_removed", building_removed_stream)

	music_player = _create_audio_stream_player("theme", theme, -5.0)
	music_player.play()


func update_volume(volume_type: VolumeType, amount: float):
	match volume_type:
		VolumeType.SOUND:
			var min_volume = volume_ranges[VolumeType.SOUND][0]
			var max_volume = volume_ranges[VolumeType.SOUND][1]

			menu_sound_player.volume_db = clampf(menu_sound_player.volume_db + amount, min_volume + volume_offets["menu"], max_volume + volume_offets["menu"])
			invalid_sound_player.volume_db = clampf(invalid_sound_player.volume_db + amount, min_volume + volume_offets["invalid"], max_volume + volume_offets["invalid"])
			building_built_player.volume_db = clampf(building_built_player.volume_db + amount, min_volume + volume_offets["building_built"], max_volume + volume_offets["building_built"])
			building_removed_player.volume_db = clampf(building_removed_player.volume_db + amount, min_volume + volume_offets["building_removed"], max_volume + volume_offets["building_removed"])
		VolumeType.MUSIC:
			var min_volume = volume_ranges[VolumeType.MUSIC][0]
			var max_volume = volume_ranges[VolumeType.MUSIC][1]

			music_player.volume_db = clampf(music_player.volume_db + amount, min_volume + volume_offets["theme"], max_volume + volume_offets["theme"])
