extends Label
class_name BuildingLabel

@export var disabled: bool = false:
	set(value):
		disabled = value
		self_modulate = disabled_color if disabled else enabled_color
	get:
		return disabled

@export var enabled_color: Color
@export var disabled_color: Color

@onready var buildings: Buildings = $"/root/Scene/%Buildings"
@onready var resource_manager: ResourceManager = $"/root/Scene/%ResourceManager"

func _ready():
	resource_manager.connect("iron_changed", _update_cost, CONNECT_DEFERRED)

	_update_cost()


func _update_cost():
	var cost = buildings.BUILDING_COST.get(self.name as String) as int
	text = "%s: %s" % [self.name as String, cost]

	disabled = resource_manager.IRON < cost
