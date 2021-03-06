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
	$Panel/Label.text = "Level complete"

	if score == maxScore:
		$Panel/Description.text = global.level.levelThreeStarText
		$Panel/Hahmo.texture = global.level.levelThreeStarIcon
		visibleStars = 3
	elif score >= maxScore / 2:
		$Panel/Description.text = global.level.levelTwoStarText
		$Panel/Hahmo.texture = global.level.levelTwoStarIcon
		visibleStars = 2
	elif score >= maxScore / 3:
		$Panel/Description.text = global.level.levelOneStarText
		$Panel/Hahmo.texture = global.level.levelOneStarIcon
		visibleStars = 1
	else:
		$Panel/Description.text = global.level.levelFailText
		$Panel/Hahmo.texture = global.level.levelFailIcon
		$Panel/Label.text = "Level failed"
		
	var starNodes = $Panel/StarContainer.get_children()
	for i in range(starNodes.size()):
		if i < visibleStars:
			starNodes[i].visible = true
		else:
			starNodes[i].visible = false

func playButtonSound():
	$ButtonSound.stream.loop = false
	$ButtonSound.play()

func _on_RetryButton_pressed():
	UnPause()
	playButtonSound()
	emit_signal("restartLevel")


func _on_NextButton_pressed():
	# warning-ignore:return_value_discarded
	UnPause()
	playButtonSound()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")


func _on_RightButton_pressed():
	# warning-ignore:return_value_discarded
	UnPause()
	playButtonSound()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")
