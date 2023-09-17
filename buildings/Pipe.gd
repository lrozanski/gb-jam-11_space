extends Building
class_name Pipe

enum PipeVariant {
	HORIZONTAL,
	VERTICAL
}

@export var variant: PipeVariant = PipeVariant.HORIZONTAL:
	get:
		return variant
	set(pipe_variant): 
		variant = pipe_variant
		_update_sprite(variant)


@onready var horizontal_sprite: Sprite2D = $"Horizontal"
@onready var vertical_sprite: Sprite2D = $"Vertical"


func _update_sprite(pipe_variant: PipeVariant):
	if pipe_variant == PipeVariant.HORIZONTAL:
		horizontal_sprite.visible = true
		vertical_sprite.visible = false
	else:
		horizontal_sprite.visible = false
		vertical_sprite.visible = true
