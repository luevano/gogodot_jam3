class_name Food
extends Area2D

onready var _sprite: Sprite = $Sprite

var texture: Dictionary
var timer: Timer

var properties: Dictionary


func _ready():
	timer = Timer.new()
	timer.one_shot = true

	timer.connect("timeout", self, "_on_timer_timeout")
	connect("body_entered", self, "_on_body_entered")


func update_texture() -> void:
	_sprite.texture = texture[properties["type"]]


func set_properties(pos: Vector2, loc: Vector2, special: bool, type: int, points: int=1, special_points: int=1, ttl: float = -1.0) -> void:
	properties["global_position"] = pos
	global_position = pos
	properties["location"] = loc
	properties["special"] = special
	properties["type"] = type

	properties["points"] = points
	properties["special_points"] = special_points
	properties["ttl"] = ttl
	if properties["ttl"] != -1.0:
		timer.wait_time = properties["ttl"]
		timer.start()


func _on_body_entered(body: Node) -> void:
	Event.emit_signal("food_eaten", properties)
	queue_free()


func _on_timer_timeout() -> void:
	Event.emit_signal("food_timed_out", properties)
	queue_free()
