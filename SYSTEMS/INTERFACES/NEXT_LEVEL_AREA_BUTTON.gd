extends Sprite

signal OPEN
var STATE : bool

func _ready() -> void:
	get_node("PROGRESS").value = 0
	progress()

func _on_AREA_body_entered(_body) -> void:
	STATE = true

func _on_AREA_body_exited(_body) -> void:
	STATE = false

func progress() -> void:
	if get_node("PROGRESS").value != 100:
		if STATE == true:
			get_node("TIMER").start()
			get_node("PROGRESS").value += 2
			yield(get_node("TIMER"), "timeout")
		else:
			get_node("TIMER").start()
			get_node("PROGRESS").value -= 1
			yield(get_node("TIMER"), "timeout")
	else:
		emit_signal("OPEN")
		get_node("PROGRESS").value = 0
	progress()
