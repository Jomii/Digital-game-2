extends Panel

signal onOptionsPressed

func _process(_delta):
	var isLevelEnd = false
	if get_tree().paused && !visible:
		isLevelEnd = true
		
	if Input.is_action_just_pressed("ui_cancel") && !isLevelEnd:
		Pause()

func Pause():
	get_tree().paused = !get_tree().paused
		
	if get_tree().paused:
		show()
	else:
		hide()

func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()

func _on_MainMenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_PauseButton_button_down():
	Pause()


func _on_OptionsButton_pressed():
	emit_signal("onOptionsPressed")
