extends Node2D

@onready var half_width: int = get_parent().WIDTH / 2
@onready var half_height: int = floor(get_parent().HEIGHT / 2)

@onready var pos: Array = []
@onready var rng = RandomNumberGenerator.new()

@onready var head: PackedScene = preload("res://scenes/game/head.tscn")
@onready var hd: Node2D
@onready var segment: PackedScene = preload("res://scenes/game/segment.tscn")
@onready var seg: Node2D

@onready var apple: PackedScene = preload("res://scenes/game/apple.tscn")
@onready var appl: Node2D

@onready var paused_label = $CanvasLayer/Paused
@onready var game_over_label = $CanvasLayer/GameOver

var head_pos: Vector2
var apple_pos: Vector2

var there_is_apple: bool = false
var gg: bool = false
var paused: bool = false

var segment_arr: Array = []
var snake_max_size: int = 3

signal increase_score()
signal game_over_signal()

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST,
}

var dir: Direction
var last_movement: Direction

func _ready():
	rng.randomize()
	set_start_direction()

func _process(_delta):
	spawn_food()
	move_snake()
	
func set_start_direction():
	match rng.randi_range(1,4):
		1:
			dir = Direction.NORTH
			head_pos = Vector2(0,-1)
		2:	
			dir = Direction.SOUTH
			head_pos = Vector2(0,1)
		3:
			dir = Direction.EAST
			head_pos = Vector2(1,0)
		4:
			dir = Direction.WEST
			head_pos = Vector2(-1,0)
	pos.append_array([Vector2(0,0), head_pos])
	
	seg = segment.instantiate()
	add_child(seg)
	seg.position = Vector2(half_width*30 + pos[0].x*30, half_height*30 + pos[0].y*30)
	segment_arr.push_back(seg)
	
	hd = head.instantiate()
	add_child(hd)
	hd.position = Vector2(half_width*30 + pos[1].x*30, half_height*30 + pos[1].y*30)
	segment_arr.push_back(hd)

func _input(_event):
	if Input.is_action_just_pressed("Up") and last_movement != Direction.SOUTH:
		dir = Direction.NORTH
	elif Input.is_action_just_pressed("Down") and last_movement != Direction.NORTH:
		dir = Direction.SOUTH
	elif Input.is_action_just_pressed("Left") and last_movement != Direction.EAST:
		dir = Direction.WEST
	elif Input.is_action_just_pressed("Right") and last_movement != Direction.WEST:
		dir = Direction.EAST
	if gg and Input.is_action_just_pressed("ui_select"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	if not gg and Input.is_action_just_pressed("ui_cancel"):
		paused = not paused
		paused_label.visible = not paused_label.visible
		
func move_snake():
	if gg:
		return
	if paused:
		return
	segment_arr[-1].queue_free()
	segment_arr.pop_back()
	seg = segment.instantiate()
	add_child(seg)
	seg.position = Vector2(half_width*30 + head_pos.x*30, half_height*30 + head_pos.y*30)
	segment_arr.push_back(seg)
	
	match dir:
		Direction.NORTH:
			head_pos.y -= 1
			last_movement = Direction.NORTH
		Direction.SOUTH:
			head_pos.y += 1
			last_movement = Direction.SOUTH
		Direction.EAST:
			head_pos.x += 1
			last_movement = Direction.EAST
		Direction.WEST:
			head_pos.x -= 1
			last_movement = Direction.WEST
	
	if head_pos.x > half_width:
		head_pos.x -= half_width*2 + 1
	elif head_pos.x < -half_width:
		head_pos.x += half_width*2 + 1
	elif head_pos.y > half_height + 1:
		head_pos.y -= half_height*2 + 2
	elif head_pos.y < -half_height:
		head_pos.y += half_height*2 + 2
	
	if head_pos in pos and head_pos != pos[0]:
		game_over()
		
	pos.push_back(head_pos)
	if pos.size() > snake_max_size:
		pos.pop_front()
	
	hd = head.instantiate()
	add_child(hd)
	segment_arr.push_back(hd)
	if segment_arr.size() > snake_max_size:
		segment_arr[0].queue_free()
		segment_arr.pop_front()
	hd.position = Vector2(half_width*30 + head_pos.x*30, half_height*30 + head_pos.y*30)
	
func spawn_food():
	if there_is_apple == false:
		appl = apple.instantiate()
		appl.connect("entered", Callable(self, "food_eaten"))
		add_child(appl)
		while true:
			apple_pos = Vector2(randi_range(-half_width+1, half_width-1),randi_range(-half_height+1, half_height-1))
			if apple_pos in pos:
				continue
			appl.position = Vector2(half_width*30 + apple_pos.x*30, half_height*30 + apple_pos.y*30)
			break
		there_is_apple = true

func food_eaten():
	snake_max_size += 1
	appl.queue_free()
	there_is_apple = false
	emit_signal("increase_score")
	
func game_over():
	game_over_label.show()
	gg = true
	emit_signal("game_over_signal")
