class_name TreeLog extends Interactable

@onready var thud_sound = preload("res://game_components/sound_effects/thud.tscn")

var heldBy
# Called when the node enters the scene tree for the first time.

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer", "call_local")
func interact(action, playerId):
	var sound= thud_sound.instantiate()
	sound.global_position = global_position
	get_parent().add_child(sound)
	
	if action == "use":
		self.queue_free()
		return
	if (playerId == heldBy):
		heldBy = null
	else:
		heldBy = playerId
		
