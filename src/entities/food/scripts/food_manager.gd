class_name FoodManager
extends Node2D

export(PackedScene) var FOOD: PackedScene
export(NodePath) var WORLD_GENERATOR_NP: NodePath
onready var world_generator: Node2D = get_node(WORLD_GENERATOR_NP)
onready var possible_food_locations: Array = world_generator.get_valid_map_coords()

var max_apples: int = 10
var current_food: Array = []


func _ready():
	randomize()
	Event.connect("food_eaten", self, "_on_food_eaten")


func _process(delta) -> void:
	if current_food.size() < max_apples:
		_place_new_food()


func _place_new_food() -> void:
	var food: Area2D = FOOD.instance()
	Event.emit_signal("food_placing_new_food", food.TYPE)
	var pos_loc: Array = _get_random_pos()
	var pos: Vector2 = pos_loc[0]
	var loc: Vector2 = pos_loc[1]

	food.global_position = pos
	food.location = loc
	add_child(food)
	current_food.append(loc)
	Event.emit_signal("food_placed_new_food", food.TYPE, loc)


func _get_random_pos() -> Array:
	var found_valid_loc: bool = false
	var index: int
	var location: Vector2

	while not found_valid_loc:
		print("trying")
		index = randi() % possible_food_locations.size()
		location = possible_food_locations[index]
		if current_food.find(location) == -1:
			found_valid_loc = true

	return [world_generator.get_centered_world_position(location), location]


func _on_food_eaten(type: int, location: Vector2) -> void:
	var index: int = current_food.find(location)
	current_food.remove(index)
