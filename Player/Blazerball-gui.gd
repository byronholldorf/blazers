extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _process(delta):
	if Input.is_action_just_pressed("next_blazer_ball"):
		frame = (frame + 1) % 4
	if Input.is_action_just_pressed("1"):
		frame = 0
	if Input.is_action_just_pressed("2"):
		frame = 1
	if Input.is_action_just_pressed("3"):
		frame = 2
	if Input.is_action_just_pressed("4"):
		frame = 3

