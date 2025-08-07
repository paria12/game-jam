extends Node2D

var time_passed : int = 0;

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	time_passed += 1;
	var minutes = int(time_passed / 60.0)
	var seconds = time_passed - minutes * 60.0
	$Label.text = '%02d:%02d' % [minutes,seconds]
	$Label.add_theme_font_size_override("font", 16);
	
func get_time():
	var minutes = int(time_passed / 60.0)
	var seconds = time_passed - minutes * 60.0
	return '%02d:%02d' % [minutes,seconds];
