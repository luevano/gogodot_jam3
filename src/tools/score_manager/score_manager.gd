extends Node

export(Resource) var TEXT_FONT: Resource

var score: int = 0
var growth: int = 0

var point_text_time: float = 2.0
var _point_text_fmt: String = "+%s"


func _ready():
	Event.connect("food_eaten", self, "_on_food_eaten")


func _on_food_eaten(properties: Dictionary) -> void:
	var points: int = properties["points"]
	var location: Vector2 = properties["global_position"]
	_process_points(points)
	_spawn_added_score_text(points, location)


func _process_points(points: int) -> void:
	var score_to_grow: int = (growth + 1) * Global.POINTS_TO_GROW - score
	var amount_to_grow: int = 0
	var growth_progress: int
	score += points
	if points >= score_to_grow:
		amount_to_grow += 1
		points -= score_to_grow
		# maybe be careful with this
		amount_to_grow += points / Global.POINTS_TO_GROW
		growth += amount_to_grow
		Event.emit_signal("snake_add_new_segment", amount_to_grow)

	growth_progress = Global.POINTS_TO_GROW - ((growth + 1) * Global.POINTS_TO_GROW - score)
	Event.emit_signal("snake_growth_progress", growth_progress)


func _spawn_added_score_text(points: int, location: Vector2) -> void:
	var label: Label = Label.new()
	label.text = _point_text_fmt % points
	label.add_color_override("font_color", Color.red)
	label.add_font_override("font", TEXT_FONT)
	label.set_global_position(location)
	add_child(label)
	yield(get_tree().create_timer(point_text_time), "timeout")
	remove_child(label)
