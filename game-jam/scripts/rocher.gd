extends CharacterBody2D

@export var base_speed = 400
@export var incremente_value = 5
@export var coef_offscreen = 2.2;
var speed = base_speed
var activated = false;
var on_screen = false;

func _physics_process(delta: float) -> void:
	if(activated):
		var target_speed
		if(on_screen):
			target_speed = base_speed
		else:
			target_speed = base_speed * coef_offscreen
		var current_increment = incremente_value
		var pic_difference = abs(target_speed - speed)
		if(current_increment > pic_difference):
			current_increment = pic_difference
		if(speed > target_speed):
			speed -= current_increment
		if(speed < target_speed):
			speed += current_increment
		velocity.x = -speed
		$Sprite2D.rotation_degrees -= speed/250;
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.has_touched_rock_room = true;
	body.camera_shake();
	activated = true;

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true;


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false;
