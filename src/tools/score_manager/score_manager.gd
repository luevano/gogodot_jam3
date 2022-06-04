extends Node


var score: int = 0
var growth: int = 0


func _ready():
	Event.connect("food_eaten", self, "_on_food_eaten")


func _on_food_eaten(properties: Dictionary) -> void:
	var points: int = properties["points"]
	var score_to_grow: int = (growth + 1) * Global.POINTS_TO_GROW - score
	var amount_to_grow: int = 0
	score += points
	if points >= score_to_grow:
		amount_to_grow += 1
		points -= score_to_grow
		# maybe be careful with this
		amount_to_grow += points / Global.POINTS_TO_GROW
		growth += amount_to_grow
		Event.emit_signal("snake_add_new_segment", amount_to_grow)

	score_to_grow = Global.POINTS_TO_GROW - ((growth + 1) * Global.POINTS_TO_GROW - score)
	Event.emit_signal("snake_growth_progress", score_to_grow)
