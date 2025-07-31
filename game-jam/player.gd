extends CharacterBody2D

@export var speed = 300
@export var gravity  = 30
@export var jump = 800

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 500:
			velocity.y = 500
		
	if Input.is_action_just_pressed("jump"): #&& is_on_floor():
		velocity.y = -jump
	
	# cas dans lequel on utilise la position accroupi*
	# réduire la speed à 200 
	#if Input.is_action_just_pressed("crouch"):
		
	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x = speed * horizontal_direction
	move_and_slide()
