extends Area2D

signal NEXT_LEVEL

func _on_NEXT_LEVEL_body_entered(body) -> void:
	emit_signal("NEXT_LEVEL")
	print(body)
