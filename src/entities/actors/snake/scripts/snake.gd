class_name Snake
extends Node2D

export(PackedScene) var BODY_SEGMENT_NP: PackedScene
export(PackedScene) var TAIL_SEGMENT_NP: PackedScene

onready var path: Path2D = $Path

var stats: Stats = SaveData.get_stats()

var finished_adding_initial_segments: bool = false
var current_body_segments: int = 0
var body_segment_stack: Array
var tail_segment: PathFollow2D
# didn't konw how to name this, basically holds the current path lenght
# 	whenever the add body segment, and we use this stack to add body parts
var body_segment_queue: Array

var debug: bool = false


func _ready():
	set_physics_process(false)
	set_process_input(false)
	Event.connect("toggle_debug", self, "_on_toggle_debug")
	Event.connect("snake_path_new_point", self, "_on_snake_path_new_point")
	Event.connect("snake_add_new_segment", self, "_on_snake_add_new_segment")
	Event.connect("snake_added_new_segment", self, "_on_snake_added_new_segment")
	Event.connect("snake_added_initial_segments", self, "_on_snake_added_initial_segments")

	# Event.connect("food_eaten", self, "_on_food_eaten")
	# need to always set a new curve when ready, so when restarting it's af resh curve
	path.curve = Curve2D.new()


func _physics_process(delta: float) -> void:
	if body_segment_queue.size() != 0 and current_body_segments >= Global.SNAKE_INITIAL_SEGMENTS:
		_add_new_segment()

	# if body_segment_stack.size() > 0:
	# 	distance_to_first_segment = path.curve.get_baked_length() - body_segment_stack.front().offset
	# 	if distance_to_first_segment >= Global.SNAKE_SEGMENT_SIZE:
	# 		print(distance_to_first_segment)


func _draw() -> void:
	if debug:
		if path.curve.get_baked_points().size() >= 2:
			draw_polyline(path.curve.get_baked_points(), Color.aquamarine, 1, true)


func _add_new_segment() -> void:
	var _path_length_threshold: float = body_segment_queue[0] + Global.SNAKE_SEGMENT_SIZE
	if path.curve.get_baked_length() >= _path_length_threshold:
		var _temp_body_segment: PathFollow2D = BODY_SEGMENT_NP.instance()
		Event.emit_signal("snake_adding_new_segment", "body")
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
		Event.emit_signal("snake_adding_new_segment", _temp_body_segment.TYPE)
		if _temp_body_segment.TYPE == "body":
			body_segment_stack.append(_temp_body_segment)
		else:
			tail_segment = _temp_body_segment
		path.add_child(_temp_body_segment)

		# just to keep things going, tail shouldn't count as body segment
		current_body_segments += 1
		Event.emit_signal("snake_added_new_segment", _temp_body_segment.TYPE)


func _add_segment_to_queue() -> void:
	# need to have the queues in a fixed separation, else if the eating functionality
	#	gets spammed, all next bodyparts will be spawned almost at the same spot
	if body_segment_queue.size() == 0:
		body_segment_queue.append(path.curve.get_baked_length())
	else:
		body_segment_queue.append(body_segment_queue.back() + Global.SNAKE_SEGMENT_SIZE)


func _on_snake_path_new_point(coordinates: Vector2) -> void:
	path.curve.add_point(coordinates)
	# update call is to draw curve as there are new points to the path's curve
	if debug:
		update()

	if not finished_adding_initial_segments:
		if current_body_segments < Global.SNAKE_INITIAL_SEGMENTS:
			_add_initial_segment(BODY_SEGMENT_NP)
		elif current_body_segments == Global.SNAKE_INITIAL_SEGMENTS:
			_add_initial_segment(TAIL_SEGMENT_NP)


func _on_snake_added_new_segment(type: String) -> void:
	if type == "tail":
		current_body_segments -= 1
		finished_adding_initial_segments = true
		Event.emit_signal("snake_added_initial_segments")


func _on_snake_added_initial_segments() -> void:
	set_physics_process(true)
	set_process_input(true)


func _on_snake_add_new_segment(amount: int) -> void:
	for i in amount:
		_add_segment_to_queue()


func _on_toggle_debug() -> void:
	debug = !debug
