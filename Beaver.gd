extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target = Vector2.ZERO

@onready var all_interactions = []

func _ready():
	update_interactions()

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		target = Vector2(mouse_pos.x, mouse_pos.y)
	
	if Input.is_action_just_pressed("Destroy"):
		execute_interaction("damage")
	if Input.is_action_just_pressed("Interact"):
		execute_interaction("interact")


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
		sprite.offset.x = -100
	elif velocity.x < 0:
		sprite.flip_h = true
		sprite.offset.x = 100
		

	move_and_slide()


# Interaction Methods

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	print(area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

	

func update_interactions():
	var interaction_label = $InteractionComponents/InteractionLabel
	if all_interactions:
		var interaction = all_interactions[0]
		interaction_label.text = interaction.interact_label
	else:
		interaction_label.text = ""


func execute_interaction(action: String):
	if all_interactions:
		var curr_interaction: Interactable = all_interactions[0]
		match curr_interaction.interact_type:
			"tree":
				curr_interaction.interact(action)
