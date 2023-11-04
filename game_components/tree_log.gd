class_name TreeLog extends Interactable

var heldBy
# Called when the node enters the scene tree for the first time.

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer", "call_local")
func interact(action, playerId):
	heldBy = playerId
	if (playerId == heldBy):
		heldBy = null
