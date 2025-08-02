extends Node2D

var spiques;

func _ready() -> void:
	spiques = []
	for child in get_children():
		if(child.name.contains("spiques")):
			spiques.append(child)
			
func get_size():
	return $background_platform.get_size();

func _on_area_2d_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout
	for spique in spiques:
		spique.activate()
