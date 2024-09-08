extends Node3D


@export var current_level:int = 0
var previous_level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_level = current_level
	update_level()
func _process(delta: float) -> void:
	if previous_level!=current_level:
		update_level()
		previous_level=current_level
	
func update_level():
	$Scene_loader.switch_scene(current_level)
	
