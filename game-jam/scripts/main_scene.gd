extends Node2D

@export var height_ground_roof = 820.0

var player = preload("res://scènes/player.tscn")
var victory_platform = preload("res://scènes/win_platform.tscn")
var platform = preload("res://scènes/platform.tscn")
var background_platform = preload("res://scènes/background_platform.tscn")
var background_platform_with_platform_hole = preload("res://scènes/background_platform_with_platform_hole.tscn")
var spikes_platform = preload("res://scènes/spikes_platform.tscn")
var pressure_spikes_platform = preload("res://scènes/pressure_spikes_platform.tscn")
var arrow_platform = preload("res://scènes/platform_with_arrow.tscn")
var rocher_platform = preload("res://scènes/platform_with_rocher.tscn")
var xPos  = 0;
var yPos = 0;

enum Platform_Type{
	PLATFORM = 0,
	SPIKES_PLATFORM = 1,
	PRESSURE_SPIKES_PLATFORM = 2,
	HOLE_PLATFORM = 3,
	ARROW_PLATFORM = 4
}

func _ready() -> void:
	var instance_player = player.instantiate();
	place_element(instance_player, 1000, 0)
	xPos = 0;
	yPos = 0;
	var size = place_victory_room(Vector2(xPos, yPos))
	xPos += size.x
	var number = randi_range(0,5)
	for i in range(number):
		var random_value = randi_range(0,Platform_Type.size()-1)
		match random_value:
		#match 1:
			Platform_Type.SPIKES_PLATFORM:
				size = place_spikes_room(Vector2(xPos, yPos))
				xPos += size.x
			Platform_Type.PLATFORM:
				size = place_room(Vector2(xPos, yPos))
				xPos += size.x
			Platform_Type.PRESSURE_SPIKES_PLATFORM:
				size = place_pressure_spikes_room(Vector2(xPos, yPos))
				xPos += size.x
			Platform_Type.HOLE_PLATFORM:
				size = place_hole_platform(Vector2(xPos, yPos))
				xPos += size.x
			Platform_Type.ARROW_PLATFORM:
				size = place_arrow_platform(Vector2(xPos, yPos))
				xPos += size.x
	size = place_rocher_room(Vector2(xPos, yPos))
	xPos += size.x
	instance_player.get_node("Camera2D").limit_right = xPos + instance_player.get_node("Camera2D").limit_left -100
	
func place_victory_room(pos):
	var instance = victory_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;
	
	
func place_rocher_room(pos):
	var instance = rocher_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;

func place_arrow_platform(pos):
	var instance = arrow_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;

func place_hole_platform(pos):
	var instance = background_platform_with_platform_hole.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;

func place_pressure_spikes_room(pos):
	var instance = pressure_spikes_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;
	
func place_spikes_room(pos):
	var instance = spikes_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;
	
func place_room(pos):
	var instance = background_platform.instantiate();
	var instance2 = platform.instantiate()
	var size = instance.get_size();
	place_element(instance, pos.x, pos.y + size.y/2)
	place_element(instance2, pos.x, pos.y - height_ground_roof + size.y/2)
	return size;

func place_element(instance, xpos, ypos):
	instance.position.x = xpos
	instance.position.y = ypos
	add_child(instance)
