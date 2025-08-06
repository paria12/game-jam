extends Node2D

@export var height_ground_roof = 820.0
@export var minimum_number_room = 10;
@export var victory_fade_start = 1000
@export var victory_fade_end = 100

var player = preload("res://scènes/player.tscn")
var victory_platform = preload("res://scènes/win_platform.tscn")
var platform = preload("res://scènes/platform.tscn")
var background_platform = preload("res://scènes/background_platform.tscn")
var background_platform_with_platform_hole = preload("res://scènes/background_platform_with_platform_hole.tscn")
var spikes_platform = preload("res://scènes/spikes_platform.tscn")
var pressure_spikes_platform = preload("res://scènes/pressure_spikes_platform.tscn")
var arrow_platform = preload("res://scènes/platform_with_arrow.tscn")
var rocher_platform = preload("res://scènes/platform_with_rocher.tscn")
var current_position = Vector2(0, 0)
var instance_player;


enum rooms_IDs{
	PLATFORM = 0,
	SPIKES_PLATFORM = 1,
	PRESSURE_SPIKES_PLATFORM = 2,
	HOLE_PLATFORM = 3,
	ARROW_PLATFORM = 4
}

var rooms_weight = { 
	rooms_IDs.PLATFORM: 5, 
	rooms_IDs.SPIKES_PLATFORM: 15,
	rooms_IDs.PRESSURE_SPIKES_PLATFORM: 15, 
	rooms_IDs.HOLE_PLATFORM:15,
	rooms_IDs.ARROW_PLATFORM:10 
}

var rooms_scenes = { 
	rooms_IDs.PLATFORM: background_platform, 
	rooms_IDs.SPIKES_PLATFORM: spikes_platform,
	rooms_IDs.PRESSURE_SPIKES_PLATFORM: pressure_spikes_platform, 
	rooms_IDs.HOLE_PLATFORM: background_platform_with_platform_hole,
	rooms_IDs.ARROW_PLATFORM: arrow_platform 
}
	
func _ready() -> void:
	current_position = Vector2(0, 0)
	place_room(victory_platform)
	instance_player = player.instantiate();
	place_element(instance_player, current_position.x/2, 0)
	for i in range(minimum_number_room):
		place_random_room()
	place_room(rocher_platform)
	instance_player.get_node("Camera2D").limit_right = current_position.x + instance_player.get_node("Camera2D").limit_left -100
	get_node("Sprite2D").size.x = current_position.x + instance_player.get_node("Camera2D").limit_left
	
func _process(delta):
	if !instance_player.has_touched_rock_room:
		return
	if (instance_player.position.x < victory_fade_start):
		var fade_length = victory_fade_start - victory_fade_end
		$Victory.set_transparency((fade_length-(instance_player.position.x-victory_fade_end))/fade_length)
	else: 
		$Victory.set_transparency(0)
	
func place_random_room() -> void:
		var sum_of_weight = 0;
		for room in rooms_weight:
			sum_of_weight += rooms_weight[room]
		var random_value = randi_range(0,sum_of_weight)
		for room_type in rooms_weight:
			if(random_value <= rooms_weight[room_type]):
				place_room(rooms_scenes[room_type])
				return
			random_value -= rooms_weight[room_type];
	
	
func place_room(platform_type) -> void:
	var instance = platform_type.instantiate();
	var instance2 = platform.instantiate()
	var size = instance2.get_size();
	place_element(instance, current_position.x, current_position.y + size.y/2)
	place_element(instance2, current_position.x, current_position.y - height_ground_roof + size.y/2)
	current_position.x += size.x

func place_element(instance, xpos, ypos) -> void:
	instance.position.x = xpos
	instance.position.y = ypos
	add_child(instance)
