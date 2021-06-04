extends Camera2D

func _physics_process(_delta) -> void:
	var PLAYER_POS = get_node("..").global_position
	var TARGET_POS_X = float(lerp(global_position.x, PLAYER_POS.x, 0.2))
	var TARGET_POS_Y = float(lerp(global_position.y, PLAYER_POS.y, 0.2))
	global_position = Vector2(TARGET_POS_X, TARGET_POS_Y)
