extends StaticBody2D

func _ready():
	$platform1.set_deferred("disabled", true)
	$platform2.set_deferred("disabled", true)
	$platform3.set_deferred("disabled", true)
	
func activate():
	$platform1.set_deferred("disabled", false)
	$platform2.set_deferred("disabled", false)
	$platform3.set_deferred("disabled", false)
	
