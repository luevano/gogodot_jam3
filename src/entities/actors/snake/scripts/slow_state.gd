extends Node

var fsm: StateMachine


func enter():
	if fsm.DEBUG:
		print("Got inside %s." % name)
	Event.emit_signal("snake_started_slow")
	Global.SNAKE_SPEED = Global.SNAKE_SLOW_SPEED
	yield(get_tree().create_timer(Global.SNAKE_SLOW_TIME), "timeout")
	exit()


func exit():
	Event.emit_signal("snake_finished_dash")
	Global.SNAKE_SPEED = Global.SNAKE_SPEED_BACKUP
	fsm.back()


func physics_process(delta: float) -> float:
	fsm.player.velocity = fsm.player.direction * Global.SNAKE_SPEED
	fsm.player.velocity = fsm.player.move_and_slide(fsm.player.velocity)

	fsm.slow_down_on_collisions(Global.SNAKE_SLOW_SPEED)

	return delta
