extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout;
	queue_free();
