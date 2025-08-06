extends Node2D


func _on_victory_detector_body_entered(body: Node2D) -> void:
	if(body.has_touched_rock_room):
		body.win();
