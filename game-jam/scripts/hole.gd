extends StaticBody2D


func _on_area_2d_body_entered(_body: Node2D) -> void:
	$breaking_platform.visible = true
	await get_tree().create_timer(0.25).timeout
	$breaking_platform.visible = false;
	if(has_node("destroyable_platform")):
		$hole.visible = true
		get_node("destroyable_platform").queue_free()
