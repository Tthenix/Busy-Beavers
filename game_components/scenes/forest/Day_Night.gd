extends CanvasLayer

func _ready():
	$AnimationPlayer.play("daytonight")
	$AnimationPlayer.speed_scale = 16 / float(GameManager.game_length)
