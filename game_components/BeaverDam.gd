class_name BeaverDam extends Interactable

var logs_needed = GameManager.logs_needed
var logs_gathered = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = 0
	interact_label = "Agregar Tronco"
	interact_type = "dam"
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interact(action: String, player_id):
	logs_gathered += 1
	var sprite = $Sprite2D
	var frame = int(logs_needed / (float(sprite.vframes)) *logs_gathered)
	sprite.frame = frame
