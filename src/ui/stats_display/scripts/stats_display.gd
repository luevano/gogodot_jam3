extends MarginContainer

export(PackedScene) var PROGRESSION_LABEL: PackedScene

onready var label_parent: VBoxContainer = $Center/HBox/ProgressionPanel/VBox/VBox


func _ready():
	Event.connect("display_stats", self, "_on_display_stats")
	visible = false


func _on_display_stats(old_stats: Stats, new_stats: Stats, mut_stats: Array) -> void:
	visible = true
	var old_stats_dict: Dictionary = old_stats.get_stats()
	var new_stats_dict: Dictionary = new_stats.get_stats()
	var mut_stats_dict: Array = []
	for i in mut_stats:
		mut_stats_dict.append(i)

	var type: int
	var prefix: String
	var should_print: bool

	for stat_name in old_stats_dict:
		should_print = _should_print(stat_name, new_stats_dict)
		if should_print:
			type = _get_type(stat_name)
			prefix = _get_prefix(stat_name)
			var _temp_label: ProgressionLabel = PROGRESSION_LABEL.instance()
			label_parent.add_child(_temp_label)
			_temp_label.set_properties(type, prefix, old_stats_dict[stat_name], new_stats_dict[stat_name])


func _get_type(stat_name: String) -> int:
	var type: int
	match stat_name:
		"points", "segments":
			type = ProgressionLabel.Type.BODY_SEGMENT
		"dash_points", "dash_segments":
			type = ProgressionLabel.Type.DASH_SEGMENT
		"slow_points", "slow_segments":
			type = ProgressionLabel.Type.SLOW_SEGMENT
		"jump_points", "jump_segments":
			type = ProgressionLabel.Type.JUMP_SEGMENT
		_:
			type = ProgressionLabel.Type.EMPTY
	return type


func _get_prefix(stat_name: String) -> String:
	var prefix: String
	match stat_name:
		"points":
			prefix = "points"
		"dash_points":
			prefix = "points"
		"slow_points":
			prefix = "points"
		"jump_points":
			prefix = "points"
		_:
			prefix = ""
	return prefix


func _should_print(stat_name: String, stats: Dictionary) -> bool:
	var to_print: Array = [
		"points",
		"segments",
		"dash_points",
		"dash_segments",
		"slow_points",
		"slow_segments",
		"jump_points",
		"jump_segments"
	]
	var to_print_check: Array = [
		"dash_percentage",
		"slow_percentage",
		"jump_lenght"
	]
	var checks: Dictionary = {
		to_print_check[0]: stats["trait_dash"],
		to_print_check[1]: stats["trait_slow"],
		to_print_check[2]: stats["trait_jump"]
	}

	if to_print.has(stat_name):
		return true
	elif to_print_check.has(stat_name):
		if checks[stat_name]:
			return true
		else:
			return false
	else:
		return false
