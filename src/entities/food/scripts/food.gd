class_name Food
extends Area2D

enum Type {
	APPLE
}

var _type_texture: Dictionary = {
	Type.APPLE: preload("res://entities/food/sprites/apple.png")
}

export(Type) var TYPE
onready var _sprite: Sprite = $Sprite
var location: Vector2


func _ready():
	connect("body_entered", self, "_on_body_entered")
	_sprite.texture = _type_texture[TYPE]


func _on_body_entered(body: Node) -> void:
	Event.emit_signal("food_eaten", TYPE, location)
	queue_free()