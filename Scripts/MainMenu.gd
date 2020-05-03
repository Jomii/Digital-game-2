extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Quit():
	get_tree().quit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Quit()

func playButtonSound():
	$ButtonSound.stream.loop = false
	$ButtonSound.play()

func _on_Button2_pressed():
	playButtonSound()
	Quit()

func _on_PlayButton_pressed():
	playButtonSound()
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")


func _on_OptionsButton_pressed():
	playButtonSound()
	$OptionMenu.show()

func _on_InstructionsButton_pressed():
	playButtonSound()
	$InstructionsMenu.show()
