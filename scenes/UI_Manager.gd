extends Node
class_name UI_Manager

static var CURSOR_MOVEABLE = true
static var BUILDING_PANEL_OPEN = false

@onready var cursor: Cursor = $"%Cursor"
@onready var building_panel: BuildingPanel = $"%BuildingPanel"


func _on_building_panel_open():
	BUILDING_PANEL_OPEN = true
	CURSOR_MOVEABLE = false


func _on_building_panel_close():
	BUILDING_PANEL_OPEN = false
	CURSOR_MOVEABLE = true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor.connect("construct_building", _on_building_panel_open)
	cursor.connect("demolish_building", func(): CURSOR_MOVEABLE = false)
	
	building_panel.connect("construction_confirmed", _on_building_panel_close)
	building_panel.connect("construction_canceled", _on_building_panel_close)
