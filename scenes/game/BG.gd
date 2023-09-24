extends Sprite2D

@onready var width: int = get_parent().WIDTH
@onready var height: int = get_parent().HEIGHT

func _ready():
	set_texture(CanvasTexture.new())
	self_modulate = (Color8(40, 40, 40, 125))
	region_enabled = true
	region_rect = Rect2(0, 0, width*30, height*30)
	position = Vector2(width*15, height*15)
	
func _process(_delta):
	pass
