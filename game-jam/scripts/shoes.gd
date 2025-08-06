extends RigidBody2D

@export var coeff_throw_shoes_x = 900;
@export var coeff_throw_shoes_y = -500
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
	# le dernier vecteur n'a pas l'air utile dans notre cas, valeur de base Vector2(400*direction, 200)
	apply_impulse(Vector2(coeff_throw_shoes_x * direction + velocity_player.x, coeff_throw_shoes_y - velocity_player.y), Vector2(0,0))
	linear_damp = 1.0
	rotation_degrees = randf_range(0,360)
	
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	grabable = true
