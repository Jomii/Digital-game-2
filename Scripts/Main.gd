extends Node

signal levelLoaded(characterText)

export (PackedScene) var badDrop

var level
export(int, 1, 100) var badDropChance = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	start_game()
	
func start_game():
	$Player.start($StartPosition.position)
	load_level()
	
func load_level():
	var levelScene = load("res://Levels/Level_1.tscn")
	level = levelScene.instance()
	add_child(level)
	print("loaded level ", level.name)
	print("level drops ", level.drops)
#	print("level DICt drops ", level.dictDrops)
	emit_signal("levelLoaded", level.characterText)

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
	
	
#	var drop = Drop.instance()
	
	$Drops.add_child(drop)
	
	drop.position = spawnPosition

func _on_Player_collect(type):
	# type = isDropBad
	if type:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
