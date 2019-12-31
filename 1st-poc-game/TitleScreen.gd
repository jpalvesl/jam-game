extends Node


func _ready():
	# iniciar com o botao de iniciar selecionado
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()

func _physics_process(delta):
	# para aparecer algo indicando que o botao esta selecionado 
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	elif $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()


func _on_TextureButton_pressed():
	get_tree().change_scene("res://cenas/cenas/Fase1.tscn")

func _on_TextureButton2_pressed():
	$".".queue_free()
