class_name UI
extends CanvasLayer

onready var _snake_size_label: Label = $Root/StatsHUD/VBox/SnakeSize

var snake_size: int = 0
var _snake_size_fmt: String = "Snake size: %s"


func _ready():
	Event.connect("snake_added_new_segment", self, "_on_Snake_added_new_segment")
	_snake_size_label.text =_snake_size_fmt % snake_size


func _on_Snake_added_new_segment(type: String) -> void:
	snake_size += 1
	_snake_size_label.text =_snake_size_fmt % snake_size
