extends Node2D

func _on_PlayButton_pressed():
	print("foo")
	get_tree().change_scene("res://environment/field/field.tscn")


func _on_Tutorial_pressed():
	$TutorialContainer/Tutorial.popup_centered()


func _on_Credits_pressed():
	$CreditsContainer/Credits.popup_centered()
