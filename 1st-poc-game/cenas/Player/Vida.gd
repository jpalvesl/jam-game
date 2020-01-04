extends Node2D

var Vida = 3
export(Texture) var heart

func _ready():
	update()

func _on_Player_life_changed(val):
	Vida = val
	_draw()
	update()

func _draw():
	for n in range(0,Vida):
		draw_texture(heart, Vector2(n* heart.get_width(),0))