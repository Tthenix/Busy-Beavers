extends Control

@export var stage = 0
@export var skip = false

var timer = Timer.new()
const times = [10,7,7,4]

# Called when the node enters the scene tree for the first time.
func _ready():
	if skip:
		start_game()
	else:
		timer.connect("timeout",time_step)
		timer.wait_time = times[stage]
		timer.one_shot = true
		add_child(timer)
		timer.start()


func time_step():
	$HBoxContainer.get_child(stage).visible = false
	stage += 1
	var nextStage = $HBoxContainer.get_child(stage)
	if nextStage:
		timer.wait_time = times[stage]
		timer.start()
		nextStage.visible = true
	else:
		start_game()$HBoxContainer/VBoxContainer/Join.disabled = true

func start_game():
	var scene = load("res://game_components/scenes/forest/Forest.tscn").instantiate()
	get_tree().root.add_child(scene) 
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
