class_name SoundEffect extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("finished", after_sound)
	play()
	

func after_sound():
	self.queue_free()
	
