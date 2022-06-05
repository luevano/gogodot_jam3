extends HBoxContainer

onready var progress: TextureProgress = $Progress


func _ready():
	Event.connect("snake_growth_progress", self, "_on_snake_growth_progress")
	progress.max_value = Global.POINTS_TO_GROW


func _on_snake_growth_progress(_progress: int) -> void:
	progress.value = _progress
