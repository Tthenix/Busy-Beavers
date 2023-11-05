extends CanvasLayer

signal fadeComplete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func start_fade():
	$ColorRect.visible = true
	$AnimationPlayer.play("fade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade":
		emit_signal("fadeComplete")
	
