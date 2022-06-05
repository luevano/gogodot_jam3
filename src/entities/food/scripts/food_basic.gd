class_name FoodBasic
extends Food

enum Type {
	APPLE,
	BANANA,
	RAT
}


func _ready():
	texture[Type.APPLE] = preload("res://entities/food/sprites/apple.png")
	texture[Type.BANANA] = preload("res://entities/food/sprites/banana.png")
	texture[Type.RAT] = preload("res://entities/food/sprites/rat.png")
