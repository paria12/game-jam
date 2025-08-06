extends CharacterBody2D

@export var based_speed = 400
@export var gravity  = 40
@export var jump = 750
@export var running_coef = 2.0
@export var crouch_coeff = 0.5
@export var long_jump_duration = 0.25
@export var cayote_time:float = 0.5
@export var shoes_available = 2
@export var shoes_limit = 3
@export var walk_sounds_frames = [1, 3]
@export var run_sounds_frames = [0, 1]
@export var crouch_sounds_frames = [0, 1]
@export var pitch_range = 0.3
@export var max_landing_sound_at_speed = 1000
@export var nearly_zero = 0.05;
@export var death_slow_coeff = 1.2

@onready var animation = $AnimatedSprite2D
@onready var standing = $Standing
@onready var crouching = $Crouching
@onready var camera = $Camera2D

var shoes = preload("res://scènes/shoes.tscn")
var speed = based_speed
var normal_scale = 0.0;
var divided_scale = 0;
var normal_position = 0
var divided_position = 0
var ground_timer: float = 0.0
var jump_timer:float = 0.0
var jump_velocity:float = 0.0
var death_position = Vector2(0.0, 500.0)
var is_crouching = false
var last_direction = 1.0; 
var has_touched_rock_room = false;
var shoes_prefix = "S0_"

var walks_sounds = ["walk1", "walk2"]
var last_walked_played_frame = -1; 
var walk_animations = ["S0_default", "S1_default", "S2_default"]
var walk_index = 0;
var runs_sounds = ["run1", "run2"]
var last_run_played_frame = -1;
var run_index = 0;
var run_animations = ["S0_run", "S1_run", "S2_run"]
var crouch_sounds = ["crouch1", "crouch2"]
var last_crouch_played_frame = -1;
var crouch_index = 0;
var crouch_animations = ["S0_crouch", "S1_crouch", "S2_crouch"]
var jump_sound_played = false
var fall_velocity = 0
var dead = false

func _ready() -> void:
	crouching.hide();
	standing.show();
	normal_scale = animation.scale;
	divided_scale = normal_scale / 2;
	normal_position = animation.position
	divided_position = animation.position / 2
	$ambiance.play();
	
func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("throw_shoes")):
		throw_shoes()

func _physics_process(delta: float) -> void:
	if(self.position.y >= death_position.y):
		die();
	var horizontal_direction = Input.get_axis("move_left","move_right")
	play_sounds();
	play_animations(horizontal_direction);
	manage_movements(delta, horizontal_direction);
	move_and_slide();
	
func play_sounds():
	var returned_walk_played_frame = play_steps_sound(walk_animations, walk_sounds_frames, walks_sounds, walk_index, last_walked_played_frame);	
	if(returned_walk_played_frame[0] != -1):
		last_walked_played_frame = returned_walk_played_frame[0]
	walk_index = returned_walk_played_frame[1]	
	var returned_run_played_frame = play_steps_sound(run_animations, run_sounds_frames, runs_sounds, run_index, last_run_played_frame);
	if(returned_run_played_frame[0] != -1):
		last_run_played_frame = returned_run_played_frame[0]
	run_index = returned_run_played_frame[1]
	var returned_crouch_played_frame = play_steps_sound(crouch_animations, crouch_sounds_frames, crouch_sounds, crouch_index, last_crouch_played_frame);
	if(returned_crouch_played_frame[0] != -1):
		last_crouch_played_frame = returned_crouch_played_frame[0]
	crouch_index = returned_crouch_played_frame[1]
	if is_on_floor():
		if jump_sound_played:
			jump_sound_played = false
			var volume = fall_velocity / max_landing_sound_at_speed
			if volume > 1:
				volume =  1
			$fall.volume_linear = volume
			fall_velocity = 0
			play_with_random_pitch($fall)
	else:
		if (!jump_sound_played):
			play_with_random_pitch($jump)
			jump_sound_played = true
		fall_velocity = velocity.y

