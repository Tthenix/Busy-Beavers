extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target = Vector2.ZERO

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_viewport().get_mouse_position()
		target = Vector2(mouse_pos.x, mouse_pos.y)


func _physics_process(delta):
	
	# Move toward target
	var direction = target - global_position
	var diff = target - global_position
	if (diff.length() > SPEED / 30):
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
		
	# Face moving direction
	var sprite = $Beaver
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		

	move_and_slide()
