extends CharacterBody2D

@export var based_speed = 400
@export var gravity  = 40
@export var jump = 750
@export var running_coef = 2.0
@export var long_jump_duration = 0.25
@export var cayote_time:float = 0.5

@onready var animation = $Sprite2D
@onready var standing = $Standing
@onready var crouching = $Crouching

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

func _ready() -> void:
	crouching.hide();
	standing.show();
	normal_scale = animation.scale;
	divided_scale = normal_scale / 2;
	normal_position = animation.position
	divided_position = animation.position / 2

func _physics_process(delta: float) -> void:
	# faire un input buffer
	if(self.position.y >= death_position.y):
		die();
	# cas dans lequel on utilise la position accroupi
	var horizontal_direction = Input.get_axis("move_left","move_right")
	
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
		if (Input.is_action_just_pressed("crouch")):
			velocity.y += gravity * 11 
	else:
		# regarder sur youtube comment réaliser l'accroupissement
		# regarder comment éviter qu'il reste accroupit lors du saut
		if(Input.is_action_just_pressed("crouch")):
			crouch()
		elif (Input.is_action_just_released("crouch")):
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

func crouch():
	speed = based_speed / 2
	standing.hide();
	animation.scale = divided_scale;
	animation.position = divided_position
	crouching.show()
	
func stand():
	speed = based_speed
	crouching.hide();
	animation.scale = normal_scale;
	animation.position = normal_position
	standing.show();
	
