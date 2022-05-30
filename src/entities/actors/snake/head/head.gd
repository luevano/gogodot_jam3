extends Node2D

# export(float, 1.0, 1000.0, 1.0) var SPEED: float = 100.0
# export(float, 1.0, 1000.0, 1.0) var ROT_SPEED: float = 200.0
# export(float, 0.01, 1.0, 0.01) var POSITION_UPDATE_INTERVAL: float = 0.01
var speed: float
var rot_speed: float
var position_update_interval: float

var direction: Vector2 = Vector2.UP
var _time_elapsed: float = 0.0


func _ready():
	Event.emit_signal("new_curve_point", global_position)


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		# direction = direction.rotated(deg2rad(-ROT_SPEED))
		rotate(deg2rad(-rot_speed * delta))
	if Input.is_action_pressed("move_right"):
		# direction = direction.rotated(deg2rad(ROT_SPEED))
		rotate(deg2rad(rot_speed * delta))

	move_local_x(direction.x * speed * delta)
	move_local_y(direction.y * speed * delta)

	_handle_time_elapsed(delta)


# using a timer is not recommended for < 0.01
func _handle_time_elapsed(delta: float) -> void:
	if _time_elapsed >= position_update_interval:
		Event.emit_signal("new_curve_point", global_position)
		_time_elapsed = 0.0
	_time_elapsed += delta
