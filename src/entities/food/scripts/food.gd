class_name Food
extends Area2D

onready var _sprite: Sprite = $Sprite

var texture: Dictionary
var timer: Timer

var properties: Dictionary
var points: int = 1
var time_to_live: float = -1.0


func _ready():
	randomize_stats()
	_set_properties()
	timer = Timer.new()
	timer.one_shot = true

	timer.connect("timeout", self, "_on_timer_timeout")
	connect("body_entered", self, "_on_body_entered")


func set_type(type: int) -> void:
	set_property("type", type)
	_sprite.texture = texture[type]


func set_location(loc: Vector2) -> void:
	set_property("location", loc)


func set_timer(time: float) -> void:
	time_to_live = time
	if time_to_live != -1.0:
		timer.wait_time = time_to_live
		timer.start()


func set_property(property: String, value) -> void:
	properties[property] = value


func _set_properties() -> void:
	set_property("points", points)


func randomize_stats() -> void:
	points = int(rand_range(1, 30))


func _on_body_entered(body: Node) -> void:
	Event.emit_signal("food_eaten", properties)
	queue_free()


func _on_timer_timeout() -> void:
	Event.emit_signal("food_timed_out", properties)
	queue_free()
