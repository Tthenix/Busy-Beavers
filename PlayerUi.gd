extends Control 

@export var max_woods = 10

@export var current_woods = max_woods

func take_woods(woods):
	current_woods -= woods
	var progress_bar = (current_woods/max_woods) * 100
	$UiPlayer.set_valuebar(progress_bar)
	
	if current_woods <= 0:
		queue_free()
