extends RigidBody2D

var isBad = false
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _process(_delta):
	if position.y > screen_size.y:
		queue_free()
