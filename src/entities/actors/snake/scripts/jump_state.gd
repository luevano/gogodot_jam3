extends Node

var fsm: StateMachine


func enter():
	if fsm.DEBUG:
		print("Got inside %s." % name)
	Event.emit_signal("snake_started_jump")
	fsm.player.set_collision_mask_bit(1, false)
	fsm.player.set_collision_mask_bit(2, false)
	Global.SNAKE_SPEED = Global.SNAKE_JUMP_SPEED
	yield(get_tree().create_timer(Global.SNAKE_JUMP_TIME), "timeout")
	exit()


func exit():
	fsm.player.set_collision_mask_bit(1, true)
	fsm.player.set_collision_mask_bit(2, true)
	Global.SNAKE_SPEED = Global.SNAKE_SPEED_BACKUP
	Event.emit_signal("snake_finished_jump")
	fsm.back()


func physics_process(delta: float) -> void:
	fsm.player.velocity = fsm.player.direction * Global.SNAKE_SPEED
	fsm.player.velocity = fsm.player.move_and_slide(fsm.player.velocity)

	fsm.slow_down_on_collisions(Global.SNAKE_JUMP_SPEED)
