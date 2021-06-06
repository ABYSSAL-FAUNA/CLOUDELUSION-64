extends Sprite

signal OPEN
signal ENTER(NAME)
var STATE : bool
var STOP_ANIMATE : bool = true
onready var ANIMATION_PLAYER = get_node("../ANIMATION_PLAYER")

func _ready() -> void:
	progress()

func _on_AREA_body_entered(_body) -> void:
	_on_BUTTON_button_down()

func _on_AREA_body_exited(_body) -> void:
	_on_BUTTON_button_up()

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
		progress()
	else:
		STOP_ANIMATE = false
		emit_signal("OPEN")

func _on_BUTTON_button_down() -> void:
	STATE = true
	z_index = 1
	emit_signal("ENTER", self.name)
	if STOP_ANIMATE == true:
		ANIMATION_PLAYER.play("IN")

func _on_BUTTON_button_up():
	STATE = false
	z_index = 0
	emit_signal("ENTER", "CLOUDELUSION 64")
	if STOP_ANIMATE == true:
		ANIMATION_PLAYER.play("OUT")
