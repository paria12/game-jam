extends Node2D

@export var height_ground_roof = 820.0

var platform = preload("res://platform.tscn")
var spikes_platform = preload("res://spikes_platform.tscn")
var pressure_spikes_platform = preload("res://pressure_spikes_platform.tscn")
var xPos  = 0;
var yPos = 0;

enum Platform_Type{
	PLATFORM = 0,
	SPIKES_PLATFORM = 1,
	PRESSURE_SPIKES_PLATFORM = 2
}

func _ready() -> void:
	xPos = 0;
	yPos = 0;
	var size = place_room(Vector2(xPos, yPos))
	xPos += size.x
	var number = randi_range(0,5)
	for i in range(number):
		var random_value = randi_range(0,Platform_Type.size()-1)
		match random_value:
			Platform_Type.SPIKES_PLATFORM:
				size = place_spikes_room(Vector2(xPos, yPos))
				xPos += size.x
			Platform_Type.PLATFORM:
				size = place_room(Vector2(xPos, yPos))
				xPos += size.x
			Platform_Type.PRESSURE_SPIKES_PLATFORM:
				size = place_pressure_spikes_room(Vector2(xPos, yPos))
				xPos += size.x

func place_pressure_spikes_room(pos):
	var instance = pressure_spikes_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return instance.get_size();
	
func place_spikes_room(pos):
	var instance = spikes_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return instance.get_size();
	
# regarder placement image à l'envers potentiel bug pour placement cube
func place_room(pos):
	var instance = platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;

func place_element(instance, xpos, ypos):
	instance.position.x = xpos
	instance.position.y = ypos
	add_child(instance)
