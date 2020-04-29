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
	var visibleStars = 0
	print("max score: ", maxScore, " you got: ", score)

	if score == maxScore:
		$Panel/Description.text = global.level.levelThreeStarText
		visibleStars = 3
	elif score >= maxScore / 2:
		$Panel/Description.text = global.level.levelTwoStarText
		visibleStars = 2
	elif score >= maxScore / 3:
		$Panel/Description.text = global.level.levelOneStarText
		visibleStars = 1
	else:
		$Panel/Description.text = global.level.levelFailText
		$Panel/Label.text = "Level failed"
		
	var starNodes = $Panel/StarContainer.get_children()
	for i in range(starNodes.size()):
		if i < visibleStars:
			starNodes[i].visible = true
		else:
			starNodes[i].visible = false

func _on_RetryButton_pressed():
	UnPause()
	emit_signal("restartLevel")


func _on_NextButton_pressed():
	# warning-ignore:return_value_discarded
	UnPause()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")


func _on_RightButton_pressed():
	# warning-ignore:return_value_discarded
	UnPause()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")
