class_name GameTree extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(action: String):
	print(action)
	self.queue_free()
