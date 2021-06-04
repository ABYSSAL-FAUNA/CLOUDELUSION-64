extends Control

onready var TIMER = $TIMER

var TIME = 0.0
var TIMER_ON : bool = false
var TIME_PASSED

func _process(delta) -> void:
	if TIMER_ON:
		TIME += delta
	var MSEC = fmod(TIME, 1) * 1000
	var SEC = fmod(TIME, 60)
	var MIN = fmod(TIME, 3600) / 60
	var H = fmod(fmod(TIME, 216000) / 3600, 24)
	var D = fmod(TIME, 12960000) / 86400
	TIME_PASSED = "%02dD:%02dH:%02dMIN:%02dSEC:%03dMSEC" % [D, H, MIN, SEC, MSEC]

func start_timer() -> void:
	TIME = 0
	TIMER_ON = true

func stop_timer() -> void:
	TIMER_ON = false

func record_timer() -> void:
	print("TIME USED: %s" % TIME_PASSED)
	TIME = 0
