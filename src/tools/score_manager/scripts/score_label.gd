class_name ScoreLabel
extends MarginContainer

onready var label: Label = $Hbox/Label
onready var timer: Timer = $Hbox/Label/Timer
onready var texture_rect: TextureRect = $Hbox/Center/VBox/TextureRect

enum Type {
	BODY_SEGMENT
}

var texture: Dictionary = {
	Type.BODY_SEGMENT: preload("res://ui/hud/progress_bars/sprites/grow_progress_icon.png")
}

var alive_time: float = 2.0
var fmt: String = "x%s"
var points: int


func _ready():
	timer.connect("timeout", self, "_on_timer_timout")
	timer.wait_time = 2.0
	timer.start()


func set_properties(_points: int, color: Color, location: Vector2, type: int=-1) -> void:
	print("Constructing")
	points = _points
	label.text = fmt % points
	label.add_color_override("font_color", color)
	set_global_position(location)
	if type != -1:
		texture_rect.visible = true
	match type:
		Type.BODY_SEGMENT:
			texture_rect.texture = texture[type]
	label.update()


func _on_timer_timout() -> void:
	queue_free()
