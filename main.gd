extends Control

const TWITCH_CLIENT_ID : String = "0cbzay6zw9wmy56di4qd1tvmjkmh0w"
var id : TwitchIDConnection
var api : TwitchAPIConnection
var irc : TwitchIRCConnection
var eventsub : TwitchEventSubConnection


func _ready() -> void:
	if SettingsManager.settings_loaded():
		if SettingsManager.settings.auto_login and irc == null:
			var auth : ImplicitGrantFlow = ImplicitGrantFlow.new()
			# For the auth to work, we need to poll it regularly.
			get_tree().process_frame.connect(auth.poll) # You can also use a timer if you don't want to poll on every frame.
			var token : UserAccessToken = await(auth.login(TWITCH_CLIENT_ID, ["chat:read", "chat:edit"]))
			if (token == null):
				return
			#
			id = TwitchIDConnection.new(token)
			irc = TwitchIRCConnection.new(id)
			api = TwitchAPIConnection.new(id)
			# For everything to work, the id connection has to be polled regularly.
			get_tree().process_frame.connect(id.poll)

			# Connect to the Twitch chat.
			if(!await(irc.connect_to_irc(SettingsManager.settings.twitch_channel))):
				# Authentication failed. Abort.
				return
			# Request the capabilities. By default only twitch.tv/commands and twitch.tv/tags are used.
			# Refer to https://dev.twitch.tv/docs/irc/capabilities/ for all available capapbilities.
			irc.request_capabilities()
			# Join the channel specified in the exported 'channel' variable.
			irc.join_channel(SettingsManager.settings.twitch_channel)
			
func _on_button_menu_pressed() -> void:
	SceneManager.set_scene("res://Components/SettingsDialog.tscn")

func _on_buttons_panel_twitch_cmd_button_pressed(cmd : String) -> void:
	if irc != null:
		irc.chat(cmd)
