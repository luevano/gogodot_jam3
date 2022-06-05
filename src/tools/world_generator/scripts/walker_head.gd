extends Node2D

export(NodePath) var TILEMAP_NP: NodePath
export(PackedScene) var WALKER_UNIT_NP: PackedScene
export(int, 4, 100, 1) var STARTING_UNIT_COUNT: int = 6
export(int, 2, 10, 1) var INITIAL_SAFE_ZONE_SIZE: int = 2

onready var tilemap: TileMap = get_node(TILEMAP_NP)

var max_x: int = 0
var max_y: int = 0
var map_margin: int = 10
var units: int = 0


func _ready() -> void:
	Event.connect("world_gen_walker_started", self, "_on_world_gen_walker_started")
	Event.connect("world_gen_walker_finished", self, "_on_world_gen_walker_finished")
	Event.connect("world_gen_walker_died", self, "_on_world_gen_walker_died")
	Event.connect("world_gen_spawn_walker_unit", self, "_on_world_gen_spawn_walker_unit")
	_place_safe_zone()
	_spawn_walker_units()
	_fill_empty_space()


func get_cells_around(size: int=INITIAL_SAFE_ZONE_SIZE) -> Array:
	var locations: Array = []
	for i in range(-size, size):
		for j in range(-size, size):
			locations.append(Vector2(i, j))

	return locations


func _place_safe_zone() -> void:
	var size: int = INITIAL_SAFE_ZONE_SIZE
	for i in range(-size, size):
		for j in range(-size, size):
			tilemap.set_cell(i, j, Global.WORLD_TILE_PATH)


func _spawn_walker_units() -> void:
	for i in STARTING_UNIT_COUNT:
		_spawn_walker_unit(Vector2.ZERO)


func _spawn_walker_unit(spawn_position: Vector2) -> void:
	var walker_unit: Node2D = WALKER_UNIT_NP.instance()
	add_child(walker_unit)
	units += 1
	walker_unit.position = spawn_position
	walker_unit.start(units)


func _fill_empty_space() -> void:
	var locations: Array = _get_empty_cells_location()
	for location in locations:
		tilemap.set_cellv(location, Global.WORLD_TILE_WALL)


func _get_empty_cells_location() -> Array:
	var locations: Array = []
	var rect: Rect2 = tilemap.get_used_rect()
	var margin: int = map_margin
	for x in range(-margin, rect.size.x + margin):
		for y in range (-margin, rect.size.y + margin):
			var location: Vector2 = Vector2(rect.position.x + x, rect.position.y + y)
			if tilemap.get_cell(int(location.x), int(location.y)) == TileMap.INVALID_CELL:
				locations.append(location)

	return locations


func _on_world_gen_walker_started(id: int) -> void:
	# print("Walker unit %s started." % id)
	pass


func _on_world_gen_walker_finished(id: int) -> void:
	# print("Walker unit %s finished." % id)
	pass


func _on_world_gen_walker_died(id: int) -> void:
	# print("Walker unit %s died." % id)
	pass


func _on_world_gen_spawn_walker_unit(location: Vector2) -> void:
	# print("Spawning new walking unit.")
	pass
	_spawn_walker_unit(location)
