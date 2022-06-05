extends Node2D

onready var tilemap: TileMap = $TileMap
onready var walker_head: Node2D = $WalkerHead


func get_valid_map_coords() -> Array:
	var safe_area: Array = walker_head.get_cells_around()
	var cells_used: Array = tilemap.get_used_cells_by_id(Global.WORLD_TILE_PATH)
	for location in safe_area:
		cells_used.erase(location)
	return cells_used


func get_centered_world_position(location: Vector2) -> Vector2:
	return tilemap.map_to_world(location) + Vector2.ONE * Global.TILE_SIZE / 2.0
