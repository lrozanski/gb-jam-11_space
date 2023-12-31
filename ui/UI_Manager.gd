extends Node
class_name UI_Manager

static var CURSOR_MOVEABLE = true
static var BUILDING_PANEL_OPEN = false
static var REMOVE_BUILDING_PANEL_OPEN = false

@onready var cursor: Cursor = $"%Cursor"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"
@onready var remove_building_panel: RemoveBuildingPanel = $"%StatusBar/%RemoveBuildingPanel"
@onready var game_manager: GameManager = $"%GameManager"
@onready var help_screen: HelpScreen = $"%HelpScreen"
@onready var pause_screen: Control = $"%PauseScreen"


func _on_building_panel_open(is_ore_patch: bool):
	BUILDING_PANEL_OPEN = true
	REMOVE_BUILDING_PANEL_OPEN = false
	CURSOR_MOVEABLE = false
	
	building_panel.visible = true
	building_panel.process_mode = Node.PROCESS_MODE_INHERIT
	building_panel.toggle_mine_item(is_ore_patch)


func _on_building_panel_close(_building_name: String = ""):
	BUILDING_PANEL_OPEN = false
	REMOVE_BUILDING_PANEL_OPEN = false
	CURSOR_MOVEABLE = true
	
	building_panel.toggle_mine_item(false)
	building_panel.visible = false
	building_panel.process_mode = Node.PROCESS_MODE_DISABLED


func _on_remove_building_panel_open():
	BUILDING_PANEL_OPEN = false
	REMOVE_BUILDING_PANEL_OPEN = true
	CURSOR_MOVEABLE = false
	
	remove_building_panel.visible = true
	remove_building_panel.process_mode = Node.PROCESS_MODE_INHERIT


func _on_remove_building_panel_close(_choice: bool = false):
	BUILDING_PANEL_OPEN = false
	REMOVE_BUILDING_PANEL_OPEN = false
	CURSOR_MOVEABLE = true
	
	remove_building_panel.visible = false
	remove_building_panel.process_mode = Node.PROCESS_MODE_DISABLED


func _ready():
	CURSOR_MOVEABLE = true
	BUILDING_PANEL_OPEN = false
	REMOVE_BUILDING_PANEL_OPEN = false

	cursor.connect("construct_building", _on_building_panel_open, CONNECT_DEFERRED)
	cursor.connect("demolish_building", _on_remove_building_panel_open, CONNECT_DEFERRED)
	
	building_panel.connect("construction_confirmed", _on_building_panel_close, CONNECT_DEFERRED)
	building_panel.connect("construction_canceled", _on_building_panel_close, CONNECT_DEFERRED)
	
	remove_building_panel.connect("removal_confirmed", _on_remove_building_panel_close, CONNECT_DEFERRED)
	remove_building_panel.connect("removal_canceled", _on_remove_building_panel_close, CONNECT_DEFERRED)


func _process(_delta):
	if !help_screen.visible && Input.is_action_just_pressed("Select"):
		help_screen.visible = true
		game_manager.pause()
	elif help_screen.visible && Input.is_action_just_pressed("Cancel"):
		help_screen.visible = false
		game_manager.unpause()
	if !help_screen.visible && Input.is_action_just_pressed("Start"):
		pause_screen.visible = true
		game_manager.pause()
	elif pause_screen.visible && Input.is_action_just_pressed("Cancel"):
		pause_screen.visible = false
		game_manager.unpause()
