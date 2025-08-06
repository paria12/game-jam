extends CanvasLayer

func _ready():
	self.hide();
	
func _process(_delta):
	if get_tree().paused and Input.is_action_just_pressed("play_again"):
		_on_retry_pressed()
		
func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func game_over():
	get_tree().paused = true;
	self.show()
