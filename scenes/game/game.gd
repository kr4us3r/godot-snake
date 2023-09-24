extends Node2D

const WIDTH: int = 36
const HEIGHT: int = 27

@onready var score_label = $CanvasLayer/Score
@onready var pause_label = $CanvasLayer/Pause

signal pass_score()

var score: int = 0

func _ready():
	score_label.text = "Score: %s" % 0
	pause_label.text = "Press ESC to pause"

func _process(_delta):
	pass
				
func _on_player_increase_score():
	score += 10
	score_label.text = "Score: %s" % score

func load_score():
	if not FileAccess.file_exists("res://score.cfg"):
		var cfg = FileAccess.open("res://score.cfg", FileAccess.WRITE)
		cfg.close()
		return 0
	var cfg = FileAccess.open("res://score.cfg", FileAccess.READ)
	var data = cfg.get_as_text()
	cfg.close()
	return int(data)

func save_score(scr):
	if scr > load_score():
		var cfg = FileAccess.open("res://score.cfg", FileAccess.WRITE)
		cfg.store_string("%s" % scr)
		cfg.close()
	
func _on_player_game_over_signal():
	save_score(score)
