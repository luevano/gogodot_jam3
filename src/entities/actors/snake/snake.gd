class_name Snake
extends Node2D

export(PackedScene) var BODY_SEGMENT_NP: PackedScene

onready var head: Node2D = $Head
onready var path: Path2D = $Path
onready var path_follow: PathFollow2D = $Path/PathFollow
onready var curve: Curve2D = Curve2D.new()

var speed: float = Global.SNAKE_SPEED


func _ready():
	Event.connect("new_curve_point", self, "_on_Head_new_curve_point")
	path.curve = curve


func _process(delta: float) -> void:
	path_follow.offset = path_follow.offset + speed * delta


func _draw() -> void:
	if path.curve.get_baked_points().size() >= 2:
		draw_polyline(path.curve.get_baked_points(), Color.aquamarine, 1, true)


func add_point_to_curve(coordinates: Vector2) -> void:
	path.curve.add_point(coordinates)
	# update call is to draw curve
	update()


func _on_Head_new_curve_point(coordinates: Vector2) -> void:
	add_point_to_curve(coordinates)
