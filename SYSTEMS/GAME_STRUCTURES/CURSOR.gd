extends Sprite

func _physics_process(_delta) -> void:
	global_position = get_global_mouse_position()
