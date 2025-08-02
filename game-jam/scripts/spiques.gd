extends StaticBody2D

func _ready():
	inactive();
	
func inactive():
	self.modulate = Color(255,255,255,0.0)
	$KillZone.inactive()
	$KillZone.destroy_shoes = true;
	
func activate():
	self.modulate = Color(255,255,255,255.0)
	$KillZone.activate();
	$KillZone.destroy_shoes = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	activate();
