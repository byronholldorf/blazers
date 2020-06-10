extends Area2D




func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Areas/World1.tscn")
		emit_signal("player_relocate", 975,416)
		#$Player.gposition = Vector2(975,416)
