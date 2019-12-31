extends Control

func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/Continuar.grab_focus()
	
func _physics_process(delta):
	if $MarginContainer/CenterContainer/VBoxContainer/Continuar.is_hovered() == true:
		$MarginContainer/CenterContainer/VBoxContainer/Continuar.grab_focus()
	elif $MarginContainer/CenterContainer/VBoxContainer/Sair.is_hovered() == true:
		$MarginContainer/CenterContainer/VBoxContainer/Sair.grab_focus()
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$MarginContainer/CenterContainer/VBoxContainer/Continuar.grab_focus()
		get_tree().paused = not get_tree().paused
		visible = not visible



func _on_Continuar_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible


func _on_Sair_pressed():
	get_tree().change_scene("res://TitleScreen.tscn")
