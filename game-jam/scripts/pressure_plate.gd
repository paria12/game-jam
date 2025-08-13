extends Area2D

@export var trap: Node2D = null;

var has_been_played = false;

func _on_body_exited(_body: Node2D) -> void:
	if(!has_been_played):
		if(trap is StaticBody2D):
				trap.activate()
				has_been_played = true
	$MeshInstance2D.scale.y = 11.5
	$MeshInstance2D.position.y -= 2.5
	$unpress.play()


func _on_body_entered(_body: Node2D) -> void:
	if(!has_been_played):
		if(trap is RigidBody2D):
			trap.activate()
			has_been_played = true
	$MeshInstance2D.scale.y = 6.5
	$MeshInstance2D.position.y += 2.5
	$press.play()
