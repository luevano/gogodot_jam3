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
		"dash_segments": dash_segments,
		"dash_percentage": dash_percentage,
		"slow_points": slow_points,
		"slow_segments": slow_segments,
		"slow_percentage": slow_percentage,
		"jump_points": jump_points,
		"jump_segments": jump_segments,
		"jump_lenght": jump_lenght,
		"trait_dash": trait_dash,
		"trait_slow": trait_slow,
		"trait_jump": trait_jump
	}


func set_stats(stats: Dictionary) -> void:
		points = stats["points"]
		segments = stats["segments"]
		dash_points = stats["dash_points"]
		slow_points = stats["slow_points"]
		jump_points = stats["jump_points"]
		dash_segments = stats["dash_segments"]
		slow_segments = stats["slow_segments"]
		jump_segments = stats["jump_segments"]
		dash_percentage = stats["dash_percentage"]
		slow_percentage = stats["slow_percentage"]
		jump_lenght = stats["jump_lenght"]
		trait_dash = stats["trait_dash"]
		trait_slow = stats["trait_slow"]
		trait_jump = stats["trait_jump"]
