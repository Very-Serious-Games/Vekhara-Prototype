extends Control

@onready var settingsPopup = $SettingsMenu

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_settings_pressed():
	settingsPopup.show()
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
