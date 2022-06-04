class_name FoodBasic
extends Food

enum Type {
	APPLE
}


func _ready():
	texture[Type.APPLE] = preload("res://entities/food/sprites/apple.png")