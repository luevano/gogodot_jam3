extends Node

export(PackedScene) var SCORE_LABEL: PackedScene

var initial_stats: Stats = SaveData.get_stats()
var stats: Stats = Stats.new()
var mutation_stats: Array = [
	Stats.new(),
	Stats.new(),
	Stats.new()
]

var special_values: Dictionary = {
	FoodSpecial.Type.BUNNY: [Global.POINTS_TO_DASH, Color.gray, ScoreLabel.Type.DASH_SEGMENT],
	FoodSpecial.Type.TURTLE: [Global.POINTS_TO_SLOW, Color.green, ScoreLabel.Type.SLOW_SEGMENT],
	FoodSpecial.Type.FROG: [Global.POINTS_TO_JUMP, Color.greenyellow, ScoreLabel.Type.JUMP_SEGMENT]
}

var last_snake_pos: Vector2 = Vector2.ZERO
var snake_location_offset: Vector2 = Vector2(8.0, 8.0)
var special_snake_location_offset: Vector2 = - snake_location_offset


func _ready():
	Event.connect("game_over", self, "_on_game_over")
	Event.connect("food_eaten", self, "_on_food_eaten")
	Event.connect("snake_path_new_point", self, "_on_snake_path_new_point")


func _on_food_eaten(properties: Dictionary) -> void:
	var is_special: bool = properties["special"]
	var type: int = properties["type"]
	var points: int = properties["points"]
	var special_points: int = properties["special_points"]
	var location: Vector2 = properties["global_position"]
	var amount_to_grow: int
	var special_amount_to_grow: int

	amount_to_grow = _process_points(points)
	_spawn_added_score_text(points, location)
	_spawn_added_segment_text(amount_to_grow)

	if is_special:
		special_amount_to_grow = _process_special_points(special_points, type)
		# _spawn_added_score_text(points, location)
		_spawn_added_special_segment_text(special_amount_to_grow, type)
		_check_if_unlocked(type)


func _check_if_unlocked(type: int) -> void:
	match type:
		FoodSpecial.Type.BUNNY:
			if not stats.trait_dash and stats.dash_segments != 0:
				stats.trait_dash = true
		FoodSpecial.Type.TURTLE:
			if not stats.trait_slow and stats.slow_segments != 0:
				stats.trait_slow = true
		FoodSpecial.Type.FROG:
			if not stats.trait_jump and stats.jump_segments != 0:
				stats.trait_jump = true


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


func _process_special_points(points: int, type: int) -> int:
	var score_to_grow: int
	var amount_to_grow: int = 0
	var growth_progress: int

	match type:
		FoodSpecial.Type.BUNNY:
			score_to_grow = (stats.dash_segments + 1) * special_values[type][0] - stats.dash_points
			stats.dash_points += points
		FoodSpecial.Type.TURTLE:
			score_to_grow = (stats.slow_segments + 1) * special_values[type][0] - stats.slow_points
			stats.slow_points += points
		FoodSpecial.Type.FROG:
			score_to_grow = (stats.jump_segments + 1) * special_values[type][0] - stats.jump_points
			stats.jump_points += points

	if points >= score_to_grow:
		amount_to_grow += 1
		points -= score_to_grow
		# maybe be careful with this
		amount_to_grow += points / special_values[type][0]

	match type:
		FoodSpecial.Type.BUNNY:
			stats.dash_segments += amount_to_grow
			growth_progress = special_values[type][0] - ((stats.dash_segments + 1) * special_values[type][0] - stats.dash_points)
			Event.emit_signal("snake_dash_progress", growth_progress)
		FoodSpecial.Type.TURTLE:
			stats.slow_segments += amount_to_grow
			growth_progress = special_values[type][0] - ((stats.slow_segments + 1) * special_values[type][0] - stats.slow_points)
			Event.emit_signal("snake_slow_progress", growth_progress)
		FoodSpecial.Type.FROG:
			stats.jump_segments += amount_to_grow
			growth_progress = special_values[type][0] - ((stats.jump_segments + 1) * special_values[type][0] - stats.jump_points)
			Event.emit_signal("snake_jump_progress", growth_progress)
	return amount_to_grow


func _spawn_added_score_text(points: int, location: Vector2) -> void:
	var label: ScoreLabel = SCORE_LABEL.instance()
	add_child(label)
	label.set_properties(points, Color.aquamarine, location)


func _spawn_added_segment_text(amount: int) -> void:
	if amount > 0:
		var label: ScoreLabel = SCORE_LABEL.instance()
		add_child(label)
		label.set_properties(amount, Color.green, last_snake_pos + snake_location_offset, ScoreLabel.Type.BODY_SEGMENT)


func _spawn_added_special_segment_text(amount: int, type: int)-> void:
	if amount > 0:
		var label: ScoreLabel = SCORE_LABEL.instance()
		add_child(label)
		label.set_properties(amount, special_values[type][1], last_snake_pos + special_snake_location_offset, special_values[type][2])


func _on_snake_path_new_point(coordinates: Vector2) -> void:
	last_snake_pos = coordinates


func _on_game_over() -> void:
	var max_stats: Stats = _get_max_stats()
	SaveData.save_data(max_stats)
	Event.emit_signal("display_stats", initial_stats, stats, mutation_stats)


func _get_max_stats() -> Stats:
	var old_stats_dict: Dictionary = initial_stats.get_stats()
	var new_stats_dict: Dictionary = stats.get_stats()
	var max_stats: Stats = Stats.new()
	var max_stats_dict: Dictionary = max_stats.get_stats()
	var bool_stats: Array = [
		"trait_dash",
		"trait_slow",
		"trait_jump"
	]

	for i in old_stats_dict:
		if bool_stats.has(i):
			max_stats_dict[i] = old_stats_dict[i] or new_stats_dict[i]
		else:
			max_stats_dict[i] = max(old_stats_dict[i], new_stats_dict[i])
	max_stats.set_stats(max_stats_dict)
	return max_stats
