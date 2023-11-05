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
	
	# Audio
	var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
	if velocity:
		if !audio.playing:
			audio.play()
	else:
		if audio.playing:
			audio.stop()
			
		

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
		
		var sprite = $AnimatedSprite2D
		if velocity.x == 0:
			if holding:
				if holding.interact_type == "tree_log":
					sprite.play("idle_log")
			else:
				sprite.play("idle")
		else:
			if holding:
				if holding.interact_type == "tree_log":
					sprite.play("carry_log")
			else:
				sprite.play("walking")
			if velocity.x > 0:
				sprite.flip_h = false
			elif velocity.x < 0:
				sprite.flip_h = true
			
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
	if all_interactions:
		var interaction: Interactable = all_interactions[0]
		print(interaction.interact_type)
		match interaction.interact_type:
			"dam":
				if holding:
					handleTooltip("build")
			"tree_log":
				if holding:
					handleTooltip("drop")
				else:
					handleTooltip("pick_up")
			"tree":
				if !holding:
					handleTooltip("gnaw")
			_:
				handleTooltip("no_action")
	else:
		print("No interaction")
		handleTooltip("no_action")


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
					if !curr_interaction.heldBy:
						pickUpElement(curr_interaction)
						curr_interaction.interact.rpc(action, playerId)
	update_interactions()


func pickUpElement(element: Interactable):
	holding = element
	element.z_index = 2


func dropHeldElement():
	holding.interact.rpc("drop", playerId)
	holding.z_index =1
	holding.global_position.y += holdingHeight
	holding = null

func handleTooltip(action):
	var icon = $InteractionComponents/ActionIcons
	if action == "no_action":
		icon.visible = false
	else:
		icon.visible = true
	icon.play(action)
	print(action)
		
