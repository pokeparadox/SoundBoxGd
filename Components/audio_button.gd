extends Button

var twitch_cmd : String

signal twitch_cmd_triggered(cmd : String)

func has_twitch_cmd() -> bool:
	return twitch_cmd != ""

func load_sound(sound_file_path : String) -> void:
	var sound_file = FileAccess.open(sound_file_path, FileAccess.READ)
	var ext = sound_file_path.get_extension()
	var stream : AudioStream
	var data = sound_file.get_buffer(sound_file.get_length())
	if ext == "mp3":
		var s = AudioStreamMP3.new()
		$Sound.stream = s
	elif ext == "ogg":
		## TODO Vorbis not working like this currently
		var s = AudioStreamOggVorbis.new()
		$Sound.stream = s
	elif ext == "wav":
		$Sound.stream = AudioStreamWAV.new()
	sound_file.close()
	$Sound.stream.data = data

func load_icon(icon_file_path : String) -> void:
	var image = Image.load_from_file(icon_file_path)
	if image != null:
		var texture = ImageTexture.create_from_image(image)
		self.icon = texture

func load_twitch_command(twitch_command_path : String) -> void:
	var twitch_file = FileAccess.open(twitch_command_path, FileAccess.READ)
	if twitch_file != null:
		twitch_cmd = twitch_file.get_line()
	twitch_file.close()

func _on_pressed() -> void:
	$Sound.play()
	$ButtonFlashAnim.play("FlashButton")
	if has_twitch_cmd():
		twitch_cmd_triggered.emit(twitch_cmd)


func _on_sound_finished() -> void:
	$ButtonFlashAnim.stop()

func is_playing() -> bool:
	return $Sound.playing

func deferred_free() -> void:
	$Sound.connect("finished", _do_free)
	
func _do_free() -> void:
	queue_free()
