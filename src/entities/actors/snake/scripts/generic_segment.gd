extends PathFollow2D

export(String, "body", "tail") var TYPE: String = "body"
var speed: float = Global.SNAKE_SPEED


func _process(delta: float) -> void:
	offset += speed * delta