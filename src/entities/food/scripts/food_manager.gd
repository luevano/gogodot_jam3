class_name FoodManager
extends Node2D

export(PackedScene) var FOOD_BASIC: PackedScene
export(PackedScene) var FOOD_SPECIAL: PackedScene
export(NodePath) var WORLD_GENERATOR_NP: NodePath

onready var world_generator: Node2D = get_node(WORLD_GENERATOR_NP)
onready var possible_food_locations: Array = world_generator.get_valid_map_coords()

# needed to know what food is available to setup
var stats: Stats = SaveData.get_stats()

var current_basic_food: Array = []
var current_special_food: Array = []
var max_basic_food: int
var max_special_food: int


func _ready():
	randomize()
	max_basic_food = int(possible_food_locations.size() * Global.MAX_BASIC_FOOD)
	max_special_food = int(possible_food_locations.size() * Global.MAX_SPECIAL_FOOD)
	Event.connect("food_eaten", self, "_on_food_eaten")


func _process(delta) -> void:
	if current_basic_food.size() < max_basic_food:
		_place_new_basic_food()

	if current_special_food.size() < max_special_food:
		_place_new_special_food()


func _place_new_basic_food() -> void:
	var food: FoodBasic = FOOD_BASIC.instance()
	var type: int = _get_random_food_type(FoodBasic.Type)
	Event.emit_signal("food_placing_new_food", false, type)
	var pos_loc: Array = _get_random_pos()
	var pos: Vector2 = pos_loc[0]
	var loc: Vector2 = pos_loc[1]

	# need to set the position first, else it will spawn on the middle and the moved
	if type == FoodBasic.Type.RAT:
		food.set_properties(pos, loc, false, type, Global.POINTS_TO_GROW / 2)
	else:
		food.set_properties(pos, loc, false, type)
	add_child(food)
	food.update_texture()
	current_basic_food.append(loc)
	Event.emit_signal("food_placed_new_food", food.properties)


func _place_new_special_food() -> void:
	var food: FoodSpecial = FOOD_SPECIAL.instance()
	var type: int = _get_random_food_type(FoodSpecial.Type)
	Event.emit_signal("food_placing_new_food", true, type)
	var pos_loc: Array = _get_random_pos()
	var pos: Vector2 = pos_loc[0]
	var loc: Vector2 = pos_loc[1]

	# need to set the position first, else it will spawn on the middle and the moved
	food.set_properties(pos, loc, true, type, Global.POINTS_TO_GROW, Global.POINTS_TO_GROW / Global.POINTS_TO_GROW)
	add_child(food)
	food.update_texture()
	current_special_food.append(loc)
	Event.emit_signal("food_placed_new_food", food.properties)


func _get_random_food_type(type) -> int:
	return randi() % type.size()


func _get_random_pos() -> Array:
	var found_valid_loc: bool = false
	var index: int
	var location: Vector2

	while not found_valid_loc:
		index = randi() % possible_food_locations.size()
		location = possible_food_locations[index]
		if current_basic_food.find(location) == -1 and current_special_food.find(location) == -1:
			found_valid_loc = true

	return [world_generator.get_centered_world_position(location), location]


func _on_food_eaten(properties: Dictionary) -> void:
	var index: int
	if properties["special"]:
		index = current_special_food.find(properties["location"])
		current_special_food.remove(index)
	else:
		index = current_basic_food.find(properties["location"])
		current_basic_food.remove(index)
