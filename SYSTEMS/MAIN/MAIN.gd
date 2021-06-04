extends Node2D

const N : int = 1
const E : int = 2
const S : int = 4
const W : int = 8
var CELL_WALLS : Dictionary = {Vector2(0, -2) : N, Vector2(2, 0) : E, Vector2(0, 2) : S, Vector2(-2, 0) : W}
var TILE_SIZE : Vector2
var WIDTH : int
var HEIGHT : int
var INIT_HEIGHT : int = 9
var INIT_WIDTH : int = 9
var MAP_SEED : int
var ERASE_FRACTION : float = 0.1
var PLAYER_START_POS := Vector2(32, 32)
var PLAYER_END_POS : Vector2
var GLOBAL_CAMERA_ZOOM : float = 3
var INPUT_DEBUG : bool = false
onready var MAP = get_node("TILE_MAP")
onready var PLAYER_CAMERA = get_node("../PLAYER/PLAYER_CAMERA")
onready var GLOBAL_CAMERA = get_node("GLOBAL_CAMERA")
onready var PLAYER = get_node("../PLAYER")
onready var NEXT_LEVEL = get_node("NEXT_LEVEL")
onready var ANIMATION_PLAYER = get_node("ANIMATION_PLAYER")

func _input(event : InputEvent) -> void:
	if INPUT_DEBUG == false:
		if event.is_action_pressed("ui_camera"):
			if PLAYER_CAMERA.current == true:
				PLAYER.hide()
				NEXT_LEVEL.hide()
				PLAYER_CAMERA.current = false
				GLOBAL_CAMERA.current = true
			else:
				PLAYER.show()
				NEXT_LEVEL.show()
				PLAYER_CAMERA.current = true
				GLOBAL_CAMERA.current = false
				PLAYER.show()
				NEXT_LEVEL.show()
		if event.is_action_pressed("ui_reset"):
			INIT()
		if event.is_action_pressed("ui_next_level"):
			_on_NEXT_LEVEL_OPEN()
		if event.is_action_pressed("ui_previous_level"):
			HEIGHT -= 2
			WIDTH -= 2
			print("LAYER: " + str((HEIGHT + 1) / 2 - 4))
			GLOBAL_CAMERA_ZOOM -= 0.185
			ANIMATION_PLAYER.stop()
			ANIMATION_PLAYER.play("CLOSE")
			INIT()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_node("../CURSOR").show()
	get_node("../EFFECTS/FX_CANVAS_LAYER #3/FX #3").show()
	get_node("..").modulate = Color.transparent
	randomize()
	MAP_SEED = randi()
	seed(MAP_SEED)
	print("SEED: " + str(MAP_SEED))
	PLAYER_CAMERA.current = true
	GLOBAL_CAMERA.current = false
	HEIGHT = INIT_HEIGHT
	WIDTH = INIT_WIDTH
	PLAYER.get_node("RECT").color = Color(0.866667, 0.890196, 0.890196)
	PLAYER.modulate = Color.white
	PLAYER.IN_GAME = true
	INIT()
	PLAYER.get_node("UI/TIMER_NODE").start_timer()

func INIT() -> void:
	PLAYER_END_POS = Vector2(WIDTH * 64 - 32 - 128 * (randi() % ((WIDTH + 1) / 4)), HEIGHT * 64 - 32 - 128 * (randi() % ((HEIGHT + 1) / 4)))
	GLOBAL_CAMERA.position = MAP.map_to_world(Vector2(WIDTH / 2, HEIGHT / 2))
	GLOBAL_CAMERA.zoom = Vector2(GLOBAL_CAMERA_ZOOM, GLOBAL_CAMERA_ZOOM)
	PLAYER.global_position = PLAYER_START_POS
	NEXT_LEVEL.global_position = PLAYER_END_POS
	MAKE_MAZE()
	ERASE_WALLS()
	MAP.global_position = Vector2.ZERO
	TILE_SIZE = MAP.cell_size
	print("LAYER: %s" % ((HEIGHT + 1) / 2 - 4))
	ANIMATION_PLAYER.stop()
	ANIMATION_PLAYER.play("INIT")

