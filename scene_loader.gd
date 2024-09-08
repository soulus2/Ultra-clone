extends Node

@export var scene_container:Node
@export var scenes:Array[PackedScene]

func load_scene(index:int):
	if scenes[index]:
		var scene = scenes[index].instantiate()
		scene_container.add_child(scene)
func clear_container():
	for c in scene_container.get_children():
		c.queue_free()

func switch_scene(index:int):
	clear_container()
	load_scene(index)
	
