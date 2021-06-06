extends Node

onready var ANIMATION_PLAYER = $ANIMATION_PLAYER

func ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	OS.window_maximized = true
	OS.window_fullscreen = true
	ANIMATION_PLAYER.play("LOADING_LOG_INIT")

func load_game() -> void:
	var LOADER = ResourceLoader.load_interactive("res://SYSTEMS/MAIN/GAME.tscn")
	while true:
		var ERR = LOADER.poll()
		if ERR == ERR_FILE_EOF:
			var RESOURCE = LOADER.get_resource()
			get_tree().get_root().call_deferred("add_child", RESOURCE.instance())
			get_node("EFFECTS").queue_free()
			ANIMATION_PLAYER.play("LOADING_LOG_CLOSE")
			yield(ANIMATION_PLAYER, "animation_finished")
			queue_free()
		if ERR == OK:
			var PROGRESS = float(LOADER.get_stage()) / LOADER.get_stage_count()
			get_node("LOADING_BAR/PROGRESS").margin_right = 560 * PROGRESS
		yield(get_tree(), "physics_frame")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		ready()
