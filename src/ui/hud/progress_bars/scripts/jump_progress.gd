extends HBoxContainer

onready var progress: TextureProgress = $Progress


func _ready():
	Event.connect("snake_jump_progress", self, "_on_snake_jump_progress")
	progress.max_value = Global.POINTS_TO_JUMP


func _on_snake_jump_progress(_progress: int) -> void:
	progress.value = _progress
