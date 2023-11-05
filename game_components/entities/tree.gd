class_name GameTree extends Interactable

@onready var fall_sound = preload("res://game_components/sound_effects/tree_fall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


@rpc("any_peer", "call_local")
func interact(action: String, player_id):
	var sound= fall_sound.instantiate()
	sound.global_position = global_position
	get_parent().add_child(sound)
	var trunk = preload("res://game_components/entities/tree_trunk.tscn").instantiate()
	var tree_log = preload("res://game_components/entities/tree_log.tscn").instantiate()
	get_tree().root.get_node("Forest").add_child(trunk)
	get_tree().root.get_node("Forest").add_child(tree_log)
	trunk.global_position = self.global_position
	tree_log.global_position = Vector2(self.global_position.x + 60, self.global_position.y)
	self.queue_free()
