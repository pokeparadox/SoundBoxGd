extends HFlowContainer

const WAV : String = "wav"
const OGG : String = "ogg"
const MP3 : String = "mp3"
const PNG : String = "png"
const TWITCH_TXT : String = "twitch.txt"
var SoundButton := load("res://Components/audio_button.tscn")

enum SearchType
{
	DIR,
	FILE,
	ALL
}

signal twitch_cmd_button_pressed(cmd : String)

# Called when the node enters the scene tree for the first time.
func load_buttons(buttons_path : String) -> void:
	var button_dirs = _get_folder_names(buttons_path, SearchType.DIR)
	for bd in button_dirs:
		var button_files = _get_folder_names(buttons_path + "/" + bd, SearchType.FILE)
		var has_sound : bool = false
		var sound_path : String
		var has_image : bool = false
		var image_path : String
		var button_name : String
		var has_twitch_cmd : bool = false
		var twitch_cmd_path : String
		for b in button_files:
			var ext : String = b.get_extension()
			var path : String = buttons_path + "/" + bd + "/" + b
			if ext == WAV or ext == OGG or ext == MP3:
				has_sound = true
				sound_path = path
				button_name = bd.capitalize()
			elif ext == PNG:
				has_image = true
				image_path = path
			elif b == TWITCH_TXT:
				has_twitch_cmd = true
				twitch_cmd_path = path
		var button
		if has_sound:
			button = SoundButton.instantiate()
			button.text = button_name
			button.load_sound(sound_path)
			if has_twitch_cmd:
				button.load_twitch_command(twitch_cmd_path)
				button.twitch_cmd_triggered.connect(_handle_twitch_cmd_triggered)
			self.add_child(button)
		if has_image and button != null:
			button.load_icon(image_path)
			
func _handle_twitch_cmd_triggered(cmd :String):
	twitch_cmd_button_pressed.emit(cmd)
	
func _get_folder_names(root_folder : String, search_type : SearchType = SearchType.ALL):
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


func _on_button_random_pressed() -> void:
	var buttons = self.get_children()
	if buttons != null and buttons.size() > 0:
		var selected_button = buttons.pick_random()
		if selected_button != null:
			selected_button.emit_signal("pressed")

func _clear_buttons() -> void:
	for c in get_children():
		if not c.is_playing():
			c.queue_free()
		elif c is Button:
			c.deferred_free()

func _on_sound_box_selector_sound_box_changed(box_path) -> void:
	_clear_buttons()
	load_buttons(box_path)

