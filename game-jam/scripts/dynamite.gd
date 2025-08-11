extends RigidBody2D

@export var duration_explosion = 0.5;

var has_been_played = false;
var original_radius = 0.0;

func _ready() -> void:
	gravity_scale = 0.0
	var shape = $KillZone/CollisionShape2D.shape
	original_radius = shape.radius
	
func activate():
	if(!has_been_played):
		gravity_scale = 1
		has_been_played = true

func expand_temporarily():
	var shape = $KillZone/CollisionShape2D.shape
	shape.radius = original_radius * 3.5
	await get_tree().create_timer(duration_explosion).timeout
	shape.radius = original_radius
	self.queue_free()
	get_node("../dynamite_detector").queue_free()
	get_node("../pressure_platform").queue_free()
