extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Quit():
	get_tree().quit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Quit()

func _on_Button2_pressed():
	Quit()

func _on_PlayButton_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")


func _on_OptionsButton_pressed():
	$OptionMenu.show()
