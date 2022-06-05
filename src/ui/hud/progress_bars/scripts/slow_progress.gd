extends HBoxContainer

onready var progress: TextureProgress = $Progress


func _ready():
	Event.connect("snake_slow_progress", self, "_on_snake_slow_progress")
	progress.max_value = Global.POINTS_TO_SLOW


func _on_snake_slow_progress(_progress: int) -> void:
	progress.value = _progress
