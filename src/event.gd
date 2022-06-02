extends Node

signal snake_path_new_point(coordinates)
signal snake_adding_new_segment(type)
signal snake_added_new_segment(type)
signal snake_added_initial_segments
signal snake_segment_body_entered(body)

signal food_placing_new_food(type)
signal food_placed_new_food(type)
signal food_eaten(type)