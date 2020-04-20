extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	# Restrict the position to be inside the screen
	position.x = clamp(position.x, 0, screen_size.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
