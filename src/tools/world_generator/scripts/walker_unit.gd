extends Node2D

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var direction: Dictionary = {
	Direction.LEFT: Vector2.LEFT,
	Direction.RIGHT: Vector2.RIGHT,
	Direction.UP: Vector2.UP,
	Direction.DOWN: Vector2.DOWN
}

var _walker_head: Node2D
var _tilemap: TileMap

var given_birth: bool = false
var walked_straight: bool = false

var path_length: int
var birth_chance: float
var death_chance: float
var walk_straight_chance: float
var walk_straight_length: float


func start(id: int) -> void:
	Event.emit_signal("world_gen_walker_started", id)
	_walker_head = get_parent()
	_tilemap = _walker_head.ground_tilemap
	_randomize_stats()

	var path_steps: Array = _get_path_steps()
	var walker_died: bool = _set_path_tiles(path_steps)

	if walker_died:
		Event.emit_signal("world_gen_walker_died", id)
	else:
		Event.emit_signal("world_gen_walker_finished", id)
	queue_free()


func _randomize_stats() -> void:
	randomize()
	path_length = int(rand_range(50, 200))
	birth_chance = rand_range(0.001, 0.01)
	death_chance = rand_range(0.0, 0.005) / 2.0
	walk_straight_chance = rand_range(0.001, 0.025)
	walk_straight_length = rand_range(4, 20)


func _get_path_steps() -> Array:
	var path_steps: Array = []
	var step: int
	for _i in path_length:
		step = randi() % Direction.size()
		path_steps.append(step)

		if randf() < walk_straight_chance and not walked_straight:
			for j in walk_straight_length:
				path_steps.append(step)
			walked_straight = true
	return path_steps


func _set_path_tiles(path_steps: Array) -> bool:
	# get initial tile location
	var location: Vector2 = get_parent().global_position * Global.TILE_SIZE
	var move_direction: Vector2
	_set_tile(location, _walker_head.get_random_tile())
	for step in path_steps:
		move_direction = direction[step]
		location += move_direction * Global.TILE_SIZE
		_set_tile(location, _walker_head.get_random_tile())

		if randf() < birth_chance and not given_birth:
			Event.emit_signal("world_gen_spawn_walker_unit", location)
			given_birth = true

		if randf() < death_chance:
			return true
	return false


func _set_tile(location: Vector2, tile: int) -> void:
	var coordinates: Vector2 = _tilemap.world_to_map(location)
	_update_map_size(coordinates)
	_tilemap.set_cellv(coordinates, tile)


func _update_map_size(coordinates: Vector2) -> void:
	if coordinates.x > _walker_head.max_x:
		_walker_head.max_x = coordinates.x
	if coordinates.y > _walker_head.max_y:
		_walker_head.max_y = coordinates.y
