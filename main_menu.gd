extends Node2D

func _on_PlayButton_pressed():
	get_tree().change_scene("res://environment/field/field.tscn")


func _on_Tutorial_pressed():
	print("start tutorial")


func _on_Credits_pressed():
	$Credits.popup_centered()