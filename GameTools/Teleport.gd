extends Area2D

export var to_area = "test"
var entered = false
var is_swapping = false


func _enter_tree():
	self.connect("body_shape_entered", self, "_on_body_shape_entered")
	self.connect("body_shape_exited", self, "_on_body_shape_exited")
	
func _exit_tree():
	self.disconnect("body_shape_entered", self, "_on_body_shape_entered")
	self.disconnect("body_shape_exited", self, "_on_body_shape_exited")

func swap():
	self.is_swapping = true
	get_node("/root/Game").swap_level(self.to_area)
	self.is_swapping = false

func _on_body_shape_entered(body_id, body, body_shape, area_shape):
	if body && body.name == "Player" && not self.is_swapping && not self.entered:
		self.disconnect("body_shape_entered", self, "_on_body_shape_entered")
		self.entered = true
		call_deferred("swap")

func _on_body_shape_exited(body_id, body, body_shape, area_shape):
	if body && body.name == "Player" && not self.is_swapping:
		self.entered = false
	pass
