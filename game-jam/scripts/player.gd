extends CharacterBody2D

@export var base_speed = 400
@export var gravity  = 40
@export var jump = 750
@export var running_coef = 2.0
@export var crouch_coeff = 0.5
@export var acceleration = 40
@export var air_acceleration_coeff = 0.5
@export var long_jump_duration = 0.25
@export var cayote_time:float = 0.5
@export var shoes_available = 2
@export var shoes_limit = 3
@export var walk_sounds_frames = [1, 3]
@export var run_sounds_frames = [0, 1]
@export var crouch_sounds_frames = [0, 1]
@export var pitch_range = 0.3
@export var max_landing_sound_at_speed = 1000
@export var max_landing_scale_at_speed = 2000
@export var nearly_zero = 0.05;
@export var death_slow_coeff = 1.2
@export var step_particles: PackedScene

@onready var animation = $AnimatedSprite2D
@onready var standing = $Standing
@onready var crouching = $Crouching
@onready var camera = $Camera2D

var shoes = preload("res://scènes/shoes.tscn")
var speed = base_speed
var added_velocity = 0;
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
var has_win = false;
var last_frame_played = 0;
var landing_particles_emitted = true
var character_sprite_center_offset = Vector2(20.0, 0.0)

func _ready() -> void:
	has_win = false;
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
	manage_particles(horizontal_direction);
	manage_movements(delta, horizontal_direction);
	move_and_slide();
	
func play_sounds():
	var returned_walk_played_frame = play_steps_sound(walk_animations, walk_sounds_frames, walks_sounds, walk_index, last_walked_played_frame);	
	if(returned_walk_played_frame[0] != -1):
		last_walked_played_frame = returned_walk_played_frame[0]
	walk_index = returned_walk_played_frame[1]	
	var returned_run_played_frame = play_steps_sound(run_animations, run_sounds_frames, runs_sounds, run_index, last_run_played_frame);
	# Not changing last run played frame yet because we need it for particles
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
		if(abs(horizontal_direction) <= 0.0):
			if (abs(velocity.x) <= base_speed):
				if(Input.is_action_pressed("crouch")):
					animation.play(shoes_prefix+"idle_crouch")
				else:
					animation.play(shoes_prefix+"idle")
			else:
				animation.play(shoes_prefix+"stop")
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
			
func manage_particles(horizontal_direction):
	var run_offset = Vector2(150*horizontal_direction, 0.0)
	if(run_animations.has($AnimatedSprite2D.get_animation())):
		if run_sounds_frames.has($AnimatedSprite2D.frame) && ($AnimatedSprite2D.frame != last_run_played_frame):
				var step_particle_instance = create_particle(horizontal_direction)
				step_particle_instance.global_position += run_offset
				last_run_played_frame = $AnimatedSprite2D.frame
	else:
		last_run_played_frame = -1
	if is_on_floor():
		if !landing_particles_emitted:
			var step_particle_instance = create_particle(horizontal_direction)
			var scale;
			if (fall_velocity > max_landing_scale_at_speed):
				scale = 1
			else:
				scale = (fall_velocity / max_landing_scale_at_speed) 
			scale *= 3
			step_particle_instance.scale_amount_min *= (scale)
			step_particle_instance.scale_amount_max *= (scale)
			landing_particles_emitted = true
			fall_velocity = 0
	else:
		landing_particles_emitted = false
	if ["S0_stop", "S1_stop", "S2_stop"].has($AnimatedSprite2D.get_animation()):
		var step_particle_instance = create_particle(horizontal_direction)
		step_particle_instance.global_position += run_offset

func create_particle(horizontal_direction):
	var step_particle_instance = step_particles.instantiate()
	get_parent().add_child(step_particle_instance)
	step_particle_instance.global_position = global_position + character_sprite_center_offset
	step_particle_instance.direction.x = -horizontal_direction * 0.6
	return step_particle_instance

func manage_movements(delta, horizontal_direction):
	if dead:
		be_limp()
		return
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
	if (!is_on_floor()):
		ground_timer += delta
		stand();
		if (jump_timer >= long_jump_duration) && (Input.is_action_pressed("crouch")):
			velocity.y += gravity * 2.75
		else:
			velocity.y += gravity
	else:
		ground_timer = 0.0
		if(Input.is_action_pressed("crouch")):
			crouch()
		else:
			stand()
	var target_velocity = (speed * horizontal_direction)
	if Input.is_action_pressed("run"):
		target_velocity = target_velocity * (running_coef)
	if (added_velocity != target_velocity):
		var difference = abs(added_velocity - target_velocity)
		var change_coeff = acceleration * running_coef
		if !is_on_floor():
			change_coeff *= air_acceleration_coeff
		if (difference < change_coeff):
			change_coeff = difference
		if (added_velocity < target_velocity):
			added_velocity += change_coeff
		else :
			added_velocity -= change_coeff
	velocity.x = (velocity.x + added_velocity) / 2
	
func be_limp():
	if (!is_on_floor()):
		velocity.y += gravity
	else:
		if -nearly_zero <= velocity.x && velocity.x <= nearly_zero:
			velocity.x = 0
		else:
			velocity.x = velocity.x/death_slow_coeff

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
		has_win = true;
		get_node("../Victory").victory(get_node("../canvas_timer/node_time").get_time())

func crouch():
	speed = base_speed * crouch_coeff
	standing.hide();
	standing.disabled = true;
	crouching.disabled = false;
	crouching.show()
	
func stand():
	speed = base_speed
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

func play_chase_music():
	$chaseMusic.play()
	
