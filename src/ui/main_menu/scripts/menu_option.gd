class_name MenuOption
extends CenterContainer

export(String) var label_text: String
export(bool) var selected: bool = false

onready var label: Label = $HBox/Label
onready var selector: TextureRect = $HBox/Selector
var type: int

var time_elapsed: float = 0.0
var timer: float = 0.2
var last_frame: int = 0
var frames: Array = [preload("res://ui/main_menu/sprites/selector1.png"),
					 preload("res://ui/main_menu/sprites/selector2.png"),
					 preload("res://ui/main_menu/sprites/selector3.png"),
					 preload("res://ui/main_menu/sprites/selector4.png"),
					 preload("res://ui/main_menu/sprites/selector5.png")]


func _ready():
	label.text = label_text


func _process(delta: float) -> void:
	if selected:
		if time_elapsed >= timer:
			selector.texture = frames[last_frame]
			last_frame += 1
			if last_frame == frames.size() - 1:
				last_frame = 0
			time_elapsed = 0.0
		time_elapsed += delta
	else:
		selector.texture = frames[4]
