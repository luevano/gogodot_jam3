extends Node

var MAIN_MENU_NODE: PackedScene = preload("res://ui/main_menu/scenes/MainMenu.tscn")
var GAME_NODE: PackedScene = preload("res://Game.tscn")
var GAME_SCALE: float = 2.0
var TILE_SIZE: int = 16
var GROUND_TILE_AMOUNT: int = 8
# var WORLD_TILE_PATH: int = 0
# var WORLD_TILE_WALL: int = 1

var SNAKE_INITIAL_SEGMENTS: int = 1
var SNAKE_SPEED: float = 50.0
var SNAKE_SPEED_BACKUP: float = SNAKE_SPEED
var SNAKE_ROT_SPEED: float = 300.0
var SNAKE_POSITION_UPDATE_INTERVAL: float = 0.001
# this usually corresponds to the sprite size
var SNAKE_SEGMENT_SIZE: float = 6.0

var SNAKE_DASH_SPEED: float = SNAKE_SPEED * 2.0
var SNAKE_DASH_TIME: float = 1.0
var SNAKE_DASH_COOLDOWN: float = 4.0

var SNAKE_SLOW_SPEED: float = SNAKE_SPEED / 2.0
var SNAKE_SLOW_TIME: float = 1.0
var SNAKE_SLOW_COOLDOWN: float = 4.0

var SNAKE_JUMP_SPEED: float = SNAKE_SPEED * 1.5
var SNAKE_JUMP_TIME: float = 0.5
var SNAKE_JUMP_COOLDOWN: float = 4.0

var POINTS_TO_GROW: int = 10
var POINTS_TO_DASH: int = 10
var POINTS_TO_SLOW: int = 10
var POINTS_TO_JUMP: int = 10

# percentage of the available tiles
var MAX_BASIC_FOOD: float = 0.05
var MAX_SPECIAL_FOOD: float = 0.01
