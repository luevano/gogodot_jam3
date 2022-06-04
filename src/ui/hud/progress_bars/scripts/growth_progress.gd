extends TextureProgress


func _ready():
	Event.connect("snake_growth_progress", self, "_on_snake_growth_progress")
	max_value = Global.POINTS_TO_GROW


func _on_snake_growth_progress(progress: int) -> void:
	value = progress
