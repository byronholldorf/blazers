extends KinematicBody2D

var velocity = Vector2.ZERO
var lastfacing = Vector2.RIGHT
var blazerballScene

var screenCenter = Vector2(
	ProjectSettings.get_setting("display/window/size/width")/2,
	ProjectSettings.get_setting("display/window/size/height")/2)

var dragActive = false
var dragPosition = screenCenter

export var ACCELERATION = 5
export var MAX_SPEED = 120
export var FRICTION = 15

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var blazerball_select = get_node("/root/World/GUI/Blazerball")

func _ready():
	animationTree.active = true
	animationState.start("Idle")
	blazerballScene = load("res://Player/blazerball.tscn")

func get_move_direction():
	var result = Vector2.ZERO
	if(dragActive):
		var dir = (position + get_canvas_transform().origin - dragPosition)
		result = -dir.normalized()
	else:
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
		lastfacing = move_direction
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	
	animationTree.advance(delta)

	if Input.is_action_just_pressed("throw"):
		var newball = self.blazerballScene.instance()
		newball.position = self.position
		newball.direction = lastfacing
		newball.get_node("Sprite").frame = blazerball_select.frame
		self.get_parent().add_child(newball)

	velocity = move_and_slide(velocity)
	

func _unhandled_input(event):
	if(event is InputEventScreenTouch):
		dragActive = event.pressed

	if(event is InputEventScreenTouch or event is InputEventScreenDrag):
		dragPosition = event.position

func _on_player_relocate(x, y):
	print(x+","+y)
	pass # Replace with function body.
