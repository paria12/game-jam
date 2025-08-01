extends Area2D

@export var trap: StaticBody2D = null;

func _on_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.


func _on_body_exited(_body: Node2D) -> void:
	trap.activate()
