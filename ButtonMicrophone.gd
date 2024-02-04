extends Button

var effect
var recording

func _ready() -> void:
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	
func _on_button_down() -> void:
	if $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()
		recording = null
	if not $AudioStreamRecord.playing:
		$AudioStreamRecord.play()
		effect.set_recording_active(true)


func _on_button_up() -> void:
	recording = effect.get_recording()
	effect.set_recording_active(false)
	$AudioStreamRecord.stop()
	if recording != null:
		$AudioStreamPlayer.stream = recording
		$AudioStreamPlayer.play()
