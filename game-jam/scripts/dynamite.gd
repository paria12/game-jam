extends RigidBody2D

@export var duration_explosion = 0.5;
@export var gravity = 2.0;
@export var radius_explosion = 3.5;

var has_been_played = false;
var original_radius = 0.0;

func _ready() -> void:
	gravity_scale = 0.0
	var shape = $KillZone/CollisionShape2D.shape
	# à utiliser pour éviter d'appliquer la shape aux killzones de toutes les dynamites
	var new_shape = shape.duplicate()
	$KillZone/CollisionShape2D.shape = new_shape
	original_radius = new_shape.radius
	
func activate():
	if(!has_been_played):
		gravity_scale = gravity
		has_been_played = true

func expand_temporarily():
	var shape = $KillZone/CollisionShape2D.shape
	shape.radius = original_radius * radius_explosion
	await get_tree().create_timer(duration_explosion).timeout
	shape.radius = original_radius
	self.queue_free()
	get_node("../dynamite_detector").queue_free()
	get_node("../pressure_platform").queue_free()
