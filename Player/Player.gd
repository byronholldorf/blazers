extends KinematicBody2D

var velocity = Vector2.ZERO

export var ACCELERATION = 5
export var MAX_SPEED = 120
export var FRICTION = 15

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	animationState.start("Idle")
	

func get_move_direction():
	var result = Vector2.ZERO
	result.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	result.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	result = result.normalized()
	return result


func _physics_process(delta):
	
	var move_direction = get_move_direction()
	
	if move_direction != Vector2.ZERO:
		velocity = velocity.linear_interpolate(move_direction * MAX_SPEED, ACCELERATION * delta)
		#animationTree.set("parameters/Idle/blend_position", move_direction)
		animationTree.set("parameters/Run/blend_position", move_direction)
		animationState.travel("Run")
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
		
	animationTree.advance(delta)

	velocity = move_and_slide(velocity)

func _on_player_relocate(x, y):
	print(x+","+y)
	pass # Replace with function body.
