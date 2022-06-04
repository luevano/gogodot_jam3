extends HBoxContainer

enum {
	BODY1,
	BODY2,
	BODY3,
	TAIL
}

var frames: Dictionary = {
	BODY1: preload("res://ui/hud/snake/sprites/body1.png"),
	BODY2: preload("res://ui/hud/snake/sprites/body2.png"),
	BODY3: preload("res://ui/hud/snake/sprites/body3.png"),
	TAIL: preload("res://ui/hud/snake/sprites/tail.png")
}

var last_tail_index: int = -1
var last_frame: int = -1
var frame_direction: int = 1


func _ready():
	Event.connect("snake_added_new_segment", self, "_on_snake_added_new_segment")


func _on_snake_added_new_segment(type: String) -> void:
	match type:
		"body":
			_add_body_frame()
			_move_tail_frame()
		"tail":
			_add_tail_frame()


func _add_body_frame() -> void:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = frames[_get_next_body_frame()]
	add_child(texture_rect)


func _add_tail_frame() -> void:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = frames[TAIL]
	add_child(texture_rect)
	last_tail_index = get_child_count() - 1


func _move_tail_frame() -> void:
	var child_count: int = get_child_count()
	if child_count > Global.SNAKE_INITIAL_SEGMENTS + 1:
		var last_child: TextureRect = get_child(last_tail_index)
		move_child(last_child, child_count - 1)
		last_tail_index = child_count - 1


func _get_next_body_frame() -> int:
	match last_frame:
		-1:
			last_frame = BODY2
		BODY2:
			last_frame += frame_direction
		BODY3:
			frame_direction = -1
			last_frame += frame_direction
		BODY1:
			frame_direction = 1
			last_frame += frame_direction

	return last_frame
