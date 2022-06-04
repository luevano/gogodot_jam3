class_name Main
extends Node

onready var _snake: Node2D = $Snake


func _ready() -> void:
	Event.connect("game_start", self, "_on_game_start")
	Event.connect("game_over", self, "_on_game_over")
	Event.connect("snake_segment_body_entered", self, "_on_snake_segment_body_entered")

	_snake_disabled(false)
	# OS.window_size = Global.GAME_SCALE * OS.window_size


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _on_snake_segment_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		Event.emit_signal("game_over")


func _snake_disabled(on_off: bool) -> void:
	_snake.propagate_call("set_process", [on_off])
	_snake.propagate_call("set_process_internal", [on_off])
	_snake.propagate_call("set_physics_process", [on_off])
	_snake.propagate_call("set_physics_process_internal", [on_off])
	_snake.propagate_call("set_process_input", [on_off])


func _on_game_start() -> void:
	print("game start")
	_snake_disabled(true)


func _on_game_over() -> void:
	print("game over")
	_snake_disabled(false)
