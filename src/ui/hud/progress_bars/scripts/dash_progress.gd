extends HBoxContainer

onready var progress: TextureProgress = $Progress


func _ready():
	Event.connect("snake_dash_progress", self, "_on_snake_dash_progress")
	progress.max_value = Global.POINTS_TO_DASH


func _on_snake_dash_progress(_progress: int) -> void:
	progress.value = _progress
