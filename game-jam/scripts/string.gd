extends Area2D

@export var trap: Node2D = null;
var activable = false;

func _on_body_entered(_body: Node2D) -> void:
	if(trap is not RigidBody2D):
		if(activable):
			trap.activate();
	else:
		trap.activate();
		print("je passe ici")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	activable = true;
