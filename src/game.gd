extends Node2D

onready var _snake: Node2D = $Snake


func _ready() -> void:
	Event.connect("game_over", self, "_on_game_over")
	Event.connect("game_restart", self, "_on_game_restart")
	Event.connect("snake_segment_body_entered", self, "_on_snake_segment_body_entered")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Event.emit_signal("game_restart")


func _on_snake_segment_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		Event.emit_signal("game_over")


func _snake_set_process(on_off: bool) -> void:
	_snake.propagate_call("set_process", [on_off])
	_snake.propagate_call("set_process_internal", [on_off])
	_snake.propagate_call("set_physics_process", [on_off])
	_snake.propagate_call("set_physics_process_internal", [on_off])
	_snake.propagate_call("set_process_input", [on_off])


func _on_game_over() -> void:
	print("game_over")
	_snake_set_process(false)


func _on_game_restart() -> void:
	print("game_restart")
	get_tree().change_scene_to(Global.GAME_NODE)