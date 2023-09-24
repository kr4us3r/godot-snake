extends Node2D

signal entered

func _ready():
	pass

func _process(_delta):
	pass

func _on_area_entered(area):
	if area.is_in_group("snake"):
		entered.emit()
