extends Area2D

@export var trap: Node2D = null;
var activable = false;

func _on_body_entered(body: Node2D) -> void:
	if(activable):
		trap.activate();


func _on_area_2d_body_entered(body: Node2D) -> void:
	activable = true;
