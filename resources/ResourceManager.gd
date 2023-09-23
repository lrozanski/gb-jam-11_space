extends Node
class_name ResourceManager

signal population_changed
signal ore_changed

static var POPULATION: int
static var MAX_POPULATION: int
static var ORE: int
static var MAX_ORE: int
static var FOOD: int
static var MAX_FOOD: int
static var OXYGEN: int
static var MAX_OXYGEN: int

static var POPULATION_PER_TICK: int
static var ORE_PER_TICK: int
static var FOOD_PER_TICK: int
static var OXYGEN_PER_TICK: int

static var ORE_PER_MINE: int = 2
static var FOOD_PER_FARM: int = 5
static var OXYGEN_PER_AIR_FILTER: int = 3

static var POPULATION_PER_SECOND = 0.2

@onready var event_bus: EventBus = $"%EventBus"
@onready var map: Map = $"%TileMap"
@onready var ui_resources: HBoxContainer = $"%ResourceBar/%Resources"
@onready var population_label: ResourceLabel = ui_resources.get_node("Population")
@onready var ore_label: ResourceLabel = ui_resources.get_node("Ore")
@onready var food_label: ResourceLabel = ui_resources.get_node("Food")
@onready var oxygen_label: ResourceLabel = ui_resources.get_node("Oxygen")

var resource_change_buffer = {
	"population": 0,
	"max_population": 0,
	"ore": 0,
	"food": 0,
	"oxygen": 0
}


func update_ore(amount: int):
	resource_change_buffer["ore"] += amount


func update_food_per_tick(amount: int):
	FOOD_PER_TICK += amount
	_update_resource_ui()


func update_oxygen_per_tick(amount: int):
	OXYGEN_PER_TICK += amount
	_update_resource_ui()


func _ready():
	POPULATION = 0
	MAX_POPULATION = 0
	ORE = 0
	MAX_ORE = 0
	FOOD = 0
	MAX_FOOD = 0
	OXYGEN = 0
	MAX_OXYGEN = 0
	
	POPULATION_PER_TICK = 0
	ORE_PER_TICK = 0
	FOOD_PER_TICK = 0
	OXYGEN_PER_TICK = 0

	map.connect("building_built", _on_building_built)
	map.connect("building_removed", _on_building_removed)
	map.connect("hq_placed", _on_hq_placed)

	event_bus.register_action_per_tick(update_resources)
	_update_resource_ui()


func _on_hq_placed():
	POPULATION = 1
	MAX_POPULATION = 10
	POPULATION_PER_TICK = 1
	ORE = 20
	MAX_ORE = 20
	ORE_PER_TICK = 2
	FOOD = 1
	MAX_FOOD = 5
	FOOD_PER_TICK = 5
	OXYGEN = 1
	OXYGEN_PER_TICK = 5
	MAX_OXYGEN = 30

	_update_resource_ui()
	population_changed.emit()
	ore_changed.emit()


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
	if !type in ["HQ", "Pipe", "Air Filter"]:
		update_oxygen_per_tick(1 if disabled else -1)

	match type:
		"Pipe":
			pass
		"Habitat":
			if disabled:
				decrease_max_population()
			else:
				increase_max_population()
		"Farm":
			update_food_per_tick(-FOOD_PER_FARM if disabled else FOOD_PER_FARM)
		"Air Filter":
			update_oxygen_per_tick(-OXYGEN_PER_AIR_FILTER if disabled else OXYGEN_PER_AIR_FILTER)
		"Landing Pad":
			pass
		"Mine":
			if disabled:
				ORE_PER_TICK -= ORE_PER_MINE
			else:
				ORE_PER_TICK += ORE_PER_MINE
	
	_update_resource_ui()


func update_resources():
	resource_change_buffer["population"] += POPULATION_PER_TICK
	resource_change_buffer["ore"] += ORE_PER_TICK
	resource_change_buffer["food"] += FOOD_PER_TICK
	resource_change_buffer["oxygen"] += OXYGEN_PER_TICK

	update_food_per_tick(-POPULATION_PER_TICK)


func increase_max_population():
	resource_change_buffer["max_population"] += 5


func decrease_max_population():
	resource_change_buffer["max_population"] -= 5


func _update_resource_ui():
	population_label.update_label(POPULATION, POPULATION_PER_TICK, MAX_POPULATION)
	ore_label.update_label(ORE, ORE_PER_TICK, MAX_ORE)
	food_label.update_label(FOOD, FOOD_PER_TICK, MAX_FOOD)
	oxygen_label.update_label(OXYGEN, OXYGEN_PER_TICK, MAX_OXYGEN)


func _process(_delta):
	if (
		resource_change_buffer["population"] != 0
		|| resource_change_buffer["max_population"] != 0
		|| resource_change_buffer["ore"] != 0
		|| resource_change_buffer["food"] != 0
		|| resource_change_buffer["oxygen"] != 0
	):
		POPULATION += resource_change_buffer["population"]
		MAX_POPULATION += resource_change_buffer["max_population"]
		ORE = min(ORE + resource_change_buffer["ore"], MAX_ORE)
		FOOD = min(FOOD +resource_change_buffer["food"], MAX_FOOD)
		OXYGEN = min(OXYGEN + resource_change_buffer["oxygen"], MAX_OXYGEN)
		_update_resource_ui()

		population_changed.emit()
		ore_changed.emit()

		resource_change_buffer = {
			"population": 0,
			"max_population": 0,
			"ore": 0,
			"food": 0,
			"oxygen": 0
		}
