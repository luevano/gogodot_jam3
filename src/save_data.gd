extends Node

const DATA_PATH: String = "user://data.save"

var _stats: Stats


func _ready() -> void:
	_load_data()


# called when setting "stats" and thus saving
func save_data(stats: Stats) -> void:
	_stats = stats
	var file: File = File.new()
	file.open(DATA_PATH, File.WRITE)
	file.store_line(to_json(_stats.get_stats()))
	file.close()


func get_stats() -> Stats:
	return _stats


func _load_data() -> void:
	# create an empty file if not present to avoid error while loading settings
	_handle_new_file()

	var file = File.new()
	file.open(DATA_PATH, File.READ)
	_stats = Stats.new()
	_stats.set_stats(parse_json(file.get_line()))
	file.close()


func _handle_new_file() -> void:
	var file: File = File.new()
	if not file.file_exists(DATA_PATH):
		file.open(DATA_PATH, File.WRITE)
		_stats = Stats.new()
		file.store_line(to_json(_stats.get_stats()))
		file.close()
