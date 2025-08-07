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
	
func victory(time):
	var score = "";
	Global.set_score(time);
	var scores = Global.get_score()
	var index = 1;
	if(scores.size() != 0):
		for i in scores:
			var minutes = int(i / 60.0)
			var seconds = i - minutes * 60.0
			score += "Meilleur score "+ str(index) + " : "+ str('%02d:%02d' % [minutes,seconds]) +"\n";
			index += 1
	else:
		score = "Aucun meilleur score !"
	$score.text = score;
	$Label.show();
	$score.show();
	$Retry.show()
	get_tree().paused = true;
	
func set_transparency(value):
	$Panel.modulate = Color(255, 255, 255, value*2)
