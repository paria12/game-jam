extends StaticBody2D

func _ready():
	inactive();
	
func inactive():
	self.modulate = Color(255,255,255,0.0)
	$KillZone.active = false
	
func activate():
	self.modulate = Color(255,255,255,255.0)
	$KillZone.active = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	activate();
