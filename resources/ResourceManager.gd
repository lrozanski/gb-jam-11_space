extends Node
class_name ResourceManager

signal population_changed
signal iron_changed

static var POPULATION: int
static var MAX_POPULATION: int
static var IRON: int
static var FOOD: int
static var OXYGEN: int

static var POPULATION_PER_TICK: int
static var IRON_PER_TICK: int
static var FOOD_PER_TICK: int
static var OXYGEN_PER_TICK: int

static var POPULATION_PER_SECOND = 0.2

@onready var event_bus: EventBus = $"%EventBus"
@onready var map: Map = $"%TileMap"
@onready var ui_resources: HBoxContainer = $"%ResourceBar/%Resources"
@onready var population_label: ResourceLabel = ui_resources.get_node("Population")
@onready var iron_label: ResourceLabel = ui_resources.get_node("Iron")
@onready var food_label: ResourceLabel = ui_resources.get_node("Food")
@onready var oxygen_label: ResourceLabel = ui_resources.get_node("Oxygen")

var resource_change_buffer = {
	"population": 0,
	"max_population": 0,
	"iron": 0,
	"food": 0,
	"oxygen": 0
}


func update_iron(amount: int):
	resource_change_buffer["iron"] += amount


func _ready():
	POPULATION = 0
	MAX_POPULATION = 0
	IRON = 0
	FOOD = 0
	OXYGEN = 0
	
	POPULATION_PER_TICK = 0
	IRON_PER_TICK = 0
	FOOD_PER_TICK = 0
	OXYGEN_PER_TICK = 0

	map.connect("building_built", _on_building_built)
	map.connect("building_removed", _on_building_removed)
	map.connect("hq_placed", _on_hq_placed)

	event_bus.register_action_per_tick(update_resources)
	_update_resource_ui()


func _on_hq_placed():
	POPULATION = 1
	MAX_POPULATION = 4
	POPULATION_PER_TICK = 1
	IRON = 10

	_update_resource_ui()


func _on_building_built(building: String, _tile_position: Vector2i):
	match building:
		"H Pipe":
			pass
		"V Pipe":
			pass
		"Habitat":
			pass
		"Farm":
			pass
		"Air Filter":
			pass
		"Landing Pad":
			pass
		"Mine":
			pass


func _on_building_removed(building: String, disabled: bool):
	if disabled:
		return
	on_building_state_changed(building, true)


func on_building_state_changed(type: String, disabled: bool):
	match type:
		"H Pipe":
			pass
		"V Pipe":
			pass
		"Habitat":
			if disabled:
				decrease_max_population()
			else:
				increase_max_population()
		"Farm":
			pass
		"Air Filter":
			pass
		"Landing Pad":
			pass
		"Mine":
			if disabled:
				IRON_PER_TICK -= 1
			else:
				IRON_PER_TICK += 1
	
	_update_resource_ui()


func update_resources():
	resource_change_buffer["population"] += POPULATION_PER_TICK
	resource_change_buffer["iron"] += IRON_PER_TICK
	resource_change_buffer["food"] += FOOD_PER_TICK
	resource_change_buffer["oxygen"] += OXYGEN_PER_TICK


func increase_max_population():
	resource_change_buffer["max_population"] += 4


func decrease_max_population():
	resource_change_buffer["max_population"] -= 4


func _update_resource_ui():
	population_label.update_label(POPULATION, POPULATION_PER_TICK, MAX_POPULATION)
	iron_label.update_label(IRON, IRON_PER_TICK)
	food_label.update_label(FOOD, FOOD_PER_TICK)
	oxygen_label.update_label(OXYGEN, OXYGEN_PER_TICK)


func _process(_delta):
	if (
		resource_change_buffer["population"] != 0
		|| resource_change_buffer["max_population"] != 0
		|| resource_change_buffer["iron"] != 0
		|| resource_change_buffer["food"] != 0
		|| resource_change_buffer["oxygen"] != 0
	):
		POPULATION += resource_change_buffer["population"]
		MAX_POPULATION += resource_change_buffer["max_population"]
		IRON += resource_change_buffer["iron"]
		FOOD += resource_change_buffer["food"]
		OXYGEN += resource_change_buffer["oxygen"]
		_update_resource_ui()

		population_changed.emit()
		iron_changed.emit()

		resource_change_buffer = {
			"population": 0,
			"max_population": 0,
			"iron": 0,
			"food": 0,
			"oxygen": 0
		}
