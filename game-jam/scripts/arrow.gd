extends RigidBody2D

var has_been_played = false;
@export var x_linear_velocity = -1500;

func _ready() -> void:
	gravity_scale = 0.0
	$CollisionShape2D.set_deferred("disabled", true)
	$KillZone.inactive();
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	activate();
	
func activate():
	if(!has_been_played):
		$CollisionShape2D.set_deferred("disabled", false)
		$KillZone.activate();
		get_node("AudioStreamPlayer2D").play()
		linear_velocity.x = x_linear_velocity
		has_been_played = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
