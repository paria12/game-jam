extends Area2D

var active = true;
@export var destroy_shoes = false;

func kill_destroy(body:Node2D):
	if(body.name == "Player"):
			body.die();
	elif(body.name == "Shoes" && destroy_shoes):
		body.destroy();
		
func activate():
	active = true;
	for body in get_overlapping_bodies():
		kill_destroy(body)

func inactive():
	active = false;

func _on_body_entered(body: Node2D) -> void:
	if(active):
		kill_destroy(body)
