extends Button

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

func _on_pressed() -> void:
	$Sound.play()
	$ButtonFlashAnim.play("FlashButton")


func _on_sound_finished() -> void:
	$ButtonFlashAnim.stop()
