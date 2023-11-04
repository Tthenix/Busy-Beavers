extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target: Vector2 
var holding: Interactable
var holdingHeight = 15

@onready var all_interactions = []

func _ready():
	update_interactions()

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		target = Vector2(mouse_pos.x, mouse_pos.y)
	
	if Input.is_action_just_pressed("Interact"):
		execute_interaction("interact")


func _physics_process(delta):
	
	# Move toward target
	if target:
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
		
	if holding:
		holding.global_position = Vector2(self.global_position.x, self.global_position.y - holdingHeight)

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
	var label_text = ""
	if all_interactions:
		var interaction: Interactable = all_interactions[0]
		if interaction.interact_type == "dam":
			if holding:
				label_text = interaction.interact_label
		else:
			label_text = interaction.interact_label
	interaction_label.text = label_text


func execute_interaction(action: String):
	
	if all_interactions:
		var curr_interaction: Interactable = all_interactions[0]
		
		if holding:
			match curr_interaction.interact_type:
				"dam":
					curr_interaction.interact(action)
					holding.queue_free()
					holding = null
				_:
					dropHeldElement()
		else:
			match curr_interaction.interact_type:
				"tree":
					curr_interaction.interact(action)
				"tree_log":
					pickUpElement(curr_interaction)
					curr_interaction.interact(action)


func pickUpElement(element: Interactable):
	holding = element
	element.z_index = 2
	
func dropHeldElement():
	holding.z_index =1
	holding.global_position.y += holdingHeight
	holding = null
