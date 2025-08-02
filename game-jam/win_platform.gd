extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_touched_rock_room):
		body.win();
