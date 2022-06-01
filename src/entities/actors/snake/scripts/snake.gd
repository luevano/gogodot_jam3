class_name Snake
extends Node2D

export(PackedScene) var BODY_SEGMENT_NP: PackedScene
export(PackedScene) var TAIL_SEGMENT_NP: PackedScene

onready var path: Path2D = $Path

var current_body_segments: int = 0
var max_body_initial_segments: int = 1
var body_segment_stack: Array
var tail_segment: PathFollow2D
# didn't konw how to name this, basically holds the current path lenght
# 	whenever the add body segment, and we use this stack to add body parts
var body_segment_queue: Array


func _ready():
	set_physics_process(false)
	set_process_input(false)
	Event.connect("snake_path_new_point", self, "_on_Head_snake_path_new_point")
	Event.connect("snake_added_new_segment", self, "_on_Snake_snake_added_new_segment")
	Event.connect("snake_added_initial_segments", self, "_on_Snake_snake_added_initial_segments")


func _physics_process(delta: float) -> void:
	if body_segment_queue.size() != 0:
		_add_new_segment()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_body_part"):
		_add_segment_to_queue()


func _draw() -> void:
	if path.curve.get_baked_points().size() >= 2:
		draw_polyline(path.curve.get_baked_points(), Color.aquamarine, 1, true)


func _add_new_segment() -> void:
	var _path_length_threshold: float = body_segment_queue[0] + Global.SNAKE_SEGMENT_SIZE
	if path.curve.get_baked_length() >= _path_length_threshold:
		var _temp_body_segment: PathFollow2D = BODY_SEGMENT_NP.instance()
		Event.emit_signal("snake_add_new_segment", "body")
		var _new_body_offset: float = body_segment_stack.back().offset - Global.SNAKE_SEGMENT_SIZE

		_temp_body_segment.offset = _new_body_offset
		body_segment_stack.append(_temp_body_segment)
		path.add_child(_temp_body_segment)
		tail_segment.offset = body_segment_stack.back().offset - Global.SNAKE_SEGMENT_SIZE

		body_segment_queue.pop_front()
		current_body_segments += 1
		Event.emit_signal("snake_added_new_segment", "body")


func _add_initial_segment(type: PackedScene) -> void:
	if path.curve.get_baked_length() >= (current_body_segments + 1.0) * Global.SNAKE_SEGMENT_SIZE:
		var _temp_body_segment: PathFollow2D = type.instance()
		Event.emit_signal("snake_add_new_segment", _temp_body_segment.TYPE)
		if _temp_body_segment.TYPE == "body":
			body_segment_stack.append(_temp_body_segment)
		else:
			tail_segment = _temp_body_segment
		path.add_child(_temp_body_segment)

		current_body_segments += 1
		Event.emit_signal("snake_added_new_segment", _temp_body_segment.TYPE)


func _add_segment_to_queue() -> void:
	# need to have the queues in a fixed separation, else if the eating functionality
	#	gets spammed, all next bodyparts will be spawned almost at the same spot
	if body_segment_queue.size() == 0:
		body_segment_queue.append(path.curve.get_baked_length())
	else:
		body_segment_queue.append(body_segment_queue.back() + Global.SNAKE_SEGMENT_SIZE)


func _on_Head_snake_path_new_point(coordinates: Vector2) -> void:
	path.curve.add_point(coordinates)
	# update call is to draw curve as there are new points to the path's curve
	update()

	if current_body_segments < max_body_initial_segments:
		_add_initial_segment(BODY_SEGMENT_NP)
	elif current_body_segments == max_body_initial_segments:
		_add_initial_segment(TAIL_SEGMENT_NP)


func _on_Snake_snake_added_new_segment(type: String) -> void:
	if type == "tail":
		Event.emit_signal("snake_added_initial_segments")


func _on_Snake_snake_added_initial_segments() -> void:
	set_physics_process(true)
	set_process_input(true)
