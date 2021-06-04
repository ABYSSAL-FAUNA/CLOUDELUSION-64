extends Control

onready var LABEL = $LABEL

func _process(_delta) -> void:
	LABEL.text = str(int(Engine.get_frames_per_second()))
