extends Node

var all_score_player = [];

func set_score(score):
	all_score_player.append(score);
	
func get_score():
	all_score_player.sort();
	return all_score_player;