func play_animations(horizontal_direction):
	if(shoes_available >= 2):
		shoes_prefix = "S2_"
	elif(shoes_available == 1):
		shoes_prefix = "S1_"
	else:
		shoes_prefix = "S0_"
	if dead:
		animation.play(shoes_prefix + "death")
		return
	if(horizontal_direction == 1.0):
		animation.flip_h = false;
		last_direction = horizontal_direction
	elif(horizontal_direction == -1.0):
		animation.flip_h = true
		last_direction = horizontal_direction
	if(is_on_floor()):
		if(abs(velocity.x) >= 0.0 && abs(velocity.x) <= 0.5):
			if(Input.is_action_pressed("crouch")):
				animation.play(shoes_prefix+"idle_crouch")
			else:
				animation.play(shoes_prefix+"idle")
		else:
			if(Input.is_action_pressed("crouch")):
				animation.play(shoes_prefix+"crouch")
			elif(Input.is_action_pressed("run")):
				animation.play(shoes_prefix+"run")
			else:
				animation.play(shoes_prefix+"default")
	else:
		if(velocity.y < 0.0):
			animation.play(shoes_prefix+"jump")
		else: 
			animation.play(shoes_prefix+"fall")
			
func manage_movements(delta, horizontal_direction):
	if dead:
		if (!is_on_floor()):
			velocity.y += gravity
		else:
			print(velocity)
			if -nearly_zero <= velocity.x && velocity.x <= nearly_zero:
				velocity.x = 0
			else:
				velocity.x = velocity.x/death_slow_coeff
		return
	if (!is_on_floor()):
		velocity.y += gravity
		ground_timer += delta
		stand();
		if (Input.is_action_pressed("crouch")):
			velocity.y += gravity * 1.75
	else:
		ground_timer = 0.0
		if(Input.is_action_pressed("crouch")):
			crouch()
		else:
			stand()
	if (Input.is_action_pressed("jump")):
		if ground_timer < cayote_time:
			stand()
			jump_velocity = - jump - abs(horizontal_direction / 3)
			ground_timer = cayote_time
			jump_timer = 0.0
		if (jump_timer < long_jump_duration ):
			velocity.y = jump_velocity
			jump_timer += delta
	else:
		jump_timer = long_jump_duration
	var added_velocity = (speed * horizontal_direction)
	if Input.is_action_pressed("run"):
		added_velocity = added_velocity * (running_coef)
	velocity.x = (velocity.x + added_velocity) / 2

func play_steps_sound(animations, sounds_frames, sounds, index, last_played_frame):
	var new_frame = -1;
	var new_index = index;
	if(animations.has($AnimatedSprite2D.get_animation())):
		if($AnimatedSprite2D.frame != last_played_frame && sounds_frames.has($AnimatedSprite2D.frame)):
			play_with_random_pitch(get_node(sounds[index]))
			if(index < sounds.size()-1):
				new_index += 1
			else : 
				new_index = 0
			new_frame = $AnimatedSprite2D.frame
	return [new_frame, new_index];
	
func play_with_random_pitch(played_sound):
	played_sound.pitch_scale = 1 - pitch_range + randf_range(0,pitch_range * 2)
	played_sound.play();
	
func die():
	dead = true
	crouch();
	get_node("../GameOver").game_over()
	
func win():
	if(has_touched_rock_room):
		get_node("../Victory").victory()

func crouch():
	speed = based_speed * crouch_coeff
	standing.hide();
	standing.disabled = true;
	crouching.disabled = false;
	crouching.show()
	
func stand():
	speed = based_speed
	crouching.hide();
	crouching.disabled = true
	standing.disabled = false;
	standing.show();

func get_back_shoes(shoe_instance):
	if(shoes_available < shoes_limit):
		shoes_available += 1
		shoe_instance.queue_free()

func throw_shoes():
	if(shoes_available > 0):
		var shoe_instance = shoes.instantiate()
		get_parent().add_child(shoe_instance)
		shoe_instance.global_position = $Marker2D.global_position
		shoe_instance.throw(last_direction, velocity)
		shoes_available -= 1;

func camera_shake():
	camera.one_shot = true;
