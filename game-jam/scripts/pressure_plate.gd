extends Area2D

@export var trap: StaticBody2D = null;

func _on_body_exited(_body: Node2D) -> void:
	trap.activate()
	$MeshInstance2D.scale.y = 11.5
	$MeshInstance2D.position.y -= 2.5
	$unpress.play()


func _on_body_entered(body: Node2D) -> void:
	$MeshInstance2D.scale.y = 6.5
	$MeshInstance2D.position.y += 2.5
	$press.play()
