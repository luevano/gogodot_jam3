extends Node

var GAME_NODE: PackedScene = preload("res://Game.tscn")
var GAME_SCALE: float = 2.0
var TILE_SIZE: int = 16
var WORLD_TILE_PATH: int = 0
var WORLD_TILE_WALL: int = 1

var SNAKE_INITIAL_SEGMENTS: int = 1
var SNAKE_SPEED: float = 50.0
var SNAKE_ROT_SPEED: float = 300.0
var SNAKE_POSITION_UPDATE_INTERVAL: float = 0.001
# this usually corresponds to the sprite size
var SNAKE_SEGMENT_SIZE: float = 6.0

var POINTS_TO_GROW: int = 10
