extends CharacterBody2D

@export var based_speed = 400
@export var gravity  = 40
@export var jump = 750
@export var running_coef = 2.0
@export var long_jump_duration = 0.25
@export var cayote_time:float = 0.5
@export var shoes_limit = 3


@onready var animation = $AnimatedSprite2D
@onready var standing = $Standing
@onready var crouching = $Crouching
@onready var camera = $Camera2D

var shoes = preload("res://scènes/shoes.tscn")
var shoes_available = 2
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

func _ready() -> void:
	crouching.hide();
	standing.show();
	normal_scale = animation.scale;
	divided_scale = normal_scale / 2;
	normal_position = animation.position
	divided_position = animation.position / 2
	
func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("throw_shoes")):
		throw_shoes()

func _physics_process(delta: float) -> void:
	if(self.position.y >= death_position.y):
		die();
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	if(horizontal_direction == 1.0):
		animation.flip_h = false;
		last_direction = horizontal_direction
	elif(horizontal_direction == -1.0):
		animation.flip_h = true
		last_direction = horizontal_direction
	
	
	
	#if(shoes_available >= 2):
	#	shoes_prefix = "S2_"
	#elif(shoes_available == 1):
	#	shoes_prefix = "S1_"
	#else:
	#	shoes_prefix = "S0_"
	
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
	
	if (Input.is_action_just_pressed("jump")):
		stand()
		jump_velocity = - jump - abs(horizontal_direction / 3)
		ground_timer = cayote_time
		
	if (Input.is_action_pressed("jump")):
		if (jump_timer < long_jump_duration ):
			velocity.y = jump_velocity
			jump_timer += delta
	else:
		if (jump_timer < long_jump_duration ):
			jump_timer = long_jump_duration
		if (ground_timer < cayote_time):
			jump_timer = 0.0
			jump_velocity = 0.0
		if (is_on_floor()):
			ground_timer = 0.0

	if (!is_on_floor()):
		velocity.y += gravity
		ground_timer += delta
		stand();
		if (Input.is_action_just_pressed("crouch")):
			velocity.y += gravity * 11 
	else:
		# regarder sur youtube comment réaliser l'accroupissement
		# regarder comment éviter qu'il reste accroupit lors du saut
		if(Input.is_action_pressed("crouch")):
			crouch()
		else:
			stand()
	if (!Input.is_action_just_pressed("crouch")):
		if (!Input.is_action_pressed("run")):
			velocity.x = (velocity.x +(speed * horizontal_direction)) / 2
		else : 
			velocity.x = (velocity.x +(speed * horizontal_direction * running_coef)) / 2
	else :
		velocity.x = (velocity.x +(speed * horizontal_direction)) / 2
		
	
	move_and_slide()
	
func die():
	get_node("../GameOver").game_over()
	
func win():
	if(has_touched_rock_room):
		get_node("../Victory").victory()

func crouch():
	speed = based_speed / 2.0
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
	else:
		print("You don't have any shoes !")

func camera_shake():
	camera.one_shot = true;
