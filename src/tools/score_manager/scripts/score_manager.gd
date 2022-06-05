extends Node

export(PackedScene) var SCORE_LABEL: PackedScene

var initial_stats: Stats = SaveData.get_stats()
var stats: Stats = Stats.new()
var mutation_stats: Array = [
	Stats.new(),
	Stats.new(),
	Stats.new()
]

var last_snake_pos: Vector2 = Vector2.ZERO


func _ready():
	Event.connect("game_over", self, "_on_game_over")
	Event.connect("food_eaten", self, "_on_food_eaten")
	Event.connect("snake_path_new_point", self, "_on_snake_path_new_point")


func _on_food_eaten(properties: Dictionary) -> void:
	var points: int = properties["points"]
	var location: Vector2 = properties["global_position"]
	var amount_to_grow: int = _process_points(points)
	_spawn_added_score_text(points, location)
	_spawn_added_segment_text(amount_to_grow)


func _process_points(points: int) -> int:
	var score_to_grow: int = (stats.segments + 1) * Global.POINTS_TO_GROW - stats.points
	var amount_to_grow: int = 0
	var growth_progress: int
	stats.points += points
	if points >= score_to_grow:
		amount_to_grow += 1
		points -= score_to_grow
		# maybe be careful with this
		amount_to_grow += points / Global.POINTS_TO_GROW
		stats.segments += amount_to_grow
		Event.emit_signal("snake_add_new_segment", amount_to_grow)

	growth_progress = Global.POINTS_TO_GROW - ((stats.segments + 1) * Global.POINTS_TO_GROW - stats.points)
	Event.emit_signal("snake_growth_progress", growth_progress)
	return amount_to_grow


func _spawn_added_score_text(points: int, location: Vector2) -> void:
	var label: ScoreLabel = SCORE_LABEL.instance()
	add_child(label)
	label.set_properties(points, Color.red, location)


func _spawn_added_segment_text(amount: int) -> void:
	if amount > 0:
		var label: ScoreLabel = SCORE_LABEL.instance()
		add_child(label)
		label.set_properties(amount, Color.green, last_snake_pos, ScoreLabel.Type.BODY_SEGMENT)


func _on_snake_path_new_point(coordinates: Vector2) -> void:
	last_snake_pos = coordinates


func _on_game_over() -> void:
	print("Show comparison.")
	Event.emit_signal("display_stats", initial_stats, stats, mutation_stats)
