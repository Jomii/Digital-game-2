extends Control

var level
var levels = []

func _ready():
	# set level to loaded game
#	levels = 
	var files = list_files_in_directory("res://Levels")
	for file in files:
		print(file)
	
	var levelScene = load("res://Levels/Level_1.tscn")
	
	level = levelScene.instance()
	
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
