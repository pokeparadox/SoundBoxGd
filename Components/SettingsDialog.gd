extends VBoxContainer

func _ready() -> void:
	if SettingsManager.settings_loaded():
		$TwitchChannel/LineEditTwitchChannel.text = SettingsManager.settings.twitch_channel
		$CheckBoxAutoLogin.button_pressed = SettingsManager.settings.auto_login

func _on_button_save_pressed() -> void:
	SettingsManager.settings.twitch_channel = $TwitchChannel/LineEditTwitchChannel.text
	SettingsManager.settings.auto_login = $CheckBoxAutoLogin.button_pressed
	SettingsManager.save_settings()
	return_to_main()


func _on_button_cancel_pressed() -> void:
	return_to_main()

func return_to_main() -> void:
	SceneManager.set_scene("res://main.tscn")
