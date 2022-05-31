class_name Snake
extends Node2D

export(PackedScene) var BODY_SEGMENT_NP: PackedScene
export(PackedScene) var TAIL_SEGMENT_NP: PackedScene

onready var path: Path2D = $Path

var current_body_segments: int = 0
var max_body_segments: int = 1
var body_segment_size: float = 16.0


func _ready():
	Event.connect("new_curve_point", self, "_on_Head_new_curve_point")


func _draw() -> void:
	if path.curve.get_baked_points().size() >= 2:
		draw_polyline(path.curve.get_baked_points(), Color.aquamarine, 1, true)


func add_point_to_curve(coordinates: Vector2) -> void:
	path.curve.add_point(coordinates)
	# update call is to draw curve as there are new points
	update()

	if current_body_segments < max_body_segments:
		add_snake_segment(BODY_SEGMENT_NP)
	elif current_body_segments == max_body_segments:
		add_snake_segment(TAIL_SEGMENT_NP)


func add_snake_segment(type: PackedScene) -> void:
	if path.curve.get_baked_length() >= (current_body_segments + 1.0) * body_segment_size:
		var _temp_body_segment: PathFollow2D = type.instance()
		path.add_child(_temp_body_segment)
		current_body_segments += 1


func _on_Head_new_curve_point(coordinates: Vector2) -> void:
	add_point_to_curve(coordinates)
