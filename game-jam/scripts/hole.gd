extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(2.0).timeout
	get_node("destroyable_platform").queue_free()
