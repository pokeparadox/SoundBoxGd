extends HBoxContainer

signal sound_box_changed(box_path : String)

@onready var working_dir : String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/SoundBoxGD/soundboxes/"
var box_dictionary = {}
var current_box : int = 0

func _ready() -> void:
	_create_default_folders()
	var boxes = get_boxes()
	var i : int = 0
	for b in boxes:
		box_dictionary[i] = b
		i = i + 1
	wrap_selection()

func _create_default_folders() -> void:
	OS.request_permissions()
	var default_buttons_dir : String = working_dir + "default/buttons"
	if not DirAccess.dir_exists_absolute(default_buttons_dir):
		DirAccess.make_dir_recursive_absolute(working_dir + "default/buttons")

func get_boxes():
	return DirHelper.get_dir_names(working_dir, DirHelper.SearchType.DIR)
	
func wrap_selection() -> void:
	current_box = wrapi(current_box, 0, box_dictionary.size())
	$LabelSoundBoxName.text = box_dictionary[current_box]
	emit_signal("sound_box_changed", working_dir + $LabelSoundBoxName.text)

func _on_button_previous_pressed() -> void:
	current_box = current_box - 1
	wrap_selection()


func _on_button_next_pressed() -> void:
	current_box = current_box + 1
	wrap_selection()
