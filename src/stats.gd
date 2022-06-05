class_name Stats
extends Node

# main
var points: int = 0
var segments: int = 0

# track of trait points
var dash_points: int = 0
var slow_points: int = 0
var jump_points: int = 0

# times trait achieved
var dash_segments: int = 0
var slow_segments: int = 0
var jump_segments: int = 0

# trait properties
var dash_percentage: float = 0.0
var slow_percentage: float = 0.0
var jump_lenght: float = 0.0

# trait active
var trait_dash: bool = false
var trait_slow: bool = false
var trait_jump: bool = false


func get_stats() -> Dictionary:
	return {
		"points": points,
		"segments": segments,
		"dash_points": dash_points,
		"slow_points": slow_points,
		"jump_points": jump_points,
		"dash_segments": dash_segments,
		"slow_segments": slow_segments,
		"jump_segments": jump_segments,
		"dash_percentage": dash_percentage,
		"slow_percentage": slow_percentage,
		"jump_lenght": jump_lenght,
		"trait_dash": trait_dash,
		"trait_slow": trait_slow,
		"trait_jump": trait_jump
	}


func set_stats(stats: Dictionary) -> void:
	var current_stats: Dictionary = get_stats()
	for i in stats:
		current_stats[i] = stats[i]
