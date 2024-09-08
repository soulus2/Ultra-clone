extends Node3D


@export var current_level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scene_loader.load_scene(current_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
