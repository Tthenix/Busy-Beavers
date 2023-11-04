extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var names = []
	for i in GameManager.Players:
		names.push_back(GameManager.Players[i].name)
	if names:
		text =  names[0] +"y "+names[1]+" fueron expulsados de su familia.
Ahora deben construir una represa nueva para sobrevivir a los depredadores"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
