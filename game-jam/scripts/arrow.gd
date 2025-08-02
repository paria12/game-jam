extends RigidBody2D

var has_been_played = false;

func _ready() -> void:
	gravity_scale = 0.0
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(!has_been_played):
		get_node("AudioStreamPlayer2D").play()
		has_been_played = true
	activate(body);
	
func activate(_body):
	if(self):
		linear_velocity.x = -1500

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
