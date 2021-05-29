extends Sprite

signal OPEN
var STATE : bool

func _ready():
	get_node("PROGRESS").value = 0
	progress()

func _on_AREA_body_entered(_body):
	STATE = true

func _on_AREA_body_exited(_body):
	STATE = false

func progress():
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
