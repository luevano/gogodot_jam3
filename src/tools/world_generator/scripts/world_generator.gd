extends Node2D

export(NodePath) var TILEMAP_NP: NodePath
onready var tilemap: TileMap = get_node(TILEMAP_NP)


func get_valid_map_coords() -> Array:
	return tilemap.get_used_cells_by_id(Global.WORLD_TILE_PATH)


func get_centered_world_position(location: Vector2) -> Vector2:
	return tilemap.map_to_world(location) + Vector2.ONE * Global.TILE_SIZE / 2.0
