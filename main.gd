extends Control

const TWITCH_CLIENT_ID : String = "0cbzay6zw9wmy56di4qd1tvmjkmh0w"
var _twitch_secret: String

func _init() -> void:
	pass
	var key = CryptoKey.new()
	var crypto = Crypto.new()
	key.load("res://generated.res")
	var file = FileAccess.open("res://encrypted.res", FileAccess.READ)
	if file != null:
		_twitch_secret = crypto.decrypt(key, file.get_buffer(file.get_length())).get_string_from_utf8()
	

func _ready() -> void:
	pass
	if SettingsManager.settings_loaded():
		if SettingsManager.settings.auto_login and !$Gift.connected:
			await($Gift.authenticate(TWITCH_CLIENT_ID, _twitch_secret))
			var _success = await($Gift.connect_to_irc())
			#if (success):
				#$Gift.request_caps()
				#$Gift.join_channel(SettingsManager.settings.twitch_channel)
			#await($Gift.connect_to_eventsub())
			
func _on_button_menu_pressed() -> void:
	SceneManager.set_scene("res://Components/SettingsDialog.tscn")

func _on_buttons_panel_twitch_cmd_button_pressed(cmd : String) -> void:
	if $Gift.connected:
		$Gift.chat(cmd, SettingsManager.settings.twitch_channel)
