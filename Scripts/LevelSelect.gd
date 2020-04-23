extends Control

const levels_dir = "res://Levels"
var level
var levels = []
var selectedLevelIndex = 0

func _ready():
	# TODO: pre set level to loaded game
	var files = list_files_in_directory(levels_dir)
	for file in files:
		if file != "LevelTemplate.tscn":
			var lvl = load(levels_dir + "/" + file)
			var instancedLvl = lvl.instance()
			levels.append(instancedLvl)
	
	update()
	
func update():
	global.level = levels[selectedLevelIndex]
	level = global.level
	
	$LevelTitle.text = level.name.replace('_', ' ')
	$Description.text = level.levelStartText
	$Image.texture = level.levelStartIcon
	
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

func _on_RightButton_pressed():
	changeLevelIndex(1)
	update()


func _on_LeftButton_pressed():
	changeLevelIndex(-1)
	update()


func _on_ReturnButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/LevelScene.tscn")
