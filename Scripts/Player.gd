extends Area2D

signal collect(drop)

export var speed = 400

var screen_size
var right_action_pressed = false
var left_action_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	position = pos

func _process(delta):
	var velocity = Vector2()
	var animation = "Idle"
	
	if Input.is_action_pressed("ui_right") || right_action_pressed:
		velocity.x += 1
		animation = "Wiggle"
	if Input.is_action_pressed("ui_left") || left_action_pressed:
		velocity.x -= 1
		animation = "Wiggle"
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	$Sprite.animation = animation
	position += velocity * delta
	var offset = 26
	# Restrict the position to be inside the screen
	position.x = clamp(position.x, 0 + offset, screen_size.x - offset)


func _on_RightButton_button_down():
	right_action_pressed = true


func _on_RightButton_button_up():
	right_action_pressed = false


func _on_LeftButton_button_down():
	left_action_pressed = true


func _on_LeftButton_button_up():
	left_action_pressed = false


func _on_Player_body_entered(body):
	var dropName = body.name
	# Remove possible duplicate markers from name eg. Herb1(2) -> Herb1
	dropName = dropName.trim_prefix("@")
	dropName = dropName.split("@", true, 1)
	
	var drop = {"name": dropName[0], "isBad": body.isBad}
	emit_signal("collect", drop)
	body.queue_free()


func _on_Main_levelLoaded(_characterText):
	right_action_pressed = false
	left_action_pressed = false
