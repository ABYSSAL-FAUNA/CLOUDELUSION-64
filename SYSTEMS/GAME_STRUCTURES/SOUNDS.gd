extends Node

var FILES : Array
onready var BGM = $BGM

func _process(_delta) -> void:
	if get_tree().paused == true:
		BGM.bus = "PAUSE"
	else:
		BGM.bus = "Master"

func _ready() -> void:
	var DIR = Directory.new()
	if DIR.open("res://RESOURCES/SOUNDS/BGM/") == OK:
		DIR.list_dir_begin()
		var FILE = DIR.get_next()
		while FILE != "":
			if FILE.ends_with("wav"):
				FILES.append(FILE)
			FILE = DIR.get_next()
	play_bgm_audio()

func _on_BGM_finished() -> void:
	if FILES.size() != 1:
		FILES.remove(0)
		play_bgm_audio()
	else:
		FILES.clear()
		_ready()

func play_bgm_audio() -> void:
	print(FILES[0])
	BGM.stream = load("res://RESOURCES/SOUNDS/BGM/" + FILES[0])
	BGM.play()
