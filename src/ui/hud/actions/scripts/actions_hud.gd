extends MarginContainer

onready var w: TextureButton = $VBox/WHBox/W
onready var s: TextureButton = $VBox/SHBox/S
onready var space: TextureButton = $VBox/SpaceHBox/Space

var stats: Stats = SaveData.get_stats()


func _ready():
	Event.connect("snake_started_dash", self, "_on_snake_started_dash")
	Event.connect("snake_started_slow", self, "_on_snake_started_slow")
	Event.connect("snake_started_jump", self, "_on_snake_started_jump")
	if stats.trait_dash:
		w.disabled = false
	if stats.trait_slow:
		s.disabled = false
	if stats.trait_jump:
		space.disabled = false


func _on_snake_started_dash() -> void:
	w.disabled = true
	yield(get_tree().create_timer(Global.SNAKE_DASH_COOLDOWN), "timeout")
	w.disabled = false


func _on_snake_started_slow() -> void:
	s.disabled = true
	yield(get_tree().create_timer(Global.SNAKE_SLOW_COOLDOWN), "timeout")
	s.disabled = false


func _on_snake_started_jump() -> void:
	space.disabled = true
	yield(get_tree().create_timer(Global.SNAKE_JUMP_COOLDOWN), "timeout")
	space.disabled = false