func CHECK_NEIGHBORS(CELL : Vector2, UNVISIT : Array) -> Array:
	var LIST : Array
	for n in CELL_WALLS.keys():
		if CELL + n in UNVISIT:
			LIST.append(CELL + n)
	return LIST

func MAKE_MAZE() -> void:
	var UNVISITED : Array
	var STACK : Array
	MAP.clear()
	for x in range(WIDTH):
		for y in range(HEIGHT):
			MAP.set_cellv(Vector2(x, y), N|E|S|W)
	for x in range(0, WIDTH, 2):
		for y in range(0, HEIGHT, 2):
			UNVISITED.append(Vector2(x, y))
	var CURRENT = Vector2.ZERO
	UNVISITED.erase(CURRENT)
	while UNVISITED:
		var NEIGHBORS = CHECK_NEIGHBORS(CURRENT, UNVISITED)
		if NEIGHBORS.size() > 0:
			var NEXT = NEIGHBORS[randi() % NEIGHBORS.size()]
			STACK.append(CURRENT)
			var DIR = NEXT - CURRENT
			var CURRENT_WALLS = MAP.get_cellv(CURRENT) - CELL_WALLS[DIR]
			var NEXT_WALLS = MAP.get_cellv(NEXT) - CELL_WALLS[-DIR]
			MAP.set_cellv(CURRENT, CURRENT_WALLS)
			MAP.set_cellv(NEXT, NEXT_WALLS)
			if DIR.x != 0:
				MAP.set_cellv(CURRENT + DIR / 2, 5)
			else:
				MAP.set_cellv(CURRENT + DIR /2, 10)
			CURRENT = NEXT
			UNVISITED.erase(CURRENT)
		elif STACK:
			CURRENT = STACK.pop_back()

func ERASE_WALLS() -> void:
	for _i in range(int(WIDTH * HEIGHT * ERASE_FRACTION)):
		var x = int(rand_range(2, WIDTH/2 - 2)) * 2
		var y = int(rand_range(2, HEIGHT/2 - 2)) * 2
		var CELL = Vector2(x, y)
		# pick random neighbor
		var NEIGHBOR = CELL_WALLS.keys()[randi() % CELL_WALLS.size()]
		if MAP.get_cellv(CELL) & CELL_WALLS[NEIGHBOR]:
			var WALLS = MAP.get_cellv(CELL) - CELL_WALLS[NEIGHBOR]
			var N_WALLS = MAP.get_cellv(CELL + NEIGHBOR) - CELL_WALLS[-NEIGHBOR]
			MAP.set_cellv(CELL, WALLS)
			MAP.set_cellv(CELL + NEIGHBOR, N_WALLS)
			if NEIGHBOR.x != 0:
				MAP.set_cellv(CELL + NEIGHBOR / 2, 5)
			else:
				MAP.set_cellv(CELL + NEIGHBOR / 2, 10)

func _on_NEXT_LEVEL_OPEN() -> void:
	if WIDTH == 99 and HEIGHT == 99:
		INPUT_DEBUG = true
		hide()
		PLAYER.hide()
		ANIMATION_PLAYER.stop()
		ANIMATION_PLAYER.play("CLOSE")
		PLAYER.get_node("UI/TIMER_NODE").record_timer()
		PLAYER.get_node("UI/TIMER_NODE").stop_timer()
		print("LAYER 100%")
		GameControl.load_scene(GameControl.MENU_SCENE, get_node(".."))
		queue_free()
	else:
		HEIGHT += 2
		WIDTH += 2
		GLOBAL_CAMERA_ZOOM += 0.185
		ANIMATION_PLAYER.stop()
		ANIMATION_PLAYER.play("CLOSE")
		PLAYER.get_node("UI/TIMER_NODE").record_timer()
		INIT()
