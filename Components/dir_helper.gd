extends Node

enum SearchType
{
	DIR,
	FILE,
	ALL
}

func get_dir_names(root_folder : String, search_type : SearchType = SearchType.ALL):
	var names = []
	var dir = DirAccess.open(root_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (search_type == SearchType.ALL or search_type == SearchType.DIR) and dir.current_is_dir():
				print("Found directory: " + file_name)
				names.append(file_name)
			elif (search_type == SearchType.ALL or search_type == SearchType.FILE) and not dir.current_is_dir():
				print("Found file: " + file_name)
				names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return names
