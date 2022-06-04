class_name UI
extends CanvasLayer

onready var _start_button: Button = $Root/MarginContainer/CenterContainer/Start


func _ready():
	_start_button.connect("pressed", self, "_on_start_button_pressed")


func _on_start_button_pressed() -> void:
	_start_button.disabled = true
	_start_button.visible = false
	Event.emit_signal("game_start")
