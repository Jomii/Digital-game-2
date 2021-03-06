extends Control

const levels_dir = "res://Levels"
var level
var levels = []
var selectedLevelIndex = 0
var saveData

class LevelSorter:
	static func sort_ascending(a, b):
		if int(a.name.split("_")[1]) < int(b.name.split("_")[1]):
			return true
		return false

func _ready():
	# TODO: pre set level to loaded game
	# Load savefile to set selectedLevelIndex
	load_save_file()
	set_selectedLevelIndex()
	
	# Instance all levels from Levels folder
	var files = list_files_in_directory(levels_dir)
	for file in files:
		if file != "LevelTemplate.tscn":
			var lvl = load(levels_dir + "/" + file)
			var instancedLvl = lvl.instance()
			levels.append(instancedLvl)
	
		
	levels.sort_custom(LevelSorter, "sort_ascending")
	
	global.levelCount = levels.size()
	update()
	
func load_save_file():
	var saveFilePath = "user://savefile.save"
	var saveFile = File.new()
	var err = saveFile.open(saveFilePath, File.READ)
	
	if err == OK:
		var fileText = saveFile.get_as_text()
		var json_result = JSON.parse(fileText)
		
		if json_result.error == OK:
			saveData = json_result.result
	
func update():
	global.level = levels[selectedLevelIndex]
	level = global.level
	
	# Lock playbutton if previous level has not been completed
	if !saveData && selectedLevelIndex == 0:
		$PlayButton.disabled = false
	elif saveData && selectedLevelIndex <= saveData.keys().size():
		$PlayButton.disabled = false
	else:
		$PlayButton.disabled = true
	
	$LevelTitle.text = level.name.replace('_', ' ')
	$Description.text = level.levelStartText
	$Image.texture = level.levelStartIcon
	setScore()
	
func setScore():
	# Add level node to scene to run its _start() method to calc maxScore
	add_child(level)
	var maxScore = level.maxScore
	remove_child(level)
	
	var savedLevel
	if saveData:
		savedLevel = saveData.get(level.name)
		
	var score = 0
	if savedLevel:
		score = savedLevel["score"]
	
	var visibleStars = 0
	
	if score == maxScore:
		visibleStars = 3
#		$Score.text = "***"
	elif score >= maxScore / 2:
		visibleStars = 2
#		$Score.text = "**"
	elif score >= maxScore / 3:
		visibleStars = 1
#		$Score.text = "*"
	
	var starNodes = $StarContainer.get_children()
	for i in range(starNodes.size()):
		if i < visibleStars:
			starNodes[i].visible = true
		else:
			starNodes[i].visible = false

func set_selectedLevelIndex():
	if !saveData:
		selectedLevelIndex = 0
		return
		
	var keys = saveData.keys()
	# Set level index to last completed level
	selectedLevelIndex = keys.size() - 1
	
	# Stay at last level after completing it 
	#if selectedLevelIndex >= levels.size():
	#	selectedLevelIndex = levels.size() - 1
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files

func changeLevelIndex(value):
	selectedLevelIndex += value
	if selectedLevelIndex < 0:
		selectedLevelIndex = 0
	elif selectedLevelIndex >= levels.size():
		selectedLevelIndex = levels.size() - 1

func playButtonSound():
	$ButtonSound.stream.loop = false
	$ButtonSound.play()
	
func _on_RightButton_pressed():
	playButtonSound()
	changeLevelIndex(1)
	update()


func _on_LeftButton_pressed():
	playButtonSound()
	changeLevelIndex(-1)
	update()


func _on_ReturnButton_pressed():
	playButtonSound()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_PlayButton_pressed():
	playButtonSound()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/LevelScene.tscn")


func _on_RightButton2_pressed():
	playButtonSound()
	changeLevelIndex(1)
	update()


func _on_LeftButton2_pressed():
	playButtonSound()
	changeLevelIndex(-1)
	update()
