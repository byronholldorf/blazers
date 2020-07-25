extends Node2D


var player
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = get_tree().get_root().find_node("Player", true, false)
	self.camera = get_tree().get_root().find_node("Camera2D", true, false)

func get_player():
	return self.player
	
func get_camera():
	return self.camera