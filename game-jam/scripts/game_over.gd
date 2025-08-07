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
	var score = "";
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
	$score.show();
	up = true
