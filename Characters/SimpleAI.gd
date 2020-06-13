extends Node2D

var character
var player

var state
var state_time = 0
var state_velocity = Vector2.ZERO
var state_direction = Vector2.ZERO

export var FLEE_DISTANCE = 100
export var FLEE_SPEED = 80
export var WANDER_SPEED = 10
export var ACCELERATION = 5

export var WANDER_TIME_MIN = 2
export var WANDER_TIME_MAX = 4
export var STILL_TIME_MIN = 3
export var STILL_TIME_MAX = 6


#var animationState
#var animationTree
#onready var animationPlayer = get_node("../AnimationPlayer")
onready var animationTree = get_node("../AnimationTree")
var animationState

func _ready():
	state = funcref(self, "state_wandering")
	character = get_node("../")
	
	if animationTree:
		animationTree.active = true
		animationState = animationTree.get("parameters/playback")
		animationState.start("Idle")


func distance_sq_to_player():
	var pos = player.get_position()
	var loc = character.get_position()
	return loc.distance_squared_to(pos)

func state_sleeping(delta):
	return funcref(self, "state_sleeping")

func state_still(delta):
	if distance_sq_to_player() < FLEE_DISTANCE * FLEE_DISTANCE:
		return funcref(self, "state_flee")
	return funcref(self, "state_still")

func state_flee(delta):
	var pos = player.get_position()
	var loc = character.get_position()
	state_direction = (loc-pos).normalized()
	state_velocity = state_velocity.linear_interpolate(state_direction * FLEE_SPEED, ACCELERATION * delta)
	state_velocity = character.move_and_slide(state_velocity)
	
	if distance_sq_to_player() < FLEE_DISTANCE * FLEE_DISTANCE:
		return funcref(self, "state_flee")
	if animationState:
		animationState.travel("Idle")
	state_direction = Vector2.ZERO
	return funcref(self, "state_wandering")
	
func state_wandering(delta):
	if state_time <= 0:
		if state_direction.length_squared() > 0.01:
			state_direction = Vector2.ZERO
			state_time = rand_range(STILL_TIME_MIN, STILL_TIME_MAX)
			if animationState:
				animationState.travel("Idle")
		else:
			state_direction = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
			state_time = rand_range(WANDER_TIME_MIN, WANDER_TIME_MAX)
			if animationState:
				animationState.travel("Run")
			
	state_time -= delta
	state_velocity = state_velocity.linear_interpolate(state_direction * WANDER_SPEED, ACCELERATION * delta)
	state_velocity = character.move_and_slide(state_velocity)
	if distance_sq_to_player() < FLEE_DISTANCE * FLEE_DISTANCE:
		if animationState:
			animationState.travel("Run")
		return funcref(self, "state_flee")
	return funcref(self, "state_wandering")

func _process(delta):
	if player == null:
		player = get_node("/root/World").get_player()

	state = state.call_func(delta)
	
	if animationTree:
		#animationState.travel("Run")
		#animationTree.set("parameters/Run/blend_position", Vector2(1,0))
		animationTree.set("parameters/Run/blend_position", state_velocity)
		animationTree.advance(delta)	