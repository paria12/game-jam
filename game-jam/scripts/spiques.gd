extends StaticBody2D

func inactive():
	self.modulate = Color(255,255,255,0.0)
	$KillZone.active = false
	
func activate():
	self.modulate = Color(255,255,255,255.0)
	$KillZone.active = true
