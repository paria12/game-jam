extends CanvasLayer

func _ready():
	self.hide();
	
func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func victory():
	get_tree().paused = true;
	self.show()
