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
			score += "Meilleur score "+ str(index) + " : "+ str(i) +"\n";
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
