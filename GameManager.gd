extends Node

var Players = {}
var logs_needed = 100
var game_length = 130

signal score_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_game():
	score_updated.emit()

@rpc("any_peer", "call_local")
func newGame():
	var scene = load("res://game_components/scenes/forest/Forest.tscn").instantiate()
	get_tree().root.add_child(scene) 
	for p in Players:
		Players[p].score = 0

@rpc("any_peer", "call_local")
func add_score(value: int, player: int):
	for p in Players:
		if Players[p].id == player:
			Players[p].score += value
	score_updated.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
