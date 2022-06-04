extends TextureRect

enum {
	IDLE,
	EAT,
	DEAD
}

var frames = {
	IDLE: preload("res://ui/hud/snake/sprites/head1.png"),
	EAT: preload("res://ui/hud/snake/sprites/head2.png"),
	DEAD: preload("res://ui/hud/snake/sprites/head3.png")
}


func _ready():
	texture = frames[IDLE]
	Event.connect("food_eaten", self, "_on_food_eaten")
	Event.connect("game_over", self, "_on_game_over")


func _on_food_eaten(properties: Dictionary) -> void:
	texture = frames[EAT]
	yield(get_tree().create_timer(0.25), "timeout")
	texture = frames[IDLE]


func _on_game_over() -> void:
	texture = frames[DEAD]