class_name Main
extends Node

onready var _snake: Node2D = $Snake


func _ready() -> void:
	Event.connect("snake_segment_body_entered", self, "_on_snake_segment_body_entered")
	# OS.window_size = Global.GAME_SCALE * OS.window_size


func _on_snake_segment_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		_snake_disabled(false)


func _snake_disabled(on_off: bool) -> void:
	_snake.propagate_call("set_process", [on_off])
	_snake.propagate_call("set_process_internal", [on_off])
	_snake.propagate_call("set_physics_process", [on_off])
	_snake.propagate_call("set_physics_process_internal", [on_off])
	_snake.propagate_call("set_process_input", [on_off])
