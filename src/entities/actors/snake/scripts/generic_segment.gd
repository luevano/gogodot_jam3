extends PathFollow2D

export(String, "body", "tail") var TYPE: String = "body"

onready var _segment: Area2D = get_child(0)


func _ready() -> void:
	Event.connect("snake_rotated", self, "_on_snake_rotated")
	_segment.connect("body_entered", self, "_on_body_entered")


func _physics_process(delta: float) -> void:
	offset += Global.SNAKE_SPEED * delta


func _on_body_entered(body: Node) -> void:
	Event.emit_signal("snake_segment_body_entered", body)


func _on_snake_rotated() -> void:
	# this is just random, i need to offset a tiny bit whenever the snake rotates
	#	so that the first body segmetn doesn't catch up with the head
	offset -= Global.SNAKE_SPEED * pow(get_physics_process_delta_time(), 2)