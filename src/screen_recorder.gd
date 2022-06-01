extends CanvasLayer

onready var gif_recorder: GifRecorder = $Control/GifRecorder


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_G and event.pressed:
		print("Encoding GIF.")
		gif_recorder.render_to_file("res://test.gif")
		yield(gif_recorder, "done_encoding")
		print("Done encoding GIF.")
		gif_recorder.clear()
		gif_recorder.start()
