extends StaticBody2D

var has_been_played = false;

func _ready():
	inactive();
	
func inactive():
	$CollisionShape2D.set_deferred("disabled", true)
	self.visible = false;
	$KillZone.inactive()
	$KillZone.destroy_shoes = true;
	
func activate():
	if(!has_been_played):
		$spiques_sound.play();
		has_been_played = true
	$CollisionShape2D.set_deferred("disabled", false)
	self.visible = true
	$KillZone.activate();
	$KillZone.destroy_shoes = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	activate();
