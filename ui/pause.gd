extends PopupPanel


func _on_Pause_about_to_show():
	get_tree().paused = true
	$MarginContainer/VBoxContainer/MusicContainer/MusicButton.pressed = InputLock.music
	$MarginContainer/VBoxContainer/SFXContainer/SFXButton.pressed = InputLock.sfx
	

func _on_MusicButton_toggled(button_pressed):
	InputLock.music = button_pressed


func _on_SFXButton_toggled(button_pressed):
	InputLock.sfx = button_pressed


func _on_Settings_pressed():
	popup_centered()


func _on_GUI_pause_pressed():
	popup_centered()


func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://main_menu.tscn")


func _on_ResumeButton_pressed():
	get_tree().paused = false
	hide()




func _on_Pause_popup_hide():
	_on_ResumeButton_pressed()
