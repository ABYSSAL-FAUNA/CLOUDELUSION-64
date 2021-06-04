extends Control

onready var RECT = $CANVAS_LAYER/RECT
onready var LABEL = $CANVAS_LAYER/LABEL

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		RECT.visible = not RECT.visible
		LABEL.visible = not LABEL.visible
