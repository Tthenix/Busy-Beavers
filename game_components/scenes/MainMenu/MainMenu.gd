extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	self.queue_free()
	var scene = load("res://game_components/scenes/multiplayer/MP_menu.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.queue_free()
