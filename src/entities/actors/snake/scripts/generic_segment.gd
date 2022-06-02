extends PathFollow2D

export(String, "body", "tail") var TYPE: String = "body"

onready var _segment: Area2D = get_child(0)


func _ready() -> void:
	_segment.connect("body_entered", self, "_on_body_entered")


func _physics_process(delta: float) -> void:
	offset += Global.SNAKE_SPEED * delta


func _on_body_entered(body: Node) -> void:
	Event.emit_signal("snake_segment_body_entered", body)
