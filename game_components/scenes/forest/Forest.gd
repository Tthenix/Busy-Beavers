extends Node2D

@export var PlayerScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		var spawn_locations = get_tree().get_nodes_in_group("PlayerSpawnPoint")
		for spawn in spawn_locations:
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
	GameManager.start_game()
	
	var timer = $Timer
	timer.connect("timeout",fade_to_black)
	timer.wait_time = GameManager.game_length
	timer.one_shot = true
	timer.start()
	
func fade_to_black():
	$FadeToBlack.start_fade()

func go_to_ending():
	var scene = load("res://game_components/scenes/endings/bad_ending.tscn").instantiate()
	get_tree().root.add_child(scene) 
	self.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
