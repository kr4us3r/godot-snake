extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()
	$VBoxContainer/MaxScore.text = "Max score: %s" % load_score()

func _process(_delta):
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func load_score():
	if not FileAccess.file_exists("res://score.cfg"):
		var cfg = FileAccess.open("res://score.cfg", FileAccess.WRITE)
		cfg.close()
		return 0
	var cfg = FileAccess.open("res://score.cfg", FileAccess.READ)
	var data = cfg.get_as_text()
	cfg.close()
	return data
