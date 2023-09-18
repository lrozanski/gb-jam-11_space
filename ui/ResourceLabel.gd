extends HBoxContainer
class_name ResourceLabel

@export var label: String = ""
@export var amount: int = 0
@export var delta: int = 0

@export var positive_color: Color
@export var negative_color: Color

func _get_label_sign(amount_per_tick: int):
	if amount_per_tick < 0:
		return ""
	else:
		return "+"


func update_label(new_amount: int, new_delta: int, max_amount: int = -1):
	var amount_label: Label = $"Amount"
	var delta_label: Label = $"Delta"

	amount = new_amount
	delta = new_delta

	delta_label.self_modulate = positive_color if delta >= 0 else negative_color

	if max_amount >= 0:
		amount_label.text = "%s: %s / %s" % [label, amount, max_amount]
		delta_label.text = "%s%s" % [_get_label_sign(delta), delta]
	else:
		amount_label.text = "%s: %s" % [label, amount]
		delta_label.text = "%s%s" % [_get_label_sign(delta), delta]
