extends KinematicBody2D

enum {
	LEFT=-1,
	RIGHT=1
}

onready var tongue_sprite: AnimatedSprite = $Tongue

var _initial_speed: float = Global.SNAKE_SPEED
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.UP
var _time_elapsed: float = 0.0

var stats: Stats = SaveData.get_stats()

var can_dash: bool = false
var can_slow: bool = false
var can_jump: bool = false


func _ready() -> void:
	Event.connect("food_eaten", self, "_on_food_eaten")
	Event.connect("snake_started_dash", self, "_on_snake_started_dash")
	Event.connect("snake_started_slow", self, "_on_snake_started_slow")
	Event.connect("snake_started_jump", self, "_on_snake_started_jump")

	print(stats.get_stats())
	can_dash = stats.trait_dash
	can_slow = stats.trait_slow
	can_jump = stats.trait_jump

	tongue_sprite.visible = false


func rotate_to(_direction: int) -> void:
	rotate(deg2rad(_direction * Global.SNAKE_ROT_SPEED * get_physics_process_delta_time()))
	direction = direction.rotated(deg2rad(_direction * Global.SNAKE_ROT_SPEED * get_physics_process_delta_time()))
	Event.emit_signal("snake_rotated")


# using a timer is not recommended for < 0.01
func handle_time_elapsed(delta: float) -> void:
	if _time_elapsed >= Global.SNAKE_POSITION_UPDATE_INTERVAL:
		Event.emit_signal("snake_path_new_point", global_position)
		_time_elapsed = 0.0
	_time_elapsed += delta


func _on_food_eaten(properties: Dictionary) -> void:
	if not tongue_sprite.visible:
		tongue_sprite.visible = true
	tongue_sprite.play()
	yield(tongue_sprite, "animation_finished")
	tongue_sprite.stop()
	tongue_sprite.frame = 0


func _on_snake_started_dash() -> void:
	can_dash = false
	yield(get_tree().create_timer(Global.SNAKE_DASH_COOLDOWN), "timeout")
	can_dash = true


func _on_snake_started_slow() -> void:
	can_slow = false
	yield(get_tree().create_timer(Global.SNAKE_SLOW_COOLDOWN), "timeout")
	can_slow = true


func _on_snake_started_jump() -> void:
	can_jump = false
	yield(get_tree().create_timer(Global.SNAKE_JUMP_COOLDOWN), "timeout")
	can_jump = true
