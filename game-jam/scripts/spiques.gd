extends StaticBody2D

func _ready():
	inactive();
	
func inactive():
	$CollisionShape2D.set_deferred("disabled", true)
	self.visible = false;
	$KillZone.inactive()
	$KillZone.destroy_shoes = true;
	
func activate():
	$CollisionShape2D.set_deferred("disabled", false)
	self.visible = true
	$KillZone.activate();
	$KillZone.destroy_shoes = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	activate();
