extends Node

@export var scene_container:Node
@export var scenes:Array[PackedScene]

func load_scene(index:int) -> void:
	print(index)
	if len(scenes)==0:
		Printer.print_warning("No scene array was provided")
		return
	if index >= 0 && index < len(scenes):
		
		var scene = scenes[index].instantiate()
		scene_container.add_child(scene)
	else: 
		Printer.print_other("from function [load_scene]")
		Printer.print_error("Scene index is out of range!")
		Printer.print_info("Provided index was "+ str(index) + " | Available index range was 0 - "+str(len(scenes)))

func clear_container():
	for c in scene_container.get_children():
		c.queue_free()

func switch_scene(index:int):
	if index >= 0 && index < len(scenes):
		clear_container()
		load_scene(index)
	else: 
		Printer.print_other("from function [switch_scene]")
		Printer.print_error("Scene index is out of range!")
		Printer.print_info("Provided index was "+ str(index) + " | Available index range was 0 - "+str(len(scenes)))

	
