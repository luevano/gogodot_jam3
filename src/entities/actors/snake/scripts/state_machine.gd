class_name StateMachine
extends Node

const DEBUG: bool = false

var player: KinematicBody2D
var state: Node
var history: Array = []


func _ready() -> void:
	player = get_parent()
	state = get_child(0)
	_enter_state()


func change_to(new_state: String) -> void:
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()


func back() -> void:
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()


func _enter_state() -> void:
	if DEBUG:
		print("Entering state %s" % state.name)
	state.fsm = self
	state.enter()


# routing game loop functions
func _process(delta: float) -> void:
	if state.has_method("process"):
		state.process(delta)


func _physics_process(delta: float) -> void:
	# state specific code, move_and_slide is called here
	if state.has_method("physics_process"):
		state.physics_process(delta)

	handle_slow_speeds()
	player.handle_time_elapsed(delta)


func rotate_on_input() -> void:
	if Input.is_action_pressed("move_left"):
		player.rotate_to(player.LEFT)
	if Input.is_action_pressed("move_right"):
		player.rotate_to(player.RIGHT)


func slow_down_on_collisions(speed_backup: float):
	if player.get_last_slide_collision():
		Global.SNAKE_SPEED = player.velocity.length()
	else:
		Global.SNAKE_SPEED = speed_backup


func handle_slow_speeds() -> void:
	if Global.SNAKE_SPEED <= Global.SNAKE_SPEED_BACKUP / 4.0:
		Global.SNAKE_SPEED = Global.SNAKE_SPEED_BACKUP
		Event.emit_signal("game_over")


func _input(event: InputEvent) -> void:
	if state.has_method("input"):
		state.input(event)
