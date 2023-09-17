extends Node
class_name ResourceManager

signal population_changed

static var POPULATION = 1
static var MAX_POPULATION = 0
static var FOOD = 0
static var OXYGEN = 0

static var POPULATION_PER_TICK = 1
static var FOOD_PER_TICK = 0
static var OXYGEN_PER_TICK = 0

static var POPULATION_PER_SECOND = 0.2

@onready var event_bus: EventBus = $"%EventBus"
@onready var map: Map = $"%TileMap"
@onready var ui_resources: HBoxContainer = $"%ResourceBar/%Resources"
@onready var population_label: Label = ui_resources.get_node("Population")


func _ready():
	map.connect("building_built", _on_building_built)
	map.connect("building_removed", _on_building_removed)
	
	event_bus.register_action_per_tick(update_resources)
	increase_max_population()
	_update_resource_ui()


func _on_building_built(building):
	match building:
		"H Pipe":
			pass
		"V Pipe":
			pass
		"Habitat":
			increase_max_population()
		"Farm":
			pass
		"Air Filter":
			pass
		"Landing Pad":
			pass


func _on_building_removed(building):
	match building:
		"H Pipe":
			pass
		"V Pipe":
			pass
		"Habitat":
			decrease_max_population()
		"Farm":
			pass
		"Air Filter":
			pass
		"Landing Pad":
			pass


func update_resources():
	POPULATION += POPULATION_PER_TICK
	FOOD += FOOD_PER_TICK
	OXYGEN += OXYGEN_PER_TICK
	
	_update_resource_ui()
	population_changed.emit()


func increase_max_population():
	MAX_POPULATION += 4
	_update_resource_ui()
	population_changed.emit()


func decrease_max_population():
	MAX_POPULATION -= 4
	_update_resource_ui()
	population_changed.emit()


func _update_resource_ui():
	population_label.text = "POP: %s / %s" % [POPULATION, MAX_POPULATION]
