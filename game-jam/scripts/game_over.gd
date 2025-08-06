extends CanvasLayer

var up = false

func _ready():
	self.hide();
	up = false
	
func _process(_delta):
	if up and Input.is_action_just_pressed("play_again"):
		_on_retry_pressed()
		
func _on_retry_pressed() -> void:
	up = false
	get_tree().reload_current_scene()
	
func game_over():
	self.show()
	up = true
