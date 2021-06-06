extends KinematicBody2D

export (int) var MAX_SPEED
export (int) var ACCELERATION
var MOTION = Vector2.ZERO
var DIRECTION
var IDLE_STATE : bool
var IN_GAME : bool
onready var LEVEL_HINT = $LEVEL_HINT
onready var CURSOR= $CURSOR

func _ready() -> void:
	CURSOR.hide()

func _physics_process(delta) -> void:
	var AXIS = Vector2.ZERO
	AXIS.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	AXIS.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	AXIS = AXIS.normalized()
	
	if Input.is_action_just_pressed("ui_right"):
		DIRECTION = 1
	elif Input.is_action_just_pressed("ui_left"):
		DIRECTION = -1
	
	if AXIS == Vector2.ZERO:
		IDLE_STATE = true
		apply_friction(ACCELERATION * delta)
	else:
		IDLE_STATE = false
		apply_movement(AXIS * ACCELERATION * delta)
	MOTION = move_and_slide(MOTION)
	
	if IN_GAME == true:
		LEVEL_HINT.show()
		LEVEL_HINT.look_at(get_node("../MAIN/NEXT_LEVEL").global_position)
	else:
		LEVEL_HINT.hide()

func apply_friction(AMOUNT) -> void:
	if MOTION.length() > AMOUNT:
		MOTION -= MOTION.normalized() * AMOUNT
	else:
		MOTION = Vector2.ZERO

func apply_movement(_ACCELERATION) -> void:
	MOTION += _ACCELERATION
	MOTION = MOTION.clamped(MAX_SPEED)
