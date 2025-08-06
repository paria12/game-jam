extends CanvasLayer

func _ready():
	$Label.hide()
	$Retry.hide()
	set_transparency(0)
	
func _process(_delta):
	if get_tree().paused and Input.is_action_just_pressed("play_again"):
		_on_retry_pressed()
		
func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func victory():
	$Label.show()
	$Retry.show()
	get_tree().paused = true;
	
func set_transparency(value):
	print(value)
	$Panel.modulate = Color(255, 255, 255, value*2)
