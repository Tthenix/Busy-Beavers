extends Control

var log_current = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("score_updated", _on_score_updated)
	$PlayerInfo1/PlayerPanel/LogBar1.max_value = GameManager.logs_needed
	$PlayerInfo2/PlayerPanel/LogBar2.max_value = GameManager.logs_needed

func set_log_bar(player, bar):
	match bar:
		0:
			$PlayerInfo1/PlayerPanel/LogBar1.value = player.score
			$PlayerInfo1/PlayerPanel/Label.text = player.name
				
		1:
			$PlayerInfo2/PlayerPanel/LogBar2.value = player.score
			$PlayerInfo2/PlayerPanel/Label.text = player.name
	
func _on_score_updated():
	#for p in GameManager.Players:
	var bar_index = 0
	for p in GameManager.Players:
		set_log_bar(GameManager.Players[p], bar_index)
		bar_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
