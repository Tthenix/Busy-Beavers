extends Node2D

var state = 'day'

var change_state = false

var lenght_of_day = 120
var lenght_of_night = 30

func _ready():
	if state == "day":
		$ColorRect.color.a = 0
	elif state == "night":
		$ColorRect.color.a = 150

func _on_timer_timeout():
	if state == 'day':
		state = 'night'
	elif state == 'night':
		state = 'day'
		
	change_state = true
	
func _process(delta):
	if change_state == true:
		change_state = false
		if state == "day":
			chage_to_day()
		elif state == "night":
			chage_to_night()
			
			
func chage_to_day():
	$AnimationPlayer.play("nighttoday")
	$Timer.wait_time = lenght_of_day
	$Timer.start()

func chage_to_night():
	$AnimationPlayer.play("daytonight")
	$Timer.wait_time = lenght_of_night
	$Timer.start()
