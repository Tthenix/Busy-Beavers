extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	text = ["Pepe", "Franco", "Vale", "Joaquín", "Nahuel", "José", "Roberto", "Alicia", "Eyon", "Justin", "Hogwards", "Beaver"].pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
