class_name ProgressionLabel
extends MarginContainer

enum Type {
	BODY_SEGMENT,
	DASH_SEGMENT,
	SLOW_SEGMENT,
	JUMP_SEGMENT,
	EMPTY
}

export(int) var TYPE: int = Type.EMPTY
export(String) var PREFIX: String
export(float) var BEFORE_VALUE: float
export(float) var AFTER_VALUE: float = -1.0

onready var label_prefix: Label = $HBox/Prefix
onready var label_stats: Label = $HBox/Stats
onready var texture_rect: TextureRect = $HBox/Center/VBox/TextureRect


var textures: Dictionary = {
	Type.BODY_SEGMENT: preload("res://ui/hud/progress_bars/sprites/grow/grow_progress_icon.png"),
	Type.DASH_SEGMENT: preload("res://ui/hud/progress_bars/sprites/dash/dash_progress_icon.png"),
	Type.SLOW_SEGMENT: preload("res://ui/hud/progress_bars/sprites/slow/slow_progress_icon.png"),
	Type.JUMP_SEGMENT: preload("res://ui/hud/progress_bars/sprites/jump/jump_progress_icon.png"),
	Type.EMPTY: preload("res://ui/stats_display/sprites/sep_8x8.png")
}

var _fmt: String = "%s->%s"
var _fmt_partial: String = "%s"
var _fmt_prefix: String = " %s "


func _ready() -> void:
	set_properties(TYPE, PREFIX, BEFORE_VALUE, AFTER_VALUE)


func set_properties(icon: int, prefix: String, before: float, after: float=-1.0) -> void:
	texture_rect.texture = textures[icon]
	if after == -1.0:
		label_stats.text =_fmt_partial % before
	else:
		label_stats.text =_fmt % [before, after]
		if after > before:
			label_stats.add_color_override("font_color", Color.green)
		elif after < before:
			label_stats.add_color_override("font_color", Color.red)
	if not prefix.empty():
		label_prefix.text = _fmt_prefix % prefix
	else:
		label_prefix.text = " "
	label_prefix.update()
	label_stats.update()
