extends Node3D

@export var mouse_capture:bool = false
@export var fullscreen:bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("mouse_capture"):
		mouse_capture = !mouse_capture
	if event.is_action_pressed("fullscreen"):
		fullscreen = !fullscreen
	
	if mouse_capture:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
