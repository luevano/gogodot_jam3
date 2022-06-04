extends KinematicBody2D

enum {
	LEFT=-1,
	RIGHT=1
}

onready var tongue_sprite: AnimatedSprite = $Tongue

var _initial_speed: float = Global.SNAKE_SPEED
var velocity: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.UP
var _time_elapsed: float = 0.0


func _ready() -> void:
	Event.connect("food_eaten", self, "_on_food_eaten")
	tongue_sprite.visible = false


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		_rotate_to(LEFT)
	if Input.is_action_pressed("move_right"):
		_rotate_to(RIGHT)

	velocity = _direction * Global.SNAKE_SPEED

	# not sure if needed, worked wonders when using a Node2D instead of KB2D
	velocity = move_and_slide(velocity)
	_handle_time_elapsed(delta)


func _rotate_to(direction: int) -> void:
	rotate(deg2rad(direction * Global.SNAKE_ROT_SPEED * get_physics_process_delta_time()))
	_direction = _direction.rotated(deg2rad(direction * Global.SNAKE_ROT_SPEED * get_physics_process_delta_time()))
	Event.emit_signal("snake_rotated")


# using a timer is not recommended for < 0.01
func _handle_time_elapsed(delta: float) -> void:
	if _time_elapsed >= Global.SNAKE_POSITION_UPDATE_INTERVAL:
		Event.emit_signal("snake_path_new_point", global_position)
		_time_elapsed = 0.0
	_time_elapsed += delta


func _on_food_eaten(properties: Dictionary) -> void:
	print("tongue food eaten")
	if not tongue_sprite.visible:
		tongue_sprite.visible = true
	tongue_sprite.play()
	yield(tongue_sprite, "animation_finished")
	tongue_sprite.stop()
	tongue_sprite.frame = 0
