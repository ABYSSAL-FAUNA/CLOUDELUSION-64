extends Node

func _process(_delta) -> void:
	if get_tree().paused == true:
		get_node("BGM").bus = "PAUSE"
	else:
		get_node("BGM").bus = "Master"
