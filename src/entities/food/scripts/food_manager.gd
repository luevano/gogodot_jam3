class_name FoodManager
extends Node2D

export(PackedScene) var FOOD: PackedScene

var max_apples: int = 10
var current_apples: int = 0


func _ready():
	Event.connect("food_eaten", self, "_on_food_eaten")
	randomize()


func _process(delta) -> void:
	if current_apples < max_apples:
		_place_new_food()
		current_apples += 1


func _place_new_food() -> void:
	var food: Area2D = FOOD.instance()
	Event.emit_signal("food_placing_new_food", food.TYPE)
	var position: Vector2 = _get_random_pos()
	food.global_position = position
	add_child(food)
	Event.emit_signal("food_placed_new_food", food.TYPE)


func _get_random_pos() -> Vector2:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var temp_x: float = randf() * screen_size.x - screen_size.x / 2.0
	var temp_y: float = randf() * screen_size.y - screen_size.y / 2.0

	return Vector2(temp_x, temp_y)


func _on_food_eaten(type: int) -> void:
	current_apples -= 1