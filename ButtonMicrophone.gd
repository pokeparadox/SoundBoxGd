extends Button

var effect
var recording

func _ready() -> void:
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)

func _on_button_down() -> void:
	print("Started Recording...")
	effect.set_recording_active(true)


func _on_button_up() -> void:
	recording = effect.get_recording()
	effect.set_recording_active(false)
	print("Stopped Recording.")
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()
