extends Node

export var MAX_LOAD_TIME = 10000
var MENU_SCENE : String = "res://SYSTEMS/INTERFACES/MENU.tscn"
var MAIN_SCENE : String = "res://SYSTEMS/MAIN/MAIN.tscn"

func _ready() -> void:
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_full_screen"):
		OS.window_fullscreen =  not OS.window_fullscreen

func load_scene(PATH, PARENT) -> void:
	var LOADER = ResourceLoader.load_interactive(PATH)
	print("LOADING")
	if LOADER == null:
		print("UNABLE TO FIND RESOURCE AT PATH")
		return
	var TICKS_TIME = OS.get_ticks_msec()
	while OS.get_ticks_msec() - TICKS_TIME < MAX_LOAD_TIME:
		var ERR = LOADER.poll()
		if ERR == ERR_FILE_EOF:
			var RESOURCE = LOADER.get_resource()
			PARENT.call_deferred("add_child", RESOURCE.instance())
			print("SUCCESSFULLY LOADED")
			break
		if ERR == OK:
			var PROGRESS = float(LOADER.get_stage()) / LOADER.get_stage_count()
			print(PROGRESS)
		else:
			print("ERROR LOADING FILE")
			break
		yield(get_tree(), "physics_frame")
