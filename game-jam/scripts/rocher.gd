extends CharacterBody2D

@export var speed = 700

var activated = false;

func _physics_process(delta: float) -> void:
	if(activated):
		velocity.x = -speed
		rotation_degrees -= 4.0
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.has_touched_rock_room = true;
	activated = true;
