extends Node

signal levelLoaded(characterText)
signal dropCollected(collectedList)
signal levelComplete(score)

export (PackedScene) var badDrop
export(int, 1, 100) var badDropChance = 15

var level
var collected

# Called when the node enters the scene tree for the first time.
func _ready():
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
		
	add_child(level)
	
	initialize_collected() # MUST BE AFTER ADDING CHILD!
	
	emit_signal("levelLoaded", level.characterText)

func initialize_collected():
	collected = level.drops.duplicate(true)
	for item in collected:
		item["amount"] = 0
		
		var drop = item["drop"].instance()
		item["drop"] = drop.name
		
	print(collected)
		

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
	
	drop.position = spawnPosition

func _on_Player_collect(drop):
	if drop.isBad:
		# Restart game
		start_game()
	else:
		for i in collected:
			if i.drop == drop.name:
				i["amount"] += 1
	
	emit_signal("dropCollected", collected)
	
	if isLevelComplete():
		print("we won bois")
		var score = calculateScore()
		emit_signal("levelComplete", score)
		
func calculateScore():
	return 0
