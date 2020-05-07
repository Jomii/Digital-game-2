extends Node

signal levelLoaded(characterText)
signal dropCollected(collectedList)
signal levelComplete(score)

export (PackedScene) var badDrop
export(int, 1, 100) var badDropChance = 15
export var difficultGravityScale = 10
export var difficultSpawnRate = 0.3
export (AudioStream) var pickupGood
export (AudioStream) var pickupBad

var level
var collected
var difficultyFactor = 1
var gravityScale = 1
var spawnRate = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if pickupGood:
		pickupGood.loop = false
		
	if pickupBad:
		pickupBad.loop = false
		
	start_game()
	
func start_game():
	randomize()
	$Player.start($StartPosition.position)
	
	# Remove all drops
	for i in $Drops.get_children():
		i.queue_free()
		
	load_level()
	
func load_level():
	level = global.level
	if level == null:
		print("LevelScene entered without selecting level, defaulting to Level_1")
		var lvlObject = load("res://Levels/Level_1.tscn")
		level = lvlObject.instance()
		
	if !level.get_parent():
		add_child(level)
	
	initialize_collected() # MUST BE AFTER ADDING CHILD!
	set_difficulty()
	
	emit_signal("levelLoaded", level.characterText)
	
# Save score to save-file when completing level
func save_game(levelScore):
	var saveFilePath = "user://savefile.save"
	var saveFile = File.new()
	var err = saveFile.open(saveFilePath, File.READ_WRITE)
	
	if err == ERR_FILE_NOT_FOUND:
		saveFile.open(saveFilePath, File.WRITE_READ)
	elif err != OK:
		print("error opening file, error code: ", err)
		
	var fileText = saveFile.get_as_text()
	var saveData
	var result
	
	if fileText:
		result = JSON.parse(fileText)
		# Could not parse file, most likely non valid JSON eg. empty String
		if result.error == OK:
			saveData = result.result
	
	# Empty savefile, init saveData to empty dict
	if !saveData:
		saveData = {}
		
	var levelKey = saveData.get(level.name)
	
	if !levelKey:
		saveData[level.name] = { "score": levelScore }
		print("saved ", level.name, " with score ", levelScore)
	else:
		if saveData[level.name]["score"] < levelScore:
			saveData[level.name] =  { "score": levelScore }
		
	saveFile.store_line(to_json(saveData))
	saveFile.close()

func initialize_collected():
	collected = level.drops.duplicate(true)
	for item in collected:
		item["amount"] = 0
		
		var drop = item["drop"].instance()
		item["drop"] = drop.name
		
	
# Set difficulty based on level
func set_difficulty():
	var factor = float(level.name.split("_")[1])
	factor = factor / global.levelCount
	gravityScale = difficultGravityScale * factor
	
	spawnRate = 1 - (1 - difficultSpawnRate) * factor
	$SpawnTimer.wait_time = spawnRate
	
	badDropChance += 10 * factor

# Check if collected amount >= goal amount for all drops
func isLevelComplete():
	for item in collected:
		for item2 in level.drops:
			var item2Name = item2.drop.instance().name
			if item.drop == item2Name:
				if item.amount < item2.amount:
					return false
					
	return true

func _on_SpawnTimer_timeout():
	var x1 = int(round($DropSpawn.get_point_position(0).x)) # First point
	var x2 = int(round($DropSpawn.get_point_position($DropSpawn.get_point_count() - 1).x)) # Last point
	
	var randomXFromSpawn = randi() % (x2 - x1 + 1) + x1
	
	var spawnPosition = Vector2(randomXFromSpawn, $DropSpawn.transform.get_origin().y)
	
	var randomDropIndex = randi() % level.drops.size()
	
	var dropObject = level.drops[randomDropIndex]["drop"]
	var drop = dropObject.instance()
	
	if randi() % 101 < badDropChance:
		drop = badDrop.instance()
	
	$Drops.add_child(drop)
	
	drop.gravity_scale = gravityScale
	
	drop.position = spawnPosition

func _on_Player_collect(drop):
	if drop.isBad:
		$CollectSound.stream = pickupBad
		emit_signal("levelComplete", 0)
	else:
		$CollectSound.stream = pickupGood
		for i in collected:
			if i.drop == drop.name:
				i["amount"] += 1
	
	$CollectSound.play()
	emit_signal("dropCollected", collected)
	
	if isLevelComplete():
		var score = calculateScore()
		
		if score >= global.level.maxScore / 3:
			save_game(score)
			
		emit_signal("levelComplete", score)
		
func calculateScore():
	var total = 0
	for i in level.drops:
		var dropObject = i.drop.instance()
		for drop in collected:
			if drop.drop == dropObject.name:
				# Remove points based on how many drops were collected over 
				# the goal amount
				var negativeScore = -dropObject.score * (drop.amount - i.amount)
				total += dropObject.score * i.amount
				total += negativeScore
				

	return total


func _on_LevelEnd_restartLevel():
	start_game()
