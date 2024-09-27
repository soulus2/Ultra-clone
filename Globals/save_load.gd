extends Node

var save_path = "user://saves"

func save_data(data:Dictionary, file_name:String):
	var path = save_path+file_name
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data(file_name:String):
	var path = save_path+file_name
	var file = FileAccess.open(path,FileAccess.READ)
	var loaded_data=file.get_var()
	file.close()
	
	if loaded_data!=null:
		return loaded_data;
	else:
		Printer.print_warning("No data found on path "+path)
	
