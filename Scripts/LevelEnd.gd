extends Panel

signal restartLevel()
#func _ready():
#	_on_Main_levelComplete(0)

func Pause():
	get_tree().paused = !get_tree().paused
		
	if get_tree().paused:
		show()
	else:
		hide()
		
func UnPause():
	get_tree().paused = false
	hide()

func _on_Main_levelComplete(score):
	Pause()
	
	var maxScore = global.level.maxScore
	print("max score: ", maxScore, " you got: ", score)

	if score == maxScore:
		$Description.text = global.level.levelThreeStarText
		$Score.text = "***"
	elif score >= maxScore / 2:
		$Description.text = global.level.levelTwoStarText
		$Score.text = "**"
	elif score >= maxScore / 3:
		$Description.text = global.level.levelOneStarText
		$Score.text = "*"
	else:
		$Description.text = global.level.levelFailText
		$Score.text = ""

#	if score <= 0:
#		$Description.text = global.level.levelFailText
#		$Score.text = ""
#	elif score <= maxScore / 3:
#		$Description.text = global.level.levelOneStarText
#		$Score.text = "*"
#	elif score <= maxScore / 2:
#		$Description.text = global.level.levelTwoStarText
#		$Score.text = "**"
#	elif score <= maxScore / 1:
#		$Description.text = global.level.levelThreeStarText
#		$Score.text = "***"


func _on_RetryButton_pressed():
	UnPause()
	emit_signal("restartLevel")


func _on_NextButton_pressed():
	# warning-ignore:return_value_discarded
	UnPause()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")
