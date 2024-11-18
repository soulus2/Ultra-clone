extends Control

@onready var player = $"../../.."
@onready var Debug_label = $Debug/Debug_label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_debug()
	
func update_debug():
	Debug_label.text = str("Speed: "+str(player.get_current_speed())+"\nPosition: "+str(player.get_current_position())+"\nMax wall jumps: "+str(player.get_max_wall_jumps())+"\nWall jumps left: "+str(player.get_wall_jumps())+"\nMax dashes: "+str(player.get_max_deshes())+"\nDashes left: "+str(player.get_dashes()))
	
