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


onready var sprite = get_node("Sprite")

func _ready():
	height = START_HEIGHT
	velocity = direction * THROW_SPEED
	down_vel = START_H_VELOCITY

func _physics_process(delta):
	down_vel = down_vel - (delta * GRAVITY)

	height = height - down_vel * delta
	if height < 0:
		height = -height
		velocity = velocity * BOUNCE_FRICTION_RATIO
		down_vel = -down_vel * BOUNCE_RATIO
		if abs(down_vel) < STOP_VELOCITY:
			self.get_parent().remove_child(self)
			self.queue_free()
			
	sprite.set("offset", Vector2(0, START_HEIGHT-height))
	
	velocity = move_and_slide(velocity)