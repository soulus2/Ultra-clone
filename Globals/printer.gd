extends Node

func print_error(text:String):
	print_rich("[color=red][Error] " + text + "[/color]")
	
func print_warning(text:String):
	print_rich("[color=yellow][Warning] " + text + "[/color]")
	
func print_success(text:String):
	print_rich("[color=green] " + text + "[/color]")
	
func print_info(text:String):
	print_rich("[color=#33aaff][Info] " + text + "[/color]")
	
func print_other(text:String):
	print_rich("[color=#a8a8a8]" + text + "[/color]")
	
	
