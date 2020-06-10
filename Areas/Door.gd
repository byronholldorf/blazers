extends Area2D


func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		get_tree().change_scene("res://Areas/Building1.tscn")
