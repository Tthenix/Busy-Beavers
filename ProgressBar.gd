extends ProgressBar

func _ready():
	hide()

func set_valuebar(value):
		$TextureProgressBar.value = value
		if value < 100:
			show()
		else:
			hide()
