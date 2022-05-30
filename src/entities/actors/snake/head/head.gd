extends Node2D

var speed: float = Global.SNAKE_SPEED
var rot_speed: float = Global.SNAKE_ROT_SPEED
var position_update_interval: float = Global.SNAKE_POSITION_UPDATE_INTERVAL

var _direction: Vector2 = Vector2.UP
var _time_elapsed: float = 0.0


func _ready():
	Event.emit_signal("new_curve_point", global_position)


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		# _direction = _direction.rotated(deg2rad(-ROT_SPEED))
		rotate(deg2rad(-rot_speed * delta))
	if Input.is_action_pressed("move_right"):
		# _direction = _direction.rotated(deg2rad(ROT_SPEED))
		rotate(deg2rad(rot_speed * delta))

	move_local_x(_direction.x * speed * delta)
	move_local_y(_direction.y * speed * delta)

	_handle_time_elapsed(delta)


# using a timer is not recommended for < 0.01
func _handle_time_elapsed(delta: float) -> void:
	if _time_elapsed >= position_update_interval:
		Event.emit_signal("new_curve_point", global_position)
		_time_elapsed = 0.0
	_time_elapsed += delta
