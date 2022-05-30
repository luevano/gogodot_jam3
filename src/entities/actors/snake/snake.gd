class_name Snake
extends Node2D

export(float, 1.0, 1000.0, 1.0) var SPEED: float = 100.0
export(float, 1.0, 1000.0, 1.0) var ROT_SPEED: float = 200.0
export(float, 0.01, 1.0, 0.01) var POSITION_UPDATE_INTERVAL: float = 0.01
export(PackedScene) var BODY_SEGMENT_NP: PackedScene

onready var head: Node2D = $Head
onready var path: Path2D = $Path
onready var path_follow: PathFollow2D = $Path/PathFollow
onready var curve: Curve2D = Curve2D.new()


func _ready():
	Event.connect("new_curve_point", self, "_on_Head_new_curve_point")
	path.curve = curve
	head.speed = SPEED
	head.rot_speed = ROT_SPEED
	head.position_update_interval = POSITION_UPDATE_INTERVAL
	set_process(false)


func _process(delta: float) -> void:
	path_follow.set_offset(path_follow.get_offset() + SPEED * delta)


func _draw() -> void:
	if path.curve.get_baked_points().size() >= 2:
		draw_polyline(path.curve.get_baked_points(), Color.aquamarine, 1, true)


func add_point_to_curve(coordinates: Vector2) -> void:
	path.curve.add_point(coordinates)
	# need at least 2 points to enable processing (sprite move)
	if not is_processing() and path.curve.get_baked_points().size() >= 2:
		set_process(true)
	# update call is to draw curve
	update()


func _on_Head_new_curve_point(coordinates: Vector2) -> void:
	add_point_to_curve(coordinates)
