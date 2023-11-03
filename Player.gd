extends Node2D

var teethCursor = load("res://assets/teeth.png")
var defaultCursor = load("res://assets/cursor.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(defaultCursor)
	# Connect to interactables
	## Trees
	var trees = $"../Interactables/Trees"
	print(trees)
	for tree in trees.get_children():
		pass
		#tree.connect("mouse_entered", hover_tree_on)
		#tree.connect("mouse_exited", hover_tree_off)


func hover_tree_on():
	Input.set_custom_mouse_cursor(teethCursor)
	

func hover_tree_off():
	Input.set_custom_mouse_cursor(defaultCursor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tree_mouse_entered():
	hover_tree_on() # Replace with function body.


func _on_tree_mouse_exited():
	hover_tree_off()
