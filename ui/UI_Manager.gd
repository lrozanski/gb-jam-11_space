extends Node
class_name UI_Manager

static var CURSOR_MOVEABLE = true
static var BUILDING_PANEL_OPEN = false

@onready var cursor: Cursor = $"%Cursor"
@onready var building_panel: BuildingPanel = $"%StatusBar/%BuildingPanel"


func _on_building_panel_open():
	BUILDING_PANEL_OPEN = true
	CURSOR_MOVEABLE = false
	
	building_panel.visible = true
	building_panel.process_mode = Node.PROCESS_MODE_INHERIT
	print("Opened building panel")


func _on_building_panel_close():
	BUILDING_PANEL_OPEN = false
	CURSOR_MOVEABLE = true
	
	building_panel.visible = false
	building_panel.process_mode = Node.PROCESS_MODE_DISABLED
	print("Closed building panel")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor.connect("construct_building", _on_building_panel_open, CONNECT_DEFERRED)
	cursor.connect("demolish_building", func(): CURSOR_MOVEABLE = false, CONNECT_DEFERRED)
	
	building_panel.connect("construction_confirmed", _on_building_panel_close, CONNECT_DEFERRED)
	building_panel.connect("construction_canceled", _on_building_panel_close, CONNECT_DEFERRED)
