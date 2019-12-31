extends RichTextLabel

func _on_Player_timer_changed(M, S, MS):
	set_text(str(M)+":"+str(S)+":"+str(MS))
