extends Node2D

export(NodePath) var PREV_SEGMENT_NP: NodePath

onready var prev_segment: Node2D = get_node(PREV_SEGMENT_NP)
onready var prev_segment_next_pivot: Node2D = prev_segment.get_node("NextPivot")
onready var _prev_pivot: Node2D = $PrevPivot
onready var _next_pivot: Node2D = $NextPivot

var rot_speed: float = Global.SNAKE_SEGMENT_ROT_SPEED

var prev_segment_next_pivot_to_center: Vector2
var _center_to_prev_pivot: Vector2
var _angle_between_segments: float


func _process(delta: float) -> void:
	prev_segment_next_pivot_to_center = prev_segment_next_pivot.global_position - prev_segment.global_position
	_center_to_prev_pivot = _prev_pivot.global_position - global_position

	_angle_between_segments = _center_to_prev_pivot.angle_to(prev_segment_next_pivot_to_center)
	if _angle_between_segments > 0.0:
		rotate(deg2rad(-rot_speed * delta))
	else:
		rotate(deg2rad(rot_speed * delta))

	global_position = prev_segment_next_pivot.global_position - _center_to_prev_pivot
