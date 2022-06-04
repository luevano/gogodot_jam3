extends Node

signal game_start
signal game_over

signal snake_path_new_point(coordinates)
signal snake_adding_new_segment(type)
signal snake_added_new_segment(type)
signal snake_added_initial_segments
signal snake_segment_body_entered(body)
signal snake_rotated

signal food_placing_new_food(type)
signal food_placed_new_food(type, location)
signal food_eaten(type, location)

signal world_gen_walker_started(id)
signal world_gen_walker_finished(id)
signal world_gen_walker_died(id)
signal world_gen_spawn_walker_unit(location)