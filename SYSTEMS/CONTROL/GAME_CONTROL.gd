extends Node

var MENU = preload("res://SYSTEMS/INTERFACES/MENU.tscn")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_full_screen"):
		OS.window_fullscreen =  not OS.window_fullscreen
