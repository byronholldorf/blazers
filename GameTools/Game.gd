extends Node2D


var player
var camera
var area
var current_location = ""

var levels = {
	"test": preload("res://Areas/Test-Level.tscn").instance(),
	"building2": preload("res://Areas/Building2.tscn").instance(),
	"building1": preload("res://Areas/Building1.tscn").instance()
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = get_tree().get_root().find_node("Player", true, false)
	self.camera = get_tree().get_root().find_node("Camera2D", true, false)
	self.area = get_tree().get_root().find_node("Area", true, false)
	
	var player_parent = self.player.get_parent()
	player_parent.remove_child(self.player)

	self.swap_level("test")

func get_player():
	return self.player
	
func get_camera():
	return self.camera
	

func _swap_nodes(old, new):
	var parent = old.get_parent()
	var pos = old.get_position_in_parent()
	parent.remove_child(old)
	parent.add_child(new)
	parent.move_child(new, pos)

func swap_level(new_scene):
	if current_location == new_scene:
		print("swap to same location!: "+new_scene)
		return
	var player_parent = self.player.get_parent()
	if player_parent:
		var placeholder = Node2D.new()
		placeholder.set_name("PlayerStart")
		placeholder.position = self.player.position
		self._swap_nodes(self.player, placeholder)

	self._swap_nodes(self.area, levels[new_scene])
	self.area = levels[new_scene]

	var p = self.area.find_node("PlayerStart", true, false)
	self.player.position = p.position
	self._swap_nodes(p, self.player)
	current_location = new_scene
