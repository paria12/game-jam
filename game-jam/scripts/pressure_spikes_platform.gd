extends Node2D
	
func _ready() -> void:
	$spiques.inactive();
	
func get_size():
	return $background_platform.get_size();
