extends StaticBody2D

var has_cracking_been_played = false
var has_destroy_been_played = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	$breaking_platform.visible = true
	if(!has_cracking_been_played):
		$cracking.play();
		has_cracking_been_played = true;
	await get_tree().create_timer(0.25).timeout
	if(!has_destroy_been_played):
		$destroy.play();
		has_destroy_been_played = true
	$breaking_platform.visible = false;
	if(has_node("destroyable_platform")):
		$hole.visible = true
		get_node("destroyable_platform").queue_free()
