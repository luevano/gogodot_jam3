extends Node

signal game_start
signal game_restart
signal game_over
signal toggle_debug

signal snake_path_new_point(coordinates)
signal snake_add_new_segment(amount)
signal snake_adding_new_segment(type)
signal snake_added_new_segment(type)
signal snake_added_initial_segments
signal snake_segment_body_entered(body)
signal snake_rotated
signal snake_growth_progress(progress)

signal food_placing_new_food(special, type)
signal food_placed_new_food(properties)
signal food_eaten(properties)
signal food_timed_out(properties)

signal world_gen_walker_started(id)
signal world_gen_walker_finished(id)
signal world_gen_walker_died(id)
signal world_gen_spawn_walker_unit(location)

signal display_stats(old_stats, new_stats, mut_stats)