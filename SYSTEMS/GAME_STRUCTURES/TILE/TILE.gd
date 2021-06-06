extends Node2D
class_name TILE


func clear():
	for node in get_children():
		node.queue_free()

func set_cellv(POS : Vector2, TITLE : int):
	for node in get_children():
		if node.position == POS * 64:
			node.queue_free()
	if TITLE == -1:
		print("queue")
	else:
		var SCENE : String = "res://SYSTEMS/GAME_STRUCTURES/TILE/DEFAULT/" + str(TITLE) + ".tscn"
		var PATH = load(SCENE).instance()
		PATH.editor_description = str(TITLE)
		PATH.position = POS * 64
		PATH.z_index = -128
		add_child(PATH)

func get_cellv(POS : Vector2):
	for node in get_children():
		if node.global_position == POS * 64:
			return int(node.editor_description)

