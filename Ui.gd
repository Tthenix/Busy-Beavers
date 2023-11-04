extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("score_updated", _on_score_updated)
	pass # Replace with function body.

func _on_score_updated():
	for p in GameManager.Players:
		print(GameManager.Players[p].score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
