extends Node

var fsm: StateMachine


func enter():
	if fsm.DEBUG:
		print("Got inside %s." % name)


func exit(next_state):
	fsm.change_to(next_state)


func physics_process(delta: float) -> void:
	fsm.rotate_on_input()
	fsm.player.velocity = fsm.player.direction * Global.SNAKE_SPEED
	fsm.player.velocity = fsm.player.move_and_slide(fsm.player.velocity)

	fsm.slow_down_on_collisions(Global.SNAKE_SPEED_BACKUP)


func input(event: InputEvent) -> void:
	if fsm.player.can_dash and event.is_action_pressed("dash"):
		exit("DashState")
	if fsm.player.can_slow and event.is_action_pressed("slow"):
		exit("SlowState")
	if fsm.player.can_jump and event.is_action_pressed("jump"):
		exit("JumpState")
