extends Camera2D

onready var _snake_head: KinematicBody2D = get_parent().get_node("Head")
var _snake_position: Vector2


func _physics_process(delta: float) -> void:
	_snake_position = _snake_head.global_position
	global_position = global_position.linear_interpolate(_snake_position, delta)
