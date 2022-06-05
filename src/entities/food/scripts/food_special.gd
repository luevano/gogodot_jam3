class_name FoodSpecial
extends Food

enum Type {
	BUNNY,
	TURTLE,
	FROG
}


func _ready():
	texture[Type.BUNNY] = preload("res://entities/food/sprites/bunny.png")
	texture[Type.FROG] = preload("res://entities/food/sprites/frog.png")
	texture[Type.TURTLE] = preload("res://entities/food/sprites/turtle.png")
