extends Panel

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print("game is paused: ", get_tree().paused)
		get_tree().paused = !get_tree().paused
		
		if get_tree().paused:
			show()
		else:
			hide()
#		hide()

#func _on_Player_pause():
#	get_tree().paused = true
#	show()

func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()

func _on_MainMenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
