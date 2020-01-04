extends TextureProgress

func _on_Player_timer_changed(S):
	print(S)
	set_value(S)
