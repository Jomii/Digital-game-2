extends Area2D

signal collect(type)

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
	
	if Input.is_action_pressed("ui_right") || right_action_pressed:
		velocity.x += 1
	if Input.is_action_pressed("ui_left") || left_action_pressed:
		velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	# Restrict the position to be inside the screen
	position.x = clamp(position.x, 0, screen_size.x)


func _on_RightButton_button_down():
	right_action_pressed = true


func _on_RightButton_button_up():
	right_action_pressed = false


func _on_LeftButton_button_down():
	left_action_pressed = true


func _on_LeftButton_button_up():
	left_action_pressed = false


func _on_Player_body_entered(body):
	emit_signal("collect", body.isBad)
	body.queue_free()
