extends PathFollow2D

export(String, "body", "tail") var TYPE: String = "body"


func _physics_process(delta: float) -> void:
	offset += Global.SNAKE_SPEED * delta
