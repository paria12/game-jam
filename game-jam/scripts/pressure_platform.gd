extends Node2D

func get_size():
	return $background_platform.get_size();


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_node("../Dynamite").expand_temporarily();
