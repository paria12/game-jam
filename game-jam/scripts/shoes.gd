extends RigidBody2D

var grabable = false;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(grabable):
		body.get_back_shoes(self);

func destroy():
	queue_free();
	
func throw(direction, velocity_player) -> void:
	if(direction > 0):
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
	apply_impulse(Vector2(500* direction + velocity_player.x,20 + velocity_player.y), Vector2(400*direction, 200))
	linear_damp = 1.0
	rotation_degrees = randf_range(0,360)
	
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	grabable = true
