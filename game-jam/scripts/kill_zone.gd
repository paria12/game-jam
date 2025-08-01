extends Area2D

@export var active = true;

func _on_body_entered(body: Node2D) -> void:
	if(active):
		body.die();
