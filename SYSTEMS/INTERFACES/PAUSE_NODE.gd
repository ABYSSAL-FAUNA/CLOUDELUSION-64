extends Control

onready var RECT = $RECT
onready var LABEL = $LABEL

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		RECT.visible = not RECT.visible
		LABEL.visible = not LABEL.visible
