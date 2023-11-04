extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target 
var holding: Interactable
var holdingHeight = 15
var playerId

@onready var all_interactions = []

func _ready():
	playerId = str(name).to_int()
	$MultiplayerSynchronizer.set_multiplayer_authority(1)
	if isActivePlayer():
		update_interactions()
		$Camera2D.make_current()
	
func isActivePlayer():
	return multiplayer.get_unique_id() == playerId

func isServer():
	return multiplayer.get_unique_id() == 1

func _process(delta):
	if isActivePlayer():
	
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var mouse_pos = get_global_mouse_position()
			if isServer():
				sendInput("move", mouse_pos)
			else:
				sendInput.rpc_id(1, "move", mouse_pos)
		
		if Input.is_action_just_pressed("Interact"):
			if isServer():
				sendInput("interact", null)
			else:
				sendInput.rpc_id(1, "interact", null)

@rpc("any_peer", "call_remote")
func sendInput(input,args):
	match input:
		"move":
			target = Vector2(args.x, args.y)
		"interact":
			execute_interaction("interact")


func _physics_process(delta):
	if isServer():
		# Move toward target
		if target:
			var direction = target - global_position
			var diff = target - global_position
			if (diff.length() > SPEED / 30):
				velocity = direction.normalized() * SPEED
			else:
				velocity = Vector2.ZERO
				target = null
			
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
	if isActivePlayer():
		update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	if isActivePlayer():
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


# Server only
func execute_interaction(action: String):
	if all_interactions:
		var curr_interaction: Interactable = all_interactions[0]
		
		if holding:
			match curr_interaction.interact_type:
				"dam":
					curr_interaction.interact.rpc(action, playerId)
					holding.interact.rpc("use", playerId)
					GameManager.add_score.rpc(1, playerId)
					holding = null
				_:
					dropHeldElement()
		else:
			match curr_interaction.interact_type:
				"tree":
					curr_interaction.interact.rpc(action, playerId)
				"tree_log":
					pickUpElement(curr_interaction)
					curr_interaction.interact.rpc(action, playerId)


func pickUpElement(element: Interactable):
	holding = element
	element.z_index = 2


func dropHeldElement():
	holding.interact.rpc("drop", playerId)
	holding.z_index =1
	holding.global_position.y += holdingHeight
	holding = null

