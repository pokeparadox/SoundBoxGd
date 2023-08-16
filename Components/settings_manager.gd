extends Node

var Settings = preload("res://Components/settings.gd")
var settings : Settings
const FILE_NAME : String = "user://settings.res"

func _ready() -> void:
	settings = Settings.new()
	load_settings()

func settings_loaded() -> bool:
	return settings != null

func load_settings() -> void:
	if ResourceLoader.exists(FILE_NAME):
		var resource = ResourceLoader.load(FILE_NAME)
		if resource is Settings:
			settings = resource


func save_settings() -> void:
	if settings != null:
		ResourceSaver.save(settings, FILE_NAME)
