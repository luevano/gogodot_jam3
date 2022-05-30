class_name Snake
extends KinematicBody2D

export(float, 10.0, 1000.0, 10.0) var SPEED: float = 100.0

var velocity: Vector2 = Vector2.ZERO

enum {
	NULL=-1,
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var direction: Dictionary = {
	UP: Vector2.UP,
	DOWN: Vector2.DOWN,
	LEFT: Vector2.LEFT,
	RIGHT: Vector2.RIGHT
}

var _direction_state: int = UP
var _input_direction: int = NULL


func _physics_process(delta: float) -> void:
	_input_direction = _get_direction_input()

	match _direction_state:
		NULL:
			print("No input detected, not changing direction.")
		UP:
			if _input_direction == LEFT or _input_direction == RIGHT:
				_change_direction_to(_input_direction)
		DOWN:
			if _input_direction == LEFT or _input_direction == RIGHT:
				_change_direction_to(_input_direction)
		LEFT:
			if _input_direction == UP or _input_direction == DOWN:
				_change_direction_to(_input_direction)
		RIGHT:
			if _input_direction == UP or _input_direction == DOWN:
				_change_direction_to(_input_direction)

	move_and_slide(SPEED * direction[_direction_state], Vector2.ZERO, false, 4, PI/4, false)


func _change_direction_to(new_direction: int) -> void:
	_direction_state = new_direction

	match _direction_state:
		UP:
			rotation = 0
		DOWN:
			rotation = PI
		LEFT:
			rotation = -PI/2
		RIGHT:
			rotation = PI/2


func _get_direction_input() -> int:
	if Input.is_action_pressed("move_up"):
		return UP
	elif Input.is_action_pressed("move_down"):
		return DOWN
	elif Input.is_action_pressed("move_left"):
		return LEFT
	elif Input.is_action_pressed("move_right"):
		return RIGHT

	return NULL
