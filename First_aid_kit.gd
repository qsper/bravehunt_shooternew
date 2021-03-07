extends Node2D

func _on_First_aid_kit_body_entered(body):
	if body.is_in_group("player"):
		body.healing()
		queue_free()
	pass
