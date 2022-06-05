class_name FoodSpecial
extends Food

enum Type {
	BUNNY,
	FROG,
	TURTLE,
	RAT
}


func _ready():
	texture[Type.BUNNY] = preload("res://entities/food/sprites/bunny.png")
	texture[Type.FROG] = preload("res://entities/food/sprites/frog.png")
	texture[Type.TURTLE] = preload("res://entities/food/sprites/turtle.png")
	texture[Type.RAT] = preload("res://entities/food/sprites/rat.png")
