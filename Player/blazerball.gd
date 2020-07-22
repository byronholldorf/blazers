extends KinematicBody2D

var direction = Vector2.LEFT
var velocity
var height
var down_vel = 0

export var GRAVITY = -500
export var START_HEIGHT = 20
export var START_H_VELOCITY = -40
export var BOUNCE_RATIO = .5
export var STOP_VELOCITY = 8
export var THROW_SPEED = 200
export var BOUNCE_FRICTION_RATIO = .5

onready var animationTree = get_node("AnimationTree")
var animationState

onready var sprite = get_node("Sprite")

func _ready():
	height = START_HEIGHT
	velocity = direction * THROW_SPEED
	down_vel = START_H_VELOCITY
	animationState = animationTree.get("parameters/playback")
	animationState.start("Idle")

func _physics_process(delta):
	down_vel = down_vel - (delta * GRAVITY)

	height = height - down_vel * delta
	if height < 0:
		height = -height
		velocity = velocity * BOUNCE_FRICTION_RATIO
		down_vel = -down_vel * BOUNCE_RATIO
		
			
	sprite.set("offset", Vector2(0, START_HEIGHT - height))
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO 
		if collision.collider.get("collision_layer") & 0x04:
			animationState.travel("capture")
			#self.get_parent().remove_child(self)
			var blazer = collision.collider
			blazer.get_parent().remove_child(self)
			#self.queue_free()
			blazer.queue_free()
		
		if collision.collider.get("collision_layer") & 0x10:
			self.get_parent().remove_child(self)
			self.queue_free()
	if height < 1 and abs(down_vel) < STOP_VELOCITY:
		self.set_collision_mask_bit(4, true)
	animationTree.advance(delta)
