extends Node2D


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = get_tree().get_root().find_node("Player", true, false)

func get_player():
	return self.player