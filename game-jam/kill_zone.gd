extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("tu me touches mon gars")
	body.die();
