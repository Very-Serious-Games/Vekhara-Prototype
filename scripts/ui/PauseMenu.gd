extends Control

@onready var settingsPopup = $SettingsMenu

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$AnimationPlayer.play("blur")
	
func pauseGame():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()
	pass # Replace with function body.

func _on_settings_pressed():
	settingsPopup.show()
	pass # Replace with function body.

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _process(_delta):
	pauseGame()
