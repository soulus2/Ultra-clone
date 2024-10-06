extends Node

signal spawn_player(trans)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_player.emit($Player_spwan.transform)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
