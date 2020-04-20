extends Node

export (PackedScene) var Drop

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_SpawnTimer_timeout():
	var x1 = int(round($EnemySpawn.get_point_position(0).x)) # First point
	var x2 = int(round($EnemySpawn.get_point_position($EnemySpawn.get_point_count() - 1).x)) # Last point
	
	var randomXFromSpawn = randi() % (x2 - x1 + 1) + x1
	
	var spawnPosition = Vector2(randomXFromSpawn, $EnemySpawn.transform.get_origin().y)
	
	var drop = Drop.instance()
	
	$Drops.add_child(drop)
		
	var badDrop = randi() % 7 # 1/7 is a bad drop
	if badDrop == 1:
		drop.isBad = true
		drop.modulate = Color(1, 0, 0)
	
	drop.position = spawnPosition

func _on_Player_collect(type):
	if type:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
