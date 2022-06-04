extends MarginContainer

export(NodePath) var START_OPTION_NP: NodePath
export(NodePath) var SETTINGS_OPTION_NP: NodePath
export(NodePath) var EXIT_OPTION_NP: NodePath

onready var start_option: MenuOption = get_node(START_OPTION_NP)
onready var settings_option: MenuOption = get_node(SETTINGS_OPTION_NP)
onready var exit_option: MenuOption = get_node(EXIT_OPTION_NP)

onready var main: Node2D = get_parent().get_parent()


enum Option {
	START,
	SETTINGS,
	EXIT
}

enum {
	NEXT,
	PREV
}

onready var options: Dictionary = {
	Option.START: start_option,
	Option.SETTINGS: settings_option,
	Option.EXIT: exit_option
}

var current_selection: int = Option.START


func _ready():
	Event.connect("game_start", self, "_on_game_start")
	start_option.type = Option.START
	settings_option.type = Option.SETTINGS
	exit_option.type = Option.EXIT


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		_menu_selection(NEXT)
	elif event.is_action_pressed("ui_up"):
		_menu_selection(PREV)


	if event.is_action_pressed("ui_accept"):
		match current_selection:
			Option.START:
				Event.emit_signal("game_start")
			Option.SETTINGS:
				print("Option TEST.")
			Option.EXIT:
				get_tree().quit()


func _menu_selection(selection: int) -> void:
	match selection:
		NEXT:
			current_selection += 1
			if current_selection == Option.size():
				current_selection = 0
		PREV:
			current_selection -= 1
			if current_selection == -1:
				current_selection = Option.size() - 1
	_update_options()


func _update_options() -> void:
	for i in options:
		if i == current_selection:
			options[i].selected = true
		else:
			options[i].selected = false


func _on_game_start() -> void:
	print("game_start")
	get_tree().change_scene_to(Global.GAME_NODE)
