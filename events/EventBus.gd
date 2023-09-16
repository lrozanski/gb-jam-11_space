extends Node

@onready var game_logic_tick: Timer = $"GameLogicTick"

var registered_actions: Array[Callable] = []
var registered_oneshot_actions: Array[Callable] = []


func _ready():
	game_logic_tick.connect("timeout", logic_tick)
	
	register_action_oneshot(func(): print("Started"))
	register_action_per_tick(func(): print("Tick"))


func register_action_per_tick(action: Callable):
	registered_actions.append(action)


func register_action_oneshot(action: Callable):
	registered_oneshot_actions.append(action)


func deregister_action_per_tick(action: Callable):
	var action_index = registered_actions.find(action)
	
	if action_index >= 0:
		registered_actions.remove_at(action_index)


func logic_tick():
	# Oneshot actions
	for oneshot_action in registered_oneshot_actions:
		oneshot_action.call()
	
	# Actions per logic tick
	for action in registered_actions:
		action.call()
	
	registered_oneshot_actions.clear()