extends CharacterBody2D

@export var speed = 400
@export var gravity  = 40
@export var jump = 750
@export var running_coef = 2.0
@export var long_jump_duration = 0.25
@export var cayote_time:float = 0.5

var ground_timer: float = 0.0
var jump_timer:float = 0.0
var jump_velocity:float = 0.0
var death_position = Vector2(0.0, 500.0)

func _physics_process(delta: float) -> void:
	# faire un input buffer
	
	if(self.position.y >= death_position.y):
		#$Sprite2D.queue_free()
		get_node("../GameOver").game_over()
		
	# cas dans lequel on utilise la position accroupi
	var horizontal_direction = Input.get_axis("move_left","move_right")
	
	if (Input.is_action_just_pressed("jump")):
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
			
	if (!Input.is_action_pressed("run")):
		velocity.x = (velocity.x +(speed * horizontal_direction)) / 2
	else : 
		velocity.x = (velocity.x +(speed * horizontal_direction * running_coef)) / 2
		
	move_and_slide()
	
