extends Node2D

func _ready():
	pass
#	AudioServer.set_bus_mute(0, false)

func _on_PlayButton_pressed():
#	AudioServer.set_bus_mute(0, true)
#	OS.delay_msec(200)
	get_tree().change_scene("res://environment/field/field.tscn")


func _on_Tutorial_pressed():
	$TutorialContainer/Tutorial.popup_centered()


func _on_Credits_pressed():
	$CreditsContainer/Credits.popup_centered()
