extends Node

var velocidade_player = 1
var play = false

func _ready():
	# iniciar com o botao de iniciar selecionado
	$MarginContainer/VBoxContainer/VBoxContainer/IniciarJogo.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if play:
		$player.position.x += velocidade_player
	# para aparecer algo indicando que o botao esta selecionado 
	if $MarginContainer/VBoxContainer/VBoxContainer/IniciarJogo.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/IniciarJogo.grab_focus()
	elif $MarginContainer/VBoxContainer/VBoxContainer/Controles.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/Controles.grab_focus()
	elif $MarginContainer/VBoxContainer/VBoxContainer/Creditos.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/Creditos.grab_focus()
	elif $MarginContainer/VBoxContainer/VBoxContainer/Sair.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/Sair.grab_focus()



func _on_IniciarJogo_pressed():
	$player/Sprite.play("run")
	play = true

func _on_Controles_pressed():
	get_tree().change_scene("res://cenas/cenas/Controles.tscn")

func _on_Creditos_pressed():
	get_tree().change_scene("res://cenas/cenas/Creditos.tscn")


func _on_Sair_pressed():
	get_tree().quit()

func _on_player_body_entered(body):
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_ColorRect_fade_finished():
	get_tree().change_scene("res://cenas/cenas/Fase1.tscn")