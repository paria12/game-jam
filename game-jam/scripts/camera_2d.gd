extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0

var active_shake  = false;
var one_shot = false;
var rnd = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake():
	shake_strength = randomStrength
	
func one_time(delta):
	apply_shake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
	
	offset = randomOffset()
	one_shot = false;
	active_shake = true;
	
	
func _process(delta):
	if(active_shake):
		apply_shake()
		if shake_strength > 0:
			shake_strength = lerpf(shake_strength*0.20, 0, shakeFade * delta*0.20)
		
		offset = randomOffset()
	elif(one_shot):
		one_time(delta)
	
func randomOffset() -> Vector2:
	return Vector2(rnd.randf_range(-shake_strength, shake_strength),rnd.randf_range(-shake_strength, shake_strength));
