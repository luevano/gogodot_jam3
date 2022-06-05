class_name FoodBasic
extends Food

enum Type {
	APPLE,
	BANANA
}


func _ready():
	texture[Type.APPLE] = preload("res://entities/food/sprites/apple.png")
	texture[Type.BANANA] = preload("res://entities/food/sprites/banana.png")
